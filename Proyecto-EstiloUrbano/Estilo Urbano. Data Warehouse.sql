-- =====================================================================
-- BASE DE DATOS: EstiloUrbano
-- Módulo 2 · Actividad 2: Procedimientos almacenados, normalización
-- y Data Warehouse
-- =====================================================================
USE EstiloUrbano;
GO

-- =====================================================================
-- 1. PROCEDIMIENTO ALMACENADO
-- Necesidad real: la gerencia quiere saber, para un cliente puntual,
-- cuántas citas activas tiene y cuánto ha gastado en total en el salón,
-- para poder ofrecerle promociones de fidelización.
-- =====================================================================
CREATE PROCEDURE sp_TotalGastadoPorCliente
    @id_cliente INT
AS
BEGIN
    SELECT
        cl.id_cliente,
        cl.nombre + ' ' + cl.apellido AS cliente,
        COUNT(DISTINCT c.id_cita)      AS total_citas,
        SUM(cs.precio_aplicado)        AS total_gastado
    FROM Clientes cl
    INNER JOIN Citas c          ON cl.id_cliente = c.id_cliente
    INNER JOIN Cita_Servicio cs ON c.id_cita = cs.id_cita
    WHERE cl.id_cliente = @id_cliente
      AND c.estado <> 'Cancelada'
    GROUP BY cl.id_cliente, cl.nombre, cl.apellido;
END
GO

-- Ejecución del procedimiento con un cliente real:
EXEC sp_TotalGastadoPorCliente @id_cliente = 1;
GO

-- =====================================================================
-- 2. REVISIÓN DE NORMALIZACIÓN (1FN, 2FN, 3FN)
-- Ver explicación completa en el documento entregable.
-- No se encontraron violaciones; el modelo ya nace de la Actividad 1
-- separando entidades y usando tabla puente Cita_Servicio.
-- =====================================================================

-- =====================================================================
-- 3. TABLA DE HECHOS PARA EL DATA WAREHOUSE
-- DW_VentasPorMesCategoria: ingresos y cantidad de servicios vendidos,
-- agrupados por año, mes y categoría de servicio.
-- =====================================================================
CREATE TABLE DW_VentasPorMesCategoria (
    id                        INT IDENTITY(1,1) PRIMARY KEY,
    ano                      INT NOT NULL,
    mes                       INT NOT NULL,
    nombre_categoria          VARCHAR(50) NOT NULL,
    total_servicios_vendidos  INT NOT NULL,
    ingresos_totales          DECIMAL(10,2) NOT NULL
);
GO

-- Carga de la tabla de hechos a partir de las tablas operativas:
INSERT INTO DW_VentasPorMesCategoria (anio, mes, nombre_categoria, total_servicios_vendidos, ingresos_totales)
SELECT
    YEAR(c.fecha)             AS anio,
    MONTH(c.fecha)            AS mes,
    cat.nombre_categoria,
    COUNT(cs.id_servicio)     AS total_servicios_vendidos,
    SUM(cs.precio_aplicado)   AS ingresos_totales
FROM Citas c
INNER JOIN Cita_Servicio cs        ON c.id_cita = cs.id_cita
INNER JOIN Servicios s             ON cs.id_servicio = s.id_servicio
INNER JOIN Categorias_Servicio cat ON s.id_categoria = cat.id_categoria
WHERE c.estado <> 'Cancelada'
GROUP BY YEAR(c.fecha), MONTH(c.fecha), cat.nombre_categoria;
GO

-- Resultado de la tabla de hechos:
SELECT * FROM DW_VentasPorMesCategoria
ORDER BY anio, mes, nombre_categoria;
GO