--1.  A partir del tipo_cubo creado en la práctica 3, añadir un nuevo método (procedimiento) de 
--tipo static llamado nuevoCubo con los atributos V_largo INTEGER, V_ancho INTEGER y V_alto INTEGER. 

DROP TABLE CUBOS; --Borramos primero la tabla cubos creada en anteriores ejercicios.

CREATE OR REPLACE TYPE tipo_cubo AS OBJECT (
  largo INTEGER,
  ancho INTEGER,
  alto INTEGER,
  
  -- Métodos MEMBER para calcular la superficie y el volumen
  MEMBER FUNCTION superficie RETURN INTEGER,
  MEMBER FUNCTION volumen RETURN INTEGER,
  
  -- Método MEMBER para mostrar los atributos, volumen y superficie
  MEMBER PROCEDURE mostrar,

  -- Método estático para insertar un nuevo cubo
  STATIC PROCEDURE nuevoCubo(V_largo INTEGER, V_ancho INTEGER, V_alto INTEGER)
);

--2. Desarrollar el procedimiento en el body de tal forma que realice el insert en la tabla cubos del nuevoCubo.
CREATE TABLE cubos OF tipo_cubo; --volvemos a crear la tabla para poder usar nuevoCubo


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
    
    STATIC PROCEDURE nuevoCubo(V_largo INTEGER, V_ancho INTEGER, V_alto INTEGER) IS
    v_cubo tipo_cubo; 
  BEGIN
    v_cubo := tipo_cubo(V_largo, V_ancho, V_alto); 
    INSERT INTO cubos VALUES (v_cubo); 
  END nuevoCubo; 
  
  END;
  /

--3. Crear un pequeño bloque que llame al método nuevoCubo pasándole como parámetros estos valores (1,8,1). 
DECLARE
BEGIN
  tipo_cubo.nuevoCubo(1, 8, 1);
END;


