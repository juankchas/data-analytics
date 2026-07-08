#Nivel 2
#Ejercicio 1
-- Mostrar cinco días con mayor cantidad de ingresos en la empresa por ventas. Muestra fecha con total de las ventas
SELECT DATE(t.timestamp) AS fecha_transaccion, ROUND(SUM(t.amount), 2) AS total_ventas_dia
FROM fact_transactions t
WHERE t.declined = 0 
GROUP BY DATE(t.timestamp)
ORDER BY total_ventas_dia DESC
LIMIT 5;

# Ejercicio 2
-- nombre, teléfono, país, fecha y amount, de transacciones entre 350 y 400 euros, 
-- en las fechas 9/04/2015, 20/07/2018 y 13/03/2024, ordenar de mayor a menor
SELECT c.company_name AS nombre_empresa, c.phone AS telefono, c.country AS pais, DATE(t.timestamp) AS fecha_transaccion, t.amount AS monto_euro
FROM fact_transactions t
JOIN dim_companies c ON t.company_id = c.company_id
WHERE t.amount BETWEEN 350 AND 400 -- Filtro 1: Rango de valores monetarios solicitado
    AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13') -- Filtro 2: Restricción a las fechas específicas requeridas
    AND t.declined = 0 -- Filtro solo transacciones aprobadas
ORDER BY t.amount DESC;

#Ejercicio 3
-- cantidad de transacciones que realizan las empresas, si tienen igual o más de 400 transacciones o menos.
SELECT c.company_name AS nombre_empresa, c.country AS pais, COUNT(t.transaction_id) AS total_transacciones,
    CASE 
        WHEN COUNT(t.transaction_id) >= 400 THEN '+= 400 transacciones'
        ELSE '- 400 transacciones'
    END AS clasificacion
FROM dim_companies c
LEFT JOIN fact_transactions t ON c.company_id = t.company_id
GROUP BY c.company_id, c.company_name, c.country
ORDER BY total_transacciones DESC;

#Ejercicio 4
-- Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos. 
SELECT transaction_id, amount, timestamp 
FROM fact_transactions 
WHERE transaction_id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


DELETE FROM fact_transactions 
WHERE transaction_id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


SELECT transaction_id 
FROM fact_transactions 
WHERE transaction_id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

#Ejercicio 5
-- VistaMarketing, tabla virtual con Nombre de la compañía, teléfono de contacto, país de residencia, Media de compra.
-- ordenar de mayor a menor
CREATE OR REPLACE VIEW VistaMarketing AS
SELECT c.company_name AS Nombre_Compania,  c.phone AS Telefono_Contacto, c.country AS Pais_Residencia, ROUND(AVG(t.amount), 2) AS Promedio_Compra
FROM dim_companies c
JOIN fact_transactions t ON c.company_id = t.company_id
WHERE t.declined = 0 OR t.declined IS NULL
GROUP BY c.company_id, c.company_name, c.phone, c.country;

SELECT * 
FROM VistaMarketing
ORDER BY Promedio_Compra DESC;