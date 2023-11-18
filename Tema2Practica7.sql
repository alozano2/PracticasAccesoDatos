--1. Crear un tipo colección llamado colec_hijos  que tendrá como máximo grupos de 10 valores
--y además serán de máximo 30 caracteres
CREATE TYPE colec_hijos AS VARRAY(10) OF VARCHAR2(30);
/

--2. Crea la tabla empleado con 
--Idemp number 
--Nombre varchar(30) 
--Apellidos varchar(30) 
--Hijos de tipo colección hijos 
CREATE TABLE trabajador (
  Idemp NUMBER,
  Nombre VARCHAR2(30),
  Apellidos VARCHAR2(30),
  Hijos colec_hijos
);
/

--3. Insertar los datos que aparecen en la tabla anterior. 
INSERT INTO trabajador (Idemp, Nombre, Apellidos, Hijos)
VALUES (1, 'Juan', 'Perez', colec_hijos('Ana', 'Carlos'));

INSERT INTO trabajador (Idemp, Nombre, Apellidos, Hijos)
VALUES (2, 'María', 'Gomez', colec_hijos('Pedro', 'Elena', 'Luis'));

--4. Visualizar todos los empleados. 
SELECT *
FROM trabajador;

--5. Visualizar el nombre de los hijos del empleado idemp 1. 
SELECT COLUMN_VALUE AS Nombre_Hijo
FROM TABLE(SELECT Hijos FROM trabajador WHERE Idemp = 1);
 

--6. Visualizar el nombre de todos los hijos de todos los empleados 
SELECT t.Idemp, c.COLUMN_VALUE AS Nombre_Hijo
FROM trabajador t
JOIN TABLE(t.Hijos) c ON 1 = 1;


--7. Crea un bloque PL para visualizar   cuántos hijos tiene el empleado idemp=1 
DECLARE
  v_cantidad_hijos NUMBER;
BEGIN
  -- Obtener la cantidad de hijos del empleado con Idemp = 1
  SELECT COUNT(*) INTO v_cantidad_hijos
  FROM trabajador t
  WHERE t.Idemp = 1;

  -- Mostrar la cantidad de hijos
  DBMS_OUTPUT.PUT_LINE('El empleado con Idemp = 1 tiene ' || v_cantidad_hijos || ' hijo(s).');
END;
/


--8. Crea un bloque PL para visualizar   el nombre del empleado y el nombre de todos sus hijos.
DECLARE
  v_idemp trabajador.Idemp%TYPE;
  v_nombre trabajador.Nombre%TYPE;
  v_apellido trabajador.Apellidos%TYPE;
  v_hijo_nombre colec_hijos;
BEGIN
  -- Obtenemos el nombre del trabajador y sus hijos
  FOR tbj IN (SELECT t.Idemp, t.Nombre, t.Apellidos, t.Hijos
              FROM trabajador t) 
  LOOP
    v_idemp := tbj.Idemp;
    v_nombre := tbj.Nombre;
    v_apellido := tbj.Apellidos;
    v_hijo_nombre := tbj.Hijos;

    -- Mostramos la información del trabajador
    DBMS_OUTPUT.PUT_LINE('IDEMP: ' || v_idemp || ' NOMBRE: ' || v_nombre || ' APELLIDO: ' || v_apellido);

    -- Y el nombre de sus hijos
    FOR i IN 1..v_hijo_nombre.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('El hijo: ' || i || ' se llama: ' || v_hijo_nombre(i));
    END LOOP;
    -- Separador 
    DBMS_OUTPUT.PUT_LINE('----------------------');
  END LOOP;
END;
/

--9. Visualizar cuántos hijos tienen todos los empleados. 
DECLARE
  v_idemp trabajador.Idemp%TYPE;
  v_nombre trabajador.Nombre%TYPE;
  v_apellido trabajador.Apellidos%TYPE;
  v_total_hijos NUMBER;
BEGIN
  -- Obtenemos el total de hijos de cada trabajador
  FOR tbj IN (SELECT t.Idemp, t.Nombre, t.Apellidos, t.Hijos
              FROM trabajador t)
  LOOP
    v_idemp := tbj.Idemp;
    v_nombre := tbj.Nombre;
    v_apellido := tbj.Apellidos;
    v_total_hijos := tbj.Hijos.COUNT;

    DBMS_OUTPUT.PUT_LINE('IDEMP: ' || v_idemp || ' NOMBRE: ' || v_nombre || ' APELLIDO: ' || v_apellido);
    DBMS_OUTPUT.PUT_LINE('Total de hijos: ' || v_total_hijos);
    -- Separador 
    DBMS_OUTPUT.PUT_LINE('----------------------');
  END LOOP;
END;
/

--10. Añadir un hijo mas al empleado idemp=1 que se llame Antonio.
DECLARE
  v_hijos colec_hijos := colec_hijos();  
BEGIN
  -- Obtenemos la colección actual de hijos
  SELECT Hijos
  INTO v_hijos
  FROM trabajador
  WHERE Idemp = 1;

  -- Añadimos el nuevo hijo 'Antonio' 
  v_hijos.EXTEND;  -- Extendemos la colección
  v_hijos(v_hijos.LAST) := 'Antonio';  --Añadimos

  UPDATE trabajador
  SET Hijos = v_hijos
  WHERE Idemp = 1;

  COMMIT; 
END;
/

--11. Añadir al final de la colección 3 veces el hijo uno(Luis) para el empleado de idemp=1 
DECLARE
  v_hijos colec_hijos := colec_hijos();  
BEGIN
  -- Obtenemos la colección actual de hijos
  SELECT Hijos
  INTO v_hijos
  FROM trabajador
  WHERE Idemp = 1;

  -- Añadimos 3 veces el hijo 'Luis' 
  FOR i IN 1..3 LOOP
    v_hijos.EXTEND; 
    v_hijos(v_hijos.LAST) := 'Luis';  
  END LOOP;

  UPDATE trabajador
  SET Hijos = v_hijos
  WHERE Idemp = 1;

  --COMMIT; 
END;
/

--12. Visualiza la vista user_varrays. 
SELECT * FROM USER_VARRAYS;

--13. Describe la colección colec_hijos. 
DESCRIBE colec_hijos;

