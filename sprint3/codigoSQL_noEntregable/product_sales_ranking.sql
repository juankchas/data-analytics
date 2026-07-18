CREATE OR REPLACE TABLE `sprint3-analytics-jcle.sprint3_gold.product_sales_ranking` AS
WITH exploded_transactions AS (
  SELECT 
    single_product_id
  FROM 
    `sprint3-analytics-jcle.sprint3_silver.transactions_clean`,
    UNNEST(product_ids) AS single_product_id
)

SELECT
  p.product_id,
  p.name,
  p.price,
  p.color,
  COALESCE(COUNT(et.single_product_id), 0) AS total_sold
FROM
  `sprint3-analytics-jcle.sprint3_silver.products_clean` AS p
LEFT JOIN
  exploded_transactions AS et
  ON p.product_id = et.single_product_id
GROUP BY
  p.product_id,
  p.name,
  p.price,
  p.color
ORDER BY
  total_sold DESC;