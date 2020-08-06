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
bit_col bit(32),
varbit_col bit varying (255)

);

insert into alltypes values('12345', '123.45', '1003.367', '123', '2010-01-01', '12:34:56', '2010-01-01 12:34:56 am', '2010-01-01 12:34:56.123 am','1000', '123456.7890', 123, 123.45 ,123.45, 123, '01010101', '111111111');

insert into alltypes values('12345', '123.45', '1003.367', '123', datetime'2010-01-01 12:34:56', '12:34:56', date'2010-01-01', timestamp'2010-01-01 11:00:00 am','1000', '123456.7890', 123, 123.45 ,123.45, 123, '01010101', '111111111');

select max(char_col) from alltypes;

select max(varchar_col) from alltypes;

select max(nchar_col) from alltypes;

select max(varnchar_col) from alltypes;



select min(char_col) from alltypes;

select min(varchar_col) from alltypes;

select min(nchar_col) from alltypes;

select min(varnchar_col) from alltypes;


select sum(char_col) from alltypes;

select sum(varchar_col) from alltypes;

select sum(nchar_col) from alltypes;

select sum(varnchar_col) from alltypes;


select avg(char_col) from alltypes;

select avg(varchar_col) from alltypes;

select avg(nchar_col) from alltypes;

select avg(varnchar_col) from alltypes;


select stddev_samp(char_col) from alltypes;

select stddev_samp(varchar_col) from alltypes;

select stddev_samp(nchar_col) from alltypes;

select stddev_samp(varnchar_col) from alltypes;


select stddev_pop(char_col) from alltypes;

select stddev_pop(varchar_col) from alltypes;

select stddev_pop(nchar_col) from alltypes;

select stddev_pop(varnchar_col) from alltypes;


select var_samp(char_col) from alltypes;

select var_samp(varchar_col) from alltypes;

select var_samp(nchar_col) from alltypes;

select var_samp(varnchar_col) from alltypes;


select var_pop(char_col) from alltypes;

select var_pop(varchar_col) from alltypes;

select var_pop(nchar_col) from alltypes;

select var_pop(varnchar_col) from alltypes;

drop table alltypes;
