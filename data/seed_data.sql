-- =====================================================================
-- ANIL-AI | Datos de una empresa de E-commerce
-- =====================================================================
-- AVISO IMPORTANTE:
-- Esta empresa es TOTALMENTE FICTICIA, creada únicamente con fines
-- educativos y de portafolio. Los nombres de empleados son genéricos
-- ("Empleado Ficticio N") y los proveedores, canales de venta y cifras
-- son inventados o derivados de datos sintéticos.
--
-- La estructura y los cálculos de nómina (cesantías, prima, aportes
-- patronales de salud/pensión/ARL/CCF) están basados en un archivo de
-- nómina histórica ficticia, con cargos y áreas reasignados para
-- ajustarse al contexto de e-commerce. Ningún dato corresponde a una
-- persona, empresa o proveedor real.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. EMPLEADOS
-- ---------------------------------------------------------------------
CREATE TABLE empleados (
    id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    area TEXT NOT NULL,           -- Marketing, Logística, Tecnología, Operaciones, Administración
    cargo TEXT NOT NULL,
    salario_base REAL NOT NULL,   -- IBC (Ingreso Base de Cotización)
    fecha_ingreso TEXT NOT NULL
);

INSERT INTO empleados (id, nombre, area, cargo, salario_base, fecha_ingreso) VALUES
('EMP-035', 'Empleado Ficticio 01', 'Administración', 'Gerente General', 8000000, '2021-08-01'),
('EMP-085', 'Empleado Ficticio 02', 'Tecnología', 'Líder de Tecnología', 6800000, '2024-05-28'),
('EMP-057', 'Empleado Ficticio 03', 'Marketing', 'Director(a) de Marketing', 6500000, '2022-03-03'),
('EMP-104', 'Empleado Ficticio 04', 'Operaciones', 'Coordinador(a) de Operaciones', 6200000, '2022-03-08'),
('EMP-088', 'Empleado Ficticio 05', 'Administración', 'Tesorero(a)', 3800000, '2020-01-01'),
('EMP-153', 'Empleado Ficticio 06', 'Tecnología', 'Desarrollador(a) Backend Jr.', 2800000, '2024-04-01'),
('EMP-047', 'Empleado Ficticio 07', 'Logística', 'Jefe de Logística', 2600000, '2024-04-18'),
('EMP-008', 'Empleado Ficticio 08', 'Marketing', 'Analista de Marketing Digital', 2000000, '2021-03-01'),
('EMP-010', 'Empleado Ficticio 09', 'Marketing', 'Analista de Pauta Publicitaria', 2000000, '2025-12-23'),
('EMP-106', 'Empleado Ficticio 10', 'Operaciones', 'Analista de Servicio al Cliente', 1800000, '2022-12-01'),
('EMP-002', 'Empleado Ficticio 11', 'Operaciones', 'Analista de Servicio al Cliente', 1750905, '2022-10-04'),
('EMP-040', 'Empleado Ficticio 12', 'Tecnología', 'Analista de Soporte TI', 1750905, '2024-03-01'),
('EMP-029', 'Empleado Ficticio 13', 'Administración', 'Auxiliar Contable', 1750905, '2023-01-04'),
('EMP-030', 'Empleado Ficticio 14', 'Administración', 'Auxiliar de Nómina', 1750905, '2024-07-01'),
('EMP-003', 'Empleado Ficticio 15', 'Logística', 'Auxiliar de Bodega', 1750905, '2023-02-01'),
('EMP-004', 'Empleado Ficticio 16', 'Logística', 'Auxiliar de Bodega', 1750905, '2024-11-01');

