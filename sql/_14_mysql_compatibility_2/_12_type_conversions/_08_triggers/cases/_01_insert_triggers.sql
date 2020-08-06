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

insert into alltypes values(12345, 123.45, 1003.367, 123, date'2010-01-01', time'12:34:56', timestamp'2010-01-01 12:34:56 am', datetime'2010-01-01 12:34:56.123 am',1000, 123456.7890, '2010-02-02', '2010-02-02 12:00:00 am' ,N'14:00:34 am', N'2010-03-03 09:06:03.456 am', b'01010101', b'111111111');

insert into alltypes values('1234', '123.45', '1003.367', '123', '2010-01-01', '11:34:56', '2010-01-01 12:34:56 am', '2010-01-01 12:34:56.123 am','1000', '123456.7890', 123, 123.45 ,123.45, 123, '01010101', '111111111');

CREATE TRIGGER "after_insert_trig" AFTER INSERT ON "alltypes" EXECUTE update alltypes set float_col='5.2' where ((floor('32.5') > 10));


CREATE TRIGGER "before_insert_trig" BEFORE INSERT ON "alltypes" EXECUTE  update alltypes set double_col='2' where ((1='1'));

CREATE TRIGGER "before_insert_trig2" BEFORE INSERT ON "alltypes" if new.double_col > abs('-10.5')*('2' > 2) EXECUTE  update alltypes set varchar_col=2 where ('3'+mod(to_days('2010-01-01'),'1'+cos('0')) >= hour('3:3:3'));

insert into alltypes values('123', '123.45', '1003.367', '123', '2010-01-01', '08:34:56', '2010-01-01 12:34:56 am', '2010-01-01 12:34:56.123 am','1000', '123456.7890', 123, 123.45 ,123.45, 123, '01010101', '111111111');

select * from alltypes order by 1;

drop trigger after_insert_trig;

drop trigger before_insert_trig;

drop trigger before_insert_trig2;
drop table alltypes;
