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
varbit_col bit varying (255)

);

insert into alltypes values(12345, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1000, 123456.7890, '2010-02-02', '2010-02-02 12:00:00 am' ,N'14:00:34 am', N'2010-03-03 09:06:03.456 am', b'01010101', b'111111111');

insert into alltypes values('12345', '123.45', '1003.367', '123', '2010-01-01', '11:34:56', '2010-01-01 12:34:56 am', '2010-01-01 12:34:56.123 am','1000', '123456.7890', 123, 123.45 ,123.45, 123, '01010101', '111111111');

CREATE TRIGGER "after_update_trig" AFTER UPDATE ON "alltypes" if date(from_days(elt('2','cubrid','1000000'))) > '2010-01-01' EXECUTE  insert into alltypes values (12345, 123.45, 1003.367, 123, date '2010-01-01', time '12:34:56', timestamp '2010-01-01 10:34:56 am', datetime '2010-01-01 12:34:56.123 am', 1000, 123456.7890, '2010-02-02', '2010-02-02 12:00:00 am', N'14:00:34 am', N'2010-03-03 09:06:03.456 am', B'01010101', B'111111111');


CREATE TRIGGER "before_update_trig" BEFORE UPDATE ON "alltypes" EXECUTE insert into alltypes values (12345, '123.45', '1003.367', '123', '2010-01-01', '12:34:56', '2010-01-01 09:34:56 am', '2010-01-01 12:34:56.123 am', '1000', '123456.7890', 123, 123.45, 123.45, 123, '01010101', '111111111');

CREATE TRIGGER "before_update_trig2" BEFORE UPDATE ON "alltypes" if new.date_col > '1990-12-25' EXECUTE insert into alltypes values (12345, '123.45', '1003.367', '123', '2010-01-01', '12:34:56', '2010-01-01 09:34:56 am', '2010-01-01 12:34:56.123 am', '1000', '123456.7890', 123, 123.45, 123.45, 123, '01010101', '111111111');


update alltypes set varchar_col = 120.5 where ( 10 > all {1,'2.5','3'});

select int_col, float_col, double_col  from alltypes order by 1;

drop trigger before_update_trig;

drop trigger after_update_trig;

drop trigger before_update_trig2;

drop table alltypes;
