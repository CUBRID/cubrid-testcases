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


select floor(monetary_col) from alltypes;

select floor(numeric_col) from alltypes;

select floor(char_col) from alltypes;

select floor(varchar_col) from alltypes;

select floor(nchar_col) from alltypes;

select floor(varnchar_col) from alltypes;

select if(floor('123') = floor(123), 'ok','nok');

select if(floor('123.45') = floor(123.45), 'ok','nok');

select if(floor(N'123') = floor(123),'ok','nok');

select if(floor(N'123.45') = floor(123.45),'ok','nok');

$varchar, $0.123
select floor(?) from db_root;

$varchar, $-0.123
select if (floor(?) = floor(-0.123), 'ok','nok') from db_root;

select floor(date'2010-01-01');

select floor('2010-01-01');

drop table alltypes;



