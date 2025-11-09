USE VibeFit;
GO

Select * from Metodo_Pago;

--Tipo de membrecia y socio
SELECT 
    s.id_socio,
    s.nombre_completo,
    s.correo,
    tm.tipo_membresia,
    m.precio,
    m.duracion_meses
FROM Socio s
INNER JOIN Membresia m ON s.id_membresia = m.id_membresia
INNER JOIN Tipo_Membresia tm ON m.tipo_membresia = tm.id_Tipo_membresia
ORDER BY tm.tipo_membresia, s.nombre_completo;

--clases y participantes
SELECT 
    c.nombre_clase,
    tc.tipo_clase,
    e.nombre_completo AS entrenador,
    COUNT(DISTINCT r.id_socio) AS numero_miembros,
    COUNT(r.id_reserva) AS total_reservas
FROM Clase c
LEFT JOIN Reserva r ON c.id_clase = r.id_clase
LEFT JOIN Tipo_Clase tc ON c.tipo_clase = tc.id_Tipo_clase
LEFT JOIN Entrenador e ON c.id_entrenador = e.id_entrenador
GROUP BY c.id_clase, c.nombre_clase, tc.tipo_clase, e.nombre_completo
ORDER BY total_reservas DESC;


-----------------------------------------------------------Insert para testeos-------------------------------
INSERT INTO Reserva (fecha_reserva, asistencia, id_socio, id_clase)
VALUES 
('2024-11-20', 1, 1, 1),
('2024-11-20', 1, 2, 1),
('2024-11-21', 0, 3, 1),
('2024-11-21', 1, 4, 1),
('2024-11-22', 1, 1, 1),
('2024-11-22', 1, 2, 1);


-- Insertar pagos para diferentes socios con fechas del mes actual
INSERT INTO Pago (fecha_pago, monto_pago, metodo_pago, id_socio)
VALUES 
-- Pagos para el socio 1
(GETDATE(), 50.00, 1, 1),
(DATEADD(day, -5, GETDATE()), 75.00, 2, 1),

-- Pagos para el socio 2  
(GETDATE(), 60.00, 1, 2),
(DATEADD(day, -3, GETDATE()), 80.00, 3, 2),

-- Pagos para el socio 3
(DATEADD(day, -7, GETDATE()), 45.00, 2, 3),
(GETDATE(), 90.00, 1, 3),

-- Pagos para el socio 4
(DATEADD(day, -2, GETDATE()), 55.00, 3, 4),
(GETDATE(), 70.00, 2, 4),

-- Más pagos variados
(DATEADD(day, -10, GETDATE()), 65.00, 1, 1),
(DATEADD(day, -1, GETDATE()), 85.00, 2, 2),
(DATEADD(day, -8, GETDATE()), 95.00, 3, 3),
(DATEADD(day, -4, GETDATE()), 40.00, 1, 4);