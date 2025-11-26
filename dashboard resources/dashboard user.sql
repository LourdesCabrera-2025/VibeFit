--Login Dashboard
CREATE LOGIN PowerBILogin WITH PASSWORD = 'YT8N^6UxWE$T%reHeBfUuXNo6';

USE VibeFit;
GO

--User Dashboard
CREATE USER PowerBIUser FOR LOGIN PowerBILogin;

--Permisos
EXEC sp_addrolemember 'db_datareader', 'PowerBIUser';
GRANT VIEW DATABASE STATE TO PowerBIUser;
GO

USE VibeFit;
GO

--Tabla de Fragmentación
CREATE VIEW dbo.v_IndexFragmentation
AS
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
