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

select lpad(int_col,'12',1) from alltypes;

select lpad('123456789',30,int_col) from alltypes;

select lpad(int_col,30 , float_col) from alltypes;

select lpad(int_col,30 , double_col) from alltypes;

select lpad(int_col,30 , smallint_col) from alltypes;

select lpad(int_col,30 ,monetary_col) from alltypes;

select lpad(int_col,30 , numeric_col) from alltypes;

select lpad(int_col,30 , date_col) from alltypes;

select lpad(int_col,30 , datetime_col) from alltypes;

select lpad(int_col,30 , timestamp_col) from alltypes;

select lpad(int_col,30 , time_col) from alltypes;

select lpad(int_col,30 , bit_col) from alltypes;

select lpad(int_col,30 , varbit_col) from alltypes;



select lpad(float_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,float_col) from alltypes;

select lpad(float_col,30 , float_col) from alltypes;

select lpad(float_col,30 , double_col) from alltypes;

select lpad(float_col,30 , smallint_col) from alltypes;

select lpad(float_col,30 ,monetary_col) from alltypes;

select lpad(float_col,30 , numeric_col) from alltypes;

select lpad(float_col,30 , date_col) from alltypes;

select lpad(float_col,30 , datetime_col) from alltypes;

select lpad(float_col,30 , timestamp_col) from alltypes;

select lpad(float_col,30 , time_col) from alltypes;

select lpad(float_col,30 , bit_col) from alltypes;

select lpad(float_col,30 , varbit_col) from alltypes;



select lpad(float_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,float_col) from alltypes;

select lpad(float_col,30 , float_col) from alltypes;

select lpad(float_col,30 , float_col) from alltypes;

select lpad(float_col,30 , smallint_col) from alltypes;

select lpad(float_col,30 ,monetary_col) from alltypes;

select lpad(float_col,30 , numeric_col) from alltypes;

select lpad(float_col,30 , date_col) from alltypes;

select lpad(float_col,30 , datetime_col) from alltypes;

select lpad(float_col,30 , timestamp_col) from alltypes;

select lpad(float_col,30 , time_col) from alltypes;

select lpad(float_col,30 , bit_col) from alltypes;

select lpad(float_col,30 , varbit_col) from alltypes;



select lpad(smallint_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,smallint_col) from alltypes;

select lpad(smallint_col,30 , float_col) from alltypes;

select lpad(smallint_col,30 , double_col) from alltypes;

select lpad(smallint_col,30 , smallint_col) from alltypes;

select lpad(smallint_col,30 ,monetary_col) from alltypes;

select lpad(smallint_col,30 , numeric_col) from alltypes;

select lpad(smallint_col,30 , date_col) from alltypes;

select lpad(smallint_col,30 , datetime_col) from alltypes;

select lpad(smallint_col,30 , timestamp_col) from alltypes;

select lpad(smallint_col,30 , time_col) from alltypes;

select lpad(smallint_col,30 , bit_col) from alltypes;

select lpad(smallint_col,30 , varbit_col) from alltypes;



select lpad(monetary_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,monetary_col) from alltypes;

select lpad(monetary_col,30 , float_col) from alltypes;

select lpad(monetary_col,30 , double_col) from alltypes;

select lpad(monetary_col,30 , smallint_col) from alltypes;

select lpad(monetary_col,30 ,monetary_col) from alltypes;

select lpad(monetary_col,30 , numeric_col) from alltypes;

select lpad(monetary_col,30 , date_col) from alltypes;

select lpad(monetary_col,30 , datetime_col) from alltypes;

select lpad(monetary_col,30 , timestamp_col) from alltypes;

select lpad(monetary_col,30 , time_col) from alltypes;

select lpad(monetary_col,30 , bit_col) from alltypes;

select lpad(monetary_col,30 , varbit_col) from alltypes;


select lpad(numeric_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,numeric_col) from alltypes;

select lpad(numeric_col,30 , float_col) from alltypes;

select lpad(numeric_col,30 , double_col) from alltypes;

select lpad(numeric_col,30 , smallint_col) from alltypes;

select lpad(numeric_col,30 ,monetary_col) from alltypes;

select lpad(numeric_col,30 , numeric_col) from alltypes;

select lpad(numeric_col,30 , date_col) from alltypes;

select lpad(numeric_col,30 , datetime_col) from alltypes;

select lpad(numeric_col,30 , timestamp_col) from alltypes;

select lpad(numeric_col,30 , time_col) from alltypes;

select lpad(numeric_col,30 , bit_col) from alltypes;

select lpad(numeric_col,30 , varbit_col) from alltypes;



select lpad(date_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,date_col) from alltypes;

select lpad(date_col,30 , float_col) from alltypes;

select lpad(date_col,30 , double_col) from alltypes;

select lpad(date_col,30 , smallint_col) from alltypes;

select lpad(date_col,30 ,monetary_col) from alltypes;

select lpad(date_col,30 , numeric_col) from alltypes;

select lpad(date_col,30 , date_col) from alltypes;

select lpad(date_col,30 , datetime_col) from alltypes;

select lpad(date_col,30 , timestamp_col) from alltypes;

select lpad(date_col,30 , time_col) from alltypes;

select lpad(date_col,30 , bit_col) from alltypes;

select lpad(date_col,30 , varbit_col) from alltypes;



select lpad(datetime_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,datetime_col) from alltypes;

select lpad(datetime_col,30 , float_col) from alltypes;

