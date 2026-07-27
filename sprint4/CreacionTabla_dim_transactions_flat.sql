-- SPRINT 4 - NIVEL 3: EJERCICIO 1 (DESANIMIENTO / UNNESTING)


CREATE OR REPLACE TABLE `sprint3_gold.dim_transactions_flat` AS
SELECT 
  t.transaction_id,
  t.timestamp,
  t.amount AS total_ticket,
  CAST(p.product_id AS STRING) AS product_sku,
  p.name AS product_name,
  p.price AS product_price
FROM `sprint3_gold.fact_transactions_optimized` t
-- 1. Desanidamos el Array de productos para convertir cada elemento en una fila independiente
CROSS JOIN UNNEST(t.product_ids) AS single_product_id
-- 2. Cruzamos con la tabla products_clean usando product_id
JOIN `sprint3_silver.products_clean` p
  ON CAST(single_product_id AS STRING) = CAST(p.product_id AS STRING);