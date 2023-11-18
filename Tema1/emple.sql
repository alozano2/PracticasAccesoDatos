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

--Ejercicio3: Crearse un registro t_reg_emple con la siguiente estructura: código 
--del empleado, nombre y el job. Insertar en una tabla temporal el nombre del
--empleado y job para el empleado 7782

drop table temp;

CREATE TABLE t_reg_emple (
    codigo_empleado NUMBER,
    nombre_empleado VARCHAR2(50),
    job VARCHAR2(50)
);

INSERT INTO t_reg_emple (codigo_empleado, nombre_empleado, job)
SELECT employee_id, first_name, job_id
FROM employee
WHERE employee_id = 7782;

SELECT * FROM t_reg_emple;

END;
/
--Ejercicio4: Insertar 50 filas en una tabla. Recorre todas las filas de la tabla 
--y las inserta en una tabla temporal. Crear la tabla students e insertar algunos datos.

drop table temp;

CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    age NUMBER
);

-- Insertar algunos datos de ejemplo
INSERT INTO students (student_id, first_name, last_name, age)
VALUES (1, 'John', 'Doe', 20);

INSERT INTO students (student_id, first_name, last_name, age)
VALUES (2, 'Jane', 'Smith', 22);

CREATE TABLE temp_students (
    student_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    age NUMBER
);

INSERT INTO temp_students (student_id, first_name, last_name, age)
SELECT student_id, first_name, last_name, age
FROM students;

INSERT INTO students (student_id, first_name, last_name, age)
VALUES (3, 'Emily', 'Johnson', 21);

END;
/
--Ejercicio5: Llenar una tabla PL con los nombres de los clientes y cargarla en una tabla
--temporal de sql que contenga el índice de la tabla PL y el nombre del cliente, y visualizar ésta.
drop table students;
drop table T_REG_EMPLE;
drop table TEMP_STUDENTS;

-- Crear una tabla PL en PL/SQL para almacenar los nombres de los clientes
CREATE TABLE pl_clientes (
    indice NUMBER PRIMARY KEY,
    nombre_cliente VARCHAR2(50)
);

-- Insertar los nombres de los clientes en la tabla PL
INSERT INTO pl_clientes (indice, nombre_cliente)
SELECT rownum, name
FROM customer;

-- Crear una tabla temporal en SQL para almacenar los datos
CREATE TABLE temp_clientes (
    indice NUMBER,
    nombre_cliente VARCHAR2(50)
);


-- Copiar datos de la tabla PL a la tabla temporal
INSERT INTO temp_clientes (indice, nombre_cliente)
SELECT indice, nombre_cliente
FROM pl_clientes;

-- Consultar para visualizar la tabla temporal
SELECT * FROM temp_clientes;

END;
/

--Ejercicio6: Llenar una tabla temporal con los códigos de clientes, nombre del 
--cliente y código de empleado de tres formas posibles
--usando bucle LOOP, 
--usando bucle WHILE y 
--usando bucle FOR.

-- Crear una tabla temporal para almacenar los datos
CREATE TABLE temp_datos3 (
    customer_id NUMBER,
    name VARCHAR2(50)
);

-- Usar un bucle LOOP para llenar la tabla temporal
BEGIN
    FOR customer IN (SELECT customer_id, name FROM customer) LOOP
        INSERT INTO temp_datos (customer_id, name, employee_id)
        VALUES (customer.customer_id, customer.name);
    END LOOP;
END;
/

-- Usar un bucle WHILE para llenar la tabla temporal
DECLARE
    cursor c_datos IS SELECT customer_id, name FROM customer;
    customer c_datos%ROWTYPE;
BEGIN
    OPEN c_datos;
    LOOP
        FETCH c_datos INTO customer;
        EXIT WHEN c_datos%NOTFOUND;
        
        INSERT INTO temp_datos (customer_id, name)
        VALUES (customer.customer_id, customer.name);
    END LOOP;
    CLOSE c_datos;
END;
/

-- Usar un bucle FOR para llenar la tabla temporal
DECLARE
    cursor c_datos IS SELECT customer_id, name FROM customer;
BEGIN
    FOR customer IN c_datos LOOP
        INSERT INTO temp_datos (customer_id, name)
        VALUES (customer.customer_id, customer.name);
    END LOOP;
