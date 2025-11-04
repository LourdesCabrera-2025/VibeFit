--===============================================================
-- proyecto de cátedra: VibeFit - Sistema de Reservas de Gimnasio
-- Autor: Grupo V
-- Base de datos: SQL Server 2022 Devekioer
--===============================================================

CREATE DATABASE VibeFit;
GO


USE VibeFit;
GO

-- =======================================
-- Tablas Principales
-- =======================================

CREATE TABLE Socio(
	id_socio INT IDENTITY(1,1) PRIMARY KEY,
	nombre_completo VARCHAR(100) NOT NULL,
	correo VARCHAR(100) UNIQUE NOT NULL,
	telefono VARCHAR(20),
	fecha_afiliacion DATE NOT NULL,
	id_membresia INT
);

CREATE TABLE Membresia (
	id_membresia INT IDENTITY(1,1) PRIMARY KEY,
	tipo_membresia  INT NOT NULL,
	beneficios VARCHAR(255) ,
	precio DECIMAL (8,2) NOT NULL,
	duracion_meses INT NOT NULL
);

CREATE TABLE Entrenador(
	id_entrenador INT IDENTITY(1,1) PRIMARY KEY,
	nombre_completo VARCHAR(100) NOT NULL,
	correo VARCHAR(100) UNIQUE NOT NULL,
	telefono VARCHAR(20),
	especialidad INT,
	salario DECIMAL (10,2)
);

CREATE TABLE Clase (
	id_clase INT IDENTITY(1,1) PRIMARY KEY,
	nombre_clase VARCHAR(50),
	tipo_clase INT NOT NULL,
	disponibilidad INT NOT NULL,
	horario_inicio TIME NOT NULL,
	horario_fin TIME NOT NULL,
	id_entrenador INT NOT NULL
);

CREATE TABLE Reserva (
	id_reserva INT IDENTITY(1,1) PRIMARY KEY,
	fecha_reserva DATE NOT NULL,
	asistencia BIT DEFAULT 0,
	id_socio INT NOT NULL,
	id_clase INT NOT NULL
)

CREATE TABLE Pago (
	id_pago INT IDENTITY(1,1) PRIMARY KEY,
	fecha_pago DATE NOT NULL,
	monto_pago DECIMAL(10,2) NOT NULL,
	metodo_pago INT NOT NULL,
	id_socio INT NOT NULL
);

CREATE TABLE Tipo_Membresia (
	id_Tipo_membresia INT IDENTITY(1,1) PRIMARY KEY,
	tipo_membresia VARCHAR(40)
);

CREATE TABLE Especialidad (
	id_especialidad INT IDENTITY (1,1) PRIMARY KEY,
	especialidad VARCHAR(60)
);


CREATE TABLE Tipo_Clase (
	id_Tipo_clase INT IDENTITY (1,1) PRIMARY KEY,
	tipo_clase VARCHAR(60)
)

CREATE TABLE Metodo_Pago (
	id_Metodo_pago INT IDENTITY (1,1) PRIMARY KEY,
	metodo_pago VARCHAR (60)
)


-- ===========================================
-- Relaciones (Foreign Keys)
-- ===========================================

ALTER TABLE Socio
ADD CONSTRAINT FK_Socio_Membresia
FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia);

ALTER TABLE Membresia
ADD CONSTRAINT FK_Membresia_Tipo
FOREIGN KEY (tipo_membresia) REFERENCES Tipo_Membresia(id_Tipo_membresia)

ALTER TABLE Clase 
ADD CONSTRAINT FK_Clase_Entrenador 
FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador);

ALTER TABLE Clase
ADD CONSTRAINT FK_Clase_TipoClase
FOREIGN KEY (tipo_clase) REFERENCES Tipo_Clase(id_Tipo_clase);

ALTER TABLE Entrenador
ADD CONSTRAINT FK_Entrenador_especialidad
FOREIGN KEY (especialidad) REFERENCES Especialidad (id_especialidad)

ALTER TABLE Reserva
ADD CONSTRAINT FK_Reserva_Socio
FOREIGN KEY (id_socio) REFERENCES Socio (id_socio);

