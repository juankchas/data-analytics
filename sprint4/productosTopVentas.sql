-- SPRINT 4 - NIVEL 3: EJERCICIO 2 (RANKING DE VENTAS TOP 5)

SELECT 
  product_sku,
  product_name,
  COUNT(*) AS unidades_vendidas,
  ROUND(SUM(product_price), 2) AS facturacion_total
FROM `sprint3_gold.dim_transactions_flat`
GROUP BY 
  product_sku,
  product_name
ORDER BY 
  unidades_vendidas DESC
LIMIT 5;