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
varnchar_col nchar varying(255))

PARTITION BY LIST (int_col) (
PARTITION p0 VALUES IN (1,3,5,7,9,NULL),
PARTITION p1 VALUES IN (2,4,6,8,10)

);

insert into alltypes values('1',2,3,4,date'2010-01-01',time'12:00:00 am',timestamp'2010-01-01 12:00:00 am',datetime'2010-01-01 12:00:00.123 am',100,100,'aaa','bbb',N'ccc',N'ddd');

insert into alltypes values('6.5',2,3,4,date'2010-01-01',time'12:00:00 am',timestamp'2010-01-01 12:00:00 am',datetime'2010-01-01 12:00:00.123 am',100,100,'aaa','bbb',N'ccc',N'ddd');

select * from alltypes__p__p0 order by int_col;

select * from alltypes__p__p1 order by int_col;

drop table alltypes;