END;
/

--Ejercicio7: A los pedidos del cliente 2, añadir 10 unidades más a la cantidad e 
--insertar en una tabla temporal el código de artículo y un mensaje que diga "Diez unidades más vendidas".

UPDATE sales_order
SET total = total + 10
WHERE customer_id = 102;

-- Inserta en la tabla temporal el código de artículo y el mensaje
INSERT INTO tabla_temporal (codigo_articulo, mensaje)
SELECT order_id, 'Diez unidades más vendidas' AS mensaje
FROM sales_order
WHERE customer_id = 102;

END;
/



--Ejercicio8: Crear un procedimiento que añada nuevos pedidos a un cliente determinado. El procedimiento 
--recibe el idpedido, idarticulo, cantidad y codcliente.

CREATE OR REPLACE PROCEDURE AgregarPedido(
    p_idpedido NUMBER,
    p_cantidad NUMBER,
    p_codcliente NUMBER
) AS
BEGIN
    -- Insertar el nuevo pedido en la tabla de pedidos
    INSERT INTO sales_order (order_id, total, customer_id)
    VALUES (p_idpedido, p_cantidad, p_codcliente);

    COMMIT;
END;
/


--Ejercicio9: Procedimiento que borra los pedidos del cliente especificado. Recibe el customer_id.

CREATE OR REPLACE PROCEDURE BorrarPedidosPorCliente(
    p_customer_id NUMBER
) AS
BEGIN
    -- Borrar los pedidos del cliente especificado
    DELETE FROM sales_order
    WHERE customer_id = p_customer_id;

    COMMIT;

END;
/


--Ejercicio10: Procedimiento para cambiar el oficio de un empleado. Se pasa al codemp 
--y el nuevo oficio. Insertará en TEMP oficio_ant, nuevo, codemp.
CREATE OR REPLACE PROCEDURE CambiarOficioEmpleado(
    p_codemp NUMBER,
    p_nuevo_oficio VARCHAR2
) AS
    v_oficio_anterior VARCHAR2(50);
    
BEGIN
    SELECT job_id INTO v_oficio_anterior
    FROM employee
    WHERE employee_id = p_codemp;

    -- Insertar el registro en la tabla TEMP con los valores del oficio anterior, nuevo y codemp
    INSERT INTO TEMP (oficio_ant, nuevo, codemp)
    VALUES (v_oficio_anterior, p_nuevo_oficio, p_codemp);
  
    COMMIT;

END;
/

--Ejercicio11: Crear una función "Anual" para devolver el salario anual cuando se
--pasa el salario mensual y la comisión de un empleado. Asegurarse que controla 
--nulos. Utilizar una variable de acoplamiento para ver lo que devuelve.

CREATE OR REPLACE FUNCTION Anual(
    salario_mensual NUMBER,
    comision NUMBER
) RETURN NUMBER IS
    salario_anual NUMBER;
BEGIN

    IF salario_mensual IS NULL THEN
        salario_mensual := 0; -- Valor predeterminado si el salario mensual es nulo
    END IF;

    IF comision IS NULL THEN
        comision := 0; 
    END IF;

    salario_anual := (salario_mensual * 12) + comision;

    RETURN salario_anual;
END;
/

-- Declarar una variable de acoplamiento para almacenar el resultado
DECLARE
    salario_resultado NUMBER;
BEGIN
    -- Llamar a la función "Anual" con valores de salario mensual y comisión
    salario_resultado := Anual(5000, 1000); -- Aquí puedes cambiar los valores según sea necesario

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Salario Anual: ' || salario_resultado);
END;
/

--Ejercicio12: Crear un paquete "Actualiza" que tiene tres procedimientos y una tabla PL:
--Un procedimiento de alta de un pedido.
--Un procedimiento de baja de los pedidos y detalles de un cliente concreto.
--Una tabla PL que almacenará los códigos de los pedidos.
--Un procedimiento "Listar" que tiene como parámetro 'in' el código de cliente y como parámetro de salida una tabla PL con los códigos de los pedidos del cliente especificado, además se grabará en una tabla temporal el código del pedido y el código del artículo.

