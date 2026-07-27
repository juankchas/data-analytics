
-- SPRINT 4 - NIVEL 2: EJERCICIO 4 (CAMPAÑA FIDELIZACIÓN - 3ª COMPRA)

WITH Transacciones_Secuenciadas AS (
  -- CTE 1: Asignamos el número de orden cronológico por usuario
  -- Unimos con tarjetas para obtener el user_id
  SELECT 
    c.user_id,
    t.timestamp AS fecha_transaccion,
    t.amount,
    ROW_NUMBER() OVER (
      PARTITION BY c.user_id 
      ORDER BY t.timestamp ASC
    ) AS orden_compra
  FROM `sprint3_gold.fact_transactions_optimized` t
  JOIN `sprint3_silver.credit_cards_clean` c
    ON t.card_id = c.card_id
  -- Optimizamos filtrando de entrada solo las primeras 3 compras
  QUALIFY orden_compra <= 3
),

Metricas_3_Primeras AS (
  -- CTE 2: Calculamos la media de las 3 primeras compras y capturamos la 3ª compra exacta
  SELECT 
    user_id,
    ROUND(AVG(amount), 2) AS ticket_medio_3_primeras,
    -- Capturamos la fecha y el importe exacto de la 3ª compra
    MAX(CASE WHEN orden_compra = 3 THEN fecha_transaccion END) AS fecha_3a_compra,
    MAX(CASE WHEN orden_compra = 3 THEN amount END) AS importe_3a_compra,
    COUNT(*) AS total_compras_evaluadas
  FROM Transacciones_Secuenciadas
  GROUP BY user_id
  -- Nos aseguramos de mantener ÚNICAMENTE a los usuarios que alcanzaron la 3ª compra
  HAVING COUNT(*) = 3
),

Users_Info AS (
  -- CTE 3: Información de perfil del usuario
  SELECT 
    user_id,
    CONCAT(name, ' ', surname) AS nombre_completo,
    email
  FROM `sprint3_silver.users_combined`
)

-- Consulta Final: Reporte consolidado para el equipo de Marketing
SELECT 
  m.user_id,
  u.nombre_completo,
  u.email,
  m.fecha_3a_compra,
  ROUND(m.importe_3a_compra, 2) AS importe_3a_compra,
  m.ticket_medio_3_primeras
FROM Metricas_3_Primeras m
JOIN Users_Info u
  ON m.user_id = u.user_id
ORDER BY m.ticket_medio_3_primeras DESC;