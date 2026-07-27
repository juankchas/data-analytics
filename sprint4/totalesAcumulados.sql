
-- SPRINT 4 - NIVEL 2: EJERCICIO 3 (TOTALES ACUMULADOS)

SELECT 
  fecha,
  ROUND(ventas_totales, 2) AS ventas_del_dia,
  -- Suma acumulada que se reinicia cada 1 de enero
  ROUND(
    SUM(ventas_totales) OVER (
      PARTITION BY EXTRACT(YEAR FROM fecha) 
      ORDER BY fecha ASC 
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 
    2
  ) AS ventas_acumuladas_ytd
FROM `sprint3_gold.mv_daily_sales`
ORDER BY fecha ASC;