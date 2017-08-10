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

select locate(int_col,'cubrid') from alltypes;

select locate('cubrid',int_col) from alltypes;

select locate(int_col, float_col) from alltypes;

select locate(int_col, double_col) from alltypes;

select locate(int_col, smallint_col) from alltypes;

select locate(int_col,monetary_col) from alltypes;

select locate(int_col, numeric_col) from alltypes;

select locate(int_col, date_col) from alltypes;

select locate(int_col, datetime_col) from alltypes;

select locate(int_col, timestamp_col) from alltypes;

select locate(int_col, time_col) from alltypes;

select locate(int_col, bit_col) from alltypes;

select locate(int_col, varbit_col) from alltypes;



select locate(float_col,'cubrid') from alltypes;

select locate('cubrid',float_col) from alltypes;

select locate(float_col, float_col) from alltypes;

select locate(float_col, double_col) from alltypes;

select locate(float_col, smallint_col) from alltypes;

select locate(float_col,monetary_col) from alltypes;

select locate(float_col, numeric_col) from alltypes;

select locate(float_col, date_col) from alltypes;

select locate(float_col, datetime_col) from alltypes;

select locate(float_col, timestamp_col) from alltypes;

select locate(float_col, time_col) from alltypes;

select locate(float_col, bit_col) from alltypes;

select locate(float_col, varbit_col) from alltypes;



select locate(float_col,'cubrid') from alltypes;

select locate('cubrid',float_col) from alltypes;

select locate(float_col, float_col) from alltypes;

select locate(float_col, float_col) from alltypes;

select locate(float_col, smallint_col) from alltypes;

select locate(float_col,monetary_col) from alltypes;

select locate(float_col, numeric_col) from alltypes;

select locate(float_col, date_col) from alltypes;

select locate(float_col, datetime_col) from alltypes;

select locate(float_col, timestamp_col) from alltypes;

select locate(float_col, time_col) from alltypes;

select locate(float_col, bit_col) from alltypes;

select locate(float_col, varbit_col) from alltypes;



select locate(smallint_col,'cubrid') from alltypes;

select locate('cubrid',smallint_col) from alltypes;

select locate(smallint_col, float_col) from alltypes;

select locate(smallint_col, double_col) from alltypes;

select locate(smallint_col, smallint_col) from alltypes;

select locate(smallint_col,monetary_col) from alltypes;

select locate(smallint_col, numeric_col) from alltypes;

select locate(smallint_col, date_col) from alltypes;

select locate(smallint_col, datetime_col) from alltypes;

select locate(smallint_col, timestamp_col) from alltypes;

select locate(smallint_col, time_col) from alltypes;

select locate(smallint_col, bit_col) from alltypes;

select locate(smallint_col, varbit_col) from alltypes;



select locate(monetary_col,'cubrid') from alltypes;

select locate('cubrid',monetary_col) from alltypes;

select locate(monetary_col, float_col) from alltypes;

select locate(monetary_col, double_col) from alltypes;

select locate(monetary_col, smallint_col) from alltypes;

select locate(monetary_col,monetary_col) from alltypes;

select locate(monetary_col, numeric_col) from alltypes;

select locate(monetary_col, date_col) from alltypes;

select locate(monetary_col, datetime_col) from alltypes;

select locate(monetary_col, timestamp_col) from alltypes;

select locate(monetary_col, time_col) from alltypes;

select locate(monetary_col, bit_col) from alltypes;

select locate(monetary_col, varbit_col) from alltypes;


select locate(numeric_col,'cubrid') from alltypes;

select locate('cubrid',numeric_col) from alltypes;

select locate(numeric_col, float_col) from alltypes;

select locate(numeric_col, double_col) from alltypes;

select locate(numeric_col, smallint_col) from alltypes;

select locate(numeric_col,monetary_col) from alltypes;

select locate(numeric_col, numeric_col) from alltypes;

select locate(numeric_col, date_col) from alltypes;

select locate(numeric_col, datetime_col) from alltypes;

select locate(numeric_col, timestamp_col) from alltypes;

select locate(numeric_col, time_col) from alltypes;

select locate(numeric_col, bit_col) from alltypes;

select locate(numeric_col, varbit_col) from alltypes;



select locate(date_col,'cubrid') from alltypes;

select locate('cubrid',date_col) from alltypes;

select locate(date_col, float_col) from alltypes;

select locate(date_col, double_col) from alltypes;

select locate(date_col, smallint_col) from alltypes;

select locate(date_col,monetary_col) from alltypes;

select locate(date_col, numeric_col) from alltypes;

select locate(date_col, date_col) from alltypes;

select locate(date_col, datetime_col) from alltypes;

select locate(date_col, timestamp_col) from alltypes;

select locate(date_col, time_col) from alltypes;

select locate(date_col, bit_col) from alltypes;

select locate(date_col, varbit_col) from alltypes;



select locate(datetime_col,'cubrid') from alltypes;

