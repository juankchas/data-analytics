CREATE OR REPLACE VIEW sprint3-analytics-jcle.sprint3_gold.v_marketing_kpis AS
SELECT
  c.company_name,
  c.phone,
  c.country,
  -- Calculamos el promedio de compra por compañía
  ROUND(AVG(t.amount), 2) AS avg_purchase,
  -- Aplicamos la lógica del Tier de cliente
  CASE 
    WHEN AVG(t.amount) > 260 THEN 'Premium'
    ELSE 'Standard'
  END AS client_tier
FROM
   sprint3-analytics-jcle.sprint3_silver.companies_clean AS c
LEFT JOIN
   sprint3-analytics-jcle.sprint3_silver.transactions_clean AS t
  ON c.company_id = t.business_id
GROUP BY
  c.company_name,
  c.phone,
  c.country;