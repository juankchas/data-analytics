#Nivel 3
#Ejercicio 1
CREATE TABLE tabla_estado_tarjetas AS
WITH transacciones_ordenadas AS (SELECT t.card_id, t.declined, ROW_NUMBER() OVER (PARTITION BY t.card_id  -- Numeramos las transacciones de las tarjetas de la más reciente (1) a la más antigua
                                                                                  ORDER BY t.timestamp DESC
                                                                                 ) AS posicion_temporal
                                 FROM fact_transactions t
                                ),
	 ultimas_3_transacciones AS (SELECT card_id, declined -- bloque de las 3 últimas operaciones de cada tarjeta
                                 FROM transacciones_ordenadas
                                 WHERE posicion_temporal <= 3
								),
     analisis_rechazos AS (SELECT card_id, SUM(declined) AS total_declinadas, COUNT(declined) AS total_transacciones_evaluadas -- Sumamos los rechazos en ese bloque de 3. 
                           FROM ultimas_3_transacciones -- Si la suma es 3, significa que las 3 fueron declinadas (1+1+1).
                           GROUP BY card_id
						)
SELECT c.card_id, c.iban, CASE 
                           WHEN a.total_declinadas = 3 THEN 'Inactivo'
                           ELSE 'Activo'
                           END AS estado_tarjeta
FROM dim_credit_cards c
LEFT JOIN analisis_rechazos a ON c.card_id = a.card_id;

-- ¿Cuántas tarjetas están activas?
SELECT estado_tarjeta, COUNT(*) AS cantidad_tarjetas
FROM tabla_estado_tarjetas
WHERE estado_tarjeta = 'Activo';

#ejercicio 2
-- Crear la tabla pasarela
CREATE TABLE transaction_products (
    transaction_id VARCHAR(50),
    product_id INT,
    PRIMARY KEY (transaction_id, product_id)
);

INSERT INTO transaction_products (transaction_id, product_id)
SELECT t.transaction_id, CAST(j.product_id AS UNSIGNED) AS product_id
FROM fact_transactions t
JOIN 
    -- Transformamos la cadena '9, 11, 47' en un formato JSON '[9, 11, 47]'
    JSON_TABLE( CONCAT('[', t.product_ids, ']'), '$[*]' COLUMNS (product_id VARCHAR(50) PATH '$')
              ) AS j
--  solo procesar si hay productos y la transacción fue aprobada
WHERE t.product_ids IS NOT NULL 
    AND t.product_ids <> ''
    AND t.declined = 0;
    
-- número de veces que se ha vendido cada producto
SELECT p.id AS id_producto, p.product_name AS nombre_producto, p.price AS precio_euro, p.category AS categoria, COUNT(tp.product_id) AS cantidad_veces_vendido
FROM dim_products p
JOIN transaction_products tp ON p.id = tp.product_id
GROUP BY p.id, p.product_name, p.price, p.category
ORDER BY cantidad_veces_vendido DESC;