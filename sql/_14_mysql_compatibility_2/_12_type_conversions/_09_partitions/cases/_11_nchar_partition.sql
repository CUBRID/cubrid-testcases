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

PARTITION BY LIST (nchar_col) (
PARTITION p0 VALUES IN (N'2010-01-01 12:00:00.123 am',N'11:00:00.456 AM 01/01/2009',NULL),
PARTITION p1 VALUES IN (N'576',N'2007-01-01 09:00:00 am')

);

insert into alltypes values (1,'1.1',3,4,'2010-01-01','12:00:00 am',timestamp'2010-01-01 12:00:00 am','2010-01-01 12:00:00.123 am',100,100,datetime'2009-01-01 11:00:00.456 am','aaa',datetime'2009-01-01 11:00:00.456 am',N'ddd');

insert into alltypes values (1,'4.1',3,4,'1987-11-16','10:00:00 am',timestamp'2010-01-01 12:00:00 am','2008-01-01 10:00:00.789 am',100,100,576,'aaa',576,N'ddd');

select * from alltypes__p__p0;

select * from alltypes__p__p1;

drop table alltypes;


