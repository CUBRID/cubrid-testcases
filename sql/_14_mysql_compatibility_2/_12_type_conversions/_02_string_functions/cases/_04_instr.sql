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

select instr(int_col,'12',1) from alltypes;

select instr('123456789',int_col,1) from alltypes;

select instr(int_col, float_col,1) from alltypes;

select instr(int_col, double_col,1) from alltypes;

select instr(int_col, smallint_col,1) from alltypes;

select instr(int_col,monetary_col,1) from alltypes;

select instr(int_col, numeric_col,1) from alltypes;

select instr(int_col, date_col,1) from alltypes;

select instr(int_col, datetime_col,1) from alltypes;

select instr(int_col, timestamp_col,1) from alltypes;

select instr(int_col, time_col,1) from alltypes;

select instr(int_col, bit_col,1) from alltypes;

select instr(int_col, varbit_col,1) from alltypes;



select instr(float_col,'cubrid') from alltypes;

select instr('cubrid',float_col,1) from alltypes;

select instr(float_col, float_col,1) from alltypes;

select instr(float_col, double_col,1) from alltypes;

select instr(float_col, smallint_col,1) from alltypes;

select instr(float_col,monetary_col,1) from alltypes;

select instr(float_col, numeric_col,1) from alltypes;

select instr(float_col, date_col,1) from alltypes;

select instr(float_col, datetime_col,1) from alltypes;

select instr(float_col, timestamp_col,1) from alltypes;

select instr(float_col, time_col,1) from alltypes;

select instr(float_col, bit_col,1) from alltypes;

select instr(float_col, varbit_col,1) from alltypes;



select instr(float_col,'cubrid') from alltypes;

select instr('cubrid',float_col,1) from alltypes;

select instr(float_col, float_col,1) from alltypes;

select instr(float_col, float_col,1) from alltypes;

select instr(float_col, smallint_col,1) from alltypes;

select instr(float_col,monetary_col,1) from alltypes;

select instr(float_col, numeric_col,1) from alltypes;

select instr(float_col, date_col,1) from alltypes;

select instr(float_col, datetime_col,1) from alltypes;

select instr(float_col, timestamp_col,1) from alltypes;

select instr(float_col, time_col,1) from alltypes;

select instr(float_col, bit_col,1) from alltypes;

select instr(float_col, varbit_col,1) from alltypes;



select instr(smallint_col,'cubrid') from alltypes;

select instr('cubrid',smallint_col,1) from alltypes;

select instr(smallint_col, float_col,1) from alltypes;

select instr(smallint_col, double_col,1) from alltypes;

select instr(smallint_col, smallint_col,1) from alltypes;

select instr(smallint_col,monetary_col,1) from alltypes;

select instr(smallint_col, numeric_col,1) from alltypes;

select instr(smallint_col, date_col,1) from alltypes;

select instr(smallint_col, datetime_col,1) from alltypes;

select instr(smallint_col, timestamp_col,1) from alltypes;

select instr(smallint_col, time_col,1) from alltypes;

select instr(smallint_col, bit_col,1) from alltypes;

select instr(smallint_col, varbit_col,1) from alltypes;



select instr(monetary_col,'cubrid') from alltypes;

select instr('cubrid',monetary_col,1) from alltypes;

select instr(monetary_col, float_col,1) from alltypes;

select instr(monetary_col, double_col,1) from alltypes;

select instr(monetary_col, smallint_col,1) from alltypes;

select instr(monetary_col,monetary_col,1) from alltypes;

select instr(monetary_col, numeric_col,1) from alltypes;

select instr(monetary_col, date_col,1) from alltypes;

select instr(monetary_col, datetime_col,1) from alltypes;

select instr(monetary_col, timestamp_col,1) from alltypes;

select instr(monetary_col, time_col,1) from alltypes;

select instr(monetary_col, bit_col,1) from alltypes;

select instr(monetary_col, varbit_col,1) from alltypes;


select instr(numeric_col,'cubrid') from alltypes;

select instr('cubrid',numeric_col,1) from alltypes;

select instr(numeric_col, float_col,1) from alltypes;

select instr(numeric_col, double_col,1) from alltypes;

select instr(numeric_col, smallint_col,1) from alltypes;

select instr(numeric_col,monetary_col,1) from alltypes;

select instr(numeric_col, numeric_col,1) from alltypes;

select instr(numeric_col, date_col,1) from alltypes;

select instr(numeric_col, datetime_col,1) from alltypes;

select instr(numeric_col, timestamp_col,1) from alltypes;

select instr(numeric_col, time_col,1) from alltypes;

select instr(numeric_col, bit_col,1) from alltypes;

select instr(numeric_col, varbit_col,1) from alltypes;



select instr(date_col,'cubrid') from alltypes;

select instr('cubrid',date_col,1) from alltypes;

select instr(date_col, float_col,1) from alltypes;

select instr(date_col, double_col,1) from alltypes;

select instr(date_col, smallint_col,1) from alltypes;

select instr(date_col,monetary_col,1) from alltypes;

select instr(date_col, numeric_col,1) from alltypes;

select instr(date_col, date_col,1) from alltypes;

select instr(date_col, datetime_col,1) from alltypes;

select instr(date_col, timestamp_col,1) from alltypes;

select instr(date_col, time_col,1) from alltypes;

select instr(date_col, bit_col,1) from alltypes;

