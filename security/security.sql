/*
Creación de roles, usuarios y permisos para 
         la base de datos VibeFit.
*/

USE VibeFit;
GO

-- 1. CREACIÓN DE ROLES
CREATE ROLE db_Administracion;
CREATE ROLE db_Entrenador;
CREATE ROLE db_Analista;

-- 2. ASIGNACIÓN DE PERMISOS

-- --- Permisos para rol_Analista
GRANT SELECT ON SCHEMA::dbo TO db_Analista;

--Permisos para rol_Administracion (Recepcionista) ---
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO db_Administracion;
DENY INSERT, UPDATE ON Clase TO db_Administracion;
DENY INSERT, UPDATE ON Membresia TO db_Administracion;
DENY INSERT, UPDATE ON Tipo_Clase TO db_Administracion;
DENY INSERT, UPDATE ON Tipo_Membresia TO db_Administracion;
DENY INSERT, UPDATE ON Metodo_Pago TO db_Administracion;
DENY INSERT, UPDATE ON Especialidad TO db_Administracion;
GO
-- Permiso SELECT en Entrenador, OCULTANDO el salario
GRANT SELECT ON Entrenador To db_Administracion;

-- Denegación explícita de la columna salario por seguridad
DENY SELECT ON Entrenador(salario) TO db_Administracion;


-- Permisos para rol_Entrenador
GRANT SELECT ON Clase TO db_Entrenador;
GRANT SELECT ON Reserva TO db_Entrenador;

-- Solo pueden ver el nombre del socio para pasar lista
GRANT SELECT ON Socio(id_socio, nombre_completo) TO db_Entrenador;

-- Pueden ver la info de contacto de otros entrenadores, pero no el salario
GRANT SELECT ON Entrenador TO db_Entrenador;

-- Denegación explícita de la columna salario
DENY SELECT ON Entrenador(salario) TO db_Entrenador;

-- Denegación explícita de acceso a pagos
DENY SELECT, INSERT, UPDATE, DELETE ON Pago TO db_Entrenador;

-- 3. CREACIÓN DE LOGINS

-- Es crucial usar contraseñas seguras. Cámbialas por unas complejas.
CREATE LOGIN login_recepcion WITH PASSWORD = 'Recepcion2025';
CREATE LOGIN login_entrenador WITH PASSWORD = 'Entrenador2025';
CREATE LOGIN login_analista WITH PASSWORD = 'Analista2025';

-- 4. CREACIÓN DE USUARIOS Y ASIGNACION DE ROLES

-- Usuario para Recepción
CREATE USER Recepcion FOR LOGIN login_recepcion;
ALTER ROLE db_Administracion ADD MEMBER Recepcion;

-- Usuario Entrenador
CREATE USER Entrenador FOR LOGIN login_entrenador;
ALTER ROLE db_Entrenador ADD MEMBER Entrenador;

-- Usuario para el Analista
CREATE USER Analista FOR LOGIN login_analista;
ALTER ROLE db_Analista ADD MEMBER Analista;

