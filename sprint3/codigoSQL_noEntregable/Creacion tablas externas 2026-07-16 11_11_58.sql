-- 2. Tabla: companies_raw (Capa Bronze - Esquema manual, ignorando cabecera)
CREATE OR REPLACE EXTERNAL TABLE `sprint3_bronze.companies_raw` (
  id STRING,
  company_name STRING,
  phone STRING,
  country STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/companies.csv'],
  skip_leading_rows = 1
);

-- 3. Tabla: american_users_raw (Capa Bronze - CRM Estándar)
CREATE OR REPLACE EXTERNAL TABLE `sprint3_bronze.american_users_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/american_users.csv'],
  skip_leading_rows = 1
);

-- 4. Tabla: european_users_raw (Capa Bronze - CRM Estándar)
CREATE OR REPLACE EXTERNAL TABLE `sprint3_bronze.european_users_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/european_users.csv'],
  skip_leading_rows = 1
);

-- 5. Tabla: credit_cards_raw (Capa Bronze - CRM Estándar)
CREATE OR REPLACE EXTERNAL TABLE `sprint3_bronze.credit_cards_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/credit_cards.csv'],
  skip_leading_rows = 1
);