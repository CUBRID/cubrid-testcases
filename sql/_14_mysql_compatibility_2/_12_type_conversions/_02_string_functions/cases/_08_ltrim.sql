



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

select ltrim(int_col,'cubrid') from alltypes;

select ltrim('cubrid',int_col) from alltypes;

select ltrim(int_col, float_col) from alltypes;

select ltrim(int_col, double_col) from alltypes;

select ltrim(int_col, smallint_col) from alltypes;

select ltrim(int_col,monetary_col) from alltypes;

select ltrim(int_col, numeric_col) from alltypes;

select ltrim(int_col, date_col) from alltypes;

select ltrim(int_col, datetime_col) from alltypes;

select ltrim(int_col, timestamp_col) from alltypes;

select ltrim(int_col, time_col) from alltypes;

select ltrim(int_col, bit_col) from alltypes;

select ltrim(int_col, varbit_col) from alltypes;



select ltrim(float_col,'cubrid') from alltypes;

select ltrim('cubrid',float_col) from alltypes;

select ltrim(float_col, float_col) from alltypes;

select ltrim(float_col, double_col) from alltypes;

select ltrim(float_col, smallint_col) from alltypes;

select ltrim(float_col,monetary_col) from alltypes;

select ltrim(float_col, numeric_col) from alltypes;

select ltrim(float_col, date_col) from alltypes;

select ltrim(float_col, datetime_col) from alltypes;

select ltrim(float_col, timestamp_col) from alltypes;

select ltrim(float_col, time_col) from alltypes;

select ltrim(float_col, bit_col) from alltypes;

select ltrim(float_col, varbit_col) from alltypes;



select ltrim(float_col,'cubrid') from alltypes;

select ltrim('cubrid',float_col) from alltypes;

select ltrim(float_col, float_col) from alltypes;

select ltrim(float_col, float_col) from alltypes;

select ltrim(float_col, smallint_col) from alltypes;

select ltrim(float_col,monetary_col) from alltypes;

select ltrim(float_col, numeric_col) from alltypes;

select ltrim(float_col, date_col) from alltypes;

select ltrim(float_col, datetime_col) from alltypes;

select ltrim(float_col, timestamp_col) from alltypes;

select ltrim(float_col, time_col) from alltypes;

select ltrim(float_col, bit_col) from alltypes;

select ltrim(float_col, varbit_col) from alltypes;



select ltrim(smallint_col,'cubrid') from alltypes;

select ltrim('cubrid',smallint_col) from alltypes;

select ltrim(smallint_col, float_col) from alltypes;

select ltrim(smallint_col, double_col) from alltypes;

select ltrim(smallint_col, smallint_col) from alltypes;

select ltrim(smallint_col,monetary_col) from alltypes;

select ltrim(smallint_col, numeric_col) from alltypes;

select ltrim(smallint_col, date_col) from alltypes;

select ltrim(smallint_col, datetime_col) from alltypes;

select ltrim(smallint_col, timestamp_col) from alltypes;

select ltrim(smallint_col, time_col) from alltypes;

select ltrim(smallint_col, bit_col) from alltypes;

select ltrim(smallint_col, varbit_col) from alltypes;



select ltrim(monetary_col,'cubrid') from alltypes;

select ltrim('cubrid',monetary_col) from alltypes;

select ltrim(monetary_col, float_col) from alltypes;

select ltrim(monetary_col, double_col) from alltypes;

select ltrim(monetary_col, smallint_col) from alltypes;

select ltrim(monetary_col,monetary_col) from alltypes;

select ltrim(monetary_col, numeric_col) from alltypes;

select ltrim(monetary_col, date_col) from alltypes;

select ltrim(monetary_col, datetime_col) from alltypes;

select ltrim(monetary_col, timestamp_col) from alltypes;

select ltrim(monetary_col, time_col) from alltypes;

select ltrim(monetary_col, bit_col) from alltypes;

select ltrim(monetary_col, varbit_col) from alltypes;


select ltrim(numeric_col,'cubrid') from alltypes;

select ltrim('cubrid',numeric_col) from alltypes;

select ltrim(numeric_col, float_col) from alltypes;

select ltrim(numeric_col, double_col) from alltypes;

select ltrim(numeric_col, smallint_col) from alltypes;

select ltrim(numeric_col,monetary_col) from alltypes;

select ltrim(numeric_col, numeric_col) from alltypes;

select ltrim(numeric_col, date_col) from alltypes;

select ltrim(numeric_col, datetime_col) from alltypes;

select ltrim(numeric_col, timestamp_col) from alltypes;

select ltrim(numeric_col, time_col) from alltypes;

select ltrim(numeric_col, bit_col) from alltypes;

select ltrim(numeric_col, varbit_col) from alltypes;



select ltrim(date_col,'cubrid') from alltypes;

select ltrim('cubrid',date_col) from alltypes;

select ltrim(date_col, float_col) from alltypes;

select ltrim(date_col, double_col) from alltypes;

select ltrim(date_col, smallint_col) from alltypes;

select ltrim(date_col,monetary_col) from alltypes;

select ltrim(date_col, numeric_col) from alltypes;

select ltrim(date_col, date_col) from alltypes;

select ltrim(date_col, datetime_col) from alltypes;

select ltrim(date_col, timestamp_col) from alltypes;

select ltrim(date_col, time_col) from alltypes;

