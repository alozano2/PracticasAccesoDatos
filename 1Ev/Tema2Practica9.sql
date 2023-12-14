--1. Se desea guardar los nombres de los hijos de empleados, en vez de una colección 
--que nos limita la cantidad de hijos, vamos a usar un tipo tabla, usando el ejemplo de
--la práctica 6 redefine el tipo hijos con un tipo tabla llamado tabla_hijos de tipo varchar(30). 

CREATE TYPE tabla_hijos AS TABLE OF VARCHAR2(30);
/

CREATE TABLE empleados (
    empleado_id NUMBER,
    nombre VARCHAR2(100),
    nombres_hijos tabla_hijos
);
--2. Crea la tabla empleado basándola en el tipo tabla_hijos 
--Idemp  number 
--Nombre  varchar(30) 
--Apellidos varchar(30) 
--Hijos de tipo tabla_hijos 
--Nested table hijos store as t_hijos 
CREATE TABLE empleados (
    idemp NUMBER PRIMARY KEY,
    nombre VARCHAR2(30),
    apellidos VARCHAR2(30),
    hijos tabla_hijos
)
NESTED TABLE hijos STORE AS t_hijos;
--3. La columna hijos es tipo tabl_hijos almacenada sobre un tipo de segmento especial llamado tabla anidada. 
--A.- Consulta los objetos de la base de datos con SELECT.  
SELECT object_name, object_type
FROM user_objects
WHERE object_name IN ('EMPLEADOS', 'T_HIJOS');

--B.- Consulta las estructuras de almacenamiento que usa Oracle para almacenar los objetos con SELECT. 
SELECT segment_name, segment_type, tablespace_name
FROM user_segments
WHERE segment_name IN ('EMPLEADOS', 'T_HIJOS');

--4. Inserta dos empleados con INSERT con estos datos: 
--Fernando Moreno  Hijos: (Elena,Pablo) 
--David Sanchez  Hijos: (Carmen,Candela) 
INSERT INTO empleados (idemp, nombre, apellidos, hijos)
VALUES (
    1,
    'Fernando',
    'Moreno',
    tabla_hijos('Elena', 'Pablo')
);

INSERT INTO empleados (idemp, nombre, apellidos, hijos)
VALUES (
    2,
    'David',
    'Sanchez',
    tabla_hijos('Carmen', 'Candela')
);
--5. Lista todos los empleados. 
SELECT *
FROM empleados;

--6. Lista todos los hijos del empleado 1, usando TABLE. 
SELECT *
FROM TABLE (
    SELECT hijos
    FROM empleados
    WHERE idemp = 1
);


--7. Actualiza la tabla empleado cambiando el nombre de los hijos del empleado idemp 1 por Carmen, Candela, Cayetana. 
UPDATE empleados
SET hijos = CAST(MULTISET(
        SELECT COLUMN_VALUE FROM TABLE(tabla_hijos('Carmen', 'Candela', 'Cayetana'))
    ) AS tabla_hijos)
WHERE idemp = 1;

--8. Listar todos los hijos del empleado 1 y 2 
SELECT idemp, COLUMN_VALUE AS hijo
FROM empleados, TABLE(empleados.hijos)
WHERE idemp IN (1, 2);
