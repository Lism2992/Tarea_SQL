
SET CHARACTER SET 'utf8';

-- Creación tablas --

-- Comenzamos eliminando la base de datos en caso de que ya exista, la creamos e indicamos que vamos a trabajar en ella.

DROP DATABASE IF EXISTS corrupción;

CREATE DATABASE corrupción;

USE corrupción;

-- Eliminamos todas las tablas con estos nombre en caso de que existan previamente.

DROP TABLE IF EXISTS Corruptos;
DROP TABLE IF EXISTS Familiares;
DROP TABLE IF EXISTS Partidos;
DROP TABLE IF EXISTS Teléfonos;
DROP TABLE IF EXISTS Pertenencia;
DROP TABLE IF EXISTS Imputaciones;
DROP TABLE IF EXISTS Casos;
DROP TABLE IF EXISTS Ámbitos;
DROP TABLE IF EXISTS Periódicos;
DROP TABLE IF EXISTS Jueces;

-- Vamos a comenzar creando las tablas. El orden en el que hacerlo es importante ya que hay dependencias que necesitan ser referenciadas.

-- Creamos la tabla Corruptos.

CREATE TABLE Corruptos (
DNI INT PRIMARY KEY,
Nombre VARCHAR(30) NOT NULL,
Dirección VARCHAR(60),
Ciudad VARCHAR(30),
Patrimonio NUMERIC(10,2),
CHECK (length(DNI)=8)
);

-- Creamos la tabla Familiares.

CREATE TABLE Familiares (
DNI INT,
Familiar INT,
FOREIGN KEY (DNI)
REFERENCES Corruptos(DNI)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (Familiar)
REFERENCES Corruptos(DNI)
ON DELETE CASCADE
ON UPDATE CASCADE,
PRIMARY KEY(DNI,Familiar)
);  

-- Creamos la tabla Periódicos.

CREATE TABLE Partidos (
Nombre VARCHAR(60) PRIMARY KEY,
Dirección VARCHAR(60) NOT NULL UNIQUE
); 

-- Creamos la tabla Teléfonos.

CREATE TABLE Teléfonos (
Teléfono INTEGER PRIMARY KEY,
Partido VARCHAR(60),
FOREIGN KEY (Partido)
REFERENCES Partidos(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE
); 

-- Creamos la tabla Pertenencia.

CREATE TABLE Pertenencia (
ID_Corrupto INT PRIMARY KEY,
Partido VARCHAR(60) NOT NULL,
Cargo VARCHAR(30),
FOREIGN KEY (ID_Corrupto)
REFERENCES Corruptos(DNI)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (Partido)
REFERENCES Partidos(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE
);

-- Creamos la tabla Periódicos.

CREATE TABLE Periódicos (
Nombre VARCHAR(60) PRIMARY KEY,
Web VARCHAR(60),
Ámbito VARCHAR(30) NOT NULL,
Dirección VARCHAR(60) NOT NULL,
Formato VARCHAR(30) NOT NULL,
Partido_Afín VARCHAR(60),
FOREIGN KEY (Partido_Afín)
REFERENCES Partidos(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE,
CHECK (Ámbito IN ('Local','Comarcal','Nacional','Internacional')),
CHECK (Formato IN ('papel','digital'))
);

-- Creamos la tabla Jueces.

CREATE TABLE Jueces (
Nombre VARCHAR(30) PRIMARY KEY,
Dirección VARCHAR(60),
Nacimiento DATE NOT NULL,
Inicio DATE NOT NULL,
CHECK (Inicio > Nacimiento)
);

-- Creamos la tabla Casos.

CREATE TABLE Casos (
Nombre VARCHAR(30) PRIMARY KEY,
Descripción VARCHAR(200),
Estimación INTEGER NOT NULL,
Descubridor VARCHAR(60) NOT NULL,
Fecha_Descubierto DATE,
Juez VARCHAR(30) NOT NULL,
Dictamen VARCHAR(90) NOT NULL,
FOREIGN KEY (Descubridor)
REFERENCES Periódicos(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (Juez)
REFERENCES Jueces(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE
); 

-- Creamos la tabla Imputaciones.

CREATE TABLE Imputaciones (
ID_Corrupto INT,
Nombre_Caso VARCHAR(30),
Cargo VARCHAR(30) NOT NULL,
FOREIGN KEY (ID_Corrupto)
REFERENCES Corruptos(DNI)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (Nombre_Caso)
REFERENCES Casos(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE,
PRIMARY KEY (ID_Corrupto, Nombre_Caso),
CHECK (Cargo IN ('Imputado','Condenado'))
);

-- Creamos la tabla Ámbitos.

CREATE TABLE Ámbitos (
Nombre_Caso VARCHAR(30),
Ámbito VARCHAR(30),
FOREIGN KEY (Nombre_Caso)
REFERENCES Casos(Nombre)
ON DELETE CASCADE
ON UPDATE CASCADE,
PRIMARY KEY (Nombre_Caso, Ámbito),
CHECK (Ámbito IN ('Red de tráfico','Malversación','Tráfico de influencia'))
);


-- Inserción Datos --

-- Vamos a insertar la mayoría de ellos desde código aunque habrá alguna tabla que insertemos desde un fichero externo por probar que se puede hacer.

INSERT INTO Corruptos VALUES
      (11111111,'Doña Protestona','Calle de la Amargura 28','Barcelona',100000.28),
	  (22222222,'Don Misterioso',NULL,NULL,NULL),
	  (33333333,'Señorita Adinerada','Urbanización Millonetis 28','Madrid',200000.28),
	  (44444444,'Señor Construcción','Avenida de las Pamplinas 28','Gijón',200000.28),
	  (55555555,'Conde Millonetis','Finca los Millones','Madrid',15000000.28),
	  (66666666,'Implicada Pringada','Calle de las Costras 28','Madrid',2000.28),
	  (77777777,'Marquesa Influyente','Avenida del Dinero 28','Madrid',200000.28),
	  (88888888,'Implicado Pobretón',NULL,'Barcelona',35.28),
	  (99999999,'Señora Redicha','Masía Pastizal','Barcelona',500000.28),
	  (12345678,'Señorito Farsante','Calle Misteriosa 25','Sevilla',4328.28);
	  
	  
INSERT INTO Familiares VALUES
      (77777777,99999999),
	  (99999999,77777777),
	  (77777777,44444444),
	  (44444444,77777777);
	  
INSERT INTO Partidos VALUES
      ('Partido del Dinero','Avenida del Dinero 33, Madrid'),
	  ('Coalición por la Honradez','Calle de la Honradez 28, Madrid'),
	  ('Iniciativa por la Derrota Electoral','Calle Insulsa 77, Madrid');
      
	  
INSERT INTO Teléfonos VALUES
      (123456789,'Partido del Dinero'),
	  (123456788,'Partido del Dinero'),
	  (123456787,'Partido del Dinero'),
	  (987654321,'Coalición por la Honradez'),
	  (987654322,'Coalición por la Honradez'),
	  (999887766,'Iniciativa por la Derrota Electoral');
	  
INSERT INTO Pertenencia VALUES
      (33333333,'Coalición por la Honradez','Secretario General'),
      (11111111,'Coalición por la Honradez','Portavoz'),
      (88888888,'Coalición por la Honradez',NULL),
      (55555555,'Partido del Dinero','Diputado'),
      (22222222,'Partido del Dinero',NULL);
      
-- Esta es la tabla que estamos insertando desde un fichero externo.
-- Podemos consultar el directorio seguro desde el que se nos permite hacerlo en nuestra máquina.
	  
-- SELECT @@GLOBAL.secure_file_priv;
      
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Jueces.txt'
INTO TABLE Jueces
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

INSERT INTO Periódicos VALUES
      ('El Cotilla de Castuera','www.Cotilleos.cast','Local','Calle de los Quesitos 68','papel','Iniciativa por la Derrota Electoral'),
      ('El Diario del Embutido','www.Butifarra.es','Internacional','Avenida del Morcón 27','digital','Coalición por la Honradez'),
      ('La Gaceta del Dinero','www.Corrupción.com','Nacional','Calle de la Honradez 33','papel','Partido del Dinero')
	;
    


INSERT INTO Casos VALUES
	  ('Caso Salchichón','Trama internacional de sobornos con fondos públicos para facilitar el tráfico ilegal de embutidos con países del sudeste asiático.',250,'El Diario del Embutido','2012-05-23','Hermenegildo Estricto','El consumo excesivo de embutidos es perjudicial para la salud.'),
	  ('Caso Caramelos','Tráfico de influencia para colocar a conocidos como dependientes de kioskos de caramelos.',1,'El Cotilla de Castuera','2016-08-23','Ambrosio Muecatorcida','Los kioskos para los kioskeros.'),
	  ('Caso Cromos','Utilización de fondos públicos para la compra de cromos de La Liga y así ayudar a la Marquesa Influyente a completar su colección.',500,'El Cotilla de Castuera','2019-04-29','Hermenegildo Estricto','Esa colección la quería completar yo.');


INSERT INTO Imputaciones VALUES
	  (11111111,'Caso Caramelos','Imputado'),
	  (22222222,'Caso Cromos','Imputado'),
	  (22222222,'Caso Caramelos','Imputado'),
	  (22222222,'Caso Salchichón','Imputado'),
	  (33333333,'Caso Caramelos','Imputado'),
	  (44444444,'Caso Salchichón','Condenado'),
	  (55555555,'Caso Salchichón','Condenado'),
	  (55555555,'Caso Cromos','Imputado'),
	  (66666666,'Caso Salchichón','Condenado'),
	  (77777777,'Caso Cromos','Condenado'),
	  (88888888,'Caso Caramelos','Imputado'),
	  (99999999,'Caso Salchichón','Condenado'),
	  (12345678,'Caso Salchichón','Imputado');

 
INSERT INTO Ámbitos VALUES
      ('Caso Caramelos','Tráfico de influencia'),
	  ('Caso Salchichón','Malversación'),
	  ('Caso Salchichón','Red de tráfico'),
	  ('Caso Cromos','Malversación');
	  

	  
-- Queries --

-- 1: Podemos declarar en el 'select' las columnas que queramos proyectar en la consulta.

SELECT DNI,Nombre,Ciudad 
FROM Corruptos;

-- 2: Con la instrucción distinct filtramos sólo los elementos diferentes de un determinado campo.

SELECT DISTINCT Ciudad 
FROM Corruptos;

-- 3: Con 'where' imponemos condiciones que filtran los registros que se nos muestran.
-- Pueden tener diferentes condiciones combinadas.

SELECT * 
FROM Corruptos 
WHERE Ciudad='Madrid' AND Patrimonio between 150000.00 AND 250000.00;

-- 4: Con la instrucción count podemos contar todas las filas del dataset que en este caso cumplan una determinada condición.

SELECT count(*) 
FROM Corruptos 
WHERE Ciudad='Madrid';

-- 5: Filtramos los elementos no nulos con 'IS NOT NULL' y ordenamos los resultados obtenidos según un criterio, en este caso sobre la cantidad de una columna numérica.
-- En caso de ordenar por una columna string se seguirá un orden alfabético.

SELECT Nombre,Patrimonio 
FROM Corruptos  
WHERE Patrimonio IS NOT NULL 
ORDER BY Patrimonio DESC;

-- 6: Podemos utilizar agrupaciones sobre campos pero en el 'select' sólo podemos proyectar campos agrupados o el parámetro de agrupación.
-- Se pueden seguir imponiendo filtros sobre los registros.

SELECT Ciudad,count(*) 
FROM Corruptos 
WHERE Patrimonio > 100.00 
GROUP BY Ciudad;

-- 7: Cuando queremos poner una condición sobre campos agregados como un 'count()' tenemos que utilizar 'HAVING'
-- en lugar de 'WHERE' y recordar que siempre va tras la declaración de la agrupación.

SELECT Ciudad,count(*) 
FROM Corruptos 
WHERE Patrimonio > 100.00 
GROUP BY Ciudad  
HAVING count(*) > 1;

-- 8: Podemos utilizar alias sobre las columnas generadas y combinar agrupaciones, ordenaciones y filtros como queramos.

SELECT Ciudad, sum(Patrimonio) as Suma_patrimonio 
FROM Corruptos 
WHERE Ciudad IS NOT NULL 
GROUP BY Ciudad 
ORDER BY Suma_patrimonio;

-- 9: Imponemos una condición con un 'OR'.

SELECT ID_Corrupto,Nombre_Caso 
FROM Imputaciones 
WHERE Nombre_Caso = 'Caso Salchichón' OR Nombre_Caso = 'Caso Cromos';

-- 10: Podemos utilizar la siguiente sintaxis para hacer un 'JOIN' entre dos tablas.

SELECT * 
FROM Imputaciones,Corruptos 
WHERE Corruptos.DNI = Imputaciones.ID_Corrupto;

-- 11: Hacemos un 'JOIN' al estilo de la última query pero poniendo alias a las tablas unidas y a una de las columnas proyectadas
--  e imponiendo un filtro adicional sobre dos columnas llamadas con el prefijo de la tabla correspondiente para desambiguar.

SELECT C.Nombre,I.Nombre_Caso AS participó_en 
FROM Imputaciones AS I,Corruptos AS C 
WHERE C.DNI = I.ID_Corrupto  AND (I.Nombre_Caso = 'Caso Salchichon' OR I.Nombre_Caso = 'Caso Cromos');

-- 12: 'JOIN' y proyección con alias y una condición de filtro sobre los registros.
-- Utilizamos el 'lower' para regularizar los resultados y una expresión regular que nos permite recuperar
-- los registros que no incluyan la palabra calle rodeada por cualquier tipo de campos (%).

SELECT C.Nombre,C.Dirección,I.Nombre_Caso AS participó_en 
FROM Imputaciones AS I,Corruptos AS C 
WHERE C.DNI = I.ID_Corrupto AND lower(C.Dirección) NOT LIKE '%calle%';

-- 13: Podemos imponer condiciones sobre una subquery, en este caso, estamos filtrando los nombres
-- de los jueces cuya fecha de inicio sea inferior a todas las fechas de descubrimiento de los casos.

SELECT Nombre 
FROM Jueces 
WHERE Inicio < all (SELECT Fecha_Descubierto FROM Casos);

-- 14: Podemos hacer lo mismo pero filtrando los que cumplan la condición con al menos uno de los casos. 

SELECT Nombre 
FROM Jueces 
WHERE Inicio < some (SELECT Fecha_Descubierto FROM Casos);

-- 15: Creamos una vista temporal. Esto no es una tabla pero puede ser llamada en consultas sucesivas para hacer consultas desde ella.
-- Son utilizadas si vamos a utilizar una determinada consulta como subquery en repetidas ocasiones. Estamos juntando los corruptos con
-- los casos en los que están implicados.

CREATE VIEW Implicados as 
		(SELECT I.Nombre_Caso as Caso, C.Nombre as Nombre 
         FROM Imputaciones as I,Corruptos as C 
         WHERE I.ID_Corrupto=C.DNI);
		 
-- 16: Unimos la tabla anterior con los jueces que los han procesado con la sintaxis de 'JOIN' que utilizamos anteriormente.
-- Esta nueva tabla contiene información de los corruptos, los casos en los que han estado implicados y los jueces que los han procesado.
         
SELECT I.Nombre, C.Juez as procesado_por
FROM Implicados as I,Casos as C 
WHERE I.Caso=C.Nombre;

-- 17: Vamos a mostrar cómo conseguir una consulta similar de una manera más limpia y utilizando una sintaxis más clásica para los 'JOIN'.
-- En este caso, utilizamos un 'INNER JOIN' en las dos ocasiones, por lo que no aparecerá ningún corrupto ni cas que no aparezca en alguna
-- de cada una de las tablas unidas. En este caso, estamos proyectando cada uno de los corruptos y el juez que lo ha procesado.

SELECT C.Nombre, Ca.Juez as procesado_por
FROM Corruptos as C 
INNER JOIN Imputaciones as I ON C.DNI=I.ID_Corrupto 
INNER JOIN Casos as Ca ON I.Nombre_Caso = Ca.Nombre;

-- 18: Unimos las tablas de corruptos y pertenencia para conocer qué corruptos pertenecen a qué partidos y con qué cargos. Al ser un 'INNER JOIN'
-- no aparecerán corruptos en la tabla final que no pertenezcan a ningún partido ni ningún partido.

SELECT C.Nombre, P.Partido, P.Cargo
FROM Corruptos as C 
INNER JOIN Pertenencia as P ON C.DNI = P.ID_Corrupto;

-- 19: Similar pero con un 'LEFT OUTER JOIN'. Como la tabla 'LEFT' son los corruptos, aparecerán todos, aunque su ID no aparezca en la tabla de pertenencia
-- y sus campos sean nulos. Estas dos consultas se han hecho para mostrar el correcto funcionamiento de los diferentes 'JOIN'.

SELECT C.Nombre, P.Partido, P.Cargo
FROM Corruptos as C 
LEFT OUTER JOIN Pertenencia as P ON C.DNI = P.ID_Corrupto;

-- Hay periódicos que hayan descubierto casos con políticos de partidos afines implicados?

-- 20: En mi caso voy a hacer un 'JOIN' que refleje las relaciones entre 4 tablas, corruptos, imputaciones, pertenencia y periódicos.
-- De este 'JOIN' proyectaremos las columnas Nombre del corrupto, periódico descubridor, partido del corrupto y partido afín del periódico.
-- Una vez hecho esto, sencillamente imponiendo un filtro entre la igualdad o desigualdad de los partidos podemos conocer lo planteado.

SELECT Nombre, Descubridor, Partido as Partido_del_político, Partido_Afín as Partido_del_periódico
FROM (SELECT Co.Nombre, Ca.Descubridor, Pe.Partido, Per.Partido_Afín FROM Casos as Ca 
	  INNER JOIN Imputaciones as I ON Ca.Nombre=I.Nombre_Caso 
	  INNER JOIN Corruptos as Co ON Co.DNI=I.ID_Corrupto
	  INNER JOIN Pertenencia as Pe ON Co.DNI=Pe.ID_Corrupto
	  INNER JOIN Periódicos as Per ON Ca.Descubridor=Per.Nombre) as aux
WHERE Partido = Partido_Afín;

-- No hay ningún resultado.
-- Podemos ver el resultado complementario.

SELECT Nombre, Descubridor, Partido as Partido_del_político, Partido_Afín as Partido_del_periódico
FROM (SELECT Co.Nombre, Ca.Descubridor, Pe.Partido, Per.Partido_Afín FROM Casos as Ca 
	  INNER JOIN Imputaciones as I ON Ca.Nombre=I.Nombre_Caso 
	  INNER JOIN Corruptos as Co ON Co.DNI=I.ID_Corrupto
	  INNER JOIN Pertenencia as Pe ON Co.DNI=Pe.ID_Corrupto
	  INNER JOIN Periódicos as Per ON Ca.Descubridor=Per.Nombre) as aux
WHERE Partido != Partido_Afín;

-- 21: Podríamos haber hecho esto con una vista temporal.

CREATE VIEW Corruptos_Periódicos as
(SELECT Co.Nombre, Ca.Descubridor, Pe.Partido, Per.Partido_Afín FROM Casos as Ca 
INNER JOIN Imputaciones as I ON Ca.Nombre=I.Nombre_Caso 
INNER JOIN Corruptos as Co ON Co.DNI=I.ID_Corrupto
INNER JOIN Pertenencia as Pe ON Co.DNI=Pe.ID_Corrupto
INNER JOIN Periódicos as Per ON Ca.Descubridor=Per.Nombre);

SELECT Nombre, Descubridor, Partido as Partido_del_político, Partido_Afín as Partido_del_periódico
FROM Corruptos_Periódicos
WHERE Partido = Partido_Afín;

SELECT Nombre, Descubridor, Partido as Partido_del_político, Partido_Afín as Partido_del_periódico
FROM Corruptos_Periódicos
WHERE Partido != Partido_Afín;

 

-- 22: Podemos hacer un update de los registros que cumplan una determinada condición. En nuestro caso estamos multiplicando por 1000000
-- la estimación de millones de euros implicados (transformándolo a euros) de los casos cuyo ámbito sea 'Malversación'.

UPDATE Casos
INNER JOIN Ámbitos ON Casos.Nombre = Ámbitos.Nombre_Caso
SET Casos.Estimación = Casos.Estimación * 1000000
WHERE Ámbitos.Ámbito = 'Malversación';

-- Mostramos resultados:

SELECT C.Nombre, C.Estimación, A.Ámbito 
FROM Casos as C 
INNER JOIN Ámbitos as A 
ON C.Nombre=A.Nombre_Caso;

-- 23: Por último, vamos a elimnar un tipo de registro de una de las tablas con una condición y comprobar que los 'CASCADE' se cumplen.
-- Primero mostramos la tabla Casos que incluye el campo Descubridor que hace referencia al nombre del periódico que lo descubrió y es FK
-- con una condición de eliminar en cascada en caso de que desaparezca uno de los registros del atributo al que referencia en su tabla original.

-- Mostramos la tabla original.

SELECT Nombre,Descubridor FROM Casos;

-- Eliminamos uno de los periódicos

DELETE FROM Periódicos
WHERE nombre = 'El Cotilla de Castuera';

-- Los registros referentes a ese periódico eliminado han desaparecido.

SELECT Nombre,Descubridor FROM Casos;

	  








