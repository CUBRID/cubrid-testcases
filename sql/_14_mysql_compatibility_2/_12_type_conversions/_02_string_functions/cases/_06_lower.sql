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

select lower(int_col) from alltypes;

select lower(float_col) from alltypes;

select lower(double_col) from alltypes;

select lower(smallint_col) from alltypes;

select lower(monetary_col) from alltypes;

select lower(numeric_col) from alltypes;

select lower(date_col) from alltypes;

select lower(datetime_col) from alltypes;

select lower(time_col) from alltypes;

select lower(timestamp_col) from alltypes;

select lower(bit_col) from alltypes;

select lower(varbit_col) from alltypes;



select if(lower(123) = lower(123), 'ok','nok');

select if(lower(123.45) = lower('123.45'), 'ok','nok');

select if(lower(cast(123.45 as numeric(10,2))) = lower('123.45'), 'ok','nok');

select if(lower(cast(123.45 as monetary)) = lower('$123.45'), 'ok','nok');

select if(lower(date'2010-01-01') = lower('01/01/2010'),'ok','nok');

select if(lower(datetime'2010-01-01 12:00:00.123 am') = lower('01/01/2010 12:00:00.123 am'),'ok','nok');

select if(lower(timestamp'2010-01-01 12:00:00 am') = lower('12:00:00 am 01/01/2010'),'ok','nok');

select if(lower(time'12:00:00 am') = lower('12:00:00 am'),'ok','nok');

select if(lower(b'10101010') = lower(cast (b'10101010' as string)),'ok','nok');

$int, $123
select lower(?) from db_root;

$int, $123
select if (lower(?) = lower('123'), 'ok','nok') from db_root;


drop table alltypes;
