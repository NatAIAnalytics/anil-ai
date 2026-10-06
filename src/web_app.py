import os
import webbrowser
import threading
from flask import Flask, request, jsonify, render_template
from agent import preguntar_agente, MODELO
import database

app = Flask(__name__)

# Historial de la conversación en memoria (suficiente para una demo local de un solo usuario)
historial = []


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/api/chat", methods=["POST"])
def chat():
    data = request.get_json()
    mensaje_usuario = data.get("message", "").strip()
    if not mensaje_usuario:
        return jsonify({"error": "Mensaje vacío"}), 400

    respuesta, grafica = preguntar_agente(mensaje_usuario, historial)
    payload = {"reply": respuesta}
    if grafica:
        payload["grafica"] = grafica
    return jsonify(payload)


@app.route("/api/reset", methods=["POST"])
def reset():
    historial.clear()
    return jsonify({"status": "ok"})


def abrir_navegador():
    webbrowser.open("http://127.0.0.1:5000")

@app.route("/api/resumen")
def resumen():
    nomina = database.resumen_nomina()
    ventas = database.ventas_resumen()
    pendientes = database.cuentas_por_pagar(estado="pendiente")

    return jsonify({
        "total_nomina": sum(n["costo_total_empleador"] for n in nomina),
        "total_ventas": sum(v["monto_total"] for v in ventas),
        "num_facturas_pendientes": len(pendientes),
        "monto_facturas_pendientes": sum(f["monto"] for f in pendientes),
    })

@app.route("/api/graficas")
def graficas():
    # Presupuesto vs. real, agregado por mes (sumando todas las áreas)
    pres = database.presupuesto_vs_real()
    por_mes = {}
    for fila in pres:
        m = fila["mes"]
        if m not in por_mes:
            por_mes[m] = {"presupuestado": 0, "real": 0}
        por_mes[m]["presupuestado"] += fila["monto_presupuestado"]
        por_mes[m]["real"] += fila["monto_real"]
    meses_ordenados = sorted(por_mes.keys())

    # Nómina por área (último mes disponible, o todo si no hay mes)
    nomina = database.resumen_nomina()
    nomina_por_area = {}
    for fila in nomina:
        a = fila["area"]
        nomina_por_area[a] = nomina_por_area.get(a, 0) + fila["costo_total_empleador"]

    # Ventas por categoría
    ventas = database.ventas_resumen()

    # Cuentas por pagar: pendiente vs. pagada
    cxp = database.cuentas_por_pagar()
    cxp_por_estado = {}
    for fila in cxp:
        e = fila["estado"]
        cxp_por_estado[e] = cxp_por_estado.get(e, 0) + fila["monto"]

    return jsonify({
        "presupuesto_por_mes": {
            "meses": meses_ordenados,
            "presupuestado": [por_mes[m]["presupuestado"] for m in meses_ordenados],
            "real": [por_mes[m]["real"] for m in meses_ordenados],
        },
        "nomina_por_area": {
            "areas": list(nomina_por_area.keys()),
            "montos": list(nomina_por_area.values()),
        },
        "ventas_por_categoria": {
            "categorias": [v["categoria_producto"] for v in ventas],
            "montos": [v["monto_total"] for v in ventas],
        },
        "cuentas_por_estado": {
            "estados": list(cxp_por_estado.keys()),
            "montos": list(cxp_por_estado.values()),
        },
    })
    
@app.route("/api/estado")
def estado():
    return jsonify({
        "modelo": MODELO,
        "api_key_configurada": bool(os.getenv("GROQ_API_KEY")),
    })

if __name__ == "__main__":
    threading.Timer(1.0, abrir_navegador).start()
    app.run(debug=True, use_reloader=False)