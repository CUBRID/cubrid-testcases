--This is a test case to test whether a javasp function supports CTE

DROP TABLE IF EXISTS products;
CREATE OR REPLACE FUNCTION FC(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION FC2(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';

CREATE TABLE products(id INTEGER PRIMARY KEY, parent_id INTEGER, item VARCHAR(100), price INTEGER);
INSERT INTO products VALUES (1, -1, 'Drone', 2000);
INSERT INTO products VALUES (2, 1, 'Blade', 10);
INSERT INTO products VALUES (3, 1, 'Brushless motor', 20);
INSERT INTO products VALUES (4, 1, 'Frame', 50);
INSERT INTO products VALUES (5, -1, 'Car', 20000);
INSERT INTO products VALUES (6, 5, 'Wheel', 100);
INSERT INTO products VALUES (7, 5, 'Engine', 4000);
INSERT INTO products VALUES (8, 5, 'Frame', 4700);

--ERROR: before ' ) as id FROM products WHERE parent_id = 1),
-- of_cars AS (SELE...'
-- Cannot evaluate '[dba.products].id'. (bug report CBRD-24658)

WITH
 of_drones AS (SELECT item, 'drones', FC(id) as id FROM products WHERE parent_id = 1),
 of_cars AS (SELECT item, 'cars', FC(id) as id FROM products WHERE parent_id = 5)
SELECT * FROM of_drones 
UNION ALL SELECT * FROM of_cars ORDER BY 1;

--success
WITH
 of_drones AS (SELECT item, 'drones', FC(3) as id FROM products WHERE parent_id = 1),
 of_cars AS (SELECT item, 'cars', FC(4) as id FROM products WHERE parent_id = 5)
SELECT * FROM of_drones
UNION ALL SELECT * FROM of_cars ORDER BY 1;

--using db connection. success
WITH
 of_drones AS (SELECT item, 'drones', FC2('select id from products') as id FROM products WHERE parent_id = 1),
 of_cars AS (SELECT item, 'cars', FC2('select id from products') as id FROM products WHERE parent_id = 5)
SELECT * FROM of_drones
UNION ALL SELECT * FROM of_cars ORDER BY 1;

--success
WITH
 of_drones AS (SELECT item, 'drones', FC(id) as id FROM products WHERE parent_id = 1),
 of_cars AS (SELECT item, 'cars', FC(id) as id FROM products WHERE parent_id = 5)
SELECT * FROM of_drones;

--success
SELECT item, 'drones', FC(id) as id FROM products WHERE parent_id = 1 UNION ALL SELECT item, 'cars', FC(id) as id FROM products WHERE parent_id = 5 ORDER BY 1;

DROP FUNCTION FC;
DROP FUNCTION FC2;
DROP TABLE IF EXISTS products;
