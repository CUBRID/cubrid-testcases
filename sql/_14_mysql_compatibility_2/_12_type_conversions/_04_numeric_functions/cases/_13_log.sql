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

insert into alltypes values(12345, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1000, 123456.7890, '123', '123' ,N'3', N'2', b'01010101', b'111111111', {1,2,3,4,5} , {6,7,8,9}, {0,'a','b','c',13,14,15}, '123', '123');



select log(monetary_col,monetary_col) from alltypes;

select log(numeric_col,monetary_col) from alltypes;

select log(char_col,monetary_col) from alltypes;

select log(varchar_col,monetary_col) from alltypes;

select log(nchar_col,monetary_col) from alltypes;

select log(varnchar_col, monetary_col) from alltypes;


select log(monetary_col,numeric_col) from alltypes;

select log(numeric_col,numeric_col) from alltypes;

select log(char_col,numeric_col) from alltypes;

select log(varchar_col,numeric_col) from alltypes;

select log(nchar_col,numeric_col) from alltypes;

select log(varnchar_col, numeric_col) from alltypes;


select log(monetary_col,char_col) from alltypes;

select log(char_col,char_col) from alltypes;

select log(numeric_col,char_col) from alltypes;

select log(varchar_col,char_col) from alltypes;

select log(nchar_col,char_col) from alltypes;

select log(varnchar_col, char_col) from alltypes;


select log(monetary_col,varchar_col) from alltypes;

select log(varchar_col,varchar_col) from alltypes;

select log(char_col,varchar_col) from alltypes;

select log(numeric_col,varchar_col) from alltypes;

select log(nchar_col,varchar_col) from alltypes;

select log(varnchar_col, varchar_col) from alltypes;


select log(monetary_col,nchar_col) from alltypes;

select log(nchar_col,nchar_col) from alltypes;

select log(char_col,nchar_col) from alltypes;

select log(varchar_col,nchar_col) from alltypes;

select log(numeric_col,nchar_col) from alltypes;

select log(varnchar_col, nchar_col) from alltypes;


select log(monetary_col,varnchar_col) from alltypes;

select log(varnchar_col,varnchar_col) from alltypes;

select log(char_col,varnchar_col) from alltypes;

select log(varchar_col,varnchar_col) from alltypes;

select log(nchar_col,varnchar_col) from alltypes;

select log(numeric_col, varnchar_col) from alltypes;
select if(log('123',2) = log(123,2), 'ok','nok');

select if(log('123.45','2') = log(123.45,2), 'ok','nok');

select if(log(N'123',N'2') = log(123,2),'ok','nok');

$varchar, $123
select log(?,2) from db_root;

$varchar, $123 , $varchar, $3
select if (log(?,?) = log(123,3), 'ok','nok') from db_root;

select log(date'2010-01-01',2);

select log('2010-01-01',2);
drop table alltypes;



