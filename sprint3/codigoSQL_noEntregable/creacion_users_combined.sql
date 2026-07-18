CREATE OR REPLACE TABLE `sprint3-analytics-jcle.sprint3_silver.users_combined` AS

-- 1. Procesamos y traemos los usuarios de EE.UU.
SELECT 
  id AS user_id, -- Única columna que el ejercicio nos pide renombrar obligatoriamente
  name,      
  surname,    
  email,
  -- Usamos SAFE. con punto para que si la fecha no coincide con el formato, devuelva NULL sin romper la consulta
  SAFE.PARSE_DATE('%b %d, %Y', birth_date) AS birth_date,
  phone,
  country,
  'USA' AS origin          
FROM 
  `sprint3-analytics-jcle.sprint3_bronze.american_users_raw`
WHERE 
  id IS NOT NULL

UNION ALL

-- 2. Procesamos y unimos los usuarios de Europa
SELECT 
  id AS user_id,
  name,      
  surname,    
  email,
  -- Hacemos exactamente lo mismo para la parte europea
  SAFE.PARSE_DATE('%b %d, %Y', birth_date) AS birth_date,
  phone,
  country,
  'Europe' AS origin       
FROM 
  `sprint3-analytics-jcle.sprint3_bronze.european_users_raw`
WHERE 
  id IS NOT NULL;