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

select char_length(int_col) from alltypes;

select char_length(float_col) from alltypes;

select char_length(double_col) from alltypes;

select char_length(smallint_col) from alltypes;

select char_length(monetary_col) from alltypes;

select char_length(numeric_col) from alltypes;

select char_length(date_col) from alltypes;

select char_length(datetime_col) from alltypes;

select char_length(time_col) from alltypes;

select char_length(timestamp_col) from alltypes;

select char_length(bit_col) from alltypes;

select char_length(varbit_col) from alltypes;



select if(char_length(123) = char_length(123), 'ok','nok');

select if(char_length(123.45) = char_length('123.45'), 'ok','nok');

select if(char_length(cast(123.45 as numeric(10,2))) = char_length('123.45'), 'ok','nok');

select if(char_length(cast(123.45 as monetary)) = char_length('$123.45'), 'ok','nok');

select if(char_length(date'2010-01-01') = char_length('2010-01-01'),'ok','nok');

select if(char_length(datetime'2010-01-01 12:00:00.123 am') = char_length('2010-01-01 12:00:00.123 am'),'ok','nok');

select if(char_length(timestamp'2010-01-01 12:00:00 am') = char_length('2010-01-01 12:00:00 am'),'ok','nok');

select if(char_length(time'12:00:00 am') = char_length('12:00:00 am'),'ok','nok');

select if(char_length(b'10101010') = char_length(cast (b'10101010' as string)),'ok','nok');

$varchar, $0.123
select char_length(?) from db_root;

$varchar, $-0.123
select if (char_length(?) = char_length(-0.123), 'ok','nok') from db_root;

drop table alltypes;