ALTER TABLE Reserva
ADD CONSTRAINT FK_Reserva_Clase
FOREIGN KEY (id_clase) REFERENCES Clase (id_clase);

ALTER TABLE Pago
ADD CONSTRAINT FK_Pago_Metodo
FOREIGN KEY (metodo_pago) REFERENCES Metodo_Pago(id_Metodo_pago);

ALTER TABLE Pago
ADD CONSTRAINT FK_Pago_Socio
FOREIGN KEY (id_socio) REFERENCES Socio(id_socio)

--===============================================
-- INSERTS DE CATALOGOS BASÍCOS
--===============================================

-- Tipo_Membresia

INSERT INTO Tipo_Membresia (tipo_membresia) VALUES
('Basica'),
('Premium'),
('Anual');

-- Especialidad

INSERT INTO Especialidad (especialidad) VALUES
('Yoga'),
('CrossFit'),
('Pilates'),
('Cardio Funcional');


-- Tipo Clase

INSERT INTO Tipo_Clase (tipo_clase) VALUES
('Yoga'),
('CrossFit'),
('Pilates'),
('Zumba');

-- Metodo_Pago

INSERT INTO Metodo_Pago(metodo_pago) VALUES
('Efectivo'),
('Tarjeta'),
('Transferencia'),
('Paypal');

SELECT * FROM Membresia
-- =======================================
-- Membresias
-- =======================================

INSERT INTO Membresia (tipo_membresia, beneficios, precio, duracion_meses)
VALUES
(1, 'Acceso a clases generales', 25.00, 1),
(1, 'Acceso libre a máquinas', 30.00, 1),
(2, 'Clases + entrenador personalizado', 50.00, 1),
(2, 'Acceso ilimitado + locker privado', 55.00, 1),
(2, 'Entrenamientos funcionales + asesoría nutricional', 60.00, 1),
(3, 'Plan anual con descuento del 10%', 500.00, 12),
(3, 'Plan anual VIP', 650.00, 12),
(3, 'Acceso completo y beneficios extra', 700.00, 12),
(1, 'Acceso a clases regulares + spinning', 35.00, 1),
(2, 'Entrenamiento personalizado intensivo', 75.00, 2),
(1, 'Clases de yoga y pilates', 40.00, 1),
(3, 'Membresía familiar (hasta 3 personas)', 900.00, 12),
(2, 'Membresía de 6 meses', 280.00, 6),
(1, 'Solo uso gimnasio libre', 20.00, 1),
(3, 'Anual corporativa', 850.00, 12);

SELECT * FROM Entrenador
-- ====================================================
-- Entrenadores
-- ====================================================

INSERT INTO Entrenador (nombre_completo, correo, telefono, especialidad, salario)
VALUES
('Laura Gómez', 'laura.gomez@vibefit.com', '7277-1411', 1, 950.00),
('Carlos Mendoza', 'carlos.mendoza@vibefit.com', '7515-2312', 2, 1100.00),
('Andrés Rivera', 'andres.rivera@vibefit.com', '7747-3313', 3, 980.00),
('María Torres', 'maria.torres@vibefit.com', '7297-4544', 4, 900.00),
('José Castro', 'jose.castro@vibefit.com', '7637-5425', 3, 1000.00),
('Sofía López', 'sofia.lopez@vibefit.com', '7232-6296', 1, 1050.00),
('Raúl Jiménez', 'raul.jimenez@vibefit.com', '7045-7722', 2, 1150.00),
('Fernanda Ruiz', 'fernanda.ruiz@vibefit.com', '8877-1436', 3, 980.00),
('Daniel Pérez', 'daniel.perez@vibefit.com', '7245-9319', 4, 970.00),
('Gabriela Flores', 'gabriela.flores@vibefit.com', '7257-3054', 1, 1100.00);

SELECT id_entrenador, nombre_completo FROM Entrenador;


-- =======================================================================
-- Clases
-- =======================================================================

