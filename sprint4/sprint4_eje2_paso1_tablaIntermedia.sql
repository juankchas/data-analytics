-- SPRINT 4 - NIVEL 1: EJERCICIO 2 (PASO 1)

CREATE OR REPLACE TABLE `sprint3_silver.transactions_recent` AS
SELECT 
  * EXCEPT(timestamp),
  -- Genera un timestamp dentro de los últimos 50 días
  TIMESTAMP_SUB(
    CURRENT_TIMESTAMP(), 
    INTERVAL CAST(FLOOR(RAND() * 51) AS INT64) DAY
  ) AS timestamp
FROM `sprint3_silver.transactions_clean`;