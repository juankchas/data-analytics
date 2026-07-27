-- SPRINT 4 - NIVEL 1: EJERCICIO 4 (VISTAS MATERIALIZADAS)

CREATE MATERIALIZED VIEW `sprint3_gold.mv_daily_sales` AS
SELECT 
  DATE(timestamp) AS fecha,
  COUNT(*) AS total_transacciones,
  SUM(amount) AS ventas_totales
FROM `sprint3_gold.fact_transactions_optimized`
GROUP BY fecha;