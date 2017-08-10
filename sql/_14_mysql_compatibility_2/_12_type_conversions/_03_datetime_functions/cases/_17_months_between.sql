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
insert into alltypes values(12345, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1000, 123456.7890, '2010-02-02', '2010-02-02 12:00:00 am' ,N'14:00:34 am', N'2010-03-03 09:06:03.456 am', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');



select months_between(date_col, varchar_col) from alltypes;

select months_between(date_col, varnchar_col) from alltypes;

select months_between(date_col,char_col) from alltypes;



select months_between(timestamp_col, varchar_col) from alltypes;

select months_between(timestamp_col, varnchar_col) from alltypes;

select months_between(timestamp_col,char_col) from alltypes;


select months_between(datetime_col, varchar_col) from alltypes;

select months_between(datetime_col, varnchar_col) from alltypes;

select months_between(datetime_col,char_col) from alltypes;


select months_between(varnchar_col, varchar_col) from alltypes;

select months_between(varnchar_col,char_col) from alltypes;

select months_between(char_col, varchar_col) from alltypes;

select if(months_between('2002-03-03','1990-01-01') = months_between(date'2002-03-03',date'1990-01-01'),'ok','nok');

select if(months_between('2002-03-03 12:00:00 am','1990-01-01 11:59:59 pm') = months_between(timestamp'2002-03-03 12:00:00 am',timestamp'1990-01-01 11:59:59 pm'),'ok','nok');

select if(months_between('2002-03-03 12:00:00.001 am','1990-01-01 11:59:59.002 pm') = months_between(datetime'2002-03-03 12:00:00 am',datetime'1990-01-01 11:59:59 pm'),'ok','nok');

$varchar, $2002-03-03, $varchar, $2001-02-02
select months_between(?,?) from db_root;

$varchar, $2002-03-03, $varchar, $2001-02-02
select if (months_between(?,?) = months_between('2002-03-03','2001-02-02'), 'ok','nok') from db_root;

drop table alltypes;


