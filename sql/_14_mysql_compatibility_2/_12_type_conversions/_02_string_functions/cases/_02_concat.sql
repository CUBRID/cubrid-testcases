CREATE table alltypes(
int_col INTEGER,
float_col FLOAT,
double_col DOUBLE,
smallint_col SMALLINT,
date_col DATE,
time_col TIME,
timestamp_col TIMESTAMP,
datetime_col DATETIME,
monetary_col MONETARY,
numeric_col NUMERIC(12,4),
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255),
bit_col bit(8),
varbit_col bit varying (255),
set_col set(integer),
sequence_col sequence(integer),
multiset_col multiset(integer, varchar(255)),
blob_col blob,
clob_col clob
);

insert into alltypes values(12345, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1000, 123456.7890, '123', '123.45' ,N'123.45', N'123', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');

select concat(int_col,'cubrid') from alltypes;

select concat('cubrid',int_col) from alltypes;

select concat(int_col, float_col) from alltypes;

select concat(int_col, double_col) from alltypes;

select concat(int_col, smallint_col) from alltypes;

select concat(int_col,monetary_col) from alltypes;

select concat(int_col, numeric_col) from alltypes;

select concat(int_col, date_col) from alltypes;

select concat(int_col, datetime_col) from alltypes;

select concat(int_col, timestamp_col) from alltypes;

select concat(int_col, time_col) from alltypes;

select concat(int_col, bit_col) from alltypes;

select concat(int_col, varbit_col) from alltypes;



select concat(float_col,'cubrid') from alltypes;

select concat('cubrid',float_col) from alltypes;

select concat(float_col, float_col) from alltypes;

select concat(float_col, double_col) from alltypes;

select concat(float_col, smallint_col) from alltypes;

select concat(float_col,monetary_col) from alltypes;

select concat(float_col, numeric_col) from alltypes;

select concat(float_col, date_col) from alltypes;

select concat(float_col, datetime_col) from alltypes;

select concat(float_col, timestamp_col) from alltypes;

select concat(float_col, time_col) from alltypes;

select concat(float_col, bit_col) from alltypes;

select concat(float_col, varbit_col) from alltypes;



select concat(float_col,'cubrid') from alltypes;

select concat('cubrid',float_col) from alltypes;

select concat(float_col, float_col) from alltypes;

select concat(float_col, float_col) from alltypes;

select concat(float_col, smallint_col) from alltypes;

select concat(float_col,monetary_col) from alltypes;

select concat(float_col, numeric_col) from alltypes;

select concat(float_col, date_col) from alltypes;

select concat(float_col, datetime_col) from alltypes;

select concat(float_col, timestamp_col) from alltypes;

select concat(float_col, time_col) from alltypes;

select concat(float_col, bit_col) from alltypes;

select concat(float_col, varbit_col) from alltypes;



select concat(smallint_col,'cubrid') from alltypes;

select concat('cubrid',smallint_col) from alltypes;

select concat(smallint_col, float_col) from alltypes;

select concat(smallint_col, double_col) from alltypes;

select concat(smallint_col, smallint_col) from alltypes;

select concat(smallint_col,monetary_col) from alltypes;

select concat(smallint_col, numeric_col) from alltypes;

select concat(smallint_col, date_col) from alltypes;

select concat(smallint_col, datetime_col) from alltypes;

select concat(smallint_col, timestamp_col) from alltypes;

select concat(smallint_col, time_col) from alltypes;

select concat(smallint_col, bit_col) from alltypes;

select concat(smallint_col, varbit_col) from alltypes;



select concat(monetary_col,'cubrid') from alltypes;

select concat('cubrid',monetary_col) from alltypes;

select concat(monetary_col, float_col) from alltypes;

select concat(monetary_col, double_col) from alltypes;

select concat(monetary_col, smallint_col) from alltypes;

select concat(monetary_col,monetary_col) from alltypes;

select concat(monetary_col, numeric_col) from alltypes;

select concat(monetary_col, date_col) from alltypes;

select concat(monetary_col, datetime_col) from alltypes;

select concat(monetary_col, timestamp_col) from alltypes;

select concat(monetary_col, time_col) from alltypes;

select concat(monetary_col, bit_col) from alltypes;

select concat(monetary_col, varbit_col) from alltypes;


select concat(numeric_col,'cubrid') from alltypes;

select concat('cubrid',numeric_col) from alltypes;

select concat(numeric_col, float_col) from alltypes;

select concat(numeric_col, double_col) from alltypes;

select concat(numeric_col, smallint_col) from alltypes;

select concat(numeric_col,monetary_col) from alltypes;

select concat(numeric_col, numeric_col) from alltypes;

select concat(numeric_col, date_col) from alltypes;

select concat(numeric_col, datetime_col) from alltypes;

select concat(numeric_col, timestamp_col) from alltypes;

select concat(numeric_col, time_col) from alltypes;

select concat(numeric_col, bit_col) from alltypes;

select concat(numeric_col, varbit_col) from alltypes;



select concat(date_col,'cubrid') from alltypes;

select concat('cubrid',date_col) from alltypes;

select concat(date_col, float_col) from alltypes;

select concat(date_col, double_col) from alltypes;

select concat(date_col, smallint_col) from alltypes;

select concat(date_col,monetary_col) from alltypes;

select concat(date_col, numeric_col) from alltypes;

select concat(date_col, date_col) from alltypes;

select concat(date_col, datetime_col) from alltypes;

select concat(date_col, timestamp_col) from alltypes;

select concat(date_col, time_col) from alltypes;

select concat(date_col, bit_col) from alltypes;

select concat(date_col, varbit_col) from alltypes;



select concat(datetime_col,'cubrid') from alltypes;

select concat('cubrid',datetime_col) from alltypes;

select concat(datetime_col, float_col) from alltypes;

select concat(datetime_col, double_col) from alltypes;

select concat(datetime_col, smallint_col) from alltypes;

select concat(datetime_col,monetary_col) from alltypes;

select concat(datetime_col, numeric_col) from alltypes;

select concat(datetime_col, date_col) from alltypes;

select concat(datetime_col, datetime_col) from alltypes;

select concat(datetime_col, timestamp_col) from alltypes;

select concat(datetime_col, time_col) from alltypes;

select concat(datetime_col, bit_col) from alltypes;

select concat(datetime_col, varbit_col) from alltypes;


select concat(time_col,'cubrid') from alltypes;

select concat('cubrid',time_col) from alltypes;

select concat(time_col, float_col) from alltypes;

select concat(time_col, double_col) from alltypes;

select concat(time_col, smallint_col) from alltypes;

select concat(time_col,monetary_col) from alltypes;

select concat(time_col, numeric_col) from alltypes;

select concat(time_col, date_col) from alltypes;

select concat(time_col, datetime_col) from alltypes;

select concat(time_col, timestamp_col) from alltypes;

select concat(time_col, time_col) from alltypes;

select concat(time_col, bit_col) from alltypes;

select concat(time_col, varbit_col) from alltypes;


select concat(timestamp_col,'cubrid') from alltypes;

select concat('cubrid',timestamp_col) from alltypes;

select concat(timestamp_col, float_col) from alltypes;

select concat(timestamp_col, double_col) from alltypes;

select concat(timestamp_col, smallint_col) from alltypes;

select concat(timestamp_col,monetary_col) from alltypes;

select concat(timestamp_col, numeric_col) from alltypes;

select concat(timestamp_col, date_col) from alltypes;

select concat(timestamp_col, datetime_col) from alltypes;

select concat(timestamp_col, timestamp_col) from alltypes;

select concat(timestamp_col, time_col) from alltypes;

select concat(timestamp_col, bit_col) from alltypes;

select concat(timestamp_col, varbit_col) from alltypes;


select concat(bit_col,'cubrid') from alltypes;

select concat('cubrid',bit_col) from alltypes;

select concat(bit_col, float_col) from alltypes;

select concat(bit_col, double_col) from alltypes;

select concat(bit_col, smallint_col) from alltypes;

select concat(bit_col,monetary_col) from alltypes;

select concat(bit_col, numeric_col) from alltypes;

select concat(bit_col, date_col) from alltypes;

select concat(bit_col, datetime_col) from alltypes;

select concat(bit_col, timestamp_col) from alltypes;

select concat(bit_col, time_col) from alltypes;

select concat(bit_col, bit_col) from alltypes;

select concat(bit_col, varbit_col) from alltypes;


select concat(varbit_col,'cubrid') from alltypes;

select concat('cubrid',varbit_col) from alltypes;

select concat(varbit_col, float_col) from alltypes;

select concat(varbit_col, double_col) from alltypes;

select concat(varbit_col, smallint_col) from alltypes;

select concat(varbit_col,monetary_col) from alltypes;

select concat(varbit_col, numeric_col) from alltypes;

select concat(varbit_col, date_col) from alltypes;

select concat(varbit_col, datetime_col) from alltypes;

select concat(varbit_col, timestamp_col) from alltypes;

select concat(varbit_col, time_col) from alltypes;

select concat(varbit_col, bit_col) from alltypes;

select concat(varbit_col, varbit_col) from alltypes;




select if(concat(123,123.45) = concat('123','123.45'), 'ok','nok');

select if(concat(123.45,56.7) = concat('123.45','56.7'), 'ok','nok');

select if(concat(cast(123.45 as numeric(10,2)),'cubrid') = concat('123.45','cubrid'), 'ok','nok');

select if(concat(cast(123.45 as monetary),'cubrid') = concat('$123.45','cubrid'), 'ok','nok');

select if(concat(time'12:00:00 am',date'2010-01-01') = concat('12:00:00 AM','01/01/2010'),'ok','nok');

select if(concat(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am') = concat('12:00:00.123 AM 01/01/2010','12:00:00 AM'),'ok','nok');

select if(concat(timestamp'2010-01-01 12:00:00 am',date'1987-11-16') = concat('12:00:00 AM 01/01/2010','11/16/1987'),'ok','nok');

select if(concat(date'2010-01-01',b'101010') = concat('01/01/2010',cast(b'101010' as string)),'ok','nok');

select if(concat(b'10101010',timestamp('2010-01-01 12:00:00 am')) = concat(cast (b'10101010' as string),'12:00:00.000 AM 01/01/2010'),'ok','nok');

$varchar, $123, $varchar, $12.3
select concat(?,?) from db_root;

$varchar, $123, $varchar, $12.3
select if (concat(?,?) = concat(123,12.3), 'ok','nok') from db_root;


drop table alltypes;