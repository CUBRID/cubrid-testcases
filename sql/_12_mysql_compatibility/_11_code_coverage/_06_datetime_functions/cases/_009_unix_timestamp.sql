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

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '07:00:34 PM', '12/31/2002', NULL, '07:00:34 PM', '05:55:31 PM 03/02/2002', '05:55:31 PM 02/03/2000');
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '-07:-15:-34.-13 PM', '12/31/2000', NULL, '00:00:35 AM', '05:55:31 PM 05/04/2004', '05:55:31 PM 05/04/2002');
INSERT INTO test_table VALUES(333, 333, 3.3, null, 'varchar', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004');

select 1 from (select UNIX_TIMESTAMP('2007-11-30 10:30:1922')) x;
select 1 from (select UNIX_TIMESTAMP(column_char_9) from test_table where column_integer = 333) x;
select 1 from (select UNIX_TIMESTAMP(column_datetime) from test_table where column_integer = 1) x;
select 1 from (select UNIX_TIMESTAMP(column_date) from test_table where column_integer = 1) x;
select 1 from (select /*+ NO_MERGE */ UNIX_TIMESTAMP(column_time) from test_table where column_integer = 1) x;
select 1 from (select UNIX_TIMESTAMP(column_timestamp) from test_table where column_integer = 1) x;
select 1 from (select UNIX_TIMESTAMP('05:55:31 PM 02/03/2000') from test_table where column_integer = 1) x;
select 1 from (select UNIX_TIMESTAMP('99999-12-31 23:59:59.99999999999999999999')) x;
select 1 from (select UNIX_TIMESTAMP(null)) x;
select 1 from (select UNIX_TIMESTAMP(1232222)) x;
select 1 from (select UNIX_TIMESTAMP(-1)) x;
select 1 from (select UNIX_TIMESTAMP(12345)) x;
select 1 from (select UNIX_TIMESTAMP(993456)) x;
select 1 from (select UNIX_TIMESTAMP(12345678)) x;
select 1 from (select UNIX_TIMESTAMP(12345678901)) x;
select 1 from (select UNIX_TIMESTAMP(123456789012)) x;
select 1 from (select UNIX_TIMESTAMP(12345678901234)) x;
select 1 from (select UNIX_TIMESTAMP('0300-01-01 00:00:00.')) x;
select 1 from (select UNIX_TIMESTAMP('3900-01-01 00:44:00.666')) x;
select 1 from (select UNIX_TIMESTAMP('3900-xxxx-01 00:xxxx:00.xxxxxxxxxxx')) x;
select 1 from (select UNIX_TIMESTAMP('2000-33-55 11:22:33')) x;
select 1 from (select UNIX_TIMESTAMP('0200-33-55 11:22:33')) x;
select 1 from (select UNIX_TIMESTAMP('2000-xxxxx-xx 11:x3')) x;
select 1 from (select UNIX_TIMESTAMP('20-33-55 11:22:33')) x;
select 1 from (select UNIX_TIMESTAMP('02-33-55 11:22:33')) x;
select 1 from (select UNIX_TIMESTAMP('20-xxxxx-xx 11:x3')) x;
select 1 from (select UNIX_TIMESTAMP('10000101000000')) x;
select 1 from (select UNIX_TIMESTAMP('01000101000000')) x;
select 1 from (select UNIX_TIMESTAMP('000101000000')) x;
select 1 from (select UNIX_TIMESTAMP('1000-01-01')) x;
select 1 from (select UNIX_TIMESTAMP('0900-01-01')) x;
select 1 from (select UNIX_TIMESTAMP('xxxxx-1-01')) x;
select 1 from (select UNIX_TIMESTAMP('99-12-31')) x;
select 1 from (select UNIX_TIMESTAMP('xxxx1-01')) x;
select 1 from (select UNIX_TIMESTAMP('99991231')) x;
select 1 from (select UNIX_TIMESTAMP('991231')) x;
DROP TABLE test_table;

