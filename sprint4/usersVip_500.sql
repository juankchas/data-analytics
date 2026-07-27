-- SPRINT 4 - NIVEL 2: EJERCICIO 1 (PERFILADO DE CLIENTES VIP GASTO > 500€)

WITH User_Transactions AS (
  -- CTE 1: Unimos las transacciones optimizadas con las tarjetas para obtener el user_id
  SELECT 
    c.user_id,
    t.amount
  FROM `sprint3_gold.fact_transactions_optimized` t
  JOIN `sprint3_silver.credit_cards_clean` c
    ON t.card_id = c.card_id
),

VIP_Stats AS (
  -- CTE 2: Agrupamos por usuario y aplicamos redondeo a 2 decimales
  SELECT 
    user_id,
    COUNT(*) AS num_compras,
    ROUND(AVG(amount), 2) AS ticket_medio,
    ROUND(MAX(amount), 2) AS max_compra,
    ROUND(SUM(amount), 2) AS total_gastado
  FROM User_Transactions
  GROUP BY user_id
  HAVING SUM(amount) > 500
),

Users_Info AS (
  -- CTE 3: Extraemos datos personales de la tabla de usuarios
  SELECT 
    user_id,
    CONCAT(name, ' ', surname) AS nombre_completo,
    email
  FROM `sprint3_silver.users_combined`
)

-- Consulta Final: Unimos métricas VIP redondeadas con datos personales
SELECT 
  v.user_id,
  u.nombre_completo,
  u.email,
  v.num_compras,
  v.ticket_medio,
  v.max_compra,
  v.total_gastado
FROM VIP_Stats v
JOIN Users_Info u
  ON v.user_id = u.user_id
ORDER BY v.total_gastado DESC;