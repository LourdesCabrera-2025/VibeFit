-------------------------------------------------------------
-- 1. Crear LOGIN para Power BI (a nivel de servidor)
-------------------------------------------------------------
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'PowerBILogin')
BEGIN
    CREATE LOGIN PowerBILogin 
    WITH PASSWORD = 'YT8N^6UxWE$T%reHeBfUuXNo6';
END
GO

-------------------------------------------------------------
-- 2. Crear USER dentro de la base VibeFit
-- (Debe tener el MISMO nombre del LOGIN)
-------------------------------------------------------------
USE VibeFit;
GO

-- Si existía un usuario incorrecto, lo borramos
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'PowerBIUser')
    DROP USER PowerBIUser;
GO

-- Si existe un User que no coincide, lo borramos
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'PowerBILogin')
    DROP USER PowerBILogin;
GO

-- Crear usuario nuevo vinculado al login
CREATE USER PowerBILogin FOR LOGIN PowerBILogin;
GO

-------------------------------------------------------------
-- 3. Asignar permisos de SOLO LECTURA
-------------------------------------------------------------

-- Permiso básico para leer todas las tablas
EXEC sp_addrolemember 'db_datareader', 'PowerBILogin';
GO

-- Permiso para que Power BI pueda ver estados internos
GRANT VIEW DATABASE STATE TO PowerBILogin;
GO


-------------------------------------------------------------
-- 4. Crear Vista de Monitoreo (Fragmentación)
--    Power BI la Leerá para Dashboard de Optimización
-------------------------------------------------------------
IF OBJECT_ID('dbo.v_IndexFragmentation', 'V') IS NOT NULL
    DROP VIEW dbo.v_IndexFragmentation;
GO

CREATE VIEW dbo.v_IndexFragmentation AS
SELECT  
    DB_NAME() AS database_name,
    OBJECT_NAME(ips.object_id) AS table_name,
    i.name AS index_name,
    i.type_desc AS index_type,
    ips.avg_fragmentation_in_percent,
    ips.page_count,
    ips.index_id,
    ips.alloc_unit_type_desc,
    ips.index_level,
    ips.partition_number,
    GETDATE() AS capture_time
FROM sys.dm_db_index_physical_stats (
        DB_ID(), 
        NULL, 
        NULL, 
        NULL, 
        'LIMITED'
) ips
INNER JOIN sys.indexes i
    ON ips.object_id = i.object_id
    AND ips.index_id = i.index_id
WHERE ips.page_count > 0;
GO

-------------------------------------------------------------
-- 5. Validación: revisar login y user creados
-------------------------------------------------------------
SELECT name, type_desc 
FROM sys.server_principals
WHERE name = 'PowerBILogin';

SELECT name, type_desc 
FROM sys.database_principals
WHERE name = 'PowerBILogin';
GO