-- ---------------------------------------------------------------------
-- 2. NÓMINA MENSUAL
-- Esquema alineado a la normativa laboral colombiana: incluye aux. de
-- transporte, descuentos del trabajador (salud/pensión), provisiones
-- (cesantías, intereses de cesantías, prima, vacaciones) y aportes
-- patronales (salud, pensión, caja de compensación, ARL).
-- ---------------------------------------------------------------------
CREATE TABLE nomina_mensual (
    empleado_id TEXT NOT NULL,
    mes TEXT NOT NULL,                         -- formato 'YYYY-MM'
    ibc REAL NOT NULL,                         -- Ingreso Base de Cotización
    auxilio_transporte REAL NOT NULL,
    descuento_salud_trabajador REAL NOT NULL,
    descuento_pension_trabajador REAL NOT NULL,
    cesantias REAL NOT NULL,
    intereses_cesantias REAL NOT NULL,
    provision_prima REAL NOT NULL,
    provision_vacaciones REAL NOT NULL,
    aporte_salud_empleador REAL NOT NULL,
    aporte_pension_empleador REAL NOT NULL,
    aporte_ccf_empleador REAL NOT NULL,
    aporte_arl_empleador REAL NOT NULL,
    costo_total_empleador REAL NOT NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

INSERT INTO nomina_mensual (empleado_id, mes, ibc, auxilio_transporte, descuento_salud_trabajador,
    descuento_pension_trabajador, cesantias, intereses_cesantias, provision_prima, provision_vacaciones,
    aporte_salud_empleador, aporte_pension_empleador, aporte_ccf_empleador, aporte_arl_empleador,
    costo_total_empleador) VALUES
('EMP-002', '2026-01', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-002', '2026-02', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-002', '2026-03', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-002', '2026-04', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-002', '2026-05', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-002', '2026-06', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-003', '2026-01', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-003', '2026-02', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-003', '2026-03', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-003', '2026-04', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-003', '2026-05', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-003', '2026-06', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-004', '2026-01', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-004', '2026-02', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-004', '2026-03', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-004', '2026-04', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-004', '2026-05', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-004', '2026-06', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 76164.4, 2931482.2),
('EMP-008', '2026-01', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-008', '2026-02', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-008', '2026-03', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-008', '2026-04', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-008', '2026-05', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-008', '2026-06', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-010', '2026-01', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-010', '2026-02', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-010', '2026-03', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-010', '2026-04', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-010', '2026-05', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-010', '2026-06', 2000000, 249095, 80000, 80000, 187424.6, 22490.9, 187424.6, 83400, 170000, 240000, 80000, 10440, 3230275.1),
('EMP-029', '2026-01', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-029', '2026-02', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-029', '2026-03', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-029', '2026-04', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-029', '2026-05', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-029', '2026-06', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-030', '2026-01', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-030', '2026-02', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-030', '2026-03', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-030', '2026-04', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-030', '2026-05', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-030', '2026-06', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-035', '2026-01', 8000000, 0, 320000, 320000, 666666.7, 80000, 666666.7, 333600, 680000, 960000, 320000, 41760, 11748693.3),
('EMP-035', '2026-02', 8000000, 0, 320000, 320000, 666666.7, 80000, 666666.7, 333600, 680000, 960000, 320000, 41760, 11748693.3),
('EMP-035', '2026-03', 8000000, 0, 320000, 320000, 666666.7, 80000, 666666.7, 333600, 680000, 960000, 320000, 41760, 11748693.3),
('EMP-035', '2026-04', 8000000, 0, 320000, 320000, 666666.7, 80000, 666666.7, 333600, 680000, 960000, 320000, 41760, 11748693.3),
('EMP-035', '2026-05', 8000000, 0, 320000, 320000, 666666.7, 80000, 666666.7, 333600, 680000, 960000, 320000, 41760, 11748693.3),
('EMP-035', '2026-06', 8000000, 0, 320000, 320000, 666666.7, 80000, 666666.7, 333600, 680000, 960000, 320000, 41760, 11748693.3),
('EMP-040', '2026-01', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-040', '2026-02', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-040', '2026-03', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-040', '2026-04', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-040', '2026-05', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-040', '2026-06', 1750905, 249095, 70036.2, 70036.2, 166666.7, 20000, 166666.7, 73012.7, 148826.9, 210108.6, 70036.2, 9139.7, 2864457.5),
('EMP-047', '2026-01', 2600000, 249095, 104000, 104000, 237424.6, 28490.9, 237424.6, 108420, 221000, 312000, 104000, 113100, 4210955.1),
('EMP-047', '2026-02', 2600000, 249095, 104000, 104000, 237424.6, 28490.9, 237424.6, 108420, 221000, 312000, 104000, 113100, 4210955.1),
('EMP-047', '2026-03', 2600000, 249095, 104000, 104000, 237424.6, 28490.9, 237424.6, 108420, 221000, 312000, 104000, 113100, 4210955.1),
('EMP-047', '2026-04', 2600000, 249095, 104000, 104000, 237424.6, 28490.9, 237424.6, 108420, 221000, 312000, 104000, 113100, 4210955.1),
('EMP-047', '2026-05', 2600000, 249095, 104000, 104000, 237424.6, 28490.9, 237424.6, 108420, 221000, 312000, 104000, 113100, 4210955.1),
('EMP-047', '2026-06', 2600000, 249095, 104000, 104000, 237424.6, 28490.9, 237424.6, 108420, 221000, 312000, 104000, 113100, 4210955.1),
('EMP-057', '2026-01', 6500000, 0, 260000, 260000, 541666.7, 65000, 541666.7, 271050, 552500, 780000, 260000, 33930, 9545813.3),
('EMP-057', '2026-02', 6500000, 0, 260000, 260000, 541666.7, 65000, 541666.7, 271050, 552500, 780000, 260000, 33930, 9545813.3),
('EMP-057', '2026-03', 6500000, 0, 260000, 260000, 541666.7, 65000, 541666.7, 271050, 552500, 780000, 260000, 33930, 9545813.3),
('EMP-057', '2026-04', 6500000, 0, 260000, 260000, 541666.7, 65000, 541666.7, 271050, 552500, 780000, 260000, 33930, 9545813.3),
('EMP-057', '2026-05', 6500000, 0, 260000, 260000, 541666.7, 65000, 541666.7, 271050, 552500, 780000, 260000, 33930, 9545813.3),
('EMP-057', '2026-06', 6500000, 0, 260000, 260000, 541666.7, 65000, 541666.7, 271050, 552500, 780000, 260000, 33930, 9545813.3),
('EMP-085', '2026-01', 6800000, 0, 272000, 272000, 566666.7, 68000, 566666.7, 283560, 578000, 816000, 272000, 35496, 9986389.3),
('EMP-085', '2026-02', 6800000, 0, 272000, 272000, 566666.7, 68000, 566666.7, 283560, 578000, 816000, 272000, 35496, 9986389.3),
('EMP-085', '2026-03', 6800000, 0, 272000, 272000, 566666.7, 68000, 566666.7, 283560, 578000, 816000, 272000, 35496, 9986389.3),
('EMP-085', '2026-04', 6800000, 0, 272000, 272000, 566666.7, 68000, 566666.7, 283560, 578000, 816000, 272000, 35496, 9986389.3),
('EMP-085', '2026-05', 6800000, 0, 272000, 272000, 566666.7, 68000, 566666.7, 283560, 578000, 816000, 272000, 35496, 9986389.3),
('EMP-085', '2026-06', 6800000, 0, 272000, 272000, 566666.7, 68000, 566666.7, 283560, 578000, 816000, 272000, 35496, 9986389.3),
('EMP-088', '2026-01', 3800000, 0, 152000, 152000, 316666.7, 38000, 316666.7, 158460, 323000, 456000, 152000, 19836, 5580629.3),
('EMP-088', '2026-02', 3800000, 0, 152000, 152000, 316666.7, 38000, 316666.7, 158460, 323000, 456000, 152000, 19836, 5580629.3),
('EMP-088', '2026-03', 3800000, 0, 152000, 152000, 316666.7, 38000, 316666.7, 158460, 323000, 456000, 152000, 19836, 5580629.3),
('EMP-088', '2026-04', 3800000, 0, 152000, 152000, 316666.7, 38000, 316666.7, 158460, 323000, 456000, 152000, 19836, 5580629.3),
('EMP-088', '2026-05', 3800000, 0, 152000, 152000, 316666.7, 38000, 316666.7, 158460, 323000, 456000, 152000, 19836, 5580629.3),
('EMP-088', '2026-06', 3800000, 0, 152000, 152000, 316666.7, 38000, 316666.7, 158460, 323000, 456000, 152000, 19836, 5580629.3),
('EMP-104', '2026-01', 6200000, 0, 248000, 248000, 516666.7, 62000, 516666.7, 258540, 527000, 744000, 248000, 32364, 9105237.3),
('EMP-104', '2026-02', 6200000, 0, 248000, 248000, 516666.7, 62000, 516666.7, 258540, 527000, 744000, 248000, 32364, 9105237.3),
('EMP-104', '2026-03', 6200000, 0, 248000, 248000, 516666.7, 62000, 516666.7, 258540, 527000, 744000, 248000, 32364, 9105237.3),
('EMP-104', '2026-04', 6200000, 0, 248000, 248000, 516666.7, 62000, 516666.7, 258540, 527000, 744000, 248000, 32364, 9105237.3),
('EMP-104', '2026-05', 6200000, 0, 248000, 248000, 516666.7, 62000, 516666.7, 258540, 527000, 744000, 248000, 32364, 9105237.3),
('EMP-104', '2026-06', 6200000, 0, 248000, 248000, 516666.7, 62000, 516666.7, 258540, 527000, 744000, 248000, 32364, 9105237.3),
('EMP-106', '2026-01', 1800000, 249095, 72000, 72000, 170757.9, 20490.9, 170757.9, 75060, 153000, 216000, 72000, 9396, 2936557.8),
('EMP-106', '2026-02', 1800000, 249095, 72000, 72000, 170757.9, 20490.9, 170757.9, 75060, 153000, 216000, 72000, 9396, 2936557.8),
('EMP-106', '2026-03', 1800000, 249095, 72000, 72000, 170757.9, 20490.9, 170757.9, 75060, 153000, 216000, 72000, 9396, 2936557.8),
('EMP-106', '2026-04', 1800000, 249095, 72000, 72000, 170757.9, 20490.9, 170757.9, 75060, 153000, 216000, 72000, 9396, 2936557.8),
('EMP-106', '2026-05', 1800000, 249095, 72000, 72000, 170757.9, 20490.9, 170757.9, 75060, 153000, 216000, 72000, 9396, 2936557.8),
('EMP-106', '2026-06', 1800000, 249095, 72000, 72000, 170757.9, 20490.9, 170757.9, 75060, 153000, 216000, 72000, 9396, 2936557.8),
('EMP-153', '2026-01', 2800000, 249095, 112000, 112000, 254091.2, 30490.9, 254091.2, 116760, 238000, 336000, 112000, 68208, 4458736.5),
('EMP-153', '2026-02', 2800000, 249095, 112000, 112000, 254091.2, 30490.9, 254091.2, 116760, 238000, 336000, 112000, 68208, 4458736.5),
('EMP-153', '2026-03', 2800000, 249095, 112000, 112000, 254091.2, 30490.9, 254091.2, 116760, 238000, 336000, 112000, 68208, 4458736.5),
('EMP-153', '2026-04', 2800000, 249095, 112000, 112000, 254091.2, 30490.9, 254091.2, 116760, 238000, 336000, 112000, 68208, 4458736.5),
('EMP-153', '2026-05', 2800000, 249095, 112000, 112000, 254091.2, 30490.9, 254091.2, 116760, 238000, 336000, 112000, 68208, 4458736.5),
('EMP-153', '2026-06', 2800000, 249095, 112000, 112000, 254091.2, 30490.9, 254091.2, 116760, 238000, 336000, 112000, 68208, 4458736.5);

-- ---------------------------------------------------------------------
-- 3. PRESUPUESTO (para análisis FP&A: presupuesto vs. real)
-- ---------------------------------------------------------------------
CREATE TABLE presupuesto (
    id INTEGER PRIMARY KEY,
    area TEXT NOT NULL,
    categoria TEXT NOT NULL,      -- Pauta Publicitaria, Envíos, Software, Otros
    mes TEXT NOT NULL,
    monto_presupuestado REAL NOT NULL
);

INSERT INTO presupuesto (area, categoria, mes, monto_presupuestado) VALUES
('Marketing',      'Pauta Publicitaria', '2026-01', 18000000),
('Marketing',      'Pauta Publicitaria', '2026-02', 18000000),
('Marketing',      'Pauta Publicitaria', '2026-03', 20000000),
('Marketing',      'Pauta Publicitaria', '2026-04', 20000000),
('Marketing',      'Pauta Publicitaria', '2026-05', 22000000),
('Marketing',      'Pauta Publicitaria', '2026-06', 22000000),
('Logística',      'Envíos',             '2026-01', 15000000),
('Logística',      'Envíos',             '2026-02', 15000000),
('Logística',      'Envíos',             '2026-03', 16000000),
('Logística',      'Envíos',             '2026-04', 16000000),
('Logística',      'Envíos',             '2026-05', 17000000),
('Logística',      'Envíos',             '2026-06', 17000000),
('Tecnología',     'Software',           '2026-01', 8000000),
('Tecnología',     'Software',           '2026-02', 8000000),
('Tecnología',     'Software',           '2026-03', 8500000),
('Tecnología',     'Software',           '2026-04', 8500000),
('Tecnología',     'Software',           '2026-05', 9000000),
('Tecnología',     'Software',           '2026-06', 9000000),
('Administración', 'Otros',              '2026-01', 5000000),
('Administración', 'Otros',              '2026-02', 5000000),
('Administración', 'Otros',              '2026-03', 5200000),
('Administración', 'Otros',              '2026-04', 5200000),
('Administración', 'Otros',              '2026-05', 5500000),
('Administración', 'Otros',              '2026-06', 5500000);

-- ---------------------------------------------------------------------
-- 4. GASTOS REALES (para comparar contra el presupuesto)
-- ---------------------------------------------------------------------
CREATE TABLE gastos_reales (
    id INTEGER PRIMARY KEY,
    area TEXT NOT NULL,
    categoria TEXT NOT NULL,
    mes TEXT NOT NULL,
    monto_real REAL NOT NULL
);

INSERT INTO gastos_reales (area, categoria, mes, monto_real) VALUES
('Marketing',      'Pauta Publicitaria', '2026-01', 17200000),
('Marketing',      'Pauta Publicitaria', '2026-02', 19500000),
('Marketing',      'Pauta Publicitaria', '2026-03', 19800000),
('Marketing',      'Pauta Publicitaria', '2026-04', 24600000),  -- variación fuerte (anomalía)
('Marketing',      'Pauta Publicitaria', '2026-05', 21500000),
('Marketing',      'Pauta Publicitaria', '2026-06', 22300000),
('Logística',      'Envíos',             '2026-01', 14500000),
('Logística',      'Envíos',             '2026-02', 15800000),
('Logística',      'Envíos',             '2026-03', 16100000),
('Logística',      'Envíos',             '2026-04', 15900000),
('Logística',      'Envíos',             '2026-05', 18700000),
('Logística',      'Envíos',             '2026-06', 17200000),
('Tecnología',     'Software',           '2026-01', 7900000),
('Tecnología',     'Software',           '2026-02', 8100000),
('Tecnología',     'Software',           '2026-03', 8400000),
('Tecnología',     'Software',           '2026-04', 8450000),
('Tecnología',     'Software',           '2026-05', 8950000),
('Tecnología',     'Software',           '2026-06', 9200000),
('Administración', 'Otros',              '2026-01', 4800000),
('Administración', 'Otros',              '2026-02', 5100000),
('Administración', 'Otros',              '2026-03', 5150000),
('Administración', 'Otros',              '2026-04', 5300000),
('Administración', 'Otros',              '2026-05', 5450000),
('Administración', 'Otros',              '2026-06', 5600000);

-- ---------------------------------------------------------------------
-- 5. CUENTAS POR PAGAR (proveedores genéricos/ficticios)
-- ---------------------------------------------------------------------
CREATE TABLE cuentas_por_pagar (
    id INTEGER PRIMARY KEY,
    proveedor TEXT NOT NULL,
    numero_factura TEXT NOT NULL,
    fecha_emision TEXT NOT NULL,
    fecha_vencimiento TEXT NOT NULL,
    monto REAL NOT NULL,
    estado TEXT NOT NULL          -- 'pendiente' o 'pagada'
);

INSERT INTO cuentas_por_pagar (proveedor, numero_factura, fecha_emision, fecha_vencimiento, monto, estado) VALUES
('Transportes Rápidos del Norte',   'FE-1001', '2026-05-02', '2026-06-01', 4200000, 'pagada'),
('Transportes Rápidos del Norte',   'FE-1015', '2026-06-02', '2026-07-01', 4500000, 'pendiente'),
('Envíos Express Andina',           'FE-2044', '2026-05-10', '2026-06-09', 3100000, 'pagada'),
('Envíos Express Andina',           'FE-2061', '2026-06-10', '2026-07-09', 3300000, 'pendiente'),
('NubeTech Servicios Cloud',        'FE-3302', '2026-05-01', '2026-05-31', 6800000, 'pagada'),
('NubeTech Servicios Cloud',        'FE-3350', '2026-06-01', '2026-06-30', 7100000, 'pendiente'),
('AdVolta Publicidad Digital',      'FE-4410', '2026-05-05', '2026-06-04', 12500000, 'pagada'),
('AdVolta Publicidad Digital',      'FE-4460', '2026-06-05', '2026-07-04', 13800000, 'pendiente'),
('Conecta Redes Publicitarias',     'FE-5501', '2026-05-08', '2026-06-07', 8900000, 'pagada'),
('Conecta Redes Publicitarias',     'FE-5550', '2026-06-08', '2026-07-07', 9600000, 'pendiente'),
('Distribuidora Central de Insumos','FE-6001', '2026-04-20', '2026-05-20', 15200000, 'pagada'),
('Distribuidora Central de Insumos','FE-6045', '2026-06-01', '2026-07-01', 16000000, 'pendiente'),
('Arriendo Bodega Zona Norte',      'FE-7001', '2026-06-01', '2026-06-30', 5200000, 'pendiente');

-- ---------------------------------------------------------------------
-- 6. MOVIMIENTOS BANCARIOS y LIBROS CONTABLES (para conciliación)
-- ---------------------------------------------------------------------
CREATE TABLE movimientos_bancarios (
    id INTEGER PRIMARY KEY,
    fecha TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    monto REAL NOT NULL,          -- positivo = ingreso, negativo = egreso
    referencia TEXT
);

CREATE TABLE libros_contables (
    id INTEGER PRIMARY KEY,
    fecha TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    monto REAL NOT NULL,
    referencia TEXT
);

-- Se dejan 3 discrepancias intencionales para que el agente las detecte.
INSERT INTO movimientos_bancarios (fecha, descripcion, monto, referencia) VALUES
('2026-06-01', 'Pago Transportes Rápidos del Norte', -4200000, 'REF-001'),
('2026-06-03', 'Recaudo ventas Canal Marketplace A',  22500000, 'REF-002'),
('2026-06-05', 'Pago NubeTech Servicios Cloud',       -6800000, 'REF-003'),
('2026-06-07', 'Recaudo ventas Tienda Propia',         18200000, 'REF-004'),
('2026-06-09', 'Pago Envíos Express Andina',          -3100000, 'REF-005'),
('2026-06-12', 'Recaudo ventas Canal Marketplace B',    9800000, 'REF-006'),
('2026-06-15', 'Pago nómina primera quincena',        -21500000, 'REF-007'),
('2026-06-18', 'Recaudo ventas Canal Marketplace A',   24100000, 'REF-008'),
('2026-06-20', 'Comisión bancaria',                      -85000, 'REF-009'),
('2026-06-22', 'Pago Conecta Redes Publicitarias',     -8900000, 'REF-010');

INSERT INTO libros_contables (fecha, descripcion, monto, referencia) VALUES
('2026-06-01', 'Pago Transportes Rápidos del Norte', -4200000, 'REF-001'),
('2026-06-03', 'Recaudo ventas Canal Marketplace A',  22500000, 'REF-002'),
('2026-06-05', 'Pago NubeTech Servicios Cloud',       -6800000, 'REF-003'),
('2026-06-07', 'Recaudo ventas Tienda Propia',         18200000, 'REF-004'),
('2026-06-09', 'Pago Envíos Express Andina',          -3100000, 'REF-005'),
('2026-06-12', 'Recaudo ventas Canal Marketplace B',    9750000, 'REF-006'),  -- diferencia intencional
('2026-06-15', 'Pago nómina primera quincena',        -21500000, 'REF-007'),
('2026-06-18', 'Recaudo ventas Canal Marketplace A',   24100000, 'REF-008'),
-- REF-009 (comisión bancaria) no fue registrada en libros -> discrepancia
('2026-06-22', 'Pago Conecta Redes Publicitarias',     -8950000, 'REF-010');  -- diferencia intencional

-- ---------------------------------------------------------------------
-- 7. VENTAS
-- FUENTE Y ATRIBUCIÓN:
-- Los valores de esta tabla (categorías, montos y cantidades) están
-- derivados de una muestra real del dataset público "Amazon Sale
-- Report" (Kaggle, ventas de e-commerce de moda, India, 2022),
-- usado aquí únicamente con fines educativos/portafolio. Se realizaron
-- las siguientes transformaciones sobre los datos originales:
--   - Se excluyeron pedidos cancelados.
--   - El nombre del canal de venta se reemplazó por uno genérico
--     ("Tienda en Línea"), ya que este proyecto no está afiliado ni
--     representa a Amazon ni a ninguna otra marca real.
--   - Las categorías de producto se tradujeron al español.
--   - Los montos se reescalaron a una magnitud consistente con el
--     resto del proyecto (no corresponden a una tasa de cambio oficial).
--   - Las fechas se desplazaron al año 2026 para alinearlas con el
--     resto de los datos financieros del proyecto.
-- ---------------------------------------------------------------------
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    fecha TEXT NOT NULL,
    canal TEXT NOT NULL,
    categoria_producto TEXT NOT NULL,
    monto REAL NOT NULL,
    unidades INTEGER NOT NULL
);

INSERT INTO ventas (fecha, canal, categoria_producto, monto, unidades) VALUES
('2026-03-31', 'Tienda en Línea', 'Conjunto', 31350, 1),
('2026-04-01', 'Tienda en Línea', 'Vestido Étnico', 46350, 1),
('2026-04-01', 'Tienda en Línea', 'Conjunto', 49950, 1),
('2026-04-02', 'Tienda en Línea', 'Conjunto', 31350, 1),
('2026-04-02', 'Tienda en Línea', 'Vestido Casual', 46250, 1),
('2026-04-02', 'Tienda en Línea', 'Blusa', 24950, 1),
('2026-04-03', 'Tienda en Línea', 'Conjunto', 52550, 1),
('2026-04-03', 'Tienda en Línea', 'Vestido Étnico', 15850, 1),
('2026-04-03', 'Tienda en Línea', 'Vestido Étnico', 34900, 2),
('2026-04-03', 'Tienda en Línea', 'Vestido Étnico', 26050, 1),
('2026-04-05', 'Tienda en Línea', 'Conjunto', 36450, 1),
('2026-04-05', 'Tienda en Línea', 'Vestido Étnico', 15950, 1),
('2026-04-05', 'Tienda en Línea', 'Vestido Étnico', 22450, 1),
('2026-04-06', 'Tienda en Línea', 'Blusa', 29950, 1),
('2026-04-06', 'Tienda en Línea', 'Vestido Étnico', 21750, 1),
('2026-04-06', 'Tienda en Línea', 'Vestido Étnico', 38550, 1),
('2026-04-06', 'Tienda en Línea', 'Vestido Étnico', 21300, 1),
('2026-04-08', 'Tienda en Línea', 'Vestido Étnico', 24350, 1),
('2026-04-08', 'Tienda en Línea', 'Vestido Étnico', 24350, 1),
('2026-04-08', 'Tienda en Línea', 'Vestido Casual', 37200, 1),
('2026-04-09', 'Tienda en Línea', 'Conjunto', 33000, 1),
('2026-04-09', 'Tienda en Línea', 'Vestido Étnico', 18800, 1),
('2026-04-11', 'Tienda en Línea', 'Vestido Étnico', 25850, 1),
('2026-04-12', 'Tienda en Línea', 'Vestido Étnico', 18800, 1),
('2026-04-12', 'Tienda en Línea', 'Conjunto', 44050, 1),
('2026-04-12', 'Tienda en Línea', 'Vestido Étnico', 21750, 1),
('2026-04-12', 'Tienda en Línea', 'Vestido Casual', 40350, 1),
('2026-04-12', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-04-12', 'Tienda en Línea', 'Conjunto', 49950, 1),
('2026-04-13', 'Tienda en Línea', 'Vestido Casual', 40350, 1),
('2026-04-13', 'Tienda en Línea', 'Conjunto', 44400, 1),
('2026-04-13', 'Tienda en Línea', 'Conjunto', 57000, 1),
('2026-04-13', 'Tienda en Línea', 'Conjunto', 36250, 1),
('2026-04-13', 'Tienda en Línea', 'Conjunto', 39400, 1),
('2026-04-14', 'Tienda en Línea', 'Conjunto', 59300, 1),
('2026-04-14', 'Tienda en Línea', 'Vestido Casual', 36050, 1),
('2026-04-14', 'Tienda en Línea', 'Blusa', 28700, 1),
('2026-04-14', 'Tienda en Línea', 'Conjunto', 41200, 1),
('2026-04-14', 'Tienda en Línea', 'Conjunto', 41200, 1),
('2026-04-15', 'Tienda en Línea', 'Blusa', 15950, 1),
('2026-04-15', 'Tienda en Línea', 'Conjunto', 31550, 1),
('2026-04-15', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-04-16', 'Tienda en Línea', 'Vestido Étnico', 56800, 2),
('2026-04-16', 'Tienda en Línea', 'Conjunto', 32700, 1),
('2026-04-16', 'Tienda en Línea', 'Conjunto', 27450, 1),
('2026-04-16', 'Tienda en Línea', 'Vestido Étnico', 16450, 1),
('2026-04-16', 'Tienda en Línea', 'Conjunto', 39400, 1),
('2026-04-16', 'Tienda en Línea', 'Conjunto', 48450, 1),
('2026-04-17', 'Tienda en Línea', 'Vestido Étnico', 23550, 1),
('2026-04-17', 'Tienda en Línea', 'Blusa', 26150, 1),
('2026-04-17', 'Tienda en Línea', 'Conjunto', 37550, 1),
('2026-04-17', 'Tienda en Línea', 'Conjunto', 29550, 1),
('2026-04-17', 'Tienda en Línea', 'Blusa', 27000, 1),
('2026-04-18', 'Tienda en Línea', 'Blusa', 27000, 1),
('2026-04-18', 'Tienda en Línea', 'Vestido Étnico', 12950, 1),
('2026-04-19', 'Tienda en Línea', 'Conjunto', 29850, 1),
('2026-04-19', 'Tienda en Línea', 'Blusa', 24350, 1),
('2026-04-19', 'Tienda en Línea', 'Vestido Étnico', 23750, 1),
('2026-04-20', 'Tienda en Línea', 'Conjunto', 39400, 1),
('2026-04-20', 'Tienda en Línea', 'Conjunto', 41750, 1),
('2026-04-21', 'Tienda en Línea', 'Conjunto', 54950, 1),
('2026-04-22', 'Tienda en Línea', 'Vestido Étnico', 17450, 1),
('2026-04-23', 'Tienda en Línea', 'Vestido Étnico', 21750, 1),
('2026-04-23', 'Tienda en Línea', 'Conjunto', 28150, 1),
('2026-04-23', 'Tienda en Línea', 'Blusa', 28700, 1),
('2026-04-24', 'Tienda en Línea', 'Vestido Étnico', 25850, 1),
('2026-04-24', 'Tienda en Línea', 'Blusa', 24650, 1),
('2026-04-24', 'Tienda en Línea', 'Vestido Casual', 37200, 1),
('2026-04-24', 'Tienda en Línea', 'Conjunto', 73150, 1),
('2026-04-24', 'Tienda en Línea', 'Conjunto', 28150, 1),
('2026-04-25', 'Tienda en Línea', 'Vestido Étnico', 18150, 1),
('2026-04-26', 'Tienda en Línea', 'Conjunto', 39400, 1),
('2026-04-27', 'Tienda en Línea', 'Conjunto', 33300, 1),
('2026-04-27', 'Tienda en Línea', 'Vestido Étnico', 18800, 1),
('2026-04-29', 'Tienda en Línea', 'Vestido Étnico', 22900, 1),
('2026-04-29', 'Tienda en Línea', 'Conjunto', 29850, 1),
('2026-04-29', 'Tienda en Línea', 'Conjunto', 29100, 1),
('2026-04-30', 'Tienda en Línea', 'Vestido Casual', 36050, 1),
('2026-05-01', 'Tienda en Línea', 'Conjunto', 24950, 1),
('2026-05-01', 'Tienda en Línea', 'Vestido Casual', 34500, 1),
('2026-05-02', 'Tienda en Línea', 'Vestido Étnico', 22100, 1),
('2026-05-02', 'Tienda en Línea', 'Conjunto', 29850, 1),
('2026-05-02', 'Tienda en Línea', 'Vestido Casual', 36200, 1),
('2026-05-03', 'Tienda en Línea', 'Blusa Formal', 27250, 1),
('2026-05-03', 'Tienda en Línea', 'Vestido Casual', 37150, 1),
('2026-05-04', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-05-04', 'Tienda en Línea', 'Conjunto', 32750, 1),
('2026-05-04', 'Tienda en Línea', 'Vestido Étnico', 18800, 1),
('2026-05-04', 'Tienda en Línea', 'Vestido Étnico', 17850, 1),
('2026-05-04', 'Tienda en Línea', 'Conjunto', 37550, 1),
('2026-05-05', 'Tienda en Línea', 'Vestido Étnico', 24200, 1),
('2026-05-05', 'Tienda en Línea', 'Vestido Casual', 44950, 1),
('2026-05-05', 'Tienda en Línea', 'Conjunto', 37950, 1),
('2026-05-05', 'Tienda en Línea', 'Vestido Étnico', 21400, 1),
('2026-05-06', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-05-07', 'Tienda en Línea', 'Conjunto', 38350, 1),
('2026-05-08', 'Tienda en Línea', 'Conjunto', 27150, 1),
('2026-05-08', 'Tienda en Línea', 'Vestido Étnico', 14600, 1),
('2026-05-11', 'Tienda en Línea', 'Vestido Casual', 38550, 1),
('2026-05-12', 'Tienda en Línea', 'Vestido Casual', 37050, 1),
('2026-05-13', 'Tienda en Línea', 'Conjunto', 26850, 1),
('2026-05-13', 'Tienda en Línea', 'Conjunto', 34800, 1),
('2026-05-13', 'Tienda en Línea', 'Vestido Étnico', 26150, 1),
('2026-05-14', 'Tienda en Línea', 'Conjunto', 44450, 1),
('2026-05-15', 'Tienda en Línea', 'Conjunto', 53600, 1),
('2026-05-15', 'Tienda en Línea', 'Vestido Tradicional', 49950, 1),
('2026-05-15', 'Tienda en Línea', 'Vestido Étnico', 23550, 1),
('2026-05-16', 'Tienda en Línea', 'Conjunto', 36800, 1),
('2026-05-17', 'Tienda en Línea', 'Conjunto', 34800, 1),
('2026-05-17', 'Tienda en Línea', 'Vestido Casual', 44250, 1),
('2026-05-19', 'Tienda en Línea', 'Conjunto', 69950, 1),
('2026-05-19', 'Tienda en Línea', 'Conjunto', 39550, 1),
('2026-05-20', 'Tienda en Línea', 'Vestido Étnico', 15050, 1),
('2026-05-21', 'Tienda en Línea', 'Pantalón', 16550, 1),
('2026-05-22', 'Tienda en Línea', 'Conjunto', 53600, 1),
('2026-05-23', 'Tienda en Línea', 'Conjunto', 49950, 1),
('2026-05-24', 'Tienda en Línea', 'Blusa', 28700, 1),
('2026-05-24', 'Tienda en Línea', 'Vestido Étnico', 20250, 1),
('2026-05-25', 'Tienda en Línea', 'Vestido Étnico', 43450, 1),
('2026-05-25', 'Tienda en Línea', 'Vestido Étnico', 15900, 1),
('2026-05-25', 'Tienda en Línea', 'Conjunto', 38550, 1),
('2026-05-25', 'Tienda en Línea', 'Vestido Étnico', 19100, 1),
('2026-05-25', 'Tienda en Línea', 'Blusa', 27250, 1),
('2026-05-26', 'Tienda en Línea', 'Conjunto', 23900, 1),
('2026-05-26', 'Tienda en Línea', 'Vestido Étnico', 23450, 1),
('2026-05-27', 'Tienda en Línea', 'Vestido Étnico', 15050, 1),
('2026-05-27', 'Tienda en Línea', 'Vestido Étnico', 24350, 1),
('2026-05-27', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-05-28', 'Tienda en Línea', 'Blusa', 28700, 1),
('2026-05-28', 'Tienda en Línea', 'Vestido Étnico', 25850, 1),
('2026-05-28', 'Tienda en Línea', 'Conjunto', 41850, 1),
('2026-05-28', 'Tienda en Línea', 'Blusa', 25900, 1),
('2026-05-29', 'Tienda en Línea', 'Conjunto', 31750, 1),
('2026-05-29', 'Tienda en Línea', 'Conjunto', 31550, 1),
('2026-05-30', 'Tienda en Línea', 'Conjunto', 59300, 1),
('2026-05-30', 'Tienda en Línea', 'Vestido Casual', 31250, 1),
('2026-06-01', 'Tienda en Línea', 'Conjunto', 74950, 1),
('2026-06-01', 'Tienda en Línea', 'Conjunto', 65950, 1),
('2026-06-02', 'Tienda en Línea', 'Vestido Étnico', 24300, 1),
('2026-06-02', 'Tienda en Línea', 'Conjunto', 54950, 1),
('2026-06-03', 'Tienda en Línea', 'Blusa', 41800, 1),
('2026-06-04', 'Tienda en Línea', 'Conjunto', 49950, 1),
('2026-06-04', 'Tienda en Línea', 'Vestido Casual', 41200, 1),
('2026-06-04', 'Tienda en Línea', 'Vestido Étnico', 18800, 1),
('2026-06-04', 'Tienda en Línea', 'Conjunto', 39950, 1),
('2026-06-05', 'Tienda en Línea', 'Conjunto', 49950, 1),
('2026-06-05', 'Tienda en Línea', 'Vestido Casual', 58400, 1),
('2026-06-07', 'Tienda en Línea', 'Vestido Étnico', 36800, 1),
('2026-06-07', 'Tienda en Línea', 'Conjunto', 58150, 1),
('2026-06-07', 'Tienda en Línea', 'Vestido Étnico', 24550, 1),
('2026-06-08', 'Tienda en Línea', 'Vestido Étnico', 23800, 1),
('2026-06-08', 'Tienda en Línea', 'Vestido Étnico', 19350, 1),
('2026-06-08', 'Tienda en Línea', 'Vestido Étnico', 27200, 1),
('2026-06-09', 'Tienda en Línea', 'Vestido Étnico', 15050, 1),
('2026-06-10', 'Tienda en Línea', 'Vestido Étnico', 14600, 1),
('2026-06-11', 'Tienda en Línea', 'Vestido Étnico', 46250, 1),
('2026-06-12', 'Tienda en Línea', 'Conjunto', 30600, 1),
('2026-06-12', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-06-13', 'Tienda en Línea', 'Vestido Étnico', 31750, 1),
('2026-06-13', 'Tienda en Línea', 'Vestido Étnico', 21750, 1),
('2026-06-13', 'Tienda en Línea', 'Vestido Étnico', 26250, 1),
('2026-06-15', 'Tienda en Línea', 'Vestido Étnico', 33300, 1),
('2026-06-15', 'Tienda en Línea', 'Conjunto', 56100, 1),
('2026-06-15', 'Tienda en Línea', 'Vestido Tradicional', 23750, 1),
('2026-06-16', 'Tienda en Línea', 'Vestido Étnico', 31750, 1),
('2026-06-17', 'Tienda en Línea', 'Vestido Casual', 36750, 1),
('2026-06-17', 'Tienda en Línea', 'Vestido Étnico', 64500, 2),
('2026-06-18', 'Tienda en Línea', 'Blusa', 15050, 1),
('2026-06-18', 'Tienda en Línea', 'Conjunto', 31750, 1),
('2026-06-18', 'Tienda en Línea', 'Conjunto', 64050, 1),
('2026-06-18', 'Tienda en Línea', 'Conjunto', 58800, 1),
('2026-06-21', 'Tienda en Línea', 'Vestido Étnico', 19350, 1),
('2026-06-21', 'Tienda en Línea', 'Vestido Étnico', 21550, 1),
('2026-06-21', 'Tienda en Línea', 'Conjunto', 58150, 1),
('2026-06-21', 'Tienda en Línea', 'Conjunto', 29950, 1),
('2026-06-21', 'Tienda en Línea', 'Conjunto', 24050, 1),
('2026-06-22', 'Tienda en Línea', 'Blusa', 21050, 1),
('2026-06-22', 'Tienda en Línea', 'Conjunto', 53750, 1),
('2026-06-22', 'Tienda en Línea', 'Vestido Casual', 36750, 1),
('2026-06-22', 'Tienda en Línea', 'Vestido Casual', 38550, 1),
('2026-06-22', 'Tienda en Línea', 'Conjunto', 39400, 1),
('2026-06-22', 'Tienda en Línea', 'Vestido Étnico', 34800, 1),
('2026-06-22', 'Tienda en Línea', 'Vestido Étnico', 32700, 1),
('2026-06-23', 'Tienda en Línea', 'Vestido Étnico', 26050, 1),
('2026-06-24', 'Tienda en Línea', 'Vestido Étnico', 24350, 1),
('2026-06-24', 'Tienda en Línea', 'Vestido Étnico', 22050, 1),
('2026-06-24', 'Tienda en Línea', 'Vestido Casual', 36750, 1),
('2026-06-25', 'Tienda en Línea', 'Conjunto', 42600, 1),
('2026-06-27', 'Tienda en Línea', 'Vestido Casual', 36750, 1),
('2026-06-27', 'Tienda en Línea', 'Conjunto', 66900, 1),
('2026-06-27', 'Tienda en Línea', 'Vestido Étnico', 22950, 1),
('2026-06-27', 'Tienda en Línea', 'Conjunto', 31300, 1),
('2026-06-28', 'Tienda en Línea', 'Vestido Étnico', 18800, 1),
('2026-06-28', 'Tienda en Línea', 'Vestido Casual', 36750, 1),
('2026-06-28', 'Tienda en Línea', 'Vestido Étnico', 28950, 1),
('2026-06-28', 'Tienda en Línea', 'Conjunto', 49950, 1),
('2026-06-28', 'Tienda en Línea', 'Vestido Casual', 36750, 1),
('2026-06-29', 'Tienda en Línea', 'Vestido Étnico', 19950, 1),
('2026-06-29', 'Tienda en Línea', 'Vestido Étnico', 15050, 1);