-- Crear una tabla PL para almacenar códigos de pedidos
CREATE TABLE pedidos (
    codigo_pedido NUMBER PRIMARY KEY
);

-- Crear el paquete "Actualiza"
CREATE OR REPLACE PACKAGE Actualiza AS
    -- Procedimiento para dar de alta un pedido
    PROCEDURE AltaPedido(codigo_pedido IN NUMBER);
    
    -- Procedimiento para dar de baja los pedidos y detalles de un cliente concreto
    PROCEDURE BajaPedidosCliente(codigo_cliente IN NUMBER);
    
    -- Procedimiento para listar los códigos de los pedidos de un cliente y grabar en una tabla temporal
    PROCEDURE Listar(codigo_cliente IN NUMBER, c_cursor OUT SYS_REFCURSOR);
END Actualiza;
/

-- Implementar el paquete "Actualiza"
CREATE OR REPLACE PACKAGE BODY Actualiza AS
    -- Procedimiento para dar de alta un pedido
    PROCEDURE AltaPedido(codigo_pedido IN NUMBER) IS
    BEGIN
        -- Insertar el código del pedido en la tabla "pedidos"
        INSERT INTO pedidos (codigo_pedido) VALUES (codigo_pedido);
    END AltaPedido;
    
    -- Procedimiento para dar de baja los pedidos y detalles de un cliente concreto
    PROCEDURE BajaPedidosCliente(codigo_cliente IN NUMBER) IS
    BEGIN
        DELETE FROM customer WHERE customer_id = customer_id;
    END BajaPedidosCliente;

    PROCEDURE Listar(codigo_cliente IN NUMBER, c_cursor OUT SYS_REFCURSOR) IS
    BEGIN
       
        OPEN c_cursor FOR
        SELECT codigo_pedido
        FROM pedidos
        WHERE codigo_cliente = codigo_cliente;
    
    END Listar;
END Actualiza;
/

--Ejercicio13: Crear un trigger para ver como suceden los eventos de activación. 
--Vamos a utilizar la tabla plantilla y vamos a cambiar a las "Enfermeras" por "Interinos".

CREATE TABLE plantilla (
    empleado_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    puesto VARCHAR2(50)
);

INSERT INTO plantilla (empleado_id, nombre, puesto)
VALUES (1, 'Empleado1', 'Enfermeras');

INSERT INTO plantilla (empleado_id, nombre, puesto)
VALUES (2, 'Empleado2', 'Enfermeras');

CREATE OR REPLACE TRIGGER CambiarPuestoEnfermeras
BEFORE UPDATE ON plantilla
FOR EACH ROW
BEGIN
    IF :NEW.puesto = 'Enfermeras' THEN
        :NEW.puesto := 'Interinos';
    END IF;
END;
/

--Ejercicio14: Crear un disparador a nivel de fila tal que después de insertar, modificar o borrar 
--un detalle de la tabla detalles introduzca en la tabla temporal el usuario , la fecha 
--del sistema el código de pedido que se ha modificado, insertado o borrado, así como un 
--mensaje que diga "Detalle dado de alta", "Detalle borrado", "Detalle modificado" según corresponda.

