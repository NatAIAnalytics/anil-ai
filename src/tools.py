import database

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "presupuesto_vs_real",
            "description": "Compara el presupuesto contra el gasto real por área y categoría, calculando la variación en pesos y en porcentaje. Útil para preguntas de tipo FP&A sobre desviaciones presupuestales.",
            "parameters": {
                "type": "object",
                "properties": {
                    "mes": {"type": ["string", "null"], "description": "Mes en formato YYYY-MM, opcional"},
                    "area": {"type": ["string", "null"], "description": "Área a filtrar (Marketing, Logística, Tecnología, Operaciones, Administración), opcional"}
                }
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "resumen_nomina",
            "description": "Devuelve el costo total de nómina (incluyendo aportes patronales) agrupado por área, opcionalmente filtrado por mes.",
            "parameters": {
                "type": "object",
                "properties": {
                    "mes": {"type": ["string", "null"], "description": "Mes en formato YYYY-MM, opcional"}
                }
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "cuentas_por_pagar",
            "description": "Lista las facturas de proveedores, opcionalmente filtradas por estado.",
            "parameters": {
                "type": "object",
                "properties": {
                    "estado": {"type": ["string", "null"], "enum": ["pendiente", "pagada", None], "description": "Filtrar por estado de la factura, opcional"}
                }
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "conciliacion_bancaria",
            "description": "Compara los movimientos bancarios contra los libros contables y devuelve únicamente las diferencias encontradas (montos distintos o movimientos faltantes).",
            "parameters": {"type": "object", "properties": {}}
        }
    },
    {
        "type": "function",
        "function": {
            "name": "ventas_resumen",
            "description": "Devuelve KPIs de ventas (monto total, unidades, ticket promedio) agrupados por categoría de producto, opcionalmente filtrado por categoría y/o mes.",
            "parameters": {
                "type": "object",
                "properties": {
                    "categoria": {"type": ["string", "null"], "description": "Categoría de producto a filtrar, opcional"},
                    "mes": {"type": ["string", "null"], "description": "Mes en formato YYYY-MM, opcional"}
                }
            }
        }
    }
    ,
    {
        "type": "function",
        "function": {
            "name": "generar_grafica",
            "description": "Genera los datos para mostrar una gráfica visual en el chat. Úsala SOLO cuando el usuario pida explícitamente una gráfica, un gráfico, una visualización, o que le 'muestres' algo visualmente (ej: 'dame la gráfica de presupuesto vs real', 'muéstrame un gráfico de ventas'). No la uses para preguntas de solo texto.",
            "parameters": {
                "type": "object",
                "properties": {
                    "tema": {
                        "type": "string",
                        "enum": ["presupuesto_vs_real", "nomina_por_area", "ventas_por_categoria", "cuentas_por_estado"],
                        "description": "Qué datos graficar"
                    }
                },
                "required": ["tema"]
            }
        }
    }
]

# ---------------------------------------------------------------------
# Diccionario que conecta el nombre de la herramienta con la función
# real de database.py que se debe ejecutar.
# ---------------------------------------------------------------------
_FUNCIONES = {
    "presupuesto_vs_real": database.presupuesto_vs_real,
    "resumen_nomina": database.resumen_nomina,
    "cuentas_por_pagar": database.cuentas_por_pagar,
    "conciliacion_bancaria": database.conciliacion_bancaria,
    "ventas_resumen": database.ventas_resumen,
    "generar_grafica": database.datos_grafica,
}


def ejecutar_herramienta(nombre: str, argumentos: dict):
    """Ejecuta la función real correspondiente a una herramienta pedida por el agente."""
    funcion = _FUNCIONES.get(nombre)
    if funcion is None:
        return {"error": f"Herramienta '{nombre}' no reconocida"}
    try:
        return funcion(**argumentos)
    except TypeError as e:
        return {"error": f"Argumentos inválidos para '{nombre}': {e}"}
    except Exception as e:
        return {"error": f"Error ejecutando '{nombre}': {e}"}