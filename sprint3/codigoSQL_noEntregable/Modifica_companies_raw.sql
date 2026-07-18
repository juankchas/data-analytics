CREATE OR REPLACE EXTERNAL TABLE `sprint3_bronze.companies_raw` (
  id STRING,
  company_name STRING,
  phone STRING,
  country STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/companies.csv'],
  skip_leading_rows = 1,
  --Esto le dice a BigQuery que ignore las comas dentro de las comillas dobles
  quote = '"'
);