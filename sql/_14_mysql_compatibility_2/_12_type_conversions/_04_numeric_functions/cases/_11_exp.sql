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

insert into alltypes values(1, 4.5, 1.1, 5, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',10, 10, '5', '4.5' ,N'4.5', N'5', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '5', '5');


select if(exp(monetary_col) - exp($10.00)<0.01, 'ok', 'nok') from alltypes;

select if(exp(numeric_col) - exp(10.0000)<0.01, 'ok', 'nok') from alltypes;

select if(exp(char_col) - exp('5')<0.01, 'ok', 'nok') from alltypes;

select if(exp(varchar_col) - exp('4.5')<0.01, 'ok', 'nok') from alltypes;

select if(exp(nchar_col) - exp(N'4.5')<0.01, 'ok', 'nok') from alltypes;

select if(exp(varnchar_col) - exp( N'5')<0.01, 'ok', 'nok') from alltypes;

select if(exp('123') = exp(123), 'ok','nok');

select if(exp('123.45') = exp(123.45), 'ok','nok');

select if(exp(N'123') = exp(123),'ok','nok');

select if(exp(N'123.45') = exp(123.45),'ok','nok');

$varchar, $0.123
select exp(?) from db_root;

$varchar, $-0.123
select if (exp(?) = exp(-0.123), 'ok','nok') from db_root;

select exp(date'2010-01-01');

select exp('2010-01-01');
drop table alltypes;





