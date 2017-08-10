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

insert into alltypes values(1, 1.1, 1.1, 1, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am', 1, 1.1, '1', '1.1' ,N'1.1', N'1', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');

select repeat(int_col,2) from alltypes;

select repeat('cubrid',int_col) from alltypes;

select repeat(int_col, float_col) from alltypes;

select repeat(int_col, double_col) from alltypes;

select repeat(int_col, smallint_col) from alltypes;

select repeat(int_col,monetary_col) from alltypes;

select repeat(int_col, numeric_col) from alltypes;

select repeat(int_col, bit_col) from alltypes;

select repeat(int_col, varbit_col) from alltypes;



select repeat(float_col,2) from alltypes;

select repeat('cubrid',float_col) from alltypes;

select repeat(float_col, float_col) from alltypes;

select repeat(float_col, double_col) from alltypes;

select repeat(float_col, smallint_col) from alltypes;

select repeat(float_col,monetary_col) from alltypes;

select repeat(float_col, numeric_col) from alltypes;

select repeat(float_col, bit_col) from alltypes;

select repeat(float_col, varbit_col) from alltypes;



select repeat(float_col,2) from alltypes;

select repeat('cubrid',float_col) from alltypes;

select repeat(float_col, float_col) from alltypes;

select repeat(float_col, float_col) from alltypes;

select repeat(float_col, smallint_col) from alltypes;

select repeat(float_col,monetary_col) from alltypes;

select repeat(float_col, numeric_col) from alltypes;

select repeat(float_col, bit_col) from alltypes;

select repeat(float_col, varbit_col) from alltypes;



select repeat(smallint_col,2) from alltypes;

select repeat('cubrid',smallint_col) from alltypes;

select repeat(smallint_col, float_col) from alltypes;

select repeat(smallint_col, double_col) from alltypes;

select repeat(smallint_col, smallint_col) from alltypes;

select repeat(smallint_col,monetary_col) from alltypes;

select repeat(smallint_col, numeric_col) from alltypes;

select repeat(smallint_col, bit_col) from alltypes;

select repeat(smallint_col, varbit_col) from alltypes;



select repeat(monetary_col,2) from alltypes;

select repeat('cubrid',monetary_col) from alltypes;

select repeat(monetary_col, float_col) from alltypes;

select repeat(monetary_col, double_col) from alltypes;

select repeat(monetary_col, smallint_col) from alltypes;

select repeat(monetary_col,monetary_col) from alltypes;

select repeat(monetary_col, numeric_col) from alltypes;

select repeat(monetary_col, bit_col) from alltypes;

select repeat(monetary_col, varbit_col) from alltypes;


select repeat(numeric_col,2) from alltypes;

select repeat('cubrid',numeric_col) from alltypes;

select repeat(numeric_col, float_col) from alltypes;

select repeat(numeric_col, double_col) from alltypes;

select repeat(numeric_col, smallint_col) from alltypes;

select repeat(numeric_col,monetary_col) from alltypes;

select repeat(numeric_col, numeric_col) from alltypes;

select repeat(numeric_col, bit_col) from alltypes;

select repeat(numeric_col, varbit_col) from alltypes;



select repeat(date_col,2) from alltypes;

select repeat(date_col, float_col) from alltypes;

select repeat(date_col, double_col) from alltypes;

select repeat(date_col, smallint_col) from alltypes;

select repeat(date_col,monetary_col) from alltypes;

select repeat(date_col, numeric_col) from alltypes;

select repeat(date_col, bit_col) from alltypes;

select repeat(date_col, varbit_col) from alltypes;



select repeat(datetime_col,2) from alltypes;

select repeat(datetime_col, float_col) from alltypes;

select repeat(datetime_col, double_col) from alltypes;

select repeat(datetime_col, smallint_col) from alltypes;

select repeat(datetime_col,monetary_col) from alltypes;

select repeat(datetime_col, numeric_col) from alltypes;

select repeat(datetime_col, bit_col) from alltypes;

select repeat(datetime_col, varbit_col) from alltypes;


select repeat(time_col,2) from alltypes;

select repeat(time_col, float_col) from alltypes;

select repeat(time_col, double_col) from alltypes;

select repeat(time_col, smallint_col) from alltypes;

select repeat(time_col,monetary_col) from alltypes;

select repeat(time_col, numeric_col) from alltypes;

select repeat(time_col, bit_col) from alltypes;

select repeat(time_col, varbit_col) from alltypes;


select repeat(timestamp_col,2) from alltypes;

select repeat(timestamp_col, float_col) from alltypes;

select repeat(timestamp_col, double_col) from alltypes;

select repeat(timestamp_col, smallint_col) from alltypes;

select repeat(timestamp_col,monetary_col) from alltypes;

select repeat(timestamp_col, numeric_col) from alltypes;

select repeat(timestamp_col, bit_col) from alltypes;

select repeat(timestamp_col, varbit_col) from alltypes;


select repeat(bit_col,2) from alltypes;

select repeat('cubrid',bit_col) from alltypes;

select repeat(bit_col, float_col) from alltypes;

select repeat(bit_col, double_col) from alltypes;

select repeat(bit_col, smallint_col) from alltypes;

select repeat(bit_col,monetary_col) from alltypes;

select repeat(bit_col, numeric_col) from alltypes;

select repeat(bit_col, bit_col) from alltypes;

select repeat(bit_col, varbit_col) from alltypes;


select repeat(varbit_col,2) from alltypes;

select repeat('cubrid',varbit_col) from alltypes;

select repeat(varbit_col, float_col) from alltypes;

select repeat(varbit_col, double_col) from alltypes;

select repeat(varbit_col, smallint_col) from alltypes;

select repeat(varbit_col,monetary_col) from alltypes;

select repeat(varbit_col, numeric_col) from alltypes;

select repeat(varbit_col, bit_col) from alltypes;

select repeat(varbit_col, varbit_col) from alltypes;




select if(repeat(123,123.45) = repeat('123','123.45'), 'ok','nok');

select if(repeat(123.45,56.7) = repeat('123.45','56.7'), 'ok','nok');

select if(repeat(cast(123.45 as numeric(10,2)),2) = repeat('123.45','2'), 'ok','nok');

select if(repeat(cast(123.45 as monetary),'2') = repeat('$123.45','2'), 'ok','nok');

select if(repeat(time'12:00:00 am',2) = repeat(cast(time'12:00:00 am' as varchar),'2'),'ok','nok');

select if(repeat(datetime'2010-01-01 12:00:00.123 am','2') = repeat(cast(datetime'2010-01-01 12:00:00.123 am' as varchar),2),'ok','nok');

select if(repeat(timestamp'2010-01-01 12:00:00 am',2) = repeat(cast(timestamp'2010-01-01 12:00:00 am' as varchar),'2'),'ok','nok');

select if(repeat(b'10101010',2) = repeat(cast (b'10101010' as string),'2'),'ok','nok');

$varchar, $123, $varchar, $2
select repeat(?,?) from db_root;

$varchar, $123, $varchar, $2
select if (repeat(?,?) = repeat(123,2), 'ok','nok') from db_root;

drop table alltypes;
