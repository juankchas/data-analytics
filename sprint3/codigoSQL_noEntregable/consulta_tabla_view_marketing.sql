SELECT * 
FROM `sprint3-analytics-jcle.sprint3_gold.v_marketing_kpis`
ORDER BY 
  CASE WHEN client_tier = 'Premium' THEN 1 ELSE 2 END ASC, 
  avg_purchase DESC;