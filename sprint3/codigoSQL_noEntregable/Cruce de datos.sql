SELECT 
  c.company_name,
  c.country,
  DATE(t.timestamp) AS transaction_date,
  t.amount AS amount_euros
FROM 
  `sprint3-analytics-jcle.sprint3_bronze.transactions_raw_native` t
INNER JOIN 
  `sprint3-analytics-jcle.sprint3_bronze.companies_raw` c ON t.business_id = c.id
WHERE 
  t.amount BETWEEN 100 AND 200
  AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY 
  transaction_date ASC;
