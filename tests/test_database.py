import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

import database


def test_conciliacion_bancaria_detecta_discrepancias():
    """Debe encontrar exactamente las 3 discrepancias intencionales."""
    resultado = database.conciliacion_bancaria()
    assert len(resultado) == 3
    referencias = {r["referencia"] for r in resultado}
    assert referencias == {"REF-006", "REF-009", "REF-010"}


def test_presupuesto_vs_real_calcula_variacion():
    """La variación absoluta debe ser gasto real menos presupuesto."""
    resultado = database.presupuesto_vs_real(mes="2026-04", area="Marketing")
    assert len(resultado) == 1
    fila = resultado[0]
    variacion_esperada = fila["monto_real"] - fila["monto_presupuestado"]
    assert fila["variacion_absoluta"] == variacion_esperada


def test_cuentas_por_pagar_filtra_por_estado():
    """Todas las facturas devueltas deben tener el estado solicitado."""
    resultado = database.cuentas_por_pagar(estado="pendiente")
    assert len(resultado) > 0
    assert all(f["estado"] == "pendiente" for f in resultado)


def test_ventas_resumen_no_esta_vacio():
    """Debe haber al menos una categoría de producto con ventas."""
    resultado = database.ventas_resumen()
    assert len(resultado) > 0
    assert all(fila["monto_total"] > 0 for fila in resultado)