select lpad(datetime_col,30 , double_col) from alltypes;

select lpad(datetime_col,30 , smallint_col) from alltypes;

select lpad(datetime_col,30 ,monetary_col) from alltypes;

select lpad(datetime_col,30 , numeric_col) from alltypes;

select lpad(datetime_col,30 , date_col) from alltypes;

select lpad(datetime_col,30 , datetime_col) from alltypes;

select lpad(datetime_col,30 , timestamp_col) from alltypes;

select lpad(datetime_col,30 , time_col) from alltypes;

select lpad(datetime_col,30 , bit_col) from alltypes;

select lpad(datetime_col,30 , varbit_col) from alltypes;


select lpad(time_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,time_col) from alltypes;

select lpad(time_col,30 , float_col) from alltypes;

select lpad(time_col,30 , double_col) from alltypes;

select lpad(time_col,30 , smallint_col) from alltypes;

select lpad(time_col,30 ,monetary_col) from alltypes;

select lpad(time_col,30 , numeric_col) from alltypes;

select lpad(time_col,30 , date_col) from alltypes;

select lpad(time_col,30 , datetime_col) from alltypes;

select lpad(time_col,30 , timestamp_col) from alltypes;

select lpad(time_col,30 , time_col) from alltypes;

select lpad(time_col,30 , bit_col) from alltypes;

select lpad(time_col,30 , varbit_col) from alltypes;


select lpad(timestamp_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,timestamp_col) from alltypes;

select lpad(timestamp_col,30 , float_col) from alltypes;

select lpad(timestamp_col,30 , double_col) from alltypes;

select lpad(timestamp_col,30 , smallint_col) from alltypes;

select lpad(timestamp_col,30 ,monetary_col) from alltypes;

select lpad(timestamp_col,30 , numeric_col) from alltypes;

select lpad(timestamp_col,30 , date_col) from alltypes;

select lpad(timestamp_col,30 , datetime_col) from alltypes;

select lpad(timestamp_col,30 , timestamp_col) from alltypes;

select lpad(timestamp_col,30 , time_col) from alltypes;

select lpad(timestamp_col,30 , bit_col) from alltypes;

select lpad(timestamp_col,30 , varbit_col) from alltypes;


select lpad(bit_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,bit_col) from alltypes;

select lpad(bit_col,30 , float_col) from alltypes;

select lpad(bit_col,30 , double_col) from alltypes;

select lpad(bit_col,30 , smallint_col) from alltypes;

select lpad(bit_col,30 ,monetary_col) from alltypes;

select lpad(bit_col,30 , numeric_col) from alltypes;

select lpad(bit_col,30 , date_col) from alltypes;

select lpad(bit_col,30 , datetime_col) from alltypes;

select lpad(bit_col,30 , timestamp_col) from alltypes;

select lpad(bit_col,30 , time_col) from alltypes;

select lpad(bit_col,30 , bit_col) from alltypes;

select lpad(bit_col,30 , varbit_col) from alltypes;


select lpad(varbit_col,30,'cubrid') from alltypes;

select lpad('cubrid',30,varbit_col) from alltypes;

select lpad(varbit_col,30 , float_col) from alltypes;

select lpad(varbit_col,30 , double_col) from alltypes;

select lpad(varbit_col,30 , smallint_col) from alltypes;

select lpad(varbit_col,30 ,monetary_col) from alltypes;

select lpad(varbit_col,30 , numeric_col) from alltypes;

select lpad(varbit_col,30 , date_col) from alltypes;

select lpad(varbit_col,30 , datetime_col) from alltypes;

select lpad(varbit_col,30 , timestamp_col) from alltypes;

select lpad(varbit_col,30 , time_col) from alltypes;

select lpad(varbit_col,30 , bit_col) from alltypes;

select lpad(varbit_col,30 , varbit_col) from alltypes;




select if(lpad(123.45,10,1) = lpad('123.45',10,'1'), 'ok','nok');

select if(lpad(123.45,10,5.3) = lpad('123.45',10,'5.3'), 'ok','nok');

select if(lpad(cast(123.45 as numeric(10,2)),20,'cubrid') = lpad('123.45',20,'cubrid'), 'ok','nok');

select if(lpad(cast(123.45 as monetary),23,1) = lpad('$123.45',23,1), 'ok','nok');

select if(lpad(time'12:00:00 am',30,date'2010-01-01') = lpad('12:00:00 AM',30,'01/01/2010'),'ok','nok');

select if(lpad(datetime'2010-01-01 12:00:00.123 am',40,time'12:00:00 am') = lpad('12:00:00.123 AM 01/01/2010',40,'12:00:00 AM'),'ok','nok');

select if(lpad(timestamp'2010-01-01 12:00:00 am',40,date'1987-11-16') = lpad('12:00:00 AM 01/01/2010',40,'11/16/1987'),'ok','nok');

select if(lpad(date'2010-01-01',40,b'101010') = lpad('01/01/2010',40,cast(b'101010' as string)),'ok','nok');

select if(lpad(b'10101010',40,timestamp('2010-01-01 12:00:00 am')) = lpad(cast (b'10101010' as string),40,'12:00:00.000 AM 01/01/2010'),'ok','nok');

$varchar, $123, $varchar, $30, $varchar, $12.3
select lpad(?,?,?) from db_root;

$varchar, $123, $varchar, $30, $varchar, $12.3
select if (lpad(?,?,?) = lpad(123,30,12.3), 'ok','nok') from db_root;


drop table alltypes;
