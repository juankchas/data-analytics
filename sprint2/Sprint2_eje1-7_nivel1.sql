# verificar error al cargar dataset
SELECT * 
FROM transaction;

#Ejercicio 2
-- Listado de los países que están generando ventas
-- Seleccion de los países únicos de la tabla company que tienen transacciones no rechazadas.
SELECT DISTINCT c.country 
FROM company c
JOIN transaction t ON c.id = t.company_id 
WHERE t.declined = 0 
ORDER BY c.country;

-- Cantidad de países desde los cuales se generan las ventas
-- Se cuenta el número de países distintos presentes en las transacciones exitosas.
SELECT COUNT(DISTINCT c.country) AS total_paises
FROM company c
JOIN transaction t ON c.id = t.company_id 
WHERE t.declined = 0;

-- Compañía con la mayor media de ventas
-- media del monto de las transacciones por compañía y se obtiene la mayor.
SELECT c.company_name, AVG(t.amount) AS media_ventas 
FROM company c
JOIN transaction t ON c.id = t.company_id 
WHERE t.declined = 0 
GROUP BY c.company_name 
ORDER BY media_ventas DESC 
LIMIT 1;

#Ejercicio 3
-- Utilizando sólo subconsultas
-- Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT * 
FROM transaction 
WHERE company_id IN (
    SELECT id 
    FROM company 
    WHERE country = 'Germany'
);
-- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.

SELECT DISTINCT company_name
FROM company 
WHERE id IN (
    SELECT company_id 
    FROM transaction 
    WHERE amount > (
        SELECT AVG(amount) 
        FROM transaction
    )
);

-- Eliminar del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
SELECT company_name 
FROM company 
WHERE id NOT IN (
    SELECT DISTINCT company_id 
    FROM transaction
);
-- no hay empresas

#Ejercicio 5
-- cambio en el base de datos del numero iban para una targeta de credito
SELECT *
FROM credit_card
WHERE id = "CcU-2938";

-- modificar
UPDATE credit_card 
SET iban = 'TR323456312213576817699999' 
WHERE id = 'CcU-2938';

#Ejercicio 6
-- en la tabla transacciones ingresar una nueva transaccion: 
-- Id = 108B1D1D-5B23-A76C-55EF-C568E49A99DD 
-- credit_card_id = CcU-9999
-- company_id = b-9999
-- user_id = 9999
-- lat = 829.999
-- longitude = -117.999
-- amount = 111.11
-- declined = 0 
# para ingresar los datos solicitdos primero se debe crear las Premery Key en las tablas de company y credit_card

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO `transaction`
(id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES
('108B1D1D-5B23-A76C-55EF-C568E49A99DD',
 'CcU-9999',
 'b-9999',
 9999,
 829.999,
 -117.999,
 111.11,
 0);
 
SELECT *
FROM company
WHERE id = 'b-9999';

SELECT *
FROM credit_card
WHERE id = 'CcU-9999';

SELECT * 
FROM `transaction`
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

#Ejercicio 7
-- solicitan eliminar la columna "pan" de la tabla credit_card. mostrar el cambio realizado.

SELECT *
FROM credit_card
limit 1;

ALTER TABLE credit_card
DROP COLUMN pan;