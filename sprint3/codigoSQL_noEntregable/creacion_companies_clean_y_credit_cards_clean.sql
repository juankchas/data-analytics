-- 1. Creamos la tabla nativa de Compañías limpias
CREATE OR REPLACE TABLE `sprint3-analytics-jcle.sprint3_silver.companies_clean` AS
SELECT
  id AS company_id,
  company_name,
  phone,
  country
FROM
  `sprint3-analytics-jcle.sprint3_bronze.companies_raw`;

-- 2. Creamos la tabla nativa de Tarjetas de Crédito limpias
CREATE OR REPLACE TABLE `sprint3-analytics-jcle.sprint3_silver.credit_cards_clean` AS
SELECT
  id AS card_id,
  * EXCEPT(id) -- Esto copia el resto de las columnas tal cual sin duplicar el 'id' original
FROM
  `sprint3-analytics-jcle.sprint3_bronze.credit_cards_raw`;