select instr(date_col, varbit_col,1) from alltypes;



select instr(datetime_col,'cubrid') from alltypes;

select instr('cubrid',datetime_col,1) from alltypes;

select instr(datetime_col, float_col,1) from alltypes;

select instr(datetime_col, double_col,1) from alltypes;

select instr(datetime_col, smallint_col,1) from alltypes;

select instr(datetime_col,monetary_col,1) from alltypes;

select instr(datetime_col, numeric_col,1) from alltypes;

select instr(datetime_col, date_col,1) from alltypes;

select instr(datetime_col, datetime_col,1) from alltypes;

select instr(datetime_col, timestamp_col,1) from alltypes;

select instr(datetime_col, time_col,1) from alltypes;

select instr(datetime_col, bit_col,1) from alltypes;

select instr(datetime_col, varbit_col,1) from alltypes;


select instr(time_col,'cubrid') from alltypes;

select instr('cubrid',time_col,1) from alltypes;

select instr(time_col, float_col,1) from alltypes;

select instr(time_col, double_col,1) from alltypes;

select instr(time_col, smallint_col,1) from alltypes;

select instr(time_col,monetary_col,1) from alltypes;

select instr(time_col, numeric_col,1) from alltypes;

select instr(time_col, date_col,1) from alltypes;

select instr(time_col, datetime_col,1) from alltypes;

select instr(time_col, timestamp_col,1) from alltypes;

select instr(time_col, time_col,1) from alltypes;

select instr(time_col, bit_col,1) from alltypes;

select instr(time_col, varbit_col,1) from alltypes;


select instr(timestamp_col,'cubrid') from alltypes;

select instr('cubrid',timestamp_col,1) from alltypes;

select instr(timestamp_col, float_col,1) from alltypes;

select instr(timestamp_col, double_col,1) from alltypes;

select instr(timestamp_col, smallint_col,1) from alltypes;

select instr(timestamp_col,monetary_col,1) from alltypes;

select instr(timestamp_col, numeric_col,1) from alltypes;

select instr(timestamp_col, date_col,1) from alltypes;

select instr(timestamp_col, datetime_col,1) from alltypes;

select instr(timestamp_col, timestamp_col,1) from alltypes;

select instr(timestamp_col, time_col,1) from alltypes;

select instr(timestamp_col, bit_col,1) from alltypes;

select instr(timestamp_col, varbit_col,1) from alltypes;


select instr(bit_col,'cubrid') from alltypes;

select instr('cubrid',bit_col,1) from alltypes;

select instr(bit_col, float_col,1) from alltypes;

select instr(bit_col, double_col,1) from alltypes;

select instr(bit_col, smallint_col,1) from alltypes;

select instr(bit_col,monetary_col,1) from alltypes;

select instr(bit_col, numeric_col,1) from alltypes;

select instr(bit_col, date_col,1) from alltypes;

select instr(bit_col, datetime_col,1) from alltypes;

select instr(bit_col, timestamp_col,1) from alltypes;

select instr(bit_col, time_col,1) from alltypes;

select instr(bit_col, bit_col,1) from alltypes;

select instr(bit_col, varbit_col,1) from alltypes;


select instr(varbit_col,'cubrid') from alltypes;

select instr('cubrid',varbit_col,1) from alltypes;

select instr(varbit_col, float_col,1) from alltypes;

select instr(varbit_col, double_col,1) from alltypes;

select instr(varbit_col, smallint_col,1) from alltypes;

select instr(varbit_col,monetary_col,1) from alltypes;

select instr(varbit_col, numeric_col,1) from alltypes;

select instr(varbit_col, date_col,1) from alltypes;

select instr(varbit_col, datetime_col,1) from alltypes;

select instr(varbit_col, timestamp_col,1) from alltypes;

select instr(varbit_col, time_col,1) from alltypes;

select instr(varbit_col, bit_col,1) from alltypes;

select instr(varbit_col, varbit_col,1) from alltypes;

select if(instr(123.45,123,1) = instr('123.45','123',1), 'ok','nok');

select if(instr(123.45,56.7) = instr('123.45','56.7',1), 'ok','nok');

select if(instr(cast(123.45 as numeric(10,2)),'cubrid',1) = instr('123.45','cubrid',1), 'ok','nok');

select if(instr(cast(123.45 as monetary),'123',1) = instr('$123.45','123',1), 'ok','nok');

select if(instr(time'12:00:00 am',date'2010-01-01',1) = instr('12:00:00 am','2010-01-01',1),'ok','nok'));

select if(instr(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am',1) = instr('2010-01-01 12:00:00.123 am','12:00:00 am',1),'ok','nok');

select if(instr(timestamp'2010-01-01 12:00:00 am',date'1987-11-16',1) = instr('2010-01-01 12:00:00 am','1987-11-16',1),'ok','nok');

select if(instr(date'2010-01-01',b'101010',1) = instr('2010-01-01',cast(b'101010' as string),1),'ok','nok');

select if(instr(b'10101010',timestamp'2010-01-01 12:00:00 am',1) = instr(cast (b'10101010' as string),'2010-01-01 12:00:00 am',1),'ok','nok');

$varchar, $123, $varchar, $12.3
select instr(?,?) from db_root;

$varchar, $123, $varchar, $12.3
select if (instr(?,?) = instr(123,12.3), 'ok','nok') from db_root;


drop table alltypes;