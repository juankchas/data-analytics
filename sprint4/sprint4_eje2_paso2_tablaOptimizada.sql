-- SPRINT 4 - NIVEL 1: EJERCICIO 2 (PASO 2)

CREATE OR REPLACE TABLE `sprint3_gold.fact_transactions_optimized`
PARTITION BY DATE(timestamp)
CLUSTER BY business_id AS
SELECT 
  * 
FROM `sprint3_silver.transactions_recent`;