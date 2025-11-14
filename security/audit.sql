/*
Implementacion de la auditoría de seguridad para
             la base de datos VibeFit.
*/

USE master;
GO

-- 1. Creacion de la Auditoría del Servidor
CREATE SERVER AUDIT Audit_VibeFit_Pagos
TO FILE ( FILEPATH = 'C:\BackupsPrueba\AuditLogs\Proyecto' ); -- (esta ruta se cambia)
GO

CREATE SERVER AUDIT Audit_VibeFit_Socios
TO FILE ( FILEPATH = 'C:\BackupsPrueba\AuditLogs\Proyecto' );
GO

-- 2. Habilitar la Auditoría del Servidor
ALTER SERVER AUDIT Audit_VibeFit_Pagos
WITH (STATE = ON);
GO
ALTER SERVER AUDIT Audit_VibeFit_Socios
WITH (STATE = ON);
GO

USE VibeFit;
GO

-- 3. Crear la Especificación de Auditoría de Base de Datos

CREATE DATABASE AUDIT SPECIFICATION Audit_Pagos_VibeFit
FOR SERVER AUDIT Audit_VibeFit_Pagos
ADD (INSERT, UPDATE, DELETE ON dbo.Pago BY public)
WITH (STATE = ON);
GO

CREATE DATABASE AUDIT SPECIFICATION Audit_Socios_VibeFit
FOR SERVER AUDIT Audit_VibeFit_Socios
ADD (INSERT, UPDATE, DELETE ON dbo.Socio BY public)
WITH (STATE = ON);
GO

--Comprobacion del funcionamiento de la auditoria.
SELECT * FROM Pago;
SELECT * FROM Socio;

INSERT INTO Pago (fecha_pago, monto_pago, metodo_pago, id_socio) VALUES
('2025-03-01', 200.00, 2, 20);

DELETE FROM Pago
WHERE id_pago = 21;

SELECT * FROM sys.fn_get_audit_file('C:\BackupsPrueba\AuditLogs\Proyecto\*', DEFAULT, DEFAULT);

