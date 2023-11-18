--Ejercicio1: Realizar un programa que solicite un número de empleado determinado, 
--el programa debe comprobar si el salario es mayor que 1000, y si no es así actualizar 
--el salario con una subida del 20% y, en una tabla temporal, insertar el nombre del empleado 
--y el mensaje "Sueldo actualizado". Si ya superaba los 1000, se inserta en la tabla temporal 
--el nombre del empleado y el mensaje "No necesita actualización".

CREATE TABLE temp (nombre_empleado VARCHAR2(50), mensaje VARCHAR2(50));

DECLARE
    v_employee_id NUMBER;
    v_salary employee.salary%TYPE;
    v_first_name VARCHAR2(50);
BEGIN
    v_employee_id := &employee_id;  -- El usuario ingresará el número de empleado

    SELECT salary, first_name
    INTO v_salary, v_first_name
    FROM employee
    WHERE employee_id = v_employee_id;

    IF v_salary <= 1000 THEN
        v_salary := v_salary * 1.20;

        UPDATE employee
        SET salary = v_salary
        WHERE employee_id = v_employee_id;

        INSERT INTO temp VALUES (v_first_name, 'Sueldo actualizado');
    ELSE
        INSERT INTO temp VALUES (v_first_name, 'No necesita actualización');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Proceso completado.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END;
/

--Ejercicio2:Hacer un programa que solicite por teclado un código de cliente e inserte 
--en la tabla temporal el número total de pedidos de ese cliente (tot_ped), el precio total 
--de esos pedidos (precio_tot), el código del cliente (cod_cli) y el nombre del cliente (nombre_cli).

drop table temp;
CREATE TABLE temp (
    cod_cli NUMBER,
    nombre_cli VARCHAR2(50),
    tot_ped NUMBER,
    precio_tot NUMBER
);


DECLARE
    v_cod_cli NUMBER;
    v_nombre_cli VARCHAR2(50);
    v_tot_ped NUMBER := 0;
    v_precio_tot NUMBER := 0;
BEGIN
    
    v_cod_cli := &customer_id;  -- El usuario ingresará el código de cliente

   
    SELECT name INTO v_nombre_cli
    FROM customer
    WHERE customer_id = v_cod_cli;

   
    FOR sales_order IN (SELECT order_id, total
                        FROM sales_order
                        WHERE customer_id = v_cod_cli)
    LOOP
        v_tot_ped := v_tot_ped + 1;  -- Incrementar el contador de pedidos
        v_precio_tot := v_precio_tot + sales_order.total;  -- Sumar el precio total
    END LOOP;

    
    INSERT INTO temp VALUES (v_cod_cli, v_nombre_cli, v_tot_ped, v_precio_tot);

    
    DBMS_OUTPUT.PUT_LINE('Proceso completado.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        
        DBMS_OUTPUT.PUT_LINE('Cliente no encontrado.');
    WHEN OTHERS THEN
        
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END;
/

--Ejercicio3
