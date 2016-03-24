CREATE TABLE test_table(column_integer INTEGER,
column_smallint SMALLINT,
column_numeric_9_2 NUMERIC(9,2),
column_char_9 CHAR(9),
column_varchar_92 VARCHAR(92),
column_date DATE,
column_bit BIT(4),
column_time TIME,
column_timestamp TIMESTAMP,
column_datetime datetime,
monet monetary, 
big bigint, 
float_num float, 
PRIMARY KEY (column_integer)
);

INSERT INTO test_table VALUES(1, 11, 1.1, NULL, '07:00:34 PM', '12/31/2000', NULL, '07:00:34 PM', '05:55:31 PM 03/02/2002', '05:55:31 PM 02/03/2000', 123.3, 4444444444444, 44.44);

select format(null, 1);
select format('aaa', 'aaa');
select format(column_bit, column_bit) from test_table where column_integer = 1;
select format(column_char_9, 1) from test_table where column_integer = 1;
select format(monet, 1) from test_table;
select format(big, 0) from test_table;
select format(float_num, 3) from test_table;
select format(column_integer, 0) from test_table;
select format(column_smallint, 0) from test_table;
select format('999', -4) from test_table;
select format('-666.666', 2) from test_table;

DROP TABLE test_table;

SELECT FORMAT(cast (2 as short), 4) from db_root;
SELECT FORMAT(cast (2 as int), 4) from db_root;
SELECT FORMAT(cast (2 as bigint), 4) from db_root;
SELECT FORMAT(cast (2.022 as float), 4) from db_root;
SELECT FORMAT(cast (2.022 as double), 4) from db_root;
SELECT FORMAT(cast (2 as numeric), 4) from db_root;
SELECT FORMAT(cast (2.022 as monetary), 4) from db_root;

SELECT FORMAT(cast (-2 as short), 4) from db_root;
SELECT FORMAT(cast (-2 as int), 4) from db_root;
SELECT FORMAT(cast (-2 as bigint), 4) from db_root;
SELECT FORMAT(cast (-2.022 as float), 4) from db_root;
SELECT FORMAT(cast (-2.022 as double), 4) from db_root;
SELECT FORMAT(cast (-2 as numeric), 4) from db_root;
SELECT FORMAT(cast (-2.022 as monetary), 4) from db_root;

SELECT FORMAT(1, -4) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select format(null_c, 1) from db_root;
drop table tbl;
