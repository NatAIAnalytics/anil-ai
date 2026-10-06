import sqlite3
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(BASE_DIR, "data", "empresa.db")


def get_connection():
    """Abre una conexión a la base de datos y permite acceder a las filas como diccionarios."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def _rows_to_dicts(cursor):
    """Convierte el resultado de una consulta en una lista de diccionarios (más fácil de manejar)."""
    return [dict(row) for row in cursor.fetchall()]


def presupuesto_vs_real(mes: str = None, area: str = None):
    """Compara presupuesto contra gasto real, opcionalmente filtrado por mes y/o área."""
    conn = get_connection()
    query = """
        SELECT p.area, p.categoria, p.mes,
               p.monto_presupuestado, g.monto_real,
               (g.monto_real - p.monto_presupuestado) AS variacion_absoluta,
               ROUND((g.monto_real - p.monto_presupuestado) * 100.0 / p.monto_presupuestado, 2) AS variacion_pct
        FROM presupuesto p
        JOIN gastos_reales g
          ON p.area = g.area AND p.categoria = g.categoria AND p.mes = g.mes
        WHERE 1=1
    """
    params = []
    if mes:
        query += " AND p.mes = ?"
        params.append(mes)
    if area:
        query += " AND p.area = ?"
        params.append(area)
    query += " ORDER BY p.mes, p.area"

    cur = conn.execute(query, params)
    result = _rows_to_dicts(cur)
    conn.close()
    return result


def resumen_nomina(mes: str = None):
    """Costo total de nómina por área, opcionalmente filtrado por mes."""
    conn = get_connection()
    query = """
        SELECT e.area, n.mes,
               COUNT(DISTINCT e.id) AS num_empleados,
               SUM(n.costo_total_empleador) AS costo_total_empleador
        FROM nomina_mensual n
        JOIN empleados e ON e.id = n.empleado_id
        WHERE 1=1
    """
    params = []
    if mes:
        query += " AND n.mes = ?"
        params.append(mes)
    query += " GROUP BY e.area, n.mes ORDER BY n.mes, e.area"

    cur = conn.execute(query, params)
    result = _rows_to_dicts(cur)
    conn.close()
    return result


def cuentas_por_pagar(estado: str = None):
    """Lista facturas de proveedores, opcionalmente filtradas por estado ('pendiente' o 'pagada')."""
    conn = get_connection()
    query = "SELECT * FROM cuentas_por_pagar WHERE 1=1"
    params = []
    if estado:
        query += " AND estado = ?"
        params.append(estado)
    query += " ORDER BY fecha_vencimiento"

    cur = conn.execute(query, params)
    result = _rows_to_dicts(cur)
    conn.close()
    return result


def conciliacion_bancaria():
    """Compara movimientos bancarios contra libros contables y devuelve las diferencias."""
    conn = get_connection()
    query = """
        SELECT b.referencia, b.fecha, b.descripcion,
               b.monto AS monto_banco, l.monto AS monto_libros,
               (b.monto - COALESCE(l.monto, 0)) AS diferencia
        FROM movimientos_bancarios b
        LEFT JOIN libros_contables l ON b.referencia = l.referencia
        WHERE l.referencia IS NULL OR b.monto != l.monto
        ORDER BY b.fecha
    """
    cur = conn.execute(query)
    result = _rows_to_dicts(cur)
    conn.close()
    return result


def ventas_resumen(categoria: str = None, mes: str = None):
    """KPIs de ventas: total, unidades y ticket promedio, opcionalmente por categoría y/o mes (YYYY-MM)."""
    conn = get_connection()
    query = """
        SELECT categoria_producto,
               COUNT(*) AS num_ventas,
               SUM(monto) AS monto_total,
               SUM(unidades) AS unidades_totales,
               ROUND(AVG(monto), 0) AS ticket_promedio
        FROM ventas
        WHERE 1=1
    """
    params = []
    if categoria:
        query += " AND categoria_producto = ?"
        params.append(categoria)
    if mes:
        query += " AND strftime('%Y-%m', fecha) = ?"
        params.append(mes)
    query += " GROUP BY categoria_producto ORDER BY monto_total DESC"

    cur = conn.execute(query, params)
    result = _rows_to_dicts(cur)
    conn.close()
    return result

def datos_grafica(tema: str):
    """Devuelve datos listos para graficar un tema específico del negocio."""
    if tema == "presupuesto_vs_real":
        filas = presupuesto_vs_real()
        por_mes = {}
        for fila in filas:
            m = fila["mes"]
            if m not in por_mes:
                por_mes[m] = {"presupuestado": 0, "real": 0}
            por_mes[m]["presupuestado"] += fila["monto_presupuestado"]
            por_mes[m]["real"] += fila["monto_real"]
        meses = sorted(por_mes.keys())
        return {
            "titulo": "Presupuesto vs. Real por mes",
            "tipo_grafico": "bar",
            "labels": meses,
            "series": [
                {"nombre": "Presupuestado", "valores": [por_mes[m]["presupuestado"] for m in meses]},
                {"nombre": "Real", "valores": [por_mes[m]["real"] for m in meses]},
            ],
        }

    if tema == "nomina_por_area":
        filas = resumen_nomina()
        por_area = {}
        for fila in filas:
            a = fila["area"]
            por_area[a] = por_area.get(a, 0) + fila["costo_total_empleador"]
        return {
            "titulo": "Nómina por área",
            "tipo_grafico": "bar",
            "labels": list(por_area.keys()),
            "series": [{"nombre": "Costo total", "valores": list(por_area.values())}],
        }

    if tema == "ventas_por_categoria":
        filas = ventas_resumen()
        return {
            "titulo": "Ventas por categoría",
            "tipo_grafico": "bar",
            "labels": [f["categoria_producto"] for f in filas],
            "series": [{"nombre": "Ventas", "valores": [f["monto_total"] for f in filas]}],
        }

    if tema == "cuentas_por_estado":
        filas = cuentas_por_pagar()
        por_estado = {}
        for fila in filas:
            e = fila["estado"]
            por_estado[e] = por_estado.get(e, 0) + fila["monto"]
        return {
            "titulo": "Cuentas por pagar",
            "tipo_grafico": "doughnut",
            "labels": list(por_estado.keys()),
            "series": [{"nombre": "Monto", "valores": list(por_estado.values())}],
        }

    return {"error": f"Tema de gráfica '{tema}' no reconocido"}
    