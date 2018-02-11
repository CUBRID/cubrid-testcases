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

select concat_ws(int_col,'cubrid') from alltypes;

select concat_ws('cubrid',int_col) from alltypes;

select concat_ws(int_col, float_col) from alltypes;

select concat_ws(int_col, double_col) from alltypes;

select concat_ws(int_col, smallint_col) from alltypes;

select concat_ws(int_col,monetary_col) from alltypes;

select concat_ws(int_col, numeric_col) from alltypes;

select concat_ws(int_col, date_col) from alltypes;

select concat_ws(int_col, datetime_col) from alltypes;

select concat_ws(int_col, timestamp_col) from alltypes;

select concat_ws(int_col, time_col) from alltypes;

select concat_ws(int_col, bit_col) from alltypes;

select concat_ws(int_col, varbit_col) from alltypes;



select concat_ws(float_col,'cubrid') from alltypes;

select concat_ws('cubrid',float_col) from alltypes;

select concat_ws(float_col, float_col) from alltypes;

select concat_ws(float_col, double_col) from alltypes;

select concat_ws(float_col, smallint_col) from alltypes;

select concat_ws(float_col,monetary_col) from alltypes;

select concat_ws(float_col, numeric_col) from alltypes;

select concat_ws(float_col, date_col) from alltypes;

select concat_ws(float_col, datetime_col) from alltypes;

select concat_ws(float_col, timestamp_col) from alltypes;

select concat_ws(float_col, time_col) from alltypes;

select concat_ws(float_col, bit_col) from alltypes;

select concat_ws(float_col, varbit_col) from alltypes;



select concat_ws(float_col,'cubrid') from alltypes;

select concat_ws('cubrid',float_col) from alltypes;

select concat_ws(float_col, float_col) from alltypes;

select concat_ws(float_col, float_col) from alltypes;

select concat_ws(float_col, smallint_col) from alltypes;

select concat_ws(float_col,monetary_col) from alltypes;

select concat_ws(float_col, numeric_col) from alltypes;

select concat_ws(float_col, date_col) from alltypes;

select concat_ws(float_col, datetime_col) from alltypes;

select concat_ws(float_col, timestamp_col) from alltypes;

select concat_ws(float_col, time_col) from alltypes;

select concat_ws(float_col, bit_col) from alltypes;

select concat_ws(float_col, varbit_col) from alltypes;



select concat_ws(smallint_col,'cubrid') from alltypes;

select concat_ws('cubrid',smallint_col) from alltypes;

select concat_ws(smallint_col, float_col) from alltypes;

select concat_ws(smallint_col, double_col) from alltypes;

select concat_ws(smallint_col, smallint_col) from alltypes;

select concat_ws(smallint_col,monetary_col) from alltypes;

select concat_ws(smallint_col, numeric_col) from alltypes;

select concat_ws(smallint_col, date_col) from alltypes;

select concat_ws(smallint_col, datetime_col) from alltypes;

select concat_ws(smallint_col, timestamp_col) from alltypes;

select concat_ws(smallint_col, time_col) from alltypes;

select concat_ws(smallint_col, bit_col) from alltypes;

select concat_ws(smallint_col, varbit_col) from alltypes;



select concat_ws(monetary_col,'cubrid') from alltypes;

select concat_ws('cubrid',monetary_col) from alltypes;

select concat_ws(monetary_col, float_col) from alltypes;

select concat_ws(monetary_col, double_col) from alltypes;

select concat_ws(monetary_col, smallint_col) from alltypes;

select concat_ws(monetary_col,monetary_col) from alltypes;

select concat_ws(monetary_col, numeric_col) from alltypes;

select concat_ws(monetary_col, date_col) from alltypes;

select concat_ws(monetary_col, datetime_col) from alltypes;

select concat_ws(monetary_col, timestamp_col) from alltypes;

select concat_ws(monetary_col, time_col) from alltypes;

select concat_ws(monetary_col, bit_col) from alltypes;

select concat_ws(monetary_col, varbit_col) from alltypes;


select concat_ws(numeric_col,'cubrid') from alltypes;

select concat_ws('cubrid',numeric_col) from alltypes;

select concat_ws(numeric_col, float_col) from alltypes;

select concat_ws(numeric_col, double_col) from alltypes;

select concat_ws(numeric_col, smallint_col) from alltypes;

select concat_ws(numeric_col,monetary_col) from alltypes;

select concat_ws(numeric_col, numeric_col) from alltypes;

select concat_ws(numeric_col, date_col) from alltypes;

select concat_ws(numeric_col, datetime_col) from alltypes;

select concat_ws(numeric_col, timestamp_col) from alltypes;

select concat_ws(numeric_col, time_col) from alltypes;

select concat_ws(numeric_col, bit_col) from alltypes;

select concat_ws(numeric_col, varbit_col) from alltypes;



select concat_ws(date_col,'cubrid') from alltypes;

select concat_ws('cubrid',date_col) from alltypes;

select concat_ws(date_col, float_col) from alltypes;

select concat_ws(date_col, double_col) from alltypes;

select concat_ws(date_col, smallint_col) from alltypes;

select concat_ws(date_col,monetary_col) from alltypes;

select concat_ws(date_col, numeric_col) from alltypes;

select concat_ws(date_col, date_col) from alltypes;

select concat_ws(date_col, datetime_col) from alltypes;

select concat_ws(date_col, timestamp_col) from alltypes;

select concat_ws(date_col, time_col) from alltypes;

select concat_ws(date_col, bit_col) from alltypes;

select concat_ws(date_col, varbit_col) from alltypes;



select concat_ws(datetime_col,'cubrid') from alltypes;

select concat_ws('cubrid',datetime_col) from alltypes;

