--Crear el tipo �empleado� con los atributos �Rut varchar(10)�, �Nombre varchar(10)�, 
--�Cargo varchar(9)�, �fechaIng date�, �sueldo number(9)�, �somision number (9)�, y �anticipo
--number (9)�, la funci�n �sueldo_liquido�, que devuelve un number, y el procedimiento �aumento_sueldo� 
--que recibe como par�metro el aumento (number). 

CREATE TYPE empleado AS OBJECT (
  Rut VARCHAR2(10),
  Nombre VARCHAR2(10),
  Cargo VARCHAR2(9),
  fechaIng DATE,
  sueldo NUMBER(9),
  comision NUMBER(9),
  anticipo NUMBER(9),
  
  -- Funci�n para calcular sueldo l�quido
  MEMBER FUNCTION sueldo_liquido RETURN NUMBER,
  
  -- Procedimiento para aumento de sueldo
  MEMBER PROCEDURE aumento_sueldo(aumento NUMBER)
);
/

--2. Crear el body para dicho tipo desarrollando la funci�n y el procedimiento. El sueldo 
--l�quido se calcular�  como �(sueldo +comisi�n )- anticipo�, y el aumento de sueldo se 
--calcular� como �sueldo+aumento�. 

CREATE OR REPLACE TYPE BODY empleado AS
  
  -- Funci�n para calcular sueldo l�quido
  MEMBER FUNCTION sueldo_liquido RETURN NUMBER IS
  BEGIN
    RETURN (sueldo + comision) - anticipo;
  END sueldo_liquido;
  
  -- Procedimiento para aumento de sueldo
  MEMBER PROCEDURE aumento_sueldo(aumento NUMBER) IS
  BEGIN
    sueldo := sueldo + aumento;
  END aumento_sueldo;
  
END;
/

--3. Altera el tipo Empleado y a�ade el procedimiento �setAnticipo� que recibe como par�metro el anticipo de tipo number. 
ALTER TYPE empleado ADD MEMBER PROCEDURE setAnticipo(anticipo NUMBER);
/

--4. Crea el body para el nuevo m�todo
CREATE OR REPLACE TYPE BODY empleado AS
  
  MEMBER FUNCTION sueldo_liquido RETURN NUMBER IS
  BEGIN
    RETURN (sueldo + comision) - anticipo;
  END sueldo_liquido;
  
  -- Procedimiento para aumento de sueldo
  MEMBER PROCEDURE aumento_sueldo(aumento NUMBER) IS
  BEGIN
    sueldo := sueldo + aumento;
  END aumento_sueldo;

  -- Procedimiento para establecer anticipo
  MEMBER PROCEDURE setAnticipo(anticipo NUMBER) IS
  BEGIN
    self.anticipo := anticipo;
  END setAnticipo;
  
END;
/

--5. Crear una tabla empleados de tipo empleado. 
CREATE TABLE empleados OF empleado;

--6. Insertar dos o tres empleados, con estos datos
INSERT INTO empleados VALUES ('1', 'Pepe', 'director', SYSDATE, 2000, 500, 0);
INSERT INTO empleados VALUES ('2', 'Juan', 'vendedor', SYSDATE, 1000, 300, 0);
INSERT INTO empleados VALUES ('3', 'Elena', 'vendedor', SYSDATE, 1000, 400, 0);

--7. Crear un bloque PL/SQL para listar el sueldo l�quido del empleado rut=1. 
--Aumentarle el sueldo con 400 euros. Listar el sueldo aumentado. La salida ser� como sigue: 
DECLARE
  v_sueldo NUMBER;
  v_sueldo_liquido NUMBER;
  v_nombre VARCHAR2(10);
  v_cargo VARCHAR2(9);
BEGIN
  -- Listar sueldo l�quido del empleado con Rut=1
  SELECT e.nombre, e.cargo, e.sueldo, e.sueldo_liquido() 
  INTO v_nombre, v_cargo, v_sueldo, v_sueldo_liquido
  FROM empleados e
  WHERE e.nombre = 'Pepe';

  DBMS_OUTPUT.PUT_LINE(v_nombre||' '||v_cargo||' '||'Sueldo: ' || v_sueldo || ' Sueldo l�quido: ' || v_sueldo_liquido);

  -- Aumentar sueldo en 400 euros
  UPDATE empleados
  SET sueldo = sueldo + 400
  WHERE nombre = 'Pepe';

  -- Listar sueldo aumentado
  SELECT e.nombre, e.cargo, e.sueldo, e.sueldo_liquido() 
  INTO v_nombre, v_cargo, v_sueldo, v_sueldo_liquido
  FROM empleados e
  WHERE e.nombre = 'Pepe';

  DBMS_OUTPUT.PUT_LINE(v_nombre||' '||v_cargo||' '||' Sueldo aumentado: ' || v_sueldo || ' Sueldo l�quido: ' || v_sueldo_liquido);
END;
/

--8. Persistir en la tabla empleados el sueldo aumentado 
select * from empleados; --Hecho en ejercicio7

--9. Sacar los sueldos y sus sueldos l�quidos de todos los empleados. OJO: poner alias en las funciones dentro de cursores. 
DECLARE
  CURSOR c_empleados IS
    SELECT e.Nombre,
           e.sueldo,
           e.sueldo_liquido() AS sueldo_liquido
    FROM empleados e;

BEGIN
  FOR emp IN c_empleados LOOP
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || emp.Nombre ||
                         ' Sueldo: ' || emp.sueldo || ' Sueldo l�quido: ' || emp.sueldo_liquido);
  END LOOP;
END;
/