CREATE TABLE temporal_detalle_eventos (
    evento_id NUMBER PRIMARY KEY,
    usuario VARCHAR2(50),
    fecha DATE,
    codigo_pedido NUMBER,
    mensaje VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER DetallesEventosTrigger
AFTER INSERT OR UPDATE OR DELETE ON detalles
FOR EACH ROW
DECLARE
    evento_mensaje VARCHAR2(100);
BEGIN
    IF INSERTING THEN
        evento_mensaje := 'Detalle dado de alta';
    ELSIF UPDATING THEN
        evento_mensaje := 'Detalle modificado';
    ELSIF DELETING THEN
        evento_mensaje := 'Detalle borrado';
    END IF;

    INSERT INTO temporal_detalle_eventos (evento_id, usuario, fecha, codigo_pedido, mensaje)
    VALUES (SEQ_EVENTO_ID.NEXTVAL, USER, SYSDATE, :OLD.codigo_pedido, evento_mensaje);
END;
/

--Ejercicio15: Disparador que inserta una fila en la tabla Temp con el texto ‘subida 
--de salario empleado’ y el número del empleado al que se le ha subido el salario. 
--El disparador se activará después de actualizar el salario de la tabla empleador.

CREATE TABLE Temp (
    evento_id NUMBER PRIMARY KEY,
    mensaje VARCHAR2(100),
    numero_empleado NUMBER
);

CREATE OR REPLACE TRIGGER SubidaSalarioTrigger
AFTER UPDATE ON empleados
FOR EACH ROW
DECLARE
    v_salario_anterior NUMBER;
BEGIN
    IF :OLD.salario <> :NEW.salario THEN
        INSERT INTO Temp (evento_id, mensaje, numero_empleado)
        VALUES (SEQ_EVENTO_ID.NEXTVAL, 'subida de salario empleado', :OLD.numero_empleado);
    END IF;
END;
/

--Ejercicio16: Trigger que se dispara cada vez que se borra un empleado, guardando 
--el número empleado, apellido y departamento en la tabla TEMP.

CREATE TABLE TEMP (
    numero_empleado NUMBER,
    apellido VARCHAR2(50),
    departamento VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER BorradoEmpleadoTrigger
BEFORE DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO TEMP (numero_empleado, apellido, departamento)
    VALUES (:OLD.numero_empleado, :OLD.apellido, :OLD.departamento);
END;
/

--Ejercicio17: Limitar a 5 (0 al 4) el número de detalles de cada pedido.

CREATE OR REPLACE TRIGGER LimiteDetallesPorPedido
BEFORE INSERT ON sales_order
FOR EACH ROW
DECLARE
    v_cantidad_detalles NUMBER;
BEGIN
 
    SELECT COUNT(*) INTO v_cantidad_detalles
    FROM sales_order
    WHERE order_id = :NEW.order_id;

    IF v_cantidad_detalles >= 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Se ha alcanzado el límite de 5 detalles por pedido.');
    END IF;
END;
/

--Ejercicio18: Solicitar un código de cliente por teclado; si existe se inserta su código 
--en una tabla temporal y el mensaje 'EXISTE', y si no existe se dispara la excepción 
--NO_DATA_FOUND y se inserta en la tabla temporal el mensaje 'NO EXISTE'.

CREATE TABLE temporal_clientes (
    codigo_cliente NUMBER,
    mensaje VARCHAR2(100)
);

DECLARE
    v_codigo_cliente NUMBER;
BEGIN
    v_codigo_cliente := &codigo_cliente; 

    SELECT 1
    INTO v_codigo_cliente
    FROM customer
    WHERE codigo_cliente = v_codigo_cliente;

    INSERT INTO temporal_clientes (codigo_cliente, mensaje)
    VALUES (v_codigo_cliente, 'EXISTE');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO temporal_clientes (codigo_cliente, mensaje)
        VALUES (v_codigo_cliente, 'NO EXISTE');
END;
/

--Ejercicio19:Se solicita un código de artículo por teclado y se inserta en una tabla 
--temporal el precio y la descripción de este artículo si está pedido, es decir, si 
--su código está en la tabla detalle. Si el artículo no está pedido, se genera una excepción 
--de usuario  con el mensaje "El artículo (código) no lo ha pedido ningún cliente"
DECLARE
    v_codigo_articulo NUMBER;
    v_precio NUMBER;
    v_descripcion VARCHAR2(100);
BEGIN
    v_codigo_articulo := &order_id; 

    SELECT precio, descripcion
    INTO v_precio, v_descripcion
    FROM sales_order
    WHERE order_id = v_codigo_articulo;

    INSERT INTO temporal_articulos (codigo_articulo, precio, descripcion)
    VALUES (v_codigo_articulo, v_precio, v_descripcion);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'El artículo (' || v_codigo_articulo || ') no lo ha pedido ningún cliente');
END;
/

--Ejercicio20: Se solicita un código de artículo por teclado y se inserta en una tabla 
--temporal el precio y la descripción de este artículo si está pedido, es decir, si su 
--código está en la tabla detalle. Si el artículo no está pedido, se genera una excepción de usuario 
--con el mensaje "El artículo (código) no lo ha pedido ningún cliente" 
  
DECLARE
    v_codigo_articulo NUMBER;
    v_precio NUMBER;
    v_descripcion VARCHAR2(100);
BEGIN
    
    v_codigo_articulo := item_id; 

    SELECT actual_price, total
    INTO v_precio, v_descripcion
    FROM item
    WHERE item_id = v_codigo_articulo;

    INSERT INTO temporal_articulos (codigo_articulo, precio, descripcion)
    VALUES (v_codigo_articulo, v_precio, v_descripcion);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'El artículo (' || v_codigo_articulo || ') no lo ha pedido ningún cliente');