INSERT INTO Clase (nombre_clase, tipo_clase, disponibilidad, horario_inicio, horario_fin, id_entrenador)
VALUES
('Yoga Sunrise', 1, 20, '07:00', '08:00', 1),
('CrossFit Power', 2, 15, '08:00', '09:00', 2),
('Spinning Intenso', 3, 12, '09:00', '10:00', 3),
('Pilates Core', 4, 18, '10:00', '11:00', 4),
('Zumba Fun', 3, 25, '11:00', '12:00', 5),
('Yoga Flow', 1, 20, '16:00', '17:00', 6),
('CrossFit Elite', 2, 15, '17:00', '18:00', 7),
('Spinning Night', 3, 12, '18:00', '19:00', 8),
('Pilates Relax', 4, 18, '19:00', '20:00', 9),
('Cardio Dance', 4, 25, '20:00', '21:00', 10),
('Yoga Balance', 1, 20, '07:00', '08:00', 1),
('CrossFit Max', 2, 15, '08:00', '09:00', 2),
('Spinning Pro', 3, 12, '09:00', '10:00', 3),
('Pilates Energy', 4, 18, '10:00', '11:00', 4),
('Zumba Xtreme', 2, 25, '11:00', '12:00', 5),
('Yoga Advanced', 1, 20, '16:00', '17:00', 6),
('CrossFit Burn', 2, 15, '17:00', '18:00', 7),
('Spinning Express', 3, 12, '18:00', '19:00', 8),
('Pilates Plus', 4, 18, '19:00', '20:00', 9),
('Zumba Energy', 1, 25, '20:00', '21:00', 10);



-- =======================================================================
-- Socio
-- =======================================================================