select concat_ws(datetime_col, float_col) from alltypes;

select concat_ws(datetime_col, double_col) from alltypes;

select concat_ws(datetime_col, smallint_col) from alltypes;

select concat_ws(datetime_col,monetary_col) from alltypes;

select concat_ws(datetime_col, numeric_col) from alltypes;

select concat_ws(datetime_col, date_col) from alltypes;

select concat_ws(datetime_col, datetime_col) from alltypes;

select concat_ws(datetime_col, timestamp_col) from alltypes;

select concat_ws(datetime_col, time_col) from alltypes;

select concat_ws(datetime_col, bit_col) from alltypes;

select concat_ws(datetime_col, varbit_col) from alltypes;


select concat_ws(time_col,'cubrid') from alltypes;

select concat_ws('cubrid',time_col) from alltypes;

select concat_ws(time_col, float_col) from alltypes;

select concat_ws(time_col, double_col) from alltypes;

select concat_ws(time_col, smallint_col) from alltypes;

select concat_ws(time_col,monetary_col) from alltypes;

select concat_ws(time_col, numeric_col) from alltypes;

select concat_ws(time_col, date_col) from alltypes;

select concat_ws(time_col, datetime_col) from alltypes;

select concat_ws(time_col, timestamp_col) from alltypes;

select concat_ws(time_col, time_col) from alltypes;

select concat_ws(time_col, bit_col) from alltypes;

select concat_ws(time_col, varbit_col) from alltypes;


select concat_ws(timestamp_col,'cubrid') from alltypes;

select concat_ws('cubrid',timestamp_col) from alltypes;

select concat_ws(timestamp_col, float_col) from alltypes;

select concat_ws(timestamp_col, double_col) from alltypes;

select concat_ws(timestamp_col, smallint_col) from alltypes;

select concat_ws(timestamp_col,monetary_col) from alltypes;

select concat_ws(timestamp_col, numeric_col) from alltypes;

select concat_ws(timestamp_col, date_col) from alltypes;

select concat_ws(timestamp_col, datetime_col) from alltypes;

select concat_ws(timestamp_col, timestamp_col) from alltypes;

select concat_ws(timestamp_col, time_col) from alltypes;

select concat_ws(timestamp_col, bit_col) from alltypes;

select concat_ws(timestamp_col, varbit_col) from alltypes;


select concat_ws(bit_col,'cubrid') from alltypes;

select concat_ws('cubrid',bit_col) from alltypes;

select concat_ws(bit_col, float_col) from alltypes;

select concat_ws(bit_col, double_col) from alltypes;

select concat_ws(bit_col, smallint_col) from alltypes;

select concat_ws(bit_col,monetary_col) from alltypes;

select concat_ws(bit_col, numeric_col) from alltypes;

select concat_ws(bit_col, date_col) from alltypes;

select concat_ws(bit_col, datetime_col) from alltypes;

select concat_ws(bit_col, timestamp_col) from alltypes;

select concat_ws(bit_col, time_col) from alltypes;

select concat_ws(bit_col, bit_col) from alltypes;

select concat_ws(bit_col, varbit_col) from alltypes;


select concat_ws(varbit_col,'cubrid') from alltypes;

select concat_ws('cubrid',varbit_col) from alltypes;

select concat_ws(varbit_col, float_col) from alltypes;

select concat_ws(varbit_col, double_col) from alltypes;

select concat_ws(varbit_col, smallint_col) from alltypes;

select concat_ws(varbit_col,monetary_col) from alltypes;

select concat_ws(varbit_col, numeric_col) from alltypes;

select concat_ws(varbit_col, date_col) from alltypes;

select concat_ws(varbit_col, datetime_col) from alltypes;

select concat_ws(varbit_col, timestamp_col) from alltypes;

select concat_ws(varbit_col, time_col) from alltypes;

select concat_ws(varbit_col, bit_col) from alltypes;

select concat_ws(varbit_col, varbit_col) from alltypes;

select if(concat_ws(123,123.45) = concat_ws('123','123.45'), 'ok','nok');

select if(concat_ws(123.45,56.7) = concat_ws('123.45','56.7'), 'ok','nok');

select if(concat_ws(cast(123.45 as numeric(10,2)),'cubrid') = concat_ws('123.45','cubrid'), 'ok','nok');

select if(concat_ws(cast(123.45 as monetary),'cubrid') = concat_ws('$123.45','cubrid'), 'ok','nok');

select if(concat_ws(time'12:00:00 am',date'2010-01-01') = concat_ws('12:00:00 AM','2010-01-01'),'ok','nok');

select if(concat_ws(datetime'2010-01-01 12:00:00.123 am',time'12:00:00 am') = concat_ws('2010-01-01 12:00:00.123 am','12:00:00 AM'),'ok','nok');

select if(concat_ws(timestamp'2010-01-01 12:00:00 am',date'1987-11-16') = concat_ws('2010-01-01 12:00:00 am','11/16/1987'),'ok','nok');

select if(concat_ws(date'2010-01-01',b'101010') = concat_ws('2010-01-01',cast(b'101010' as string)),'ok','nok');

$varchar, $123, $varchar, $12.3
select concat_ws(?,?) from db_root;

$varchar, $123, $varchar, $12.3
select if (concat_ws(?,?) = concat_ws(123,12.3), 'ok','nok') from db_root;


drop table alltypes;


--add test case for bug 6524
create table t1(s2 char(10));
insert into t1 values(NULL);
insert into t1 values('AA');
select concat_ws('x','1',s2) from t1 order by 1;
select concat_ws('x',s2,'1') from t1 order by 1;
select concat_ws('x','1',s2,'1') from t1 order by 1;
drop table t1;