END;
/

--Ejercicio21: Modificar el ejercicio 2 añadiendo excepciones, de tal forma que en el 
--gestor de excepciones controlemos que select ha fallado, insertando en una tabla temporal 
--cliente no existe, o bien articulo no existe, según haya fallado uno u otro. 
DECLARE
    v_codigo_cliente NUMBER;
    v_codigo_articulo NUMBER;
    v_precio NUMBER;
    v_descripcion VARCHAR2(100);
BEGIN

    v_codigo_cliente := &customer_id; 
    v_codigo_articulo := &item_id; 

    BEGIN
        SELECT actual_price, total
        INTO v_precio, v_descripcion
        FROM item
        WHERE customer_id = v_codigo_cliente AND item_id = v_codigo_articulo;

        INSERT INTO temporal_info (codigo_cliente, codigo_articulo, precio, descripcion)
        VALUES (v_codigo_cliente, v_codigo_articulo, v_precio, v_descripcion);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO temporal_info (codigo_cliente, codigo_articulo, mensaje)
            VALUES (v_codigo_cliente, v_codigo_articulo, 'Cliente o artículo no existe');
    END;
END;
/

--Ejercicio22: Crear un trigger que se ejecutará automáticamente cuando se elimine 
--algún empleado en la tabla correspondiente visualizando el número y el nombre de los empleados borrados.

CREATE OR REPLACE TRIGGER BorradoEmpleadoTrigger
AFTER DELETE ON employee
FOR EACH ROW
BEGIN
    -- Mostrar el número y el nombre del empleado borrado
    DBMS_OUTPUT.PUT_LINE('Empleado borrado - Número: ' || :OLD.employee_id || ', Nombre: ' || :OLD.first_name);
END;
/

--Ejercicio23: Crear un procedimiento que reciba como parámetro un código de empleado, 
--y modificar el salario de un empleado en función del número de empleados que tiene a su cargo:
--si no tiene ningún empleado a su cargo subirle 50 euros.
--si tiene 1 empleado a su cargo subirle 80 euros.
--si tiene 2 empleados a su cargo subirle 100 euros.
--si tiene más de tres empleados a su cargo subirle 110 euros.
--si es el PRESIDENTE su salario se incrementa en 30 euros

CREATE OR REPLACE PROCEDURE ModificarSalarioEmpleado (
    p_codigo_empleado IN NUMBER
) IS
    v_salario_actual NUMBER;
    v_empleados_a_cargo NUMBER;
BEGIN
    -- Obtener el salario actual del empleado   
    SELECT COUNT(*)
    INTO v_empleados_a_cargo
    FROM employee
    WHERE employee_id = p_codigo_empleado;

    -- Modificar el salario según el número de empleados a cargo
    IF v_empleados_a_cargo = 0 THEN
        -- No tiene empleados a cargo, subirle 50 euros
        v_salario_actual := v_salario_actual + 50;
    ELSIF v_empleados_a_cargo = 1 THEN
        -- Tiene 1 empleado a cargo, subirle 80 euros
        v_salario_actual := v_salario_actual + 80;
    ELSIF v_empleados_a_cargo = 2 THEN
        -- Tiene 2 empleados a cargo, subirle 100 euros
        v_salario_actual := v_salario_actual + 100;
    ELSIF v_empleados_a_cargo > 3 THEN
        -- Tiene más de 3 empleados a cargo, subirle 110 euros
        v_salario_actual := v_salario_actual + 110;
    END IF;

    -- Incrementar el salario del PRESIDENTE en 30 euros
    IF v_empleados_a_cargo = 0 THEN
        v_salario_actual := v_salario_actual + 30;
    END IF;

    -- Actualizar el salario del empleado en la tabla "empleados"
    UPDATE employee
    SET salary = (salary + v_salario_actual)
    WHERE employee_id = p_codigo_empleado;
    
    COMMIT; 
