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

select strcmp(int_col,'cubrid') from alltypes;

select strcmp('cubrid',int_col) from alltypes;

select strcmp(int_col, float_col) from alltypes;

select strcmp(int_col, double_col) from alltypes;

select strcmp(int_col, smallint_col) from alltypes;

select strcmp(int_col,monetary_col) from alltypes;

select strcmp(int_col, numeric_col) from alltypes;

select strcmp(int_col, date_col) from alltypes;

select strcmp(int_col, datetime_col) from alltypes;

select strcmp(int_col, timestamp_col) from alltypes;

select strcmp(int_col, time_col) from alltypes;

select strcmp(int_col, bit_col) from alltypes;

select strcmp(int_col, varbit_col) from alltypes;



select strcmp(float_col,'cubrid') from alltypes;

select strcmp('cubrid',float_col) from alltypes;

select strcmp(float_col, float_col) from alltypes;

select strcmp(float_col, double_col) from alltypes;

select strcmp(float_col, smallint_col) from alltypes;

select strcmp(float_col,monetary_col) from alltypes;

select strcmp(float_col, numeric_col) from alltypes;

select strcmp(float_col, date_col) from alltypes;

select strcmp(float_col, datetime_col) from alltypes;

select strcmp(float_col, timestamp_col) from alltypes;

select strcmp(float_col, time_col) from alltypes;

select strcmp(float_col, bit_col) from alltypes;

select strcmp(float_col, varbit_col) from alltypes;



select strcmp(float_col,'cubrid') from alltypes;

select strcmp('cubrid',float_col) from alltypes;

select strcmp(float_col, float_col) from alltypes;

select strcmp(float_col, float_col) from alltypes;

select strcmp(float_col, smallint_col) from alltypes;

select strcmp(float_col,monetary_col) from alltypes;

select strcmp(float_col, numeric_col) from alltypes;

select strcmp(float_col, date_col) from alltypes;

select strcmp(float_col, datetime_col) from alltypes;

select strcmp(float_col, timestamp_col) from alltypes;

select strcmp(float_col, time_col) from alltypes;

select strcmp(float_col, bit_col) from alltypes;

select strcmp(float_col, varbit_col) from alltypes;



select strcmp(smallint_col,'cubrid') from alltypes;

select strcmp('cubrid',smallint_col) from alltypes;

select strcmp(smallint_col, float_col) from alltypes;

select strcmp(smallint_col, double_col) from alltypes;

select strcmp(smallint_col, smallint_col) from alltypes;

select strcmp(smallint_col,monetary_col) from alltypes;

select strcmp(smallint_col, numeric_col) from alltypes;

select strcmp(smallint_col, date_col) from alltypes;

select strcmp(smallint_col, datetime_col) from alltypes;

select strcmp(smallint_col, timestamp_col) from alltypes;

select strcmp(smallint_col, time_col) from alltypes;

select strcmp(smallint_col, bit_col) from alltypes;

select strcmp(smallint_col, varbit_col) from alltypes;



select strcmp(monetary_col,'cubrid') from alltypes;

select strcmp('cubrid',monetary_col) from alltypes;

select strcmp(monetary_col, float_col) from alltypes;

select strcmp(monetary_col, double_col) from alltypes;

select strcmp(monetary_col, smallint_col) from alltypes;

select strcmp(monetary_col,monetary_col) from alltypes;

select strcmp(monetary_col, numeric_col) from alltypes;

select strcmp(monetary_col, date_col) from alltypes;

select strcmp(monetary_col, datetime_col) from alltypes;

select strcmp(monetary_col, timestamp_col) from alltypes;

select strcmp(monetary_col, time_col) from alltypes;

select strcmp(monetary_col, bit_col) from alltypes;

select strcmp(monetary_col, varbit_col) from alltypes;


select strcmp(numeric_col,'cubrid') from alltypes;

select strcmp('cubrid',numeric_col) from alltypes;

select strcmp(numeric_col, float_col) from alltypes;

select strcmp(numeric_col, double_col) from alltypes;

select strcmp(numeric_col, smallint_col) from alltypes;

select strcmp(numeric_col,monetary_col) from alltypes;

select strcmp(numeric_col, numeric_col) from alltypes;

select strcmp(numeric_col, date_col) from alltypes;

select strcmp(numeric_col, datetime_col) from alltypes;

select strcmp(numeric_col, timestamp_col) from alltypes;

select strcmp(numeric_col, time_col) from alltypes;

select strcmp(numeric_col, bit_col) from alltypes;

select strcmp(numeric_col, varbit_col) from alltypes;



select strcmp(date_col,'cubrid') from alltypes;

select strcmp('cubrid',date_col) from alltypes;

select strcmp(date_col, float_col) from alltypes;

select strcmp(date_col, double_col) from alltypes;

select strcmp(date_col, smallint_col) from alltypes;

select strcmp(date_col,monetary_col) from alltypes;

select strcmp(date_col, numeric_col) from alltypes;

select strcmp(date_col, date_col) from alltypes;

select strcmp(date_col, datetime_col) from alltypes;

select strcmp(date_col, timestamp_col) from alltypes;

select strcmp(date_col, time_col) from alltypes;

select strcmp(date_col, bit_col) from alltypes;

select strcmp(date_col, varbit_col) from alltypes;



select strcmp(datetime_col,'cubrid') from alltypes;

