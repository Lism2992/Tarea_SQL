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
	  