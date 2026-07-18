CREATE OR REPLACE TABLE `sprint3-analytics-jcle.sprint3_silver.products_clean` AS
SELECT
  -- 1. Renombramos las columnas según las reglas de Data Governance
  id AS product_id,
  product_name AS name,
  
  -- 2. Eliminamos el prefijo 'WH-' y convertimos a número entero (INT64)
  CAST(REPLACE(warehouse_id, 'WH-', '') AS INT64) AS warehouse_id,
  
  -- 3. Como BigQuery ya lo importó como número directo, lo pasamos limpio
  CAST(price AS FLOAT64) AS price,
  
  -- 4. Conservamos el peso tal cual
  weight
FROM
  `sprint3-analytics-jcle.sprint3_bronze.products_raw`;