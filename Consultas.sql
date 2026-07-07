MÓDULO 01: FUNDAMENTOS DE SQL
Autora: Paola Beltre
Descripción: Consultas básicas para practicar SELECT,
WHERE, ORDER BY, LIMIT, alias y operadores.
========================================================
*/

/*
Consulta 1: Mostrar todos los registros de una tabla, el * seleciona toda la tabla.
Objetivo: Practicar el uso básico de SELECT.
*/
SELECT *
FROM empleados;

/*
Consulta 2: Mostrar columnas específicas. Aqui no utilizamos el * ya que estamos buscando columnas en especifico.
Objetivo: Seleccionar solamente los campos necesarios.
*/
SELECT nombre, apellido, puesto
FROM empleados;

/*
Consulta 3: Filtrar registros con WHERE. 
Objetivo: Obtener empleados pertenecientes a un departamento específico.
*/
SELECT nombre, apellido, departamento
FROM empleados
WHERE departamento = 'Tecnología';

/*
Consulta 4: Ordenar resultados. El order by te dice el orden que tu quieres que aparescan los resultaods.
Objetivo: Mostrar empleados ordenados alfabéticamente por apellido.
*/
SELECT nombre, apellido, puesto
FROM empleados
ORDER BY apellido ASC;

/*
Consulta 5: Filtrar con operadores numéricos.
Objetivo: Obtener empleados con salario mayor a 30000.
*/
SELECT nombre, apellido, salario
FROM empleados
WHERE salario > 30000;

/*
Consulta 6: Usar alias en columnas.
Objetivo: Presentar nombres de columnas más claros en los resultados.
*/
SELECT
    nombre AS Nombre,
    apellido AS Apellido,
    salario AS Salario_Mensual
FROM empleados;

/*
Consulta 7: Limitar resultados.
Objetivo: Mostrar solamente los primeros 5 registros.
*/
SELECT *
FROM empleados
LIMIT 5;

/*
Consulta 8: Filtrar con varias condiciones.
Objetivo: Buscar empleados del área de Tecnología con salario mayor a 30000.
*/
SELECT nombre, apellido, departamento, salario
FROM empleados
WHERE departamento = 'Tecnología'
  AND salario > 30000;

/*
Conclusión:
Estas consultas representan la base para trabajar con bases de datos relacionales.
Permiten seleccionar, filtrar, ordenar y presentar información de manera clara.
*/
