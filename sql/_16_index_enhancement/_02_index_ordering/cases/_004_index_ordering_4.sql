
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
PRIMARY KEY (column_integer)
);

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '07:00:34 PM', '12/31/2000', NULL, '07:00:34 PM', '05:55:31 PM 03/02/2002', '05:55:31 PM 02/03/2000');
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '-07:-15:-34.-13 PM', '12/31/2000', NULL, '00:00:35 AM', '05:55:31 PM 05/04/2004', '05:55:31 PM 05/04/2002');
INSERT INTO test_table VALUES(333, 3333, 3.3, null, '05:55:31 PM 02/03/2000', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004');

create reverse index idx1 on test_table(column_integer);
create index idx2 on test_table(column_integer, column_varchar_92);
create reverse index idx3 on test_table(column_integer, column_varchar_92);
create index idx4 on test_table(column_integer, column_timestamp);
create index idx5 on test_table(column_timestamp);
create index idx6 on test_table(column_varchar_92, column_bit, column_datetime, column_smallint);

select column_integer, column_datetime from test_table order by column_integer;
select column_integer, column_datetime from test_table order by column_integer desc;
select column_integer, column_timestamp from test_table where column_timestamp > column_datetime order by column_timestamp;
select column_integer, column_timestamp from test_table where column_integer >= 2 order by column_integer, column_timestamp;
select t.column_varchar_92, t.column_bit, t.column_datetime, t.column_smallint from (select * from test_table where column_integer * 100 >= column_smallint and column_varchar_92 > '' order by column_varchar_92, column_bit, column_datetime, column_smallint) as t;

DROP TABLE test_table;
