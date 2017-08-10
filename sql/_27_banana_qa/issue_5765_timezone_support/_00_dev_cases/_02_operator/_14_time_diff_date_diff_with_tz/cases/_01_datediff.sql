CREATE table alltypes(
int_col INTEGER,
float_col FLOAT,
double_col DOUBLE,
smallint_col SMALLINT,
date_col DATE,
time_col time,
timestamp_col timestamptz,
datetime_col datetimetz,
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

insert into alltypes values(12345, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamptz'2010-01-01 12:34:56 am', datetimetz'2010-01-01 12:34:56.123 am',1000, 123456.7890, '2010-02-02', '2010-02-02 12:00:00 am' ,N'14:00:34 am', N'2010-03-03 09:06:03.456 am', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');



select datediff(date_col, varchar_col) from alltypes;

select datediff(date_col, varnchar_col) from alltypes;

select datediff(date_col,char_col) from alltypes;



select datediff(timestamp_col, varchar_col) from alltypes;

select datediff(timestamp_col, varnchar_col) from alltypes;

select datediff(timestamp_col,char_col) from alltypes;


select datediff(datetime_col, varchar_col) from alltypes;

select datediff(datetime_col, varnchar_col) from alltypes;

select datediff(datetime_col,char_col) from alltypes;


select datediff(varnchar_col, varchar_col) from alltypes;

select datediff(varnchar_col,char_col) from alltypes;

select datediff(char_col, varchar_col) from alltypes;

select if(datediff('2002-03-03','1990-01-01') = datediff(date'2002-03-03',date'1990-01-01'),'ok','nok');

select if(datediff('2002-03-03 12:00:00 am','1990-01-01 11:59:59 pm') = datediff(timestamptz'2002-03-03 12:00:00 am',timestamptz'1990-01-01 11:59:59 pm'),'ok','nok');

select if(datediff('2002-03-03 12:00:00.001 am','1990-01-01 11:59:59.002 pm') = datediff(datetimetz'2002-03-03 12:00:00 am',datetimetz'1990-01-01 11:59:59 pm'),'ok','nok');

$varchar, $2002-03-03, $varchar, $2001-02-02
select datediff(?,?) from db_root;

$varchar, $2002-03-03, $varchar, $2001-02-02
select if (datediff(?,?) = datediff('2002-03-03','2001-02-02'), 'ok','nok') from db_root;

drop table alltypes;


