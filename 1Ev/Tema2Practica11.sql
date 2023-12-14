--1. Crea un tipo para almacenar direcciones postales con dos campos, la dirección y el código postal, llamado Tipo_direccion. 
CREATE TYPE Tipo_direccion AS OBJECT (
    direccion VARCHAR2(100),
    codigo_postal VARCHAR2(20)
);


--2. Crea un tipo contacto (tipo_contacto)para almacenar un número de teléfono y un email. 
CREATE TYPE tipo_contacto AS OBJECT (
    numero_telefono VARCHAR2(20),
    email VARCHAR2(100)
);

--3. Crea un tipo persona (tipo_persona) con los campos id, nombre, apellido, dirección y contacto. 
--Después crea un subtipo cliente (tipo_cliente) con otro campo adicional llamado número de pedidos. 
CREATE TYPE tipo_persona AS OBJECT (
    id NUMBER,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    direccion Tipo_direccion,
    contacto tipo_contacto
);

CREATE TYPE tipo_cliente UNDER tipo_persona (
    numero_pedidos NUMBER
);

--4. Describe el tipo_direccion, el tipo_contacto , el tipo persona y el tipo cliente. 

SELECT ATTR_NAME, ATTR_TYPE_NAME, LENGTH
FROM ALL_TYPE_ATTRS
WHERE TYPE_NAME = 'TIPO_ARTICULO';

SELECT ATTR_NAME, ATTR_TYPE_NAME, LENGTH
FROM ALL_TYPE_ATTRS
WHERE TYPE_NAME = 'TIPO_DIRECCION';

SELECT ATTR_NAME, ATTR_TYPE_NAME, LENGTH
FROM ALL_TYPE_ATTRS
WHERE TYPE_NAME = 'TIPO_CONTACTO';

SELECT ATTR_NAME, ATTR_TYPE_NAME, LENGTH
FROM ALL_TYPE_ATTRS
WHERE TYPE_NAME = 'TIPO_PERSONA';

--5. Crea un tipo artículo (tipo_articulo)con los campos id, nombre, descripción, precio y 
--porcentaje de iva. Después crea un tipo tabla anidada (tabla_articulos) as table of tipo_articulo. 
CREATE TYPE tipo_articulo AS OBJECT (
    id NUMBER,
    nombre VARCHAR2(100),
    descripcion VARCHAR2(255),
    precio NUMBER,
    porcentaje_iva NUMBER
);

CREATE TYPE tabla_articulos AS TABLE OF tipo_articulo;

--6. Describe el tipo articulo. 
SELECT ATTR_NAME, ATTR_TYPE_NAME, LENGTH
FROM ALL_TYPE_ATTRS
WHERE TYPE_NAME = 'TIPO_ARTICULO';


--7. Crea un tipo para la lista de la compra(tipo_lista_compra) y otro para su detalle (tipo_lista_detalle). 
--El tipo_lista_detalle contendrá un numero number, artículo de tipo_articulo y la cantidad number. 
--El tipo_lista_compra  contendrá un identificador, fecha, cliente (será una referencia al tipo_cliente) 
--y un atributo llamado detalle que será una tabla anidada de tipo_lista_detalle. 
--(crea previamente el tipo  tabla anidada llámalo tab_lista_detalle as table of tipo_lista_detalle). 
--Se deberá incluir en la definición una función miembro para calcular el total de la lista de la compra

CREATE TYPE tipo_lista_detalle AS OBJECT (
    numero NUMBER,
    articulo tipo_articulo,
    cantidad NUMBER
);

CREATE TYPE tab_lista_detalle AS TABLE OF tipo_lista_detalle;

CREATE TYPE tipo_lista_compra AS OBJECT (
    identificador NUMBER,
    fecha DATE,
    cliente tipo_cliente,
    detalle tab_lista_detalle,

    MEMBER FUNCTION calcular_total RETURN NUMBER
);

CREATE TYPE BODY tipo_lista_compra AS
    MEMBER FUNCTION calcular_total RETURN NUMBER IS
        total NUMBER := 0;
    BEGIN
        FOR i IN detalle.FIRST..detalle.LAST LOOP
            total := total + (detalle(i).articulo.precio * detalle(i).cantidad);
        END LOOP;
        RETURN total;
    END calcular_total;
END;

--8. Crea el body del tipo lista de la compra para definir el método total. 
CREATE TYPE BODY tipo_lista_compra AS
    MEMBER FUNCTION calcular_total RETURN NUMBER IS
        total NUMBER := 0;
    BEGIN
        FOR i IN 1..self.detalle.COUNT LOOP
            total := total + (self.detalle(i).articulo.precio * self.detalle(i).cantidad);
        END LOOP;
        RETURN total;
    END calcular_total;
END;


--9. Crea una tabla clientes e inserta dos clientes con número pedidos a 0.
CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    numero_pedidos NUMBER DEFAULT 0
);

INSERT INTO clientes (id_cliente, nombre, apellido, numero_pedidos)
VALUES (1, 'Cliente1', 'Apellido1', 0);

INSERT INTO clientes (id_cliente, nombre, apellido, numero_pedidos)
VALUES (2, 'Cliente2', 'Apellido2', 0);

--10. Crea la tabla para las listas de la compra e inserta una lista de la compra con un detalle de dos artículos para el cliente id =1. 

CREATE TABLE lista_compra (
    id_lista NUMBER PRIMARY KEY,
    fecha DATE,
    id_cliente NUMBER REFERENCES clientes(id_cliente)
);

-- Insertar la lista de compra
INSERT INTO lista_compra (id_lista, fecha, id_cliente)
VALUES (1, SYSDATE, 1); -- Aquí se inserta la lista de compra con id_lista = 1, fecha actual y cliente con id_cliente = 1

-- Insertar detalles de la lista de compra (dos artículos)
INSERT INTO detalle_lista_compra (id_lista, id_producto, cantidad)
VALUES (1, 1, 3); -- Detalle del producto con id_producto = 1 y cantidad 3 para la lista con id_lista = 1

INSERT INTO detalle_lista_compra (id_lista, id_producto, cantidad)
VALUES (1, 2, 2); -- Detalle del producto con id_producto = 2 y cantidad 2 para la lista con id_lista = 1

--11. Muestra con una select los datos de la lista de la compra. 
SELECT lc.id_lista, lc.fecha, lc.id_cliente, dlc.id_producto, dlc.cantidad
FROM lista_compra lc
JOIN detalle_lista_compra dlc ON lc.id_lista = dlc.id_lista
WHERE lc.id_cliente = 1; 

--12. Construye una select para mostrar por pantalla el id de una lista de la compra y su total. 
DECLARE
    v_total NUMBER;
BEGIN
    SELECT lc.id_lista, tipo_lista_compra(lc.fecha, lc.id_cliente, NULL, NULL).calcular_total() AS total
    INTO lc_id, v_total
    FROM lista_compra lc
    WHERE lc.id_lista = 1; -- Cambiar el valor según el ID de la lista de compra deseada

    DBMS_OUTPUT.PUT_LINE('ID de la lista de compra: ' || lc_id);
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_total);
END;

