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


select (int_col < varchar_col) from alltypes;

select (int_col < varnchar_col) from alltypes;

select (int_col < char_col) from alltypes;

select (int_col < nchar_col) from alltypes;


select (float_col < varchar_col) from alltypes;

select (float_col < varnchar_col) from alltypes;

select (float_col < char_col) from alltypes;

select (float_col < nchar_col) from alltypes;


select (double_col < varchar_col) from alltypes;

select (double_col < varnchar_col) from alltypes;

select (double_col < char_col) from alltypes;

select (double_col < nchar_col) from alltypes;


select (varnchar_col < varchar_col) from alltypes;

select (varnchar_col < char_col) from alltypes;

select (char_col < varchar_col) from alltypes;


select if(('123' < '456.56') = (123 < 456.56) ,'ok','nok');

select if((N'123' < 456.56) = (123 < 456.56) ,'ok','nok');

select if((N'123' < N'456.56') = (123 < 456.56) ,'ok','nok');

$varchar, $5, $varchar, $7
select (? < ?) from db_root;

$varchar, $5, $varchar, $7
select if ((? < ?) = (5 < 7), 'ok','nok') from db_root;

drop table alltypes;