select strcmp('cubrid',datetime_col) from alltypes;

select strcmp(datetime_col, float_col) from alltypes;

select strcmp(datetime_col, double_col) from alltypes;

select strcmp(datetime_col, smallint_col) from alltypes;

select strcmp(datetime_col,monetary_col) from alltypes;

select strcmp(datetime_col, numeric_col) from alltypes;

select strcmp(datetime_col, date_col) from alltypes;

select strcmp(datetime_col, datetime_col) from alltypes;

select strcmp(datetime_col, timestamp_col) from alltypes;

select strcmp(datetime_col, time_col) from alltypes;

select strcmp(datetime_col, bit_col) from alltypes;

select strcmp(datetime_col, varbit_col) from alltypes;


select strcmp(time_col,'cubrid') from alltypes;

select strcmp('cubrid',time_col) from alltypes;

select strcmp(time_col, float_col) from alltypes;

select strcmp(time_col, double_col) from alltypes;

select strcmp(time_col, smallint_col) from alltypes;

select strcmp(time_col,monetary_col) from alltypes;

select strcmp(time_col, numeric_col) from alltypes;

select strcmp(time_col, date_col) from alltypes;

select strcmp(time_col, datetime_col) from alltypes;

select strcmp(time_col, timestamp_col) from alltypes;

select strcmp(time_col, time_col) from alltypes;

select strcmp(time_col, bit_col) from alltypes;

select strcmp(time_col, varbit_col) from alltypes;


select strcmp(timestamp_col,'cubrid') from alltypes;

select strcmp('cubrid',timestamp_col) from alltypes;

select strcmp(timestamp_col, float_col) from alltypes;

select strcmp(timestamp_col, double_col) from alltypes;

select strcmp(timestamp_col, smallint_col) from alltypes;

select strcmp(timestamp_col,monetary_col) from alltypes;

select strcmp(timestamp_col, numeric_col) from alltypes;

select strcmp(timestamp_col, date_col) from alltypes;

select strcmp(timestamp_col, datetime_col) from alltypes;

select strcmp(timestamp_col, timestamp_col) from alltypes;

select strcmp(timestamp_col, time_col) from alltypes;

select strcmp(timestamp_col, bit_col) from alltypes;

select strcmp(timestamp_col, varbit_col) from alltypes;


select strcmp(bit_col,'cubrid') from alltypes;

select strcmp('cubrid',bit_col) from alltypes;

select strcmp(bit_col, float_col) from alltypes;

select strcmp(bit_col, double_col) from alltypes;

select strcmp(bit_col, smallint_col) from alltypes;

select strcmp(bit_col,monetary_col) from alltypes;

select strcmp(bit_col, numeric_col) from alltypes;

select strcmp(bit_col, date_col) from alltypes;

select strcmp(bit_col, datetime_col) from alltypes;

select strcmp(bit_col, timestamp_col) from alltypes;

select strcmp(bit_col, time_col) from alltypes;

select strcmp(bit_col, bit_col) from alltypes;

select strcmp(bit_col, varbit_col) from alltypes;


select strcmp(varbit_col,'cubrid') from alltypes;

select strcmp('cubrid',varbit_col) from alltypes;

select strcmp(varbit_col, float_col) from alltypes;

select strcmp(varbit_col, double_col) from alltypes;

select strcmp(varbit_col, smallint_col) from alltypes;

select strcmp(varbit_col,monetary_col) from alltypes;

select strcmp(varbit_col, numeric_col) from alltypes;

select strcmp(varbit_col, date_col) from alltypes;

select strcmp(varbit_col, datetime_col) from alltypes;

select strcmp(varbit_col, timestamp_col) from alltypes;

select strcmp(varbit_col, time_col) from alltypes;

select strcmp(varbit_col, bit_col) from alltypes;

select strcmp(varbit_col, varbit_col) from alltypes;




select if(strcmp(123,123.45) = strcmp('123','123.45'), 'ok','nok');

select if(strcmp(123.45,56.7) = strcmp('123.45','56.7'), 'ok','nok');

select if(strcmp(cast(123.45 as numeric(10,2)),'cubrid') = strcmp('123.45','cubrid'), 'ok','nok');

select if(strcmp(cast(123.45 as monetary),'cubrid') = strcmp('$123.45','cubrid'), 'ok','nok');

select if(strcmp(time'12:00:00 am',date'2010-01-01') = strcmp('12:00:00 am','2010-01-01'),'ok','nok'));

select if(strcmp(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am') = strcmp('2010-01-01 12:00:00.123 am','12:00:00 am'),'ok','nok');

select if(strcmp(timestamp'2010-01-01 12:00:00 am',date'1987-11-16') = strcmp('2010-01-01 12:00:00 am','1987-11-16'),'ok','nok');

select if(strcmp(date'2010-01-01',b'101010') = strcmp('2010-01-01',cast(b'101010' as string)),'ok','nok');

select if(strcmp(b'10101010',timestamp('2010-01-01 12:00:00 am')) = strcmp(cast (b'10101010' as string),'2010-01-01 12:00:00 am'),'ok','nok');

$varchar, $123, $varchar, $12.3
select strcmp(?,?) from db_root;

$varchar, $123, $varchar, $12.3
select if (strcmp(?,?) = strcmp(123,12.3), 'ok','nok') from db_root;

drop table alltypes;
