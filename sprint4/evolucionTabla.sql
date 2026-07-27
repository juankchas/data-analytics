
-- SPRINT 4 - NIVEL 3: EJERCICIO 3 - PASO 2: CREACIÓN DE TABLA CON IVA

CREATE OR REPLACE TABLE `sprint3_gold.dim_transactions_flat` AS
SELECT 
  t.transaction_id,
  t.timestamp,
  t.amount AS total_ticket,
  CAST(p.product_id AS STRING) AS product_sku,
  p.name AS product_name,
  p.price AS product_unit_price,
  -- Invocación limpia de la UDF paramétrica (Importe, Tasa IVA 21%)
  `sprint3_gold.calculate_tax`(p.price, 0.21) AS product_price_tax_inc
FROM `sprint3_gold.fact_transactions_optimized` t
CROSS JOIN UNNEST(t.product_ids) AS single_product_id
JOIN `sprint3_silver.products_clean` p
  ON CAST(single_product_id AS STRING) = CAST(p.product_id AS STRING);