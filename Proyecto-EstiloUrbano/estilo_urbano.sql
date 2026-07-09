==========================================================================
-- BASE DE DATOS: EstiloUrbano
-- Empresa: Estilo Urbano Salón & Barbería
-- Actividad 2: Construcción de la base de datos y primeras consultas SQL
-- =====================================================================
 
-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE EstiloUrbano;
GO
USE EstiloUrbano;
GO
 
-- =====================================================================
-- 2. CREACIÓN DE TABLAS (DDL)
-- =====================================================================
 
CREATE TABLE Clientes (
    id_cliente      INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(50)  NOT NULL,
    apellido        VARCHAR(50)  NOT NULL,
    telefono        VARCHAR(15),
    correo          VARCHAR(100),
    fecha_registro  DATE NOT NULL
);
 
CREATE TABLE Empleados (
    id_empleado         INT IDENTITY(1,1) PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL,
    apellido            VARCHAR(50) NOT NULL,
    telefono            VARCHAR(15),
    especialidad        VARCHAR(50),
    fecha_contratacion  DATE NOT NULL
);
 
CREATE TABLE Categorias_Servicio (
    id_categoria      INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria  VARCHAR(50) NOT NULL
);
 
CREATE TABLE Servicios (
    id_servicio       INT IDENTITY(1,1) PRIMARY KEY,
    nombre_servicio   VARCHAR(50) NOT NULL,
    descripcion       VARCHAR(150),
    precio            DECIMAL(10,2) NOT NULL,
    duracion_minutos  INT NOT NULL,
    id_categoria      INT NOT NULL,
    CONSTRAINT FK_Servicios_Categoria FOREIGN KEY (id_categoria)
        REFERENCES Categorias_Servicio(id_categoria)
);
 
CREATE TABLE Productos (
    id_producto       INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto   VARCHAR(50) NOT NULL,
    precio            DECIMAL(10,2) NOT NULL,
    stock             INT NOT NULL,
    id_categoria      INT NOT NULL,
    CONSTRAINT FK_Productos_Categoria FOREIGN KEY (id_categoria)
        REFERENCES Categorias_Servicio(id_categoria)
);
 
CREATE TABLE Citas (
    id_cita       INT IDENTITY(1,1) PRIMARY KEY,
    fecha         DATE NOT NULL,
    hora          TIME NOT NULL,
    estado        VARCHAR(20) NOT NULL,
    id_cliente    INT NOT NULL,
    id_empleado   INT NOT NULL,
    CONSTRAINT FK_Citas_Cliente FOREIGN KEY (id_cliente)
        REFERENCES Clientes(id_cliente),
    CONSTRAINT FK_Citas_Empleado FOREIGN KEY (id_empleado)
        REFERENCES Empleados(id_empleado)
);
 
CREATE TABLE Cita_Servicio (
    id_cita          INT NOT NULL,
    id_servicio      INT NOT NULL,
    precio_aplicado  DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Cita_Servicio PRIMARY KEY (id_cita, id_servicio),
    CONSTRAINT FK_CS_Cita FOREIGN KEY (id_cita)
        REFERENCES Citas(id_cita),
    CONSTRAINT FK_CS_Servicio FOREIGN KEY (id_servicio)
        REFERENCES Servicios(id_servicio)
);
GO
 
-- =====================================================================
-- 3. INSERCIÓN DE DATOS DE EJEMPLO
-- =====================================================================
 
-- Clientes
INSERT INTO Clientes (nombre, apellido, telefono, correo, fecha_registro) VALUES
('Rosa', 'Martinez', '809-555-1023', 'rosa.martinez@gmail.com', '2025-02-10'),
('Juan', 'Perez', '829-555-2045', 'juanperez@hotmail.com', '2025-03-05'),
('Carla', 'Diaz', '849-555-3167', 'carla.diaz@gmail.com', '2025-04-18'),
('Miguel', 'Santos', '809-555-4289', 'msantos@gmail.com', '2025-05-22'),
('Yolanda', 'Reyes', '829-555-5301', 'yreyes@outlook.com', '2025-06-01');
 
