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

-- ============================================
-- SEGURIDAD SQL (ROLES ,USUARIOS Y POLITICAS 
-- ============================================

use VibeFit

--- ===============================
--   Creación de roles
--- ===============================

CREATE ROLE db_Administracion;
CREATE ROLE db_Entrenador;
CREATE ROLE db_Analista;

-- ================================
-- Permisos para el rol de analista 
-- ================================


GRANT SELECT ON SCHEMA::dbo TO db_Analista;

-- =================================
-- Permisos para el rol de  Administración
-- =================================
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO db_Administracion;
DENY INSERT, UPDATE ON Clase TO db_Administracion;
DENY INSERT, UPDATE ON Membresia TO db_Administracion;
DENY INSERT, UPDATE ON Tipo_Clase TO db_Administracion;
DENY INSERT , UPDATE ON Tipo_Membresia TO db_Administracion;
DENY INSERT, UPDATE ON Metodo_Pago TO db_Administracion;
DENY INSERT ,UPDATE ON Especialidad TO db_Administracion;

-- ==================================
-- Ver Entrenador sin salario
-- ==================================

GRANT SELECT ON Entrenador TO db_Administracion;
DENY SELECT ON Entrenador(salario) TO db_Administracion;

-- =====================================
-- Permisos rol Entrenador
-- =====================================

GRANT SELECT ON Clase TO db_Entrenador;
GRANT SELECT ON Reserva TO db_Entrenador;
GRANT SELECT ON Socio(id_socio, nombre_completo) TO db_Entrenador;
GRANT SELECT ON Entrenador TO db_Entrenador;
DENY SELECT ON Entrenador(salario) TO db_Entrenador;
DENY SELECT, INSERT, UPDATE , DELETE ON Pago TO db_Entrenador;


--===============================
-- Creación de Logins y Usuarios
--===============================
USE master
CREATE LOGIN [login_recepcion]
WITH PASSWORD = 'Recepcion2025VibeFit',
CHECK_POLICY = ON,
CHECK_EXPIRATION = OFF;

CREATE LOGIN [login_entrenador]
WITH PASSWORD = 'Entrenador2025VibeFit',
CHECK_POLICY = ON,
CHECK_EXPIRATION = OFF;

CREATE LOGIN [login_Analista]
WITH PASSWORD = 'Analista2025VibeFit',
CHECK_POLICY = ON,
CHECK_EXPIRATION = OFF;

USE VibeFit

CREATE USER Recepcion FOR LOGIN login_recepcion;
ALTER ROLE db_Administracion ADD MEMBER Recepcion;

CREATE USER Entrenador FOR LOGIN login_entrenador;
ALTER ROLE db_Entrenador ADD MEMBER Entrenador;

CREATE USER Analista FOR LOGIN login_Analista;
ALTER ROLE db_analista ADD MEMBER Analista;

--==========================================
--    Audítorias 
-- ========================================
USE master
CREATE SERVER AUDIT Audit_VibeFit_Pagos
TO FILE ( FILEPATH = 'C:\VibeFit\Auditorias\');

CREATE SERVER AUDIT Audit_VibeFit_Socios
TO FILE ( FILEPATH = 'C:\VibeFit\Auditorias\');

ALTER SERVER AUDIT Audit_VibeFit_Pagos
WITH (STATE = ON);

ALTER SERVER AUDIT Audit_VibeFit_Socios
WITH (STATE = ON)

-- =============================================
--- AUDITORIA DE PAGOS
-- =============================================
USE VibeFit
CREATE DATABASE AUDIT SPECIFICATION Audit_Pagos_VibeFit
FOR SERVER AUDIT Audit_VibeFit_Pagos ADD (INSERT, UPDATE , DELETE ON Pago BY public)
WITH (STATE =  ON) ;

-- ==============================================
--  AUDITORIA DE SOCIOS
-- ==============================================

CREATE DATABASE AUDIT SPECIFICATION Audit_Socios_VibeFit
FOR SERVER AUDIT Audit_VibeFit_Socios
ADD (INSERT, UPDATE ,  DELETE ON dbo.Socio BY public)
WITH (STATE = ON)


-- ===================================
-- Pruebas de Auditoria 
--====================================
use VibeFit

INSERT INTO Pago (fecha_pago, monto_pago, metodo_pago, id_socio) VALUES
('2925-03-01' , 200.00,2 ,20);

DELETE FROM Pago WHERE id_pago = 21;

-- ====================================
-- Consulta de Logs de Auditoía
-- ====================================

SELECT *
FROM sys.fn_get_audit_file (
 'C:\VibeFit\Auditorias\*',
 DEFAULT ,
 DEFAULT
);


-- =============================================
-- Estrategias de Optimización mediante ïndices
--==============================================

-- Consultas que se convertiran a funciones ventana --
-- Consulta Ingresos totales por mes
SELECT YEAR(P.fecha_pago) AS Anio, MONTH(P.fecha_pago) AS Mes, SUM(P.monto_pago) AS Ingresos_totales FROM Pago P
GROUP BY YEAR(P.fecha_pago), MONTH(P.fecha_pago);

-- Consulta sobre entrenador
SELECT E.id_entrenador AS ID, nombre_completo AS Entrenador, E.correo AS Email, ES.especialidad AS Especialidad,
C.nombre_clase AS Clase FROM Entrenador E
JOIN Especialidad ES ON ES.id_especialidad = E.especialidad
JOIN Clase C ON C.id_entrenador = E.id_entrenador
ORDER BY ES.especialidad;

-- Consulta  de clases por reservas
SELECT C.id_clase AS ID, C.nombre_clase AS Clase, COUNT(R.id_reserva) AS Reservas FROM Reserva R
JOIN Clase C ON R.id_clase = C.id_clase WHERE R.fecha_reserva BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY C.id_clase, C.nombre_clase;

-- Consulta de asistencia
SELECT C.id_clase AS ID, C.nombre_clase AS Clase, SUM(CAST(R.asistencia AS INT)) AS Asistencias, COUNT(R.id_reserva) AS Total_reservas FROM Reserva R
JOIN Clase C ON R.id_clase = C.id_clase
GROUP BY C.nombre_clase, C.id_clase;

--Consulta Socios con sus respectivas reservas
SELECT S.id_socio AS ID_Socio, S.nombre_completo AS Socio, R.id_reserva AS ID_Reserva, 
R.fecha_reserva AS Fecha, R.id_clase AS ID_Clase,
C.nombre_clase AS Clase, COUNT(R.id_reserva) OVER (PARTITION BY S.id_socio) AS Total_reservas
FROM Socio S 
JOIN Reserva R ON S.id_socio = R.id_socio
LEFT JOIN Clase C ON R.id_clase = C.id_clase
ORDER BY S.nombre_completo ASC;

-- Creacion de Indices 
CREATE NONCLUSTERED INDEX IX_Pago_Fecha
ON Pago(fecha_pago);

CREATE NONCLUSTERED INDEX IX_Reserva_Fecha
ON Reserva(fecha_reserva);

CREATE NONCLUSTERED INDEX IX_Reserva_Clase
ON Reserva(id_clase);

CREATE NONCLUSTERED INDEX IX_Pago_Socio
ON Pago(id_socio);

CREATE NONCLUSTERED INDEX IX_Clase_Entrenador
ON Clase(id_entrenador);


-- ============================================
-- Consultas Avanzadas con Funciones Ventana
-- ===========================================

use VibeFit
-- Consultas Básicas convertidas a Funciones Ventana -- 

SELECT 
	p.id_socio,
	s.nombre_completo,
	p.monto_pago,
	p.fecha_pago,

	SUM(p.monto_pago) OVER (PARTITION BY YEAR(p.fecha_pago), MONTH (p.fecha_pago)) AS Total_Mensual,
	CAST(ROUND(AVG(p.monto_pago) OVER (),2) AS decimal (10,2)) AS Promedio_Global,
	SUM(p.monto_pago) OVER (
		ORDER BY p.fecha_pago
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	)AS Ingreso_Acumulado
FROM Pago p
INNER JOIN Socio s ON p.id_socio = s.id_socio
ORDER BY p.fecha_pago;


SELECT 
	c.id_clase ,
	c.nombre_clase,

	COUNT (r.id_reserva) As Total_Reservas,
	CAST(ROUND(COUNT (r.id_reserva) * 100.0/ 
	SUM(COUNT(r.id_reserva)) OVER(),
	2)AS decimal(10,2)) AS Porcentaje_Global,
	RANK() OVER(ORDER BY COUNT (R.id_reserva) DESC) AS Ranking_Clase
FROM Reserva r
INNER  JOIN Clase c ON r.id_clase = c.id_clase
GROUP  BY c.id_clase, c.nombre_clase
ORDER BY Total_Reservas DESC;

SELECT  * FROM 
(
SELECT 
	s.id_socio,
	s.nombre_completo,

	MIN(r.fecha_reserva) OVER(PARTITION BY s.nombre_completo) AS Primera_Reserva,
	MAX(r.fecha_reserva) OVER(PARTITION BY s.nombre_completo) AS Ultima_Reserva,

	COUNT(R.id_reserva) OVER (PARTITION BY s.nombre_completo) AS Total_Reservas,

	ROW_NUMBER() OVER (PARTITION BY s.nombre_completo ORDER BY r.fecha_reserva) AS Numero_Actividad
FROM Socio s
LEFT JOIN Reserva r ON s.id_socio = r.id_socio)T
where Numero_Actividad = 1 ORDER BY nombre_completo;



-- == Plan de Backup y Recuperación == --

-- FULL BACKUP (DIARIO)--

BACKUP DATABASE VibeFit
TO DISK = 'C:\VibeFit\Backups_VibeFit\Full\VibeFit_FULL.bak'
WITH FORMAT, INIT, 
	NAME ='FULL BACKUP DIARY';

-- DIFFERENTIAL BACKUP (EVERY 6 HOURS)--

BACKUP DATABASE VibeFit
TO DISK = 'C:\VibeFit\Backups_VibeFit\Diff\VibeFit_DIFF.bak'
WITH DIFFERENTIAL ,
	NAME = 'DIFFERENTIAL BACKUP';


-- LOG TRANSACTION BACKUP --

BACKUP LOG VibeFit 
TO DISK = 'C:\VibeFit\Backups_VibeFit\Log\VibeFit_LOG.trn'
WITH INIT,
	NAME = 'LOG TRANSACTION BACKUP ';

-- Plan de Recuperación --

-- Restaurar backup completo --

RESTORE DATABASE VibeFit
FROM DISK = 'C:\VibeFit\Backups_VibeFit\Full\VibeFit_FULL.bak'
WITH NORECOVERY;

--Restaurar el ultimo backup diferencial --
RESTORE DATABASE VibeFit
FROM DISK = 'C:\VibeFit\Backups_VibeFit\Diff\VibeFit_DIFF.bak'
WITH NORECOVERY;

-- Restuarar todos los backups de logs posteriores --
RESTORE LOG VibeFit
FROM DISK =  'C:\VibeFit\Backups_VibeFit\Log\VibeFit_LOG.trn'
WITH NORECOVERY;

-- Finalizar la recuperacion --
RESTORE DATABASE VibeFit WITH RECOVERY;
