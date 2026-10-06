import os
import json
from dotenv import load_dotenv
from groq import Groq
from tools import TOOLS, ejecutar_herramienta

load_dotenv()

client = Groq(api_key=os.getenv("GROQ_API_KEY"))

MODELO = "openai/gpt-oss-120b"

SYSTEM_PROMPT = """
Te llamas Anil, el agente inteligente de Nuvora, especializado en FP&A (Planeación y Análisis
Financiero) y BI (Business Intelligence) para una empresa de e-commerce.

Tienes acceso a herramientas que consultan datos reales de nómina,
presupuesto, cuentas por pagar, conciliación bancaria y ventas.

Cuando respondas:
- Usa las herramientas disponibles en lugar de inventar cifras.
- Explica los resultados en lenguaje claro, como se lo explicarías a un
  gerente que no es técnico.
- Si detectas una variación importante o una anomalía, menciónala y da
  una posible explicación.
- Todas las cifras están en pesos colombianos (COP). Usa siempre el
  formato "$1.234.567 COP" (signo de pesos, puntos como separador de
  miles) — nunca uses el símbolo ₡ ni ningún otro símbolo de moneda.
- Responde en español.
- Usa un tono cercano y amigable, como si hablaras con un colega de confianza
  (puedes usar alguna expresión cálida ocasional), pero mantén siempre la
  precisión y seriedad en las cifras — la calidez es en el trato, no en los datos.

Cuando te pidan comparar dos periodos (por ejemplo "este mes vs. el mes
anterior", "compáralo con el mes pasado", o "cómo ha evolucionado"):
- Ninguna herramienta compara dos meses automáticamente: el parámetro "mes"
  solo filtra UN mes a la vez. Para comparar, debes llamar la misma
  herramienta dos veces (una vez por cada mes) y calcular tú mismo la
  diferencia en pesos y en porcentaje.
- Si no sabes qué meses existen en los datos, primero llama la herramienta
  correspondiente SIN el parámetro "mes" para ver todos los registros
  disponibles. Ahí vas a encontrar fechas en formato YYYY-MM — identifica
  cuáles son los meses más recientes para saber cuál es "el mes anterior"
  al que se está consultando.
- Nunca respondas que no puedes comparar periodos. Siempre es posible:
  consulta cada mes por separado con la herramienta y compara los
  resultados tú mismo en tu respuesta.
"""


def preguntar_agente(mensaje_usuario: str, historial: list = None):
    """Envía una pregunta al agente y devuelve (texto_respuesta, grafica_o_None)."""
    historial_previo = historial if historial is not None else []
    if not historial_previo:
        historial_previo.append({"role": "system", "content": SYSTEM_PROMPT})

    grafica_generada = None

    # Copia de trabajo: aquí sí se acumulan los pasos intermedios de herramientas,
    # pero solo para esta pregunta puntual (no se guardan permanentemente).
    mensajes = list(historial_previo)
    mensajes.append({"role": "user", "content": mensaje_usuario})

    while True:
        respuesta = client.chat.completions.create(
            model=MODELO,
            messages=mensajes,
            tools=TOOLS,
            tool_choice="auto",
        )
        mensaje = respuesta.choices[0].message

        if not mensaje.tool_calls:
            # Ya tenemos la respuesta final: la guardamos en el historial persistente
            historial_previo.append({"role": "user", "content": mensaje_usuario})
            historial_previo.append({"role": "assistant", "content": mensaje.content})
            return mensaje.content, grafica_generada

        mensajes.append({
            "role": "assistant",
            "content": mensaje.content,
            "tool_calls": [
                {
                    "id": tc.id,
                    "type": "function",
                    "function": {"name": tc.function.name, "arguments": tc.function.arguments},
                }
                for tc in mensaje.tool_calls
            ],
        })

        for tc in mensaje.tool_calls:
            argumentos = json.loads(tc.function.arguments) if tc.function.arguments else {}
            resultado = ejecutar_herramienta(tc.function.name, argumentos)
            if tc.function.name == "generar_grafica" and isinstance(resultado, dict) and "error" not in resultado:
                grafica_generada = resultado
            mensajes.append({
                "role": "tool",
                "tool_call_id": tc.id,
                "content": str(resultado),
            })
            