select locate('cubrid',datetime_col) from alltypes;

select locate(datetime_col, float_col) from alltypes;

select locate(datetime_col, double_col) from alltypes;

select locate(datetime_col, smallint_col) from alltypes;

select locate(datetime_col,monetary_col) from alltypes;

select locate(datetime_col, numeric_col) from alltypes;

select locate(datetime_col, date_col) from alltypes;

select locate(datetime_col, datetime_col) from alltypes;

select locate(datetime_col, timestamp_col) from alltypes;

select locate(datetime_col, time_col) from alltypes;

select locate(datetime_col, bit_col) from alltypes;

select locate(datetime_col, varbit_col) from alltypes;


select locate(time_col,'cubrid') from alltypes;

select locate('cubrid',time_col) from alltypes;

select locate(time_col, float_col) from alltypes;

select locate(time_col, double_col) from alltypes;

select locate(time_col, smallint_col) from alltypes;

select locate(time_col,monetary_col) from alltypes;

select locate(time_col, numeric_col) from alltypes;

select locate(time_col, date_col) from alltypes;

select locate(time_col, datetime_col) from alltypes;

select locate(time_col, timestamp_col) from alltypes;

select locate(time_col, time_col) from alltypes;

select locate(time_col, bit_col) from alltypes;

select locate(time_col, varbit_col) from alltypes;


select locate(timestamp_col,'cubrid') from alltypes;

select locate('cubrid',timestamp_col) from alltypes;

select locate(timestamp_col, float_col) from alltypes;

select locate(timestamp_col, double_col) from alltypes;

select locate(timestamp_col, smallint_col) from alltypes;

select locate(timestamp_col,monetary_col) from alltypes;

select locate(timestamp_col, numeric_col) from alltypes;

select locate(timestamp_col, date_col) from alltypes;

select locate(timestamp_col, datetime_col) from alltypes;

select locate(timestamp_col, timestamp_col) from alltypes;

select locate(timestamp_col, time_col) from alltypes;

select locate(timestamp_col, bit_col) from alltypes;

select locate(timestamp_col, varbit_col) from alltypes;


select locate(bit_col,'cubrid') from alltypes;

select locate('cubrid',bit_col) from alltypes;

select locate(bit_col, float_col) from alltypes;

select locate(bit_col, double_col) from alltypes;

select locate(bit_col, smallint_col) from alltypes;

select locate(bit_col,monetary_col) from alltypes;

select locate(bit_col, numeric_col) from alltypes;

select locate(bit_col, date_col) from alltypes;

select locate(bit_col, datetime_col) from alltypes;

select locate(bit_col, timestamp_col) from alltypes;

select locate(bit_col, time_col) from alltypes;

select locate(bit_col, bit_col) from alltypes;

select locate(bit_col, varbit_col) from alltypes;


select locate(varbit_col,'cubrid') from alltypes;

select locate('cubrid',varbit_col) from alltypes;

select locate(varbit_col, float_col) from alltypes;

select locate(varbit_col, double_col) from alltypes;

select locate(varbit_col, smallint_col) from alltypes;

select locate(varbit_col,monetary_col) from alltypes;

select locate(varbit_col, numeric_col) from alltypes;

select locate(varbit_col, date_col) from alltypes;

select locate(varbit_col, datetime_col) from alltypes;

select locate(varbit_col, timestamp_col) from alltypes;

select locate(varbit_col, time_col) from alltypes;

select locate(varbit_col, bit_col) from alltypes;

select locate(varbit_col, varbit_col) from alltypes;




select if(locate(123,123.45) = locate('123','123.45'), 'ok','nok');

select if(locate(123.45,56.7) = locate('123.45','56.7'), 'ok','nok');

select if(locate(cast(123.45 as numeric(10,2)),'cubrid') = locate('123.45','cubrid'), 'ok','nok');

select if(locate(cast(123.45 as monetary),'cubrid') = locate('$123.45','cubrid'), 'ok','nok');

select if(locate(time'12:00:00 am',date'2010-01-01') = locate('12:00:00 am','2010-01-01'),'ok','nok'));

select if(locate(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am') = locate('2010-01-01 12:00:00.123 am','12:00:00 am'),'ok','nok');

select if(locate(timestamp'2010-01-01 12:00:00 am',date'1987-11-16') = locate('2010-01-01 12:00:00 am','1987-11-16'),'ok','nok');

select if(locate(date'2010-01-01',b'101010') = locate('2010-01-01',cast(b'101010' as string)),'ok','nok');

select if(locate(b'10101010',timestamp'2010-01-01 12:00:00 am') = locate(cast (b'10101010' as string),'2010-01-01 12:00:00 am'),'ok','nok');

$varchar, $123, $varchar, $12
select locate(?,?) from db_root;

$varchar, $123, $varchar, $12
select if (locate(?,?) = locate(123,12), 'ok','nok') from db_root;

drop table alltypes;
