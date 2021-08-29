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