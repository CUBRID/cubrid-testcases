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


select (int_col = varchar_col) from alltypes;

select (int_col = varnchar_col) from alltypes;

select (int_col = char_col) from alltypes;

select (int_col = nchar_col) from alltypes;


select (float_col = varchar_col) from alltypes;

select (float_col = varnchar_col) from alltypes;

select (float_col = char_col) from alltypes;

select (float_col = nchar_col) from alltypes;


select (double_col = varchar_col) from alltypes;

select (double_col = varnchar_col) from alltypes;

select (double_col = char_col) from alltypes;

select (double_col = nchar_col) from alltypes;


select (varnchar_col = varchar_col) from alltypes;

select (varnchar_col = char_col) from alltypes;

select (char_col = varchar_col) from alltypes;


select if(('123' = '456.56') = (123 = 456.56) ,'ok','nok');

select if((N'123' = 456.56) = (123 = 456.56) ,'ok','nok');

select if((N'123' = N'456.56') = (123 = 456.56) ,'ok','nok');

select select if('1' = 1, 'ok', 'nok') from db_root;

select if ('2010-01-01' = date'2010-01-01', 'ok', 'nok') from db_root;

select if({1,2,3} = {1,2,3}, 'ok', 'nok') from db_root;

select if ({'1',2,3} != {1,2,3}, 'nok', 'ok') from db_root;

$char, $2010-01-01
select if(? = date'2010-01-01', 'ok', 'nok') from db_root;

$char, $1

select if(? = 1, 'ok', 'nok') from db_root;

create table t (s1 string, s2 string);
insert into t values('1','2010-01-01');
insert into t values('2','2010-01-02');
insert into t values('3','2010-01-03');

select (s1 = 1 and  s2 = date'2010-01-01') from t order by s1, s2;
select * from t where s1 = 2;
select * from t where s2 = '2010-01-03';

drop table t;

$varchar, $5, $varchar, $5
select (? = ?) from db_root;

$varchar, $5, $varchar, $5
select if ((? = ?) = (5 = 5), 'ok','nok') from db_root;

drop table alltypes;