INSERT INTO Socio (nombre_completo, correo, telefono, fecha_afiliacion, id_membresia) VALUES
('María López', 'maria.lopez@vibefit.com', '7777-1001', '2025-01-10', 2),
('José Martínez', 'jose.martinez@vibefit.com', '7777-1002', '2025-01-11', 1),
('Ana Torres', 'ana.torres@vibefit.com', '7777-1003', '2025-01-12', 3),
('Carlos Pérez', 'carlos.perez@vibefit.com', '7777-1004', '2025-01-13', 4),
('Laura Gómez', 'laura.gomez@vibefit.com', '7777-1005', '2025-01-14', 5),
('Daniel Cruz', 'daniel.cruz@vibefit.com', '7777-1006', '2025-01-15', 6),
('Paola Rivera', 'paola.rivera@vibefit.com', '7777-1007', '2025-01-16', 7),
('Luis Hernández', 'luis.hernandez@vibefit.com', '7777-1008', '2025-01-17', 8),
('Andrea Castillo', 'andrea.castillo@vibefit.com', '7777-1009', '2025-01-18', 9),
('Ricardo Flores', 'ricardo.flores@vibefit.com', '7777-1010', '2025-01-19', 10),
('Marta López', 'marta.lopez@vibefit.com', '7777-1011', '2025-01-20', 11),
('Roberto Aguilar', 'roberto.aguilar@vibefit.com', '7777-1012', '2025-01-21', 12),
('Sandra Ruiz', 'sandra.ruiz@vibefit.com', '7777-1013', '2025-01-22', 13),
('Carlos Mejía', 'carlos.mejia@vibefit.com', '7777-1014', '2025-01-23', 14),
('Elena Castro', 'elena.castro@vibefit.com', '7777-1015', '2025-01-24', 15),
('Javier Ramos', 'javier.ramos@vibefit.com', '7777-1016', '2025-01-25', 1),
('Nadia Martínez', 'nadia.martinez@vibefit.com', '7777-1017', '2025-01-26', 2),
('Luis Pineda', 'luis.pineda@vibefit.com', '7777-1018', '2025-01-27', 3),
('Carmen Díaz', 'carmen.diaz@vibefit.com', '7777-1019', '2025-01-28', 4),
('Fernando Reyes', 'fernando.reyes@vibefit.com', '7777-1020', '2025-01-29', 5),
('Patricia López', 'patricia.lopez@vibefit.com', '7777-1021', '2025-01-30', 6),
('Héctor Cruz', 'hector.cruz@vibefit.com', '7777-1022', '2025-02-01', 7),
('Gabriela Molina', 'gabriela.molina@vibefit.com', '7777-1023', '2025-02-02', 8),
('Raúl Rivera', 'raul.rivera@vibefit.com', '7777-1024', '2025-02-03', 9),
('Diana Flores', 'diana.flores@vibefit.com', '7777-1025', '2025-02-04', 10),
('Sofía Torres', 'sofia.torres@vibefit.com', '7777-1026', '2025-02-05', 11),
('Emilio Gutiérrez', 'emilio.gutierrez@vibefit.com', '7777-1027', '2025-02-06', 12),
('Verónica Salinas', 'veronica.salinas@vibefit.com', '7777-1028', '2025-02-07', 13),
('Ricardo Romero', 'ricardo.romero@vibefit.com', '7777-1029', '2025-02-08', 14),
('Mónica Pérez', 'monica.perez@vibefit.com', '7777-1030', '2025-02-09', 15),
('Alexandra Ruiz', 'alexandra.ruiz@vibefit.com', '7777-1031', '2025-02-10', 1),
('Cristian Flores', 'cristian.flores@vibefit.com', '7777-1032', '2025-02-11', 2),
('Marcela Aguilar', 'marcela.aguilar@vibefit.com', '7777-1033', '2025-02-12', 3),
('Santiago Torres', 'santiago.torres@vibefit.com', '7777-1034', '2025-02-13', 4),
('Lorena Ramos', 'lorena.ramos@vibefit.com', '7777-1035', '2025-02-14', 5),
('Diego Castillo', 'diego.castillo@vibefit.com', '7777-1036', '2025-02-15', 6),
('Camila Reyes', 'camila.reyes@vibefit.com', '7777-1037', '2025-02-16', 7),
('Erick López', 'erick.lopez@vibefit.com', '7777-1038', '2025-02-17', 8),
('Alejandra Martínez', 'alejandra.martinez@vibefit.com', '7777-1039', '2025-02-18', 9),
('Francisco Cruz', 'francisco.cruz@vibefit.com', '7777-1040', '2025-02-19', 10),
('Diana Ramos', 'diana.ramos@vibefit.com', '7777-1041', '2025-02-20', 11),
('Tomás Vega', 'tomas.vega@vibefit.com', '7777-1042', '2025-02-21', 12),
('Rebeca Luna', 'rebeca.luna@vibefit.com', '7777-1043', '2025-02-22', 13),
('Hugo Castro', 'hugo.castro@vibefit.com', '7777-1044', '2025-02-23', 14),
('Mónica Díaz', 'monica.diaz@vibefit.com', '7777-1045', '2025-02-24', 15),
('Oscar Pineda', 'oscar.pineda@vibefit.com', '7777-1046', '2025-02-25', 1),
('Andrea Sánchez', 'andrea.sanchez@vibefit.com', '7777-1047', '2025-02-26', 2),
('Ricardo Mendoza', 'ricardo.mendoza@vibefit.com', '7777-1048', '2025-02-27', 3),
('Vanessa Cruz', 'vanessa.cruz@vibefit.com', '7777-1049', '2025-02-28', 4),
('Eduardo Rivas', 'eduardo.rivas@vibefit.com', '7777-1050', '2025-03-01', 5),
('Estefanía Gómez', 'estefania.gomez@vibefit.com', '7777-1051', '2025-03-02', 6),
('Gustavo Herrera', 'gustavo.herrera@vibefit.com', '7777-1052', '2025-03-03', 7),
('Fátima Morales', 'fatima.morales@vibefit.com', '7777-1053', '2025-03-04', 8),
('Miguel Vázquez', 'miguel.vazquez@vibefit.com', '7777-1054', '2025-03-05', 9),
('Susana Castro', 'susana.castro@vibefit.com', '7777-1055', '2025-03-06', 10),
('Pedro García', 'pedro.garcia@vibefit.com', '7777-1056', '2025-03-07', 11),
('Jessica Pérez', 'jessica.perez@vibefit.com', '7777-1057', '2025-03-08', 12),
('Marcos Ramos', 'marcos.ramos@vibefit.com', '7777-1058', '2025-03-09', 13),
('Claudia Flores', 'claudia.flores@vibefit.com', '7777-1059', '2025-03-10', 14),
('Diego Navarro', 'diego.navarro@vibefit.com', '7777-1060', '2025-03-11', 15);

