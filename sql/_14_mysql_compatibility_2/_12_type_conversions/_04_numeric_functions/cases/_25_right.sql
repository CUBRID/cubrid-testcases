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

insert into alltypes values(12, 1.4, 2.367, 2, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.2 am',2, 6.7890, '2', '1.4' ,N'1.4', N'2', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '2', '2');


select right(monetary_col,10.23) from alltypes;

select right(10.23,monetary_col) from alltypes;

select right(monetary_col,monetary_col) from alltypes;

select right(monetary_col,char_col) from alltypes;

select right(monetary_col,varchar_col) from alltypes;

select right(monetary_col,nchar_col) from alltypes;

select right(monetary_col,varnchar_col) from alltypes;


select right(numeric_col,10.23) from alltypes;

select right(10.23,numeric_col) from alltypes;

select right(numeric_col,char_col) from alltypes;

select right(numeric_col,varchar_col) from alltypes;

select right(numeric_col,nchar_col) from alltypes;

select right(numeric_col,varnchar_col) from alltypes;

select right(numeric_col,numeric_col) from alltypes;


select right(char_col,10.23) from alltypes;

select right(10.23,char_col) from alltypes;

select right(char_col,char_col) from alltypes;

select right(char_col,monetary_col) from alltypes;

select right(char_col,numeric_col) from alltypes;

select right(char_col,varchar_col) from alltypes;

select right(char_col,nchar_col) from alltypes;

select right(char_col,varnchar_col) from alltypes;


select right(varchar_col,10.23) from alltypes;

select right(10.23,varchar_col) from alltypes;

select right(varchar_col,varchar_col) from alltypes;

select right(varchar_col,monetary_col) from alltypes;

select right(varchar_col,numeric_col) from alltypes;

select right(varchar_col,varchar_col) from alltypes;

select right(varchar_col,nchar_col) from alltypes;

select right(varchar_col,varnchar_col) from alltypes;


select right(nchar_col,10.23) from alltypes;

select right(10.23,nchar_col) from alltypes;

select right(nchar_col,monetary_col) from alltypes;

select right(nchar_col,numeric_col) from alltypes;

select right(nchar_col,varchar_col) from alltypes;

select right(nchar_col,nchar_col) from alltypes;

select right(nchar_col,varnchar_col) from alltypes;


select right(varnchar_col,10.23) from alltypes;

select right(10.23,varnchar_col) from alltypes;

select right(varnchar_col,monetary_col) from alltypes;

select right(varnchar_col,numeric_col) from alltypes;

select right(varnchar_col,varchar_col) from alltypes;

select right(varnchar_col,nchar_col) from alltypes;

select right(varnchar_col,varnchar_col) from alltypes;


select if(right('2','10.5') = right(2,10.5), 'ok','nok');

select if(right('1.4',N'10.5') = right(1.4,10.5), 'ok','nok');

select if(right(N'2',N'10.5') = right(2,10.5),'ok','nok');

select if(right(N'1.4','10.5') = right(1.4,10.5),'ok','nok');

$varchar, $2, $varchar, $12.3
select right(?,?) from db_root;

$varchar, $2, $varchar, $12.3
select if (right(?,?) = right(2,12.3), 'ok','nok') from db_root;

drop table alltypes;



