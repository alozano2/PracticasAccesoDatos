--Se desea modelar un objeto tri�ngulo para almacenar sus caracter�sticas (la base y la altura), 
--y almacenar en la BBDD cientos de tri�ngulos pudiendo calcular el �rea de cada tri�ngulo. 
CREATE OR REPLACE TYPE tipo_triangulo AS OBJECT (
  base NUMBER,
  altura NUMBER,
  MEMBER FUNCTION area RETURN NUMBER
);
/

--Un tipo llamado tipo_tri�ngulo con los atributos base number, altura number y una 
--funci�n llamada  area return number. Recordar que el �rea de un tri�ngulo se calcula como (base*altura)/2. 
CREATE OR REPLACE TYPE BODY tipo_triangulo AS
  MEMBER FUNCTION area RETURN NUMBER IS
  BEGIN
    RETURN (base * altura) / 2;
  END area;
END;
/

--B) Crear el cuerpo body para dicho tipo. 
CREATE OR REPLACE TYPE BODY tipo_triangulo AS
  MEMBER FUNCTION area RETURN NUMBER IS
  BEGIN
    RETURN (base * altura) / 2;
  END area;
END;
/

--C) Crear una tabla relacional llamada triangulos para almacenar los tri�ngulos, 
--con las columnas Id number y triangulo de tipo_triangulo. 
CREATE TABLE triangulos (
  Id NUMBER,
  triangulo tipo_triangulo
);


--D)Insertar dos tri�ngulos con los siguientes valores 
--Id=1, base=5, altura=5 
--Id=2, base=10, altura=10 
-- Insertar el primer tri�ngulo
DECLARE
    id       NUMBER;
    triangulo  tipo_triangulo := tipo_triangulo(NULL, NULL);
BEGIN
    id := 1;
    triangulo.base := 5;
    triangulo.altura := 5;
    INSERT INTO triangulos VALUES (
        id,
        triangulo
    );

    id := 2;
    triangulo.base := 10;
    triangulo.altura := 10;
    INSERT INTO triangulos VALUES (
        id,
        triangulo
    );

END;
/
--E) Listar todos los tri�ngulos. 
SELECT
    tri.id,
    tri.triangulo.base,
    tri.triangulo.altura
FROM
    triangulos tri;

--F) Crear un bloque PL/SQL para recorrer la tabla tri�ngulos e invocar al m�todo �rea, de forma que en el resultado obtengamos esto: 
DECLARE
    id       NUMBER;
    triangulo  tipo_triangulo := tipo_triangulo(NULL, NULL);
    CURSOR curs IS
    SELECT
        *
    FROM
        triangulos;

BEGIN
    OPEN curs;
    FETCH curs INTO
        id,
        triangulo;
    WHILE curs%found LOOP
        dbms_output.put_line('-el triangulo con id: ' || id);
        dbms_output.put_line(' con base: ' || triangulo.base);
        dbms_output.put_line(' y altura: ' || triangulo.altura);
        dbms_output.put_line(' tiene un area de: ' || triangulo.area());
        FETCH curs INTO
            id,
            triangulo;
    END LOOP;
    CLOSE curs;
END;
/