select * from Reserva
-- =======================================================================
-- Reserva
-- =======================================================================

INSERT INTO Reserva (fecha_reserva, asistencia, id_socio, id_clase) VALUES
('2025-03-01', 1, 1, 1),
('2025-03-01', 1, 2, 2),
('2025-03-02', 0, 3, 3),
('2025-03-02', 1, 4, 4),
('2025-03-03', 1, 5, 5),
('2025-03-03', 1, 6, 6),
('2025-03-04', 0, 7, 7),
('2025-03-04', 1, 8, 8),
('2025-03-05', 1, 9, 9),
('2025-03-05', 1, 10, 10),
('2025-03-06', 0, 11, 11),
('2025-03-06', 1, 12, 12),
('2025-03-07', 1, 13, 13),
('2025-03-07', 1, 14, 14),
('2025-03-08', 0, 15, 15),
('2025-03-08', 1, 16, 16),
('2025-03-09', 1, 17, 17),
('2025-03-09', 1, 18, 18),
('2025-03-10', 0, 19, 19),
('2025-03-10', 1, 20, 20),
('2025-03-11', 1, 21, 1),
('2025-03-11', 1, 22, 2),
('2025-03-12', 0, 23, 3),
('2025-03-12', 1, 24, 4),
('2025-03-13', 1, 25, 5),
('2025-03-13', 0, 26, 6),
('2025-03-14', 1, 27, 7),
('2025-03-14', 1, 28, 8),
('2025-03-15', 1, 29, 9),
('2025-03-15', 1, 30, 10),
('2025-03-16', 0, 31, 11),
('2025-03-16', 1, 32, 12),
('2025-03-17', 1, 33, 13),
('2025-03-17', 0, 34, 14),
('2025-03-18', 1, 35, 15),
('2025-03-18', 1, 36, 16),
('2025-03-19', 1, 37, 17),
('2025-03-19', 1, 38, 18),
('2025-03-20', 0, 39, 19),
('2025-03-20', 1, 40, 20),
('2025-03-21', 1, 41, 1),
('2025-03-21', 0, 42, 2),
('2025-03-22', 1, 43, 3),
('2025-03-22', 1, 44, 4),
('2025-03-23', 1, 45, 5),
('2025-03-23', 1, 46, 6),
('2025-03-24', 0, 47, 7),
('2025-03-24', 1, 48, 8),
('2025-03-25', 1, 49, 9),
('2025-03-25', 1, 50, 10),
('2025-03-26', 1, 51, 11),
('2025-03-26', 0, 52, 12),
('2025-03-27', 1, 53, 13),
('2025-03-27', 1, 54, 14),
('2025-03-28', 1, 55, 15),
('2025-03-28', 1, 56, 16),
('2025-03-29', 1, 57, 17),
('2025-03-29', 1, 58, 18),
('2025-03-30', 1, 59, 19),
('2025-03-30', 0, 60, 20);

-- =======================================================================
-- Pago
-- =======================================================================

INSERT INTO Pago (fecha_pago, monto_pago, metodo_pago, id_socio) VALUES
('2025-02-01', 25.00, 1, 1),
('2025-02-01', 30.00, 2, 2),
('2025-02-05', 55.00, 3, 3),
('2025-02-06', 60.00, 4, 4),
('2025-02-07', 50.00, 1, 5),
('2025-02-10', 25.00, 2, 6),
('2025-02-12', 280.00, 3, 7),
('2025-02-13', 900.00, 4, 8),
('2025-02-14', 75.00, 1, 9),
('2025-02-15', 40.00, 2, 10),
('2025-02-18', 20.00, 3, 11),
('2025-02-19', 500.00, 4, 12),
('2025-02-20', 50.00, 1, 13),
('2025-02-21', 650.00, 2, 14),
('2025-02-22', 850.00, 3, 15),
('2025-02-23', 900.00, 4, 16),
('2025-02-24', 55.00, 1, 17),
('2025-02-25', 60.00, 2, 18),
('2025-02-26', 35.00, 3, 19),
('2025-02-27', 500.00, 4, 20);

SELECT * FROM Clase
SELECT * FROM Socio
Select * FROM Reserva
