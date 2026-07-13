BASE DE DATOS: EstiloUrbano
-- Módulo 2 · Actividad 1: Vistas, filtros y reportes gerenciales
-- =====================================================================
USE EstiloUrbano;
GO

-- =====================================================================
-- VISTA 1: vw_ServiciosMasRentables
-- Objetivo gerencial: identificar qué servicios generan más ingresos,
-- para decidir en cuáles enfocar promociones o capacitar más personal.
-- =====================================================================
CREATE VIEW vw_ServiciosMasRentables AS
SELECT TOP 10
    s.nombre_servicio,
    cat.nombre_categoria,
    COUNT(cs.id_servicio)        AS veces_vendido,
    SUM(cs.precio_aplicado)      AS ingresos_totales,
    AVG(cs.precio_aplicado)      AS precio_promedio
FROM Cita_Servicio cs
INNER JOIN Servicios s            ON cs.id_servicio = s.id_servicio
INNER JOIN Categorias_Servicio cat ON s.id_categoria = cat.id_categoria
WHERE cat.nombre_categoria IN ('Barbería', 'Peluquería', 'Estética', 'Cuidado Capilar')
  AND s.precio BETWEEN 100 AND 2000
GROUP BY s.nombre_servicio, cat.nombre_categoria
ORDER BY ingresos_totales DESC;
GO

-- =====================================================================
-- VISTA 2: vw_ClientesActivos
-- Objetivo gerencial: tener un listado limpio de clientes con citas
-- vigentes (no canceladas) y correo válido, para campañas de marketing
-- y fidelización.
-- =====================================================================
CREATE VIEW vw_ClientesActivos AS
SELECT DISTINCT
    cl.id_cliente,
    cl.nombre + ' ' + cl.apellido AS cliente,
    cl.correo,
    cl.telefono
FROM Clientes cl
INNER JOIN Citas c ON cl.id_cliente = c.id_cliente
WHERE c.estado <> 'Cancelada'
  AND (cl.correo LIKE '%@gmail.com' OR cl.correo LIKE '%@hotmail.com' OR cl.correo LIKE '%@outlook.com');
GO


SELECT * FROM vw_ClientesActivos
ORDER BY cliente;

-- =====================================================================
-- VISTA 3: vw_ProductividadEmpleados
-- Objetivo gerencial: medir cuántas citas atendió cada empleado y
-- cuánto generó en ingresos, como base para el pago de comisiones.
-- =====================================================================
CREATE VIEW vw_ProductividadEmpleados AS
SELECT TOP 10
    e.id_empleado,
    e.nombre + ' ' + e.apellido AS empleado,
    e.especialidad,
    COUNT(c.id_cita)             AS citas_atendidas,
    SUM(cs.precio_aplicado)      AS ingresos_generados,
    AVG(cs.precio_aplicado)      AS ticket_promedio
FROM Empleados e
INNER JOIN Citas c          ON e.id_empleado = c.id_empleado
INNER JOIN Cita_Servicio cs ON c.id_cita = cs.id_cita
WHERE c.fecha BETWEEN '2026-01-01' AND '2026-12-31'
  AND (c.estado = 'Completada' OR c.estado = 'Pendiente')
  AND NOT e.especialidad = 'Recepcionista'
GROUP BY e.id_empleado, e.nombre, e.apellido, e.especialidad
ORDER BY ingresos_generados DESC;
GO

-- =====================================================================
-- EJECUCIÓN DE LAS VISTAS (para ver los resultados)
-- =====================================================================
SELECT * FROM vw_ServiciosMasRentables;
SELECT * FROM vw_ClientesActivos;
SELECT * FROM vw_ProductividadEmpleados;