END;
/

--Ejercicoi24: Hacer dos bloques PL/SQL uno de los cuales escribe ‘Hola mundo’ al derecho y otro del revés.
-- Bloque PL/SQL que escribe 'Hola mundo' al derecho

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola mundo');
END;
/

-- Bloque PL/SQL que escribe 'Hola mundo' al revés
DECLARE
    v_cadena VARCHAR2(100);
BEGIN
    v_cadena := 'Hola mundo';
    FOR i IN REVERSE 1..LENGTH(v_cadena) LOOP
        dbms_output.put_line(SUBSTR(v_cadena, i, 1));
    END LOOP;
END;
/

--Ejercicio25: Hacer un bloque o proceso que muestre por pantalla el nombre y el jefe de cada empleado, con WHILE.
-- Bloque PL/SQL que muestra el nombre y el jefe de cada empleado
DECLARE
    v_nombre VARCHAR2(100);
    v_jefe_id NUMBER;
BEGIN
    -- Cursor para obtener información de los empleados
    FOR emp_record IN (SELECT first_name, employee_id FROM employee) LOOP
        v_nombre := emp_record.first_name;
        v_jefe_id := emp_record.employee_id;
        
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre || ', Jefe: ' || v_jefe_id);
    END LOOP;
END;
/

--Ejercicio26: Visualizar los apellidos de los empleados pertenecientes al departamento pasado por parámetro, numerándolos secuencialmente.
-- Bloque PL/SQL que muestra los apellidos de los empleados en un departamento y los numera secuencialmente
-- Bloque PL/SQL que muestra los apellidos de los empleados en un departamento y los numera secuencialmente
DECLARE
    v_departamento_id NUMBER; -- Declaración de la variable
    v_contador NUMBER := 1; 
    
    CURSOR c_empleados IS
        SELECT last_name
        FROM employee
        WHERE department_id = v_departamento_id; -- Corregir el nombre de la columna
BEGIN
    -- Solicitar el número de departamento por teclado
    v_departamento_id := &p_departamento_id;
    
    FOR emp_record IN c_empleados LOOP
        DBMS_OUTPUT.PUT_LINE('Empleado ' || v_contador || ': ' || emp_record.last_name);
        v_contador := v_contador + 1;
    END LOOP;
END;
/

--Ejercicio27: Escribir un procedimiento que reciba todos los datos de un nuevo empleado 
--y procese la transacción de alta, gestionando los siguientes errores:
--no_existe_departamento
--no_existe_director
--numero_empleado_duplicado
--salario nulo con RAISE_APPLICATION_ERROR
--Otros posibles errores de Oracle visualizando código y mensaje de error
-- Crear un procedimiento PL/SQL para dar de alta a un nuevo empleado
CREATE OR REPLACE PROCEDURE AltaEmpleado (
    p_employee_id NUMBER,
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_department_id NUMBER,
    p_salary NUMBER
) IS
BEGIN
    -- Comprobar si el departamento existe
    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = p_department_id) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El departamento especificado no existe. no_existe_departamento');
    END IF;
    
    -- Comprobar si el director (manager) existe
    IF p_manager_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = p_manager_id) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: El director especificado no existe. no_existe_director');
    END IF;

    -- Comprobar si el número de empleado está duplicado
    IF EXISTS (SELECT 1 FROM employee WHERE employee_id = p_employee_id) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error: El número de empleado ya existe. numero_empleado_duplicado');
    END IF;

    -- Comprobar si el salario es nulo
    IF p_salary IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error: El salario no puede ser nulo.');
    END IF;

    -- Insertar el nuevo empleado en la tabla "employees"
    INSERT INTO employee (employee_id, first_name, last_name, department_id, salary)
    VALUES (p_employee_id, p_first_name, p_last_name, p_department_id, p_salary);

    COMMIT; -- Confirmar la transacción
EXCEPTION
    WHEN OTHERS THEN
        -- Capturar y mostrar otros posibles errores de Oracle
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/


