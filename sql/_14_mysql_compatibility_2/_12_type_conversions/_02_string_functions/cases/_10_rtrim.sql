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

insert into alltypes values(123, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1000, 123456.7890, '123', '123.45' ,N'123.45', N'123', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');

select rtrim(int_col,'cubrid') from alltypes;

select rtrim('cubrid',int_col) from alltypes;

select rtrim(int_col, float_col) from alltypes;

select rtrim(int_col, double_col) from alltypes;

select rtrim(int_col, smallint_col) from alltypes;

select rtrim(int_col,monetary_col) from alltypes;

select rtrim(int_col, numeric_col) from alltypes;

select rtrim(int_col, date_col) from alltypes;

select rtrim(int_col, datetime_col) from alltypes;

select rtrim(int_col, timestamp_col) from alltypes;

select rtrim(int_col, time_col) from alltypes;

select rtrim(int_col, bit_col) from alltypes;

select rtrim(int_col, varbit_col) from alltypes;



select rtrim(float_col,'cubrid') from alltypes;

select rtrim('cubrid',float_col) from alltypes;

select rtrim(float_col, float_col) from alltypes;

select rtrim(float_col, double_col) from alltypes;

select rtrim(float_col, smallint_col) from alltypes;

select rtrim(float_col,monetary_col) from alltypes;

select rtrim(float_col, numeric_col) from alltypes;

select rtrim(float_col, date_col) from alltypes;

select rtrim(float_col, datetime_col) from alltypes;

select rtrim(float_col, timestamp_col) from alltypes;

select rtrim(float_col, time_col) from alltypes;

select rtrim(float_col, bit_col) from alltypes;

select rtrim(float_col, varbit_col) from alltypes;



select rtrim(float_col,'cubrid') from alltypes;

select rtrim('cubrid',float_col) from alltypes;

select rtrim(float_col, float_col) from alltypes;

select rtrim(float_col, float_col) from alltypes;

select rtrim(float_col, smallint_col) from alltypes;

select rtrim(float_col,monetary_col) from alltypes;

select rtrim(float_col, numeric_col) from alltypes;

select rtrim(float_col, date_col) from alltypes;

select rtrim(float_col, datetime_col) from alltypes;

select rtrim(float_col, timestamp_col) from alltypes;

select rtrim(float_col, time_col) from alltypes;

select rtrim(float_col, bit_col) from alltypes;

select rtrim(float_col, varbit_col) from alltypes;



select rtrim(smallint_col,'cubrid') from alltypes;

select rtrim('cubrid',smallint_col) from alltypes;

select rtrim(smallint_col, float_col) from alltypes;

select rtrim(smallint_col, double_col) from alltypes;

select rtrim(smallint_col, smallint_col) from alltypes;

select rtrim(smallint_col,monetary_col) from alltypes;

select rtrim(smallint_col, numeric_col) from alltypes;

select rtrim(smallint_col, date_col) from alltypes;

select rtrim(smallint_col, datetime_col) from alltypes;

select rtrim(smallint_col, timestamp_col) from alltypes;

select rtrim(smallint_col, time_col) from alltypes;

select rtrim(smallint_col, bit_col) from alltypes;

select rtrim(smallint_col, varbit_col) from alltypes;



select rtrim(monetary_col,'cubrid') from alltypes;

select rtrim('cubrid',monetary_col) from alltypes;

select rtrim(monetary_col, float_col) from alltypes;

select rtrim(monetary_col, double_col) from alltypes;

select rtrim(monetary_col, smallint_col) from alltypes;

select rtrim(monetary_col,monetary_col) from alltypes;

select rtrim(monetary_col, numeric_col) from alltypes;

select rtrim(monetary_col, date_col) from alltypes;

select rtrim(monetary_col, datetime_col) from alltypes;

select rtrim(monetary_col, timestamp_col) from alltypes;

select rtrim(monetary_col, time_col) from alltypes;

select rtrim(monetary_col, bit_col) from alltypes;

select rtrim(monetary_col, varbit_col) from alltypes;


select rtrim(numeric_col,'cubrid') from alltypes;

select rtrim('cubrid',numeric_col) from alltypes;

select rtrim(numeric_col, float_col) from alltypes;

select rtrim(numeric_col, double_col) from alltypes;

select rtrim(numeric_col, smallint_col) from alltypes;

select rtrim(numeric_col,monetary_col) from alltypes;

select rtrim(numeric_col, numeric_col) from alltypes;

select rtrim(numeric_col, date_col) from alltypes;

select rtrim(numeric_col, datetime_col) from alltypes;

select rtrim(numeric_col, timestamp_col) from alltypes;

select rtrim(numeric_col, time_col) from alltypes;

select rtrim(numeric_col, bit_col) from alltypes;

select rtrim(numeric_col, varbit_col) from alltypes;



select rtrim(date_col,'cubrid') from alltypes;

select rtrim('cubrid',date_col) from alltypes;

select rtrim(date_col, float_col) from alltypes;

select rtrim(date_col, double_col) from alltypes;

select rtrim(date_col, smallint_col) from alltypes;

select rtrim(date_col,monetary_col) from alltypes;

select rtrim(date_col, numeric_col) from alltypes;

select rtrim(date_col, date_col) from alltypes;

select rtrim(date_col, datetime_col) from alltypes;

select rtrim(date_col, timestamp_col) from alltypes;

select rtrim(date_col, time_col) from alltypes;

select rtrim(date_col, bit_col) from alltypes;

select rtrim(date_col, varbit_col) from alltypes;



select rtrim(datetime_col,'cubrid') from alltypes;

select rtrim('cubrid',datetime_col) from alltypes;

select rtrim(datetime_col, float_col) from alltypes;

select rtrim(datetime_col, double_col) from alltypes;

select rtrim(datetime_col, smallint_col) from alltypes;

select rtrim(datetime_col,monetary_col) from alltypes;

select rtrim(datetime_col, numeric_col) from alltypes;

select rtrim(datetime_col, date_col) from alltypes;

select rtrim(datetime_col, datetime_col) from alltypes;

select rtrim(datetime_col, timestamp_col) from alltypes;

select rtrim(datetime_col, time_col) from alltypes;

select rtrim(datetime_col, bit_col) from alltypes;

select rtrim(datetime_col, varbit_col) from alltypes;


select rtrim(time_col,'cubrid') from alltypes;

select rtrim('cubrid',time_col) from alltypes;

select rtrim(time_col, float_col) from alltypes;

select rtrim(time_col, double_col) from alltypes;

select rtrim(time_col, smallint_col) from alltypes;

select rtrim(time_col,monetary_col) from alltypes;

select rtrim(time_col, numeric_col) from alltypes;

select rtrim(time_col, date_col) from alltypes;

select rtrim(time_col, datetime_col) from alltypes;

select rtrim(time_col, timestamp_col) from alltypes;

select rtrim(time_col, time_col) from alltypes;

select rtrim(time_col, bit_col) from alltypes;

select rtrim(time_col, varbit_col) from alltypes;


select rtrim(timestamp_col,'cubrid') from alltypes;

select rtrim('cubrid',timestamp_col) from alltypes;

select rtrim(timestamp_col, float_col) from alltypes;

select rtrim(timestamp_col, double_col) from alltypes;

select rtrim(timestamp_col, smallint_col) from alltypes;

select rtrim(timestamp_col,monetary_col) from alltypes;

select rtrim(timestamp_col, numeric_col) from alltypes;

select rtrim(timestamp_col, date_col) from alltypes;

select rtrim(timestamp_col, datetime_col) from alltypes;

select rtrim(timestamp_col, timestamp_col) from alltypes;

select rtrim(timestamp_col, time_col) from alltypes;

select rtrim(timestamp_col, bit_col) from alltypes;

select rtrim(timestamp_col, varbit_col) from alltypes;


select rtrim(bit_col,'cubrid') from alltypes;

select rtrim('cubrid',bit_col) from alltypes;

select rtrim(bit_col, float_col) from alltypes;

select rtrim(bit_col, double_col) from alltypes;

select rtrim(bit_col, smallint_col) from alltypes;

select rtrim(bit_col,monetary_col) from alltypes;

select rtrim(bit_col, numeric_col) from alltypes;

select rtrim(bit_col, date_col) from alltypes;

select rtrim(bit_col, datetime_col) from alltypes;

select rtrim(bit_col, timestamp_col) from alltypes;

select rtrim(bit_col, time_col) from alltypes;

select rtrim(bit_col, bit_col) from alltypes;

select rtrim(bit_col, varbit_col) from alltypes;


select rtrim(varbit_col,'cubrid') from alltypes;

select rtrim('cubrid',varbit_col) from alltypes;

select rtrim(varbit_col, float_col) from alltypes;

select rtrim(varbit_col, double_col) from alltypes;

select rtrim(varbit_col, smallint_col) from alltypes;

select rtrim(varbit_col,monetary_col) from alltypes;

select rtrim(varbit_col, numeric_col) from alltypes;

select rtrim(varbit_col, date_col) from alltypes;

select rtrim(varbit_col, datetime_col) from alltypes;

select rtrim(varbit_col, timestamp_col) from alltypes;

select rtrim(varbit_col, time_col) from alltypes;

select rtrim(varbit_col, bit_col) from alltypes;

select rtrim(varbit_col, varbit_col) from alltypes;




select if(rtrim(123.45,123) = rtrim('123.45','123'), 'ok','nok');

select if(rtrim(123.45,56.7) = rtrim('123.45','56.7'), 'ok','nok');

select if(rtrim(cast(123.45 as numeric(10,2)),'cubrid') = rtrim('123.45','cubrid'), 'ok','nok');

select if(rtrim(cast(123.45 as monetary),'cubrid') = rtrim('$123.45','cubrid'), 'ok','nok');

select if(rtrim(time'12:00:00 am',date'2010-01-01') = rtrim('12:00:00 AM','01/01/2010'),'ok','nok');

select if(rtrim(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am') = rtrim('12:00:00.123 AM 01/01/2010','12:00:00 AM'),'ok','nok');

select if(rtrim(timestamp'2010-01-01 12:00:00 am',date'1987-11-16') = rtrim('12:00:00 AM 01/01/2010','11/16/1987'),'ok','nok');

select if(rtrim(date'2010-01-01',b'101010') = rtrim('01/01/2010',cast(b'101010' as string)),'ok','nok');

$varchar, $123, $varchar, $12.3
select rtrim(?,?) from db_root;

$varchar, $123, $varchar, $12.3
select if (rtrim(?,?) = rtrim(123,12.3), 'ok','nok') from db_root;


drop table alltypes;