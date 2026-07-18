SELECT 
  -- 1. Forzamos de forma segura la conversión a TIMESTAMP antes de extraer la DATE
  DATE(SAFE_CAST(timestamp AS TIMESTAMP)) AS transaction_date,
  
  -- 2. Sumamos y redondeamos el importe convirtiéndolo a número de forma segura
  ROUND(SUM(SAFE_CAST(amount AS FLOAT64)), 2) AS total_revenue
FROM 
  `sprint3-analytics-jcle.sprint3_bronze.transactions_raw_native`
WHERE 
  -- 3. Extraemos el año del TIMESTAMP para filtrar solo el 2021
  EXTRACT(YEAR FROM SAFE_CAST(timestamp AS TIMESTAMP)) = 2021
GROUP BY 
  transaction_date
ORDER BY 
  total_revenue DESC
LIMIT 5;