--Ejercicio28: Escribe un procedimiento (recibe como parámetro el oficio) el procedimiento 
--subirá   el sueldo de todos los empleados que ganen menos del salario medio de su oficio. 
--La subida será del 50% de la diferencia entre el salario de los empleados y la media de su oficio. Se deberá  gestionar  los posibles errores.
-- Crear un procedimiento PL/SQL para aumentar el salario de empleados que ganen menos del salario promedio de su oficio
CREATE OR REPLACE PROCEDURE AumentarSalarioPorOficio (
    p_oficio VARCHAR2
) IS
    v_salario_medio NUMBER;
BEGIN
    -- Calcular el salario promedio del oficio
    SELECT AVG(salary)
    INTO v_salario_medio
    FROM employee
    WHERE job_id = p_oficio;
    
    -- Comprobar si el salario promedio es nulo
    IF v_salario_medio IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El salario promedio del oficio no está disponible.');
    END IF;

    -- Aumentar el salario de los empleados que ganen menos del salario promedio
    UPDATE employee
    SET salary = salary + 0.5 * (v_salario_medio - salary)
    WHERE job_id = p_oficio AND salary < v_salario_medio;

    COMMIT; -- Confirmar la transacción
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Capturar la excepción si no se encuentra ningún empleado con el oficio dado
        DBMS_OUTPUT.PUT_LINE('Error: No se encontraron empleados con el oficio especificado.');
    WHEN OTHERS THEN
        -- Capturar y mostrar otros posibles errores de Oracle
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END;
/


--Ejercicio29: Escribir un programa que incremente el salario de los empleados de un 
--determinado departamento que se pasará como primer parámetro. El incremento será 
--una cantidad en euros que se pasará como segundo parámetro en la llamada. El programa 
--deberá informar del número de filas afectadas por la actualización. Los salarios se han de actualizar individualmente.
-- Crear un procedimiento PL/SQL para incrementar el salario de los empleados de un departamento
CREATE OR REPLACE PROCEDURE IncrementarSalarioDepartamento (
    p_departamento_id NUMBER,
    p_incremento_euros NUMBER
) IS
    v_numero_filas_afectadas NUMBER := 0;
BEGIN
    FOR emp_record IN (SELECT employee_id, salary FROM employee WHERE department_id = p_departamento_id) LOOP
        -- Incrementar el salario de cada empleado
        UPDATE employee
        SET salary = emp_record.salary + p_incremento_euros
        WHERE employee_id = emp_record.employee_id;

        v_numero_filas_afectadas := v_numero_filas_afectadas + 1;
    END LOOP;

    -- Informar del número de filas afectadas por la actualización
    DBMS_OUTPUT.PUT_LINE('Número de filas afectadas: ' || v_numero_filas_afectadas);
    
    COMMIT; 
END;
/


--Ejercicio30: Crear un programa que reciba un número de empleado y una cantidad que se 
--incrementará al salario del empleado correspondiente. Utilizar una excepción definida 
--por el usuario denominada salario_nulo y la predefinida when no_data_found
-- Crear una excepción definida por el usuario

-- Crear un procedimiento PL/SQL para incrementar el salario de un empleado
CREATE OR REPLACE PROCEDURE IncrementarSalarioEmpleado (
    p_numero_empleado NUMBER,
    p_incremento_euros NUMBER
) IS
    v_salario_actual NUMBER;
    salario_nulo EXCEPTION;
BEGIN
    -- Obtener el salario actual del empleado
    SELECT salary
    INTO v_salario_actual
    FROM employee
    WHERE employee_id = p_numero_empleado;
    
    -- Verificar si el empleado existe
    IF SQL%NOTFOUND THEN
        RAISE NO_DATA_FOUND;
    END IF;

    -- Comprobar si el salario es nulo
    IF v_salario_actual IS NULL THEN
        RAISE salario_nulo;
    ELSE
        -- Incrementar el salario del empleado
        UPDATE employee
        SET salary = v_salario_actual + p_incremento_euros
        WHERE employee_id = p_numero_empleado;
        
        COMMIT; -- Confirmar los cambios en la base de datos
    END IF;
EXCEPTION
    WHEN salario_nulo THEN
        DBMS_OUTPUT.PUT_LINE('Error: El salario del empleado es nulo.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontró el empleado.');
END;
/