select ltrim(date_col, bit_col) from alltypes;

select ltrim(date_col, varbit_col) from alltypes;



select ltrim(datetime_col,'cubrid') from alltypes;

select ltrim('cubrid',datetime_col) from alltypes;

select ltrim(datetime_col, float_col) from alltypes;

select ltrim(datetime_col, double_col) from alltypes;

select ltrim(datetime_col, smallint_col) from alltypes;

select ltrim(datetime_col,monetary_col) from alltypes;

select ltrim(datetime_col, numeric_col) from alltypes;

select ltrim(datetime_col, date_col) from alltypes;

select ltrim(datetime_col, datetime_col) from alltypes;

select ltrim(datetime_col, timestamp_col) from alltypes;

select ltrim(datetime_col, time_col) from alltypes;

select ltrim(datetime_col, bit_col) from alltypes;

select ltrim(datetime_col, varbit_col) from alltypes;


select ltrim(time_col,'cubrid') from alltypes;

select ltrim('cubrid',time_col) from alltypes;

select ltrim(time_col, float_col) from alltypes;

select ltrim(time_col, double_col) from alltypes;

select ltrim(time_col, smallint_col) from alltypes;

select ltrim(time_col,monetary_col) from alltypes;

select ltrim(time_col, numeric_col) from alltypes;

select ltrim(time_col, date_col) from alltypes;

select ltrim(time_col, datetime_col) from alltypes;

select ltrim(time_col, timestamp_col) from alltypes;

select ltrim(time_col, time_col) from alltypes;

select ltrim(time_col, bit_col) from alltypes;

select ltrim(time_col, varbit_col) from alltypes;


select ltrim(timestamp_col,'cubrid') from alltypes;

select ltrim('cubrid',timestamp_col) from alltypes;

select ltrim(timestamp_col, float_col) from alltypes;

select ltrim(timestamp_col, double_col) from alltypes;

select ltrim(timestamp_col, smallint_col) from alltypes;

select ltrim(timestamp_col,monetary_col) from alltypes;

select ltrim(timestamp_col, numeric_col) from alltypes;

select ltrim(timestamp_col, date_col) from alltypes;

select ltrim(timestamp_col, datetime_col) from alltypes;

select ltrim(timestamp_col, timestamp_col) from alltypes;

select ltrim(timestamp_col, time_col) from alltypes;

select ltrim(timestamp_col, bit_col) from alltypes;

select ltrim(timestamp_col, varbit_col) from alltypes;


select ltrim(bit_col,'cubrid') from alltypes;

select ltrim('cubrid',bit_col) from alltypes;

select ltrim(bit_col, float_col) from alltypes;

select ltrim(bit_col, double_col) from alltypes;

select ltrim(bit_col, smallint_col) from alltypes;

select ltrim(bit_col,monetary_col) from alltypes;

select ltrim(bit_col, numeric_col) from alltypes;

select ltrim(bit_col, date_col) from alltypes;

select ltrim(bit_col, datetime_col) from alltypes;

select ltrim(bit_col, timestamp_col) from alltypes;

select ltrim(bit_col, time_col) from alltypes;

select ltrim(bit_col, bit_col) from alltypes;

select ltrim(bit_col, varbit_col) from alltypes;


select ltrim(varbit_col,'cubrid') from alltypes;

select ltrim('cubrid',varbit_col) from alltypes;

select ltrim(varbit_col, float_col) from alltypes;

select ltrim(varbit_col, double_col) from alltypes;

select ltrim(varbit_col, smallint_col) from alltypes;

select ltrim(varbit_col,monetary_col) from alltypes;

select ltrim(varbit_col, numeric_col) from alltypes;

select ltrim(varbit_col, date_col) from alltypes;

select ltrim(varbit_col, datetime_col) from alltypes;

select ltrim(varbit_col, timestamp_col) from alltypes;

select ltrim(varbit_col, time_col) from alltypes;

select ltrim(varbit_col, bit_col) from alltypes;

select ltrim(varbit_col, varbit_col) from alltypes;




select if(ltrim(123.45,123) = ltrim('123.45','123'), 'ok','nok');

select if(ltrim(123.45,56.7) = ltrim('123.45','56.7'), 'ok','nok');

select if(ltrim(cast(123.45 as numeric(10,2)),'cubrid') = ltrim('123.45','cubrid'), 'ok','nok');

select if(ltrim(cast(123.45 as monetary),'cubrid') = ltrim('$123.45','cubrid'), 'ok','nok');

select if(ltrim(time'12:00:00 am',date'2010-01-01') = ltrim('12:00:00 AM','01/01/2010'),'ok','nok');

select if(ltrim(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am') = ltrim('12:00:00.123 AM 01/01/2010','12:00:00 AM'),'ok','nok');

select if(ltrim(timestamp'2010-01-01 12:00:00 am',date'1987-11-16') = ltrim('12:00:00 AM 01/01/2010','11/16/1987'),'ok','nok');

select if(ltrim(date'2010-01-01',b'101010') = ltrim('01/01/2010',cast(b'101010' as string)),'ok','nok');

$varchar, $123, $varchar, $12.3
select ltrim(?,?) from db_root;

$varchar, $123, $varchar, $12.3
select if (ltrim(?,?) = ltrim(123,12.3), 'ok','nok') from db_root;


drop table alltypes;



