CREATE OR REPLACE TABLE `sprint3-analytics-jcle.sprint3_silver.transactions_clean` AS
SELECT
  -- 1. Renombramos el ID
  id AS transaction_id,
  
  -- 2. Robustez en Importes: si falla la conversión, ponemos 0
  IFNULL(SAFE_CAST(amount AS FLOAT64), 0.0) AS amount,
  
  -- 3. Convertimos la fecha STRING a TIMESTAMP real
  SAFE_CAST(timestamp AS TIMESTAMP) AS timestamp,
  
  -- 4. Aseguramos que las coordenadas sean FLOAT64
  SAFE_CAST(lat AS FLOAT64) AS lat,
  SAFE_CAST(longitude AS FLOAT64) AS longitude,
  
  -- 5. Desglose de Productos: Convertimos "1, 2, 3" (STRING) a [1, 2, 3] (ARRAY de INT64)
  (
    SELECT ARRAY_AGG(SAFE_CAST(TRIM(id_item) AS INT64))
    FROM UNNEST(SPLIT(product_ids, ',')) AS id_item
  ) AS product_ids,
  
  -- 6. Mantenemos el resto de campos con sus nombres reales identificados en Bronze (business_id, card_id)
  business_id,
  card_id
FROM
  `sprint3-analytics-jcle.sprint3_bronze.transactions_raw_native`;