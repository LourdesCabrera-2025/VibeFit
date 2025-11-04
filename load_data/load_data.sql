--===============================================================
-- Proyecto de cátedra: VibeFit - Sistema de Reservas de Gimnasio
-- Autor: Grupo V
-- Carga de datos (BULK INSERT)
--===============================================================

USE VibeFit;
GO

BULK INSERT Socio FROM 'C:\bulk_data\VibeFit_Socio.csv'
WITH (
	FIELDTERMINATOR = ';', --Separador de campos
	ROWTERMINATOR = '\n',  --Separador de filas
	FIRSTROW = 2,		   --Saltar encabezado de archivo
	CODEPAGE = '65001'	   --UTF-8 (1252)
);

BULK INSERT Membresia FROM 'C:\bulk_data\VibeFit_Membresia.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Entrenador FROM 'C:\bulk_data\VibeFit_Entrenador.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Clase FROM 'C:\bulk_data\VibeFit_Clase.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Reserva FROM 'C:\bulk_data\VibeFit_Reserva.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Pago FROM 'C:\bulk_data\VibeFit_Pago.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Tipo_Membresia FROM 'C:\bulk_data\VibeFit_TipoMembresia.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Especialidad FROM 'C:\bulk_data\VibeFit_Especialidad.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Tipo_Clase FROM 'C:\bulk_data\VibeFit_TipoClase.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);

BULK INSERT Metodo_Pago FROM 'C:\bulk_data\VibeFit_MetodoPago.csv'
WITH (
	FIELDTERMINATOR = ';', 
	ROWTERMINATOR = '\n', 
	FIRSTROW = 2, 
	CODEPAGE = '65001'
);


-- ===========================================
-- Validaciones
-- ===========================================

--Verificar cantidad de registros cargados en todas las tablas
SELECT 
	i.TABLE_NAME AS Tabla, 
	p.rows AS Registros
FROM sys.objects o
JOIN sys.partitions p ON p.object_id = o.object_id
JOIN information_schema.tables i ON i.TABLE_NAME = o.name
GROUP BY i.TABLE_NAME, p.rows
ORDER BY i.TABLE_NAME


--Verificar constraints
SELECT 
	CONSTRAINT_NAME AS 'Constraint', 
	TABLE_NAME AS Tabla, 
	CONSTRAINT_TYPE AS Tipo
FROM information_schema.table_constraints


--Verificar datos cargados por cada tabla
SELECT * FROM Socio
SELECT * FROM Membresia
SELECT * FROM Entrenador
SELECT * FROM Clase
SELECT * FROM Reserva
SELECT * FROM Pago
SELECT * FROM Tipo_Membresia
SELECT * FROM Especialidad
SELECT * FROM Tipo_Clase
SELECT * FROM Metodo_Pago


--Verificar cantidad de registros cargados por cada tabla
SELECT COUNT(*) AS Registros FROM Socio
SELECT COUNT(*) AS Registros FROM Membresia
SELECT COUNT(*) AS Registros FROM Entrenador
SELECT COUNT(*) AS Registros FROM Clase
SELECT COUNT(*) AS Registros FROM Reserva
SELECT COUNT(*) AS Registros FROM Pago
SELECT COUNT(*) AS Registros FROM Tipo_Membresia
SELECT COUNT(*) AS Registros FROM Especialidad
SELECT COUNT(*) AS Registros FROM Tipo_Clase
SELECT COUNT(*) AS Registros FROM Metodo_Pago