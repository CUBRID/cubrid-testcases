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

select reverse(int_col) from alltypes;

select reverse(float_col) from alltypes;

select reverse(double_col) from alltypes;

select reverse(smallint_col) from alltypes;

select reverse(monetary_col) from alltypes;

select reverse(numeric_col) from alltypes;

select reverse(date_col) from alltypes;

select reverse(datetime_col) from alltypes;

select reverse(time_col) from alltypes;

select reverse(timestamp_col) from alltypes;

select reverse(bit_col) from alltypes;

select reverse(varbit_col) from alltypes;



select if(reverse(123) = reverse(123), 'ok','nok');

select if(reverse(123.45) = reverse('123.45'), 'ok','nok');

select if(reverse(cast(123.45 as numeric(10,2))) = reverse('123.45'), 'ok','nok');

select if(reverse(cast(123.45 as monetary)) = reverse('$123.45'), 'ok','nok');

select if(reverse(date'2010-01-01') = reverse(cast(date'2010-01-01' as varchar)),'ok','nok');

select if(reverse(datetime'2010-01-01 12:00:00.123 am') = reverse(cast(datetime'2010-01-01 12:00:00.123 am' as varchar)),'ok','nok');

select if(reverse(timestamp'2010-01-01 12:00:00 am') = reverse(cast(timestamp'2010-01-01 12:00:00 am' as varchar)),'ok','nok');

select if(reverse(time'12:00:00 am') = reverse(cast(time'12:00:00 am' as varchar)),'ok','nok');

select if(reverse(b'10101010') = reverse(cast (b'10101010' as string)),'ok','nok');

$varchar, $0.123
select reverse(?) from db_root;

$varchar, $-0.123
select if (reverse(?) = reverse(-0.123), 'ok','nok') from db_root;

drop table alltypes;