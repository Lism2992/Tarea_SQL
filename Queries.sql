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
