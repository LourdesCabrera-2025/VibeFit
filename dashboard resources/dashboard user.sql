--Login Dashboard
CREATE LOGIN PowerBILogin WITH PASSWORD = 'YT8N^6UxWE$T%reHeBfUuXNo6';

USE VibeFit;
GO

--User Dashboard
CREATE USER PowerBIUser FOR LOGIN PowerBILogin;

--Permisos
EXEC sp_addrolemember 'db_datareader', 'PowerBIUser';
GO