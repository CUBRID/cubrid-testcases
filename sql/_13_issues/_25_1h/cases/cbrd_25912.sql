
CREATE OR REPLACE FUNCTION test(i int) RETURN int as language java name 'TypeTest.testint(int) return int';
drop table if exists products;
CREATE TABLE products (id INTEGER PRIMARY KEY, parent_id INTEGER, item VARCHAR(100), price INTEGER);
INSERT INTO products VALUES (101, 1, 'Blade', 10);
INSERT INTO products VALUES (102, 2, 'Wheel', 100);

// test query
WITH 
   of_drones AS (SELECT item, 'drones', test(id) as id FROM products WHERE parent_id = 1), 
   of_cars AS (SELECT item, 'cars', 'xyz' FROM products WHERE parent_id = 2)
SELECT * FROM of_drones;

drop function test;
drop products;
