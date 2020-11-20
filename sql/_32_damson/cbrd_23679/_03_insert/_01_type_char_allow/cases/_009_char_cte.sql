set system parameters 'allow_truncated_string=yes';

---------- INSERT INTO ...
---------- WITH cte AS (SELECT ...)
---------- SELECT * FROM cte ORDERBY 1;

drop table if exists products;
drop table if exists t1;

CREATE TABLE products (id INTEGER PRIMARY KEY, parent_id INTEGER, item VARCHAR(100), price INTEGER);
INSERT INTO products VALUES (1, -1, 'Drone', 2000);
INSERT INTO products VALUES (2, 1, 'Blade', 10);
INSERT INTO products VALUES (4, 1, 'Frame', 50);
INSERT INTO products VALUES (5, -1, 'Car', 20000);
INSERT INTO products VALUES (6, 5, 'Wheel', 100);
INSERT INTO products VALUES (7, 5, 'Engine', 4000);
INSERT INTO products VALUES (8, 5, 'Frame', 4700);

-- precision > value : OK
drop table if exists t1;
create table t1 (col1 char(20));
show columns from t1;
insert into t1 with 
of_drones AS (SELECT item FROM products WHERE parent_id = 1),
of_cars AS (SELECT item FROM products WHERE parent_id = 5)
SELECT * FROM of_drones UNION ALL SELECT * FROM of_cars ORDER BY 1;
select * from t1 order by 1;

-- precision = value : OK
drop table if exists t1;
create table t1 (col1 char(6));
show columns from t1;
insert into t1 with 
of_drones AS (SELECT item FROM products WHERE parent_id = 1),
of_cars AS (SELECT item FROM products WHERE parent_id = 5)
SELECT * FROM of_drones UNION ALL SELECT * FROM of_cars ORDER BY 1;
select * from t1 order by 1;

-- precision < value :truncated string
drop table if exists t1;
create table t1 (col1 char(3));
show columns from t1;
insert into t1 with 
of_drones AS (SELECT item FROM products WHERE parent_id = 1),
of_cars AS (SELECT item FROM products WHERE parent_id = 5)
SELECT * FROM of_drones UNION ALL SELECT * FROM of_cars ORDER BY 1;
select * from t1 order by 1;

drop table t1;
drop table products;
set system parameters 'allow_truncated_string=no';
