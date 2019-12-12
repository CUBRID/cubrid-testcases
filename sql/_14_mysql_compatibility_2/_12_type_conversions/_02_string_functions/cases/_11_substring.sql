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

select substring(int_col,2) from alltypes;

select substring('cubrid',int_col) from alltypes;

select substring(int_col, float_col) from alltypes;

select substring(int_col, double_col) from alltypes;

select substring(int_col, smallint_col) from alltypes;

select substring(int_col,monetary_col) from alltypes;

select substring(int_col, numeric_col) from alltypes;

select substring(int_col, bit_col) from alltypes;

select substring(int_col, varbit_col) from alltypes;



select substring(float_col,2) from alltypes;

select substring('cubrid',float_col) from alltypes;

select substring(float_col, float_col) from alltypes;

select substring(float_col, double_col) from alltypes;

select substring(float_col, smallint_col) from alltypes;

select substring(float_col,monetary_col) from alltypes;

select substring(float_col, numeric_col) from alltypes;

select substring(float_col, bit_col) from alltypes;

select substring(float_col, varbit_col) from alltypes;



select substring(float_col,2) from alltypes;

select substring('cubrid',float_col) from alltypes;

select substring(float_col, float_col) from alltypes;

select substring(float_col, float_col) from alltypes;

select substring(float_col, smallint_col) from alltypes;

select substring(float_col,monetary_col) from alltypes;

select substring(float_col, numeric_col) from alltypes;

select substring(float_col, bit_col) from alltypes;

select substring(float_col, varbit_col) from alltypes;



select substring(smallint_col,2) from alltypes;

select substring('cubrid',smallint_col) from alltypes;

select substring(smallint_col, float_col) from alltypes;

select substring(smallint_col, double_col) from alltypes;

select substring(smallint_col, smallint_col) from alltypes;

select substring(smallint_col,monetary_col) from alltypes;

select substring(smallint_col, numeric_col) from alltypes;

select substring(smallint_col, bit_col) from alltypes;

select substring(smallint_col, varbit_col) from alltypes;



select substring(monetary_col,2) from alltypes;

select substring('cubrid',monetary_col) from alltypes;

select substring(monetary_col, float_col) from alltypes;

select substring(monetary_col, double_col) from alltypes;

select substring(monetary_col, smallint_col) from alltypes;

select substring(monetary_col,monetary_col) from alltypes;

select substring(monetary_col, numeric_col) from alltypes;

select substring(monetary_col, bit_col) from alltypes;

select substring(monetary_col, varbit_col) from alltypes;


select substring(numeric_col,2) from alltypes;

select substring('cubrid',numeric_col) from alltypes;

select substring(numeric_col, float_col) from alltypes;

select substring(numeric_col, double_col) from alltypes;

select substring(numeric_col, smallint_col) from alltypes;

select substring(numeric_col,monetary_col) from alltypes;

select substring(numeric_col, numeric_col) from alltypes;

select substring(numeric_col, bit_col) from alltypes;

select substring(numeric_col, varbit_col) from alltypes;



select substring(date_col,2) from alltypes;

select substring(date_col, float_col) from alltypes;

select substring(date_col, double_col) from alltypes;

select substring(date_col, smallint_col) from alltypes;

select substring(date_col,monetary_col) from alltypes;

select substring(date_col, numeric_col) from alltypes;

select substring(date_col, bit_col) from alltypes;

select substring(date_col, varbit_col) from alltypes;



select substring(datetime_col,2) from alltypes;

select substring(datetime_col, float_col) from alltypes;

select substring(datetime_col, double_col) from alltypes;

select substring(datetime_col, smallint_col) from alltypes;

select substring(datetime_col,monetary_col) from alltypes;

select substring(datetime_col, numeric_col) from alltypes;

select substring(datetime_col, bit_col) from alltypes;

select substring(datetime_col, varbit_col) from alltypes;


select substring(time_col,2) from alltypes;

select substring(time_col, float_col) from alltypes;

select substring(time_col, double_col) from alltypes;

select substring(time_col, smallint_col) from alltypes;

select substring(time_col,monetary_col) from alltypes;

select substring(time_col, numeric_col) from alltypes;

select substring(time_col, bit_col) from alltypes;

select substring(time_col, varbit_col) from alltypes;


select substring(timestamp_col,2) from alltypes;

select substring(timestamp_col, float_col) from alltypes;

select substring(timestamp_col, double_col) from alltypes;

select substring(timestamp_col, smallint_col) from alltypes;

select substring(timestamp_col,monetary_col) from alltypes;

select substring(timestamp_col, numeric_col) from alltypes;

select substring(timestamp_col, bit_col) from alltypes;

select substring(timestamp_col, varbit_col) from alltypes;


select substring(bit_col,2) from alltypes;

select substring('cubrid',bit_col) from alltypes;

select substring(bit_col, float_col) from alltypes;

select substring(bit_col, double_col) from alltypes;

select substring(bit_col, smallint_col) from alltypes;

select substring(bit_col,monetary_col) from alltypes;

select substring(bit_col, numeric_col) from alltypes;

select substring(bit_col, bit_col) from alltypes;

select substring(bit_col, varbit_col) from alltypes;


select substring(varbit_col,2) from alltypes;

select substring('cubrid',varbit_col) from alltypes;

select substring(varbit_col, float_col) from alltypes;

select substring(varbit_col, double_col) from alltypes;

select substring(varbit_col, smallint_col) from alltypes;

select substring(varbit_col,monetary_col) from alltypes;

select substring(varbit_col, numeric_col) from alltypes;

select substring(varbit_col, bit_col) from alltypes;

select substring(varbit_col, varbit_col) from alltypes;




select if(substring(123,123.45) = substring('123','123.45'), 'ok','nok');

select if(substring(123.45,56.7) = substring('123.45','56.7'), 'ok','nok');

select if(substring(cast(123.45 as numeric(10,2)),2) = substring('123.45','2'), 'ok','nok');

select if(substring(cast(123.45 as monetary),'2') = substring('$123.45','2'), 'ok','nok');

select if(substring(time'12:00:00 am',2) = substring(cast(time'12:00:00 am' as varchar),'2'),'ok','nok');

select if(substring(datetime'2010-01-01 12:00:00.123 am','2') = substring(cast(datetime'2010-01-01 12:00:00.123 am' as varchar),2),'ok','nok');

select if(substring(timestamp'2010-01-01 12:00:00 am',2) = substring(cast(timestamp'2010-01-01 12:00:00 am' as varchar),'2'),'ok','nok');

select if(substring(b'10101010',2) = substring(cast (b'10101010' as string),'2'),'ok','nok');

$varchar, $123, $varchar, $2
select substring(?,?) from db_root;

$varchar, $123, $varchar, $2
select if (substring(?,?) = substring(123,2), 'ok','nok') from db_root;

drop table alltypes;
