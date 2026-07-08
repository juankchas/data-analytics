#Ejercicio 8
-- 1. Creación de la Base de Datos
CREATE DATABASE IF NOT EXISTS e_commerce_analytics;
USE e_commerce_analytics;

-- TABLAS DE DIMENSIONES (Se crean primero porque la tabla de hechos depende de ellas)
-- Dimensión de Usuarios (Consolida american_users y european_users)
CREATE TABLE dim_users (
    user_id INT NOT NULL,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(150),
    birth_date VARCHAR(50), 
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255),
    signup_date DATE,
    user_segment VARCHAR(50),
    income_band VARCHAR(50),
    region VARCHAR(20) NOT NULL,
    PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dimensión de Empresas / Comercios
CREATE TABLE dim_companies (
    company_id VARCHAR(50) NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(150),
    country VARCHAR(100),
    website VARCHAR(255),
    merchant_category VARCHAR(100),
    merchant_price_position VARCHAR(50),
    PRIMARY KEY (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dimensión de Tarjetas de Crédito / Métodos de Pago
CREATE TABLE dim_credit_cards (
    card_id VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    iban VARCHAR(100),
    pan VARCHAR(100),
    pin INT,
    cvv INT,
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(10),
    card_type VARCHAR(50),
    card_renewal_flag BOOLEAN DEFAULT 0,
    PRIMARY KEY (card_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TABLA DE HECHOS (Centraliza las métricas y los eventos de negocio)
CREATE TABLE fact_transactions (
    transaction_id VARCHAR(100) NOT NULL,
    card_id VARCHAR(50) NOT NULL,
    company_id VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    timestamp DATETIME NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    declined BOOLEAN DEFAULT 0,
    product_ids VARCHAR(255),
    lat DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_amount DECIMAL(10, 2) DEFAULT 0.00,
    channel VARCHAR(50),
    campaign_id VARCHAR(100),
    device_type VARCHAR(50),
    is_international BOOLEAN DEFAULT 0,
    decline_reason VARCHAR(255),
    distance_km DECIMAL(10, 2),
    PRIMARY KEY (transaction_id),
    CONSTRAINT FK_transactions_user FOREIGN KEY (user_id) 
        REFERENCES dim_users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_transactions_company FOREIGN KEY (company_id) 
        REFERENCES dim_companies(company_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_transactions_card FOREIGN KEY (card_id) 
        REFERENCES dim_credit_cards(card_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Carga de American Users
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__american_users.csv'
INTO TABLE dim_users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(user_id, name, surname, phone, email, birth_date, country, city, postal_code, address, signup_date, user_segment, income_band)
SET region = 'America'; -- Asigna directamente el valor a la columna region

-- Carga de European Users (Se unifican automáticamente en la misma tabla)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__european_users.csv'
INTO TABLE dim_users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(user_id, name, surname, phone, email, birth_date, country, city, postal_code, address, signup_date, user_segment, income_band)
SET region = 'Europe'; -- Asigna directamente el valor a la columna region

-- Estandarización y limpieza automática de las fechas de nacimiento
ALTER TABLE dim_users ADD COLUMN birth_date_clean DATE;

UPDATE dim_users 
SET birth_date_clean = STR_TO_DATE(REPLACE(birth_date, '"', ''), '%b %e, %Y')
WHERE birth_date IS NOT NULL AND birth_date != '';

ALTER TABLE dim_users DROP COLUMN birth_date;

ALTER TABLE dim_users CHANGE COLUMN birth_date_clean birth_date DATE;

-- Carga de Compañías
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__companies.csv' 
INTO TABLE dim_companies 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(company_id, company_name, phone, email, country, website, merchant_category, merchant_price_position);

-- Carga de Tarjetas de Crédito
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__credit_cards.csv' 
INTO TABLE dim_credit_cards 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(card_id, user_id, iban, pan, pin, cvv, track1, track2, expiring_date, card_type, card_renewal_flag);

-- CARGA DE LA TABLA DE HECHOS (Transactions)
-- Este archivo usa punto y coma (;) como delimitador
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__transactions.csv' 
INTO TABLE fact_transactions 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(transaction_id, card_id, company_id, timestamp, amount, declined, product_ids, user_id, lat, longitude, discount_amount, tax_amount, shipping_amount, channel, campaign_id, device_type, is_international, decline_reason, distance_km);

SET SQL_SAFE_UPDATES = 1;

#Ejercicio 9
-- Consulta que extrae la información descriptiva del usuario
SELECT u.user_id, u.name, u.surname, u.email, u.country, u.region
FROM dim_users u
WHERE u.user_id IN (SELECT t.user_id
					FROM fact_transactions t
					GROUP BY t.user_id
					HAVING COUNT(t.transaction_id) > 80
					)
ORDER BY u.region, u.surname;

# Ejercicio 10 
-- Mostrar la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utilizando dos tablas. 
SELECT c.iban AS iban_tarjeta, c.card_type AS tipo_tarjeta, ROUND(AVG(t.amount), 2) AS promedio_transaccion
FROM fact_transactions t
JOIN dim_credit_cards c ON t.card_id = c.card_id
WHERE c.card_type IN ('credit', 'premium_credit')
AND t.company_id = (SELECT company_id 
						FROM dim_companies 
						WHERE company_name = 'Donec Ltd'
					 )
GROUP BY c.iban, c.card_type
ORDER BY promedio_transaccion DESC;