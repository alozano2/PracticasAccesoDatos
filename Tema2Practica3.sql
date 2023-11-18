--Crear el tipo cubo, con los atributos largo INTEGER, ancho INTEGER y alto INTEGER, así como 3 métodos MEMBER, que serán: 
--MEMBER FUNCTION  superficie RETURN integer 
--2*(largo*ancho+largo*alto+ancho*alto) 
--MEMBER FUNCTION  volumen RETURN integer 
--largo*alto*ancho 
--MEMBER PROCEDURE  mostrar(), que mostrará por pantalla el largo, ancho y alto así como el volumen y la superficie. 

CREATE OR REPLACE TYPE Cubo AS OBJECT (
    largo INTEGER,
    ancho INTEGER,
    alto INTEGER,

    MEMBER FUNCTION superficie RETURN INTEGER,
    MEMBER FUNCTION volumen RETURN INTEGER,
    MEMBER PROCEDURE mostrar
);
/

--A) Crea el cuerpo de este tipo desarrollando las funciones y procedimientos. 

CREATE OR REPLACE TYPE tipo_cubo AS OBJECT (
  largo INTEGER,
  ancho INTEGER,
  alto INTEGER,
  
  -- Método MEMBER para calcular la superficie
  MEMBER FUNCTION superficie RETURN INTEGER,
  
  -- Método MEMBER para calcular el volumen
  MEMBER FUNCTION volumen RETURN INTEGER,
  
  -- Método MEMBER para mostrar los atributos, volumen y superficie
  MEMBER PROCEDURE mostrar
);
/

-- Implementación de los métodos:
CREATE OR REPLACE TYPE BODY tipo_cubo AS
  
  MEMBER FUNCTION superficie RETURN INTEGER IS
  BEGIN
    RETURN 2 * (largo * ancho + largo * alto + ancho * alto);
  END;
  
  
  MEMBER FUNCTION volumen RETURN INTEGER IS
  BEGIN
    RETURN largo * alto * ancho;
  END;
  
  
  MEMBER PROCEDURE mostrar IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Largo: ' || largo);
    DBMS_OUTPUT.PUT_LINE('Ancho: ' || ancho);
    DBMS_OUTPUT.PUT_LINE('Alto: ' || alto);
    DBMS_OUTPUT.PUT_LINE('Superficie: ' || superficie);
    DBMS_OUTPUT.PUT_LINE('Volumen: ' || volumen);
  END;
END;
/

--B)Crea la tabla cubos de tipo cubo. 
CREATE TABLE cubos OF tipo_cubo;

--C) Inserta dos cubos con estas medidas( 10,10,10) y (3,4,5). 
-- Insertar un cubo con medidas (10, 10, 10)
INSERT INTO cubos VALUES (
    10,
    10,
    10
);

-- Insertar otro cubo con medidas (3, 4, 5)
INSERT INTO cubos VALUES (
    3,
    4,
    5
);

--D) Lista todos los cubos. 
SELECT * FROM cubos;

--E) Lista el volumen y la superficie del cubo de largo 10. 
DECLARE
    miCubo tipo_cubo := tipo_cubo(NULL, NULL, NULL);
BEGIN
    SELECT
        *
    INTO
        miCubo.largo,
        miCubo.ancho,
        miCubo.alto
    FROM
        cubos
    WHERE
        largo = 10;

    dbms_output.put_line('La superficie es: ' || miCubo.superficie());
    dbms_output.put_line('el volumen es: ' || miCubo.volumen());
END;
/


--F)Crea un pequeño bloque PL que  visualice los datos largo, ancho y alto del cubo de 
--largo 10, el bloque PL debe llamar al procedimiento mostrar(). 
DECLARE
    miCubo tipo_cubo := tipo_cubo(NULL, NULL, NULL);
BEGIN
    SELECT
        *
    INTO
        micubo.largo,
        miCubo.ancho,
        micubo.alto
    FROM
        cubos
    WHERE
        largo = 10;

    micubo.mostrar;
END;
/
 