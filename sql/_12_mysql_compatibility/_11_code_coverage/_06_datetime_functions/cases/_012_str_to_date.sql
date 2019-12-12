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
double_num double, 
PRIMARY KEY (column_integer)
);

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '2/28/2001', '12/31/2002', NULL, '07:00:34 PM', '05:55:31 PM 05/04/2002', '05:55:31 PM 05/04/2000', 123.3, 4444444444444, 44.44, 44.44);

select str_to_date(column_varchar_92, '%m/%d/%Y') from test_table where column_integer = 1;
select str_to_date(123, '%m/%d/%Y');
select str_to_date('07:00:34 PM', '%r');
select str_to_date('07:00:34 PM', '% r');
select str_to_date('05:55:31 PM 05/04/2002', '%r %m/%d/%Y');
select str_to_date('07:00:34 PM', '0%%%q   %r');
select str_to_date('Sat Jan 12 3rd', '%a %b %c %D'), str_to_date('Foo', '%a'), str_to_date('Bar', '%b'), str_to_date('-1', '%c'), str_to_date('-2nd', '%D');
select str_to_date('31 999999 21', '%e %f %H'), str_to_date('-4', '%d'), str_to_date('-3', '%e'), str_to_date('-1', '%f'), str_to_date('-2', '%H');
select str_to_date('11     11  311    11', '%I %i %j %k'), str_to_date('-1', '%i'), str_to_date('-1', '%I'), str_to_date('-1', '%j'), str_to_date('-2', '%k');
select str_to_date('11 am pm', '%l %p %p'), str_to_date('-1', '%l'), str_to_date('genaro', '%M'), str_to_date('-1', '%m'), str_to_date('gm', '%p');
select str_to_date('07  :  00  :  34 PM 07:00:34 AM 88', '%r %r %S'), str_to_date('-07:00:34 PM', '%r'), str_to_date('07:-01:34 PM', '%r'), str_to_date('07:00:-34 PM', '%r');
select str_to_date('07x00:34 PM', '%r'), str_to_date('07:01x34 PM', '%r'), str_to_date('07:00:34 gm', '%r'), str_to_date('-99', '%S'), str_to_date('-14', '%s');
select str_to_date('07  :  00  :  34 88 33', '%T %u %U'), str_to_date('-07:00:34', '%T'), str_to_date('07:-01:34', '%T'), str_to_date('07:00:-34', '%T');
select str_to_date('07x00:34', '%T'), str_to_date('07:01x34', '%T'), str_to_date('-99', '%u'), str_to_date('-14', '%U');
select str_to_date('12 12 Monday 0', '%v %V %W %w'), str_to_date('-1', '%v'), str_to_date('-1', '%V'), str_to_date('mandei', '%W'), str_to_date('-2', '%w');
select str_to_date('12 12 78 30 2000', '%x %X %y %y %Y'), str_to_date('-1', '%x'), str_to_date('-1', '%X'), str_to_date('-99', '%y'), str_to_date('-2', '%Y');
select str_to_date('23 am', '%H %p');
select str_to_date('0000', '%Y');
select str_to_date('13 2002', '%m %Y');
select str_to_date('32 2002', '%d %Y');
select str_to_date('04/2002', '%d/%Y');
select str_to_date('29 02 2001', '%d %m %Y');
select str_to_date('2001 54', '%Y %u');
select str_to_date('2001 54', '%x %v');
select str_to_date('2001 0', '%x %v');
select str_to_date('2001 0', '%X %V');
select str_to_date('2001 999', '%Y %j');
select str_to_date('2001 9', '%Y %w');
select str_to_date('23 am', '%h %p');
select str_to_date('70', '%i');
select str_to_date('70', '%s');
select str_to_date('1999 40 0', '%Y %u %w');
select str_to_date('1999 40 0', '%Y %U %w');
select str_to_date('1999 0 0', '%Y %U %w');
select str_to_date('1999 0 0', '%Y %u %w');
select str_to_date('1999 30 0', '%Y %u %w');
select str_to_date('1998 0 4', '%Y %u %w');
select str_to_date('1998 300', '%Y %j');
select str_to_date('1998 300 23:14:34', '%Y %j %T');
select str_to_date('2000 53 6', '%Y %U %w');
select str_to_date('2001 53 6', '%Y %U %w');
select str_to_date('2007 53 6', '%Y %U %w');


DROP TABLE test_table;