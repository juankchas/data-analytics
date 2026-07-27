-- SPRINT 4 - NIVEL 2: EJERCICIO 2 (ANÁLISIS DE TENDENCIAS)

WITH Daily_Sales AS (
  SELECT 
    fecha,
    ventas_totales AS ventas_hoy,
    -- Obtenemos las ventas del día anterior según el orden cronológico
    LAG(ventas_totales) OVER (ORDER BY fecha ASC) AS ventas_ayer
  FROM `sprint3_gold.mv_daily_sales`
)

SELECT 
  fecha,
  ROUND(ventas_hoy, 2) AS ventas_hoy,
  ROUND(ventas_ayer, 2) AS ventas_ayer,
  -- Cálculo de variación porcentual: ((Hoy - Ayer) / Ayer) * 100
  ROUND(
    SAFE_DIVIDE((ventas_hoy - ventas_ayer), ventas_ayer) * 100, 
    2
  ) AS diff_percentual
FROM Daily_Sales
ORDER BY fecha DESC;