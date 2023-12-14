--1. Crear un tipo colecci�n llamado colec_tipo_nombres_dept que tendr� como m�ximo 
--grupos de 7 valores y adem�s ser�n de m�ximo 30 caracteres. 
CREATE OR REPLACE TYPE colec_tipo_nombres_dept AS VARRAY(7) OF VARCHAR2(30);
/

--2. Crea la tabla departementos con 
--Region varchar(25) 
--Nombres_dept de tipo coleccion 
CREATE TABLE departamentos (
  Region VARCHAR2(25),
  Nombres_dept colec_tipo_nombres_dept
);
/

--3. Insertar los datos que aparecen en la tabla anterior. 
INSERT INTO departamentos VALUES ('Europa', colec_tipo_nombres_dept('shipping', 'sales', 'finances'));
INSERT INTO departamentos VALUES ('America', colec_tipo_nombres_dept('sales', 'finances', 'shipping'));
INSERT INTO departamentos VALUES ('Asia', colec_tipo_nombres_dept('finances', 'payroll', 'shipping', 'sales'));

--4. Visualizar todos los departamentos. 
SELECT * FROM departamentos;

--5. Crea un bloque PL en el que declararemos una variable de tipo colecci�n y le 
--asignaremos los siguientes valores a la colecci�n (benefits, advertising, contracting, 
--executive, marketing). Actualizar� los departamentos de la regi�n de Europa con los inicializados 
--anteriormente. Recorre la colecci�n para visualizar todos los nombres de los departamentos de la regi�n de Europa. 
--Con una salida como la siguiente: 
DECLARE
  colec_dept_eur colec_tipo_nombres_dept;
  colec_dept_actualizada colec_tipo_nombres_dept;
BEGIN
  -- Inicializamos la colecci�n con los valores del enunciado
  colec_dept_eur := colec_tipo_nombres_dept('benefits', 'advertising', 'contracting', 'executive', 'marketing');

  -- Actualizamos los departamentos de la regi�n de Europa con la nueva colecci�n
  UPDATE departamentos SET Nombres_dept = colec_dept_eur WHERE Region = 'Europa';

  -- Recorrer la colecci�n e imprimir los nombres de los departamentos de la region de europa recien actualizada
  SELECT Nombres_dept INTO colec_dept_actualizada FROM departamentos WHERE Region = 'Europa';

  -- Recorrer la colecci�n e imprimir los nombres de los departamentos de la regi�n de Europa
  FOR i IN 1..colec_dept_actualizada.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('departamentos=' || colec_dept_actualizada(i));
  END LOOP;

  COMMIT;
END;
/

--6. Crear otro bloque PL para visualizar la regi�n y sus departamentos para todas las 
--regiones ( necesitar�s un cursor) con una salida como la siguiente: 
DECLARE
  v_region VARCHAR2(25);
  v_departamento colec_tipo_nombres_dept;

BEGIN
  -- Abrimos un cursor para obtener todas las regiones
  FOR c_regiones_departamentos IN (SELECT Region, Nombres_dept FROM departamentos) LOOP
    v_region := c_regiones_departamentos.Region;
    v_departamento := c_regiones_departamentos.Nombres_dept;

    -- Imprimimos la regi�n
    DBMS_OUTPUT.PUT_LINE('Region: ' || v_region);

    -- Imprimimos los departamentos para la regi�n actual
    FOR i IN 1..v_departamento.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('departamento (' || i || '): ' || v_departamento(i));
    END LOOP;

  END LOOP;

END;
/


