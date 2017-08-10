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



select int_col*'cubrid' from alltypes;

select 'cubrid'*int_col from alltypes;

select int_col* float_col from alltypes;

select int_col* double_col from alltypes;

select int_col* smallint_col from alltypes;

select int_col*monetary_col from alltypes;

select int_col* numeric_col from alltypes;

select int_col* date_col from alltypes;

select int_col* datetime_col from alltypes;

select int_col* timestamp_col from alltypes;

select int_col* time_col from alltypes;

select int_col* bit_col from alltypes;

select int_col* varbit_col from alltypes;



select float_col*'cubrid' from alltypes;

select 'cubrid'*float_col from alltypes;

select float_col* float_col from alltypes;

select float_col* double_col from alltypes;

select float_col* smallint_col from alltypes;

select float_col*monetary_col from alltypes;

select float_col* numeric_col from alltypes;

select float_col* date_col from alltypes;

select float_col* datetime_col from alltypes;

select float_col* timestamp_col from alltypes;

select float_col* time_col from alltypes;

select float_col* bit_col from alltypes;

select float_col* varbit_col from alltypes;



select float_col*'cubrid' from alltypes;

select 'cubrid'*float_col from alltypes;

select float_col* float_col from alltypes;

select float_col* float_col from alltypes;

select float_col* smallint_col from alltypes;

select float_col*monetary_col from alltypes;

select float_col* numeric_col from alltypes;

select float_col* date_col from alltypes;

select float_col* datetime_col from alltypes;

select float_col* timestamp_col from alltypes;

select float_col* time_col from alltypes;

select float_col* bit_col from alltypes;

select float_col* varbit_col from alltypes;



select smallint_col*'cubrid' from alltypes;

select 'cubrid'*smallint_col from alltypes;

select smallint_col* float_col from alltypes;

select smallint_col* double_col from alltypes;

select smallint_col* smallint_col from alltypes;

select smallint_col*monetary_col from alltypes;

select smallint_col* numeric_col from alltypes;

select smallint_col* date_col from alltypes;

select smallint_col* datetime_col from alltypes;

select smallint_col* timestamp_col from alltypes;

select smallint_col* time_col from alltypes;

select smallint_col* bit_col from alltypes;

select smallint_col* varbit_col from alltypes;



select monetary_col*'cubrid' from alltypes;

select 'cubrid'*monetary_col from alltypes;

select monetary_col* float_col from alltypes;

select monetary_col* double_col from alltypes;

select monetary_col* smallint_col from alltypes;

select monetary_col*monetary_col from alltypes;

select monetary_col* numeric_col from alltypes;

select monetary_col* date_col from alltypes;

select monetary_col* datetime_col from alltypes;

select monetary_col* timestamp_col from alltypes;

select monetary_col* time_col from alltypes;

select monetary_col* bit_col from alltypes;

select monetary_col* varbit_col from alltypes;


select numeric_col*'cubrid' from alltypes;

select 'cubrid'*numeric_col from alltypes;

select numeric_col* float_col from alltypes;

select numeric_col* double_col from alltypes;

select numeric_col* smallint_col from alltypes;

select numeric_col*monetary_col from alltypes;

select numeric_col* numeric_col from alltypes;

select numeric_col* date_col from alltypes;

select numeric_col* datetime_col from alltypes;

select numeric_col* timestamp_col from alltypes;

select numeric_col* time_col from alltypes;

select numeric_col* bit_col from alltypes;

select numeric_col* varbit_col from alltypes;



select date_col*'cubrid' from alltypes;

select 'cubrid'*date_col from alltypes;

select date_col* float_col from alltypes;

select date_col* double_col from alltypes;

select date_col* smallint_col from alltypes;

select date_col*monetary_col from alltypes;

select date_col* numeric_col from alltypes;

select date_col* date_col from alltypes;

select date_col* datetime_col from alltypes;

select date_col* timestamp_col from alltypes;

select date_col* time_col from alltypes;

select date_col* bit_col from alltypes;

select date_col* varbit_col from alltypes;



select datetime_col*'cubrid' from alltypes;

select 'cubrid'*datetime_col from alltypes;

select datetime_col* float_col from alltypes;

select datetime_col* double_col from alltypes;

select datetime_col* smallint_col from alltypes;

select datetime_col*monetary_col from alltypes;

select datetime_col* numeric_col from alltypes;

select datetime_col* date_col from alltypes;

select datetime_col* datetime_col from alltypes;

select datetime_col* timestamp_col from alltypes;

select datetime_col* time_col from alltypes;

select datetime_col* bit_col from alltypes;

select datetime_col* varbit_col from alltypes;


select time_col*'cubrid' from alltypes;

select 'cubrid'*time_col from alltypes;

select time_col* float_col from alltypes;

select time_col* double_col from alltypes;

select time_col* smallint_col from alltypes;

select time_col*monetary_col from alltypes;

select time_col* numeric_col from alltypes;

select time_col* date_col from alltypes;

select time_col* datetime_col from alltypes;

select time_col* timestamp_col from alltypes;

select time_col* time_col from alltypes;

select time_col* bit_col from alltypes;

select time_col* varbit_col from alltypes;


select timestamp_col*'cubrid' from alltypes;

select 'cubrid'*timestamp_col from alltypes;

select timestamp_col* float_col from alltypes;

select timestamp_col* double_col from alltypes;

select timestamp_col* smallint_col from alltypes;

select timestamp_col*monetary_col from alltypes;

select timestamp_col* numeric_col from alltypes;

select timestamp_col* date_col from alltypes;

select timestamp_col* datetime_col from alltypes;

select timestamp_col* timestamp_col from alltypes;

select timestamp_col* time_col from alltypes;

select timestamp_col* bit_col from alltypes;

select timestamp_col* varbit_col from alltypes;


select bit_col*'cubrid' from alltypes;

select 'cubrid'*bit_col from alltypes;

select bit_col* float_col from alltypes;

select bit_col* double_col from alltypes;

select bit_col* smallint_col from alltypes;

select bit_col*monetary_col from alltypes;

select bit_col* numeric_col from alltypes;

select bit_col* date_col from alltypes;

select bit_col* datetime_col from alltypes;

select bit_col* timestamp_col from alltypes;

select bit_col* time_col from alltypes;

select bit_col* bit_col from alltypes;

select bit_col* varbit_col from alltypes;


select varbit_col*'cubrid' from alltypes;

select 'cubrid'*varbit_col from alltypes;

select varbit_col* float_col from alltypes;

select varbit_col* double_col from alltypes;

select varbit_col* smallint_col from alltypes;

select varbit_col*monetary_col from alltypes;

select varbit_col* numeric_col from alltypes;

select varbit_col* date_col from alltypes;

select varbit_col* datetime_col from alltypes;

select varbit_col* timestamp_col from alltypes;

select varbit_col* time_col from alltypes;

select varbit_col* bit_col from alltypes;

select varbit_col* varbit_col from alltypes;

drop table alltypes;


