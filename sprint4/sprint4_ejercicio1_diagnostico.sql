-- Consulta de diagnóstico sin optimizar
SELECT 
  t.*,
  c.* EXCEPT (company_id)
FROM `sprint3_silver.transactions_clean` t
JOIN `sprint3_silver.companies_clean` c
  ON t.business_id = c.company_id
WHERE DATE(t.timestamp) = '2022-03-12'
  AND c.country = 'Germany';