-- Empleados
INSERT INTO Empleados (nombre, apellido, telefono, especialidad, fecha_contratacion) VALUES
('Luis', 'Fernandez', '809-555-7001', 'Barbero', '2023-01-15'),
('Ana', 'Gomez', '829-555-7002', 'Colorista', '2023-03-10'),
('Pedro', 'Ramirez', '849-555-7003', 'Barbero', '2024-01-20'),
('Sofia', 'Cabrera', '809-555-7004', 'Estilista', '2024-06-05'),
('Carlos', 'Lopez', '829-555-7005', 'Manicurista', '2025-01-10');
 
-- Categorias_Servicio
INSERT INTO Categorias_Servicio (nombre_categoria) VALUES
('Barbería'),
('Peluquería'),
('Estética'),
('Cuidado Capilar');
 
-- Servicios
INSERT INTO Servicios (nombre_servicio, descripcion, precio, duracion_minutos, id_categoria) VALUES
('Corte de Cabello', 'Corte clásico a tijera y máquina', 500.00, 30, 1),
('Arreglo de Barba', 'Perfilado y afeitado de barba', 350.00, 20, 1),
('Coloración', 'Tinte completo de cabello', 1800.00, 90, 2),
('Manicura', 'Manicura clásica con esmaltado', 600.00, 40, 3),
('Tratamiento Capilar', 'Hidratación profunda de cabello', 1200.00, 45, 4);
 
-- Productos
INSERT INTO Productos (nombre_producto, precio, stock, id_categoria) VALUES
('Shampoo Profesional 500ml', 450.00, 25, 4),
('Cera para Cabello', 380.00, 15, 1),
('Tinte Rubio Ceniza', 650.00, 10, 2),
('Esmalte de Uñas', 200.00, 30, 3),
('Acondicionador Hidratante', 420.00, 20, 4);
 
-- Citas
INSERT INTO Citas (fecha, hora, estado, id_cliente, id_empleado) VALUES
('2026-07-10', '09:00', 'Pendiente', 1, 1),
('2026-07-10', '10:30', 'Pendiente', 2, 3),
('2026-07-11', '14:00', 'Completada', 3, 2),
('2026-07-11', '16:00', 'Cancelada', 4, 4),
('2026-07-12', '11:00', 'Pendiente', 5, 5);
 
-- Cita_Servicio
INSERT INTO Cita_Servicio (id_cita, id_servicio, precio_aplicado) VALUES
(1, 1, 500.00),
(1, 2, 350.00),
(2, 1, 500.00),
(3, 3, 1800.00),
(5, 4, 600.00);
GO
 
-- =====================================================================
-- 4. CONSULTAS SQL
-- =====================================================================
 
-- a) SELECT con ORDER BY
SELECT nombre_servicio, precio
FROM Servicios
ORDER BY precio DESC;
 
-- b) Función de agregación
SELECT COUNT(*) AS total_servicios,
       AVG(precio) AS precio_promedio,
       MAX(precio) AS precio_mas_alto
FROM Servicios;
 
-- c) JOIN entre tablas (Citas, Clientes y Empleados)
SELECT c.id_cita, c.fecha, c.hora,
       cl.nombre + ' ' + cl.apellido AS cliente,
       e.nombre + ' ' + e.apellido AS empleado,
       c.estado
FROM Citas c
JOIN Clientes cl ON c.id_cliente = cl.id_cliente
JOIN Empleados e ON c.id_empleado = e.id_empleado
ORDER BY c.fecha, c.hora;
 
-- d) UPDATE con WHERE
-- Justificación: se ajusta el precio del servicio "Corte de Cabello" por incremento
-- en el costo de insumos (10% de aumento).
UPDATE Servicios
SET precio = precio * 1.10
WHERE nombre_servicio = 'Corte de Cabello';
 
-- e) DELETE con WHERE
-- Justificación: se elimina la cita cancelada porque ya no representa un
-- compromiso real con el cliente y no debe contarse en reportes de citas activas.
DELETE FROM Citas
WHERE estado = 'Cancelada';
 