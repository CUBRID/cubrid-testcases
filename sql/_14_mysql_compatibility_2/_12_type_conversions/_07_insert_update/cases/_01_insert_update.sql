create table a(s varchar(255));
create table b(i integer);

insert into a(s) values(1);
insert into a(s) values(2);
insert into a(s) values(3);
insert into a(s) values(4);

insert into b select * from a;

update b set i = (select s from a where s = b.i);

select s from a order by s;

select i from b order by i;

create table c (s varchar(255), i integer);

insert into c(i,s) select a.s,b.i from a,b where a.s = b.i;

select * from c order by 1, 2;

update c set s = (select a.s + b.i from a , b where a.s = b.i and b.i = c.s order by 1);

select * from c order by 1,2;

update c set i = (select a.s + b.i from a , b where a.s = b.i and b.i = c.i order by 1);

select * from c order by 1,2;

delete from c;

$char, $1
insert into c(s) select s + ? from a order by 1;

$char, $1
update c set i = s + ?;

select * from c order by 1,2;

delete from c;


$char, $1, $int, $1
insert into c(i,s) select s + ?, s + ? from a order by 1;

$char, $1
update c set s = i + ?;

select * from c order by 1,2;

delete from c;

$int, $1, $int, $1
insert into c (s, i) select s + ?, s + ? from a order by 1;

$char, $1
update c set i = s + ?;

select * from c order by 1,2;

delete from c;

$char, $1, $char, $1
insert into c (s, i) select i + ?, i + ? from b order by 1;

$char, $1, $char, $1
update c set i = s + ?, s =  i + ?;

select * from c order by 1,2;

delete from c;

$int, $1, $int, $1
insert into c(s, i) select i + ?, i + ? from b order by 1;

select * from c order by 1,2;

delete from c;

$char, $100, $int, $100
insert into c (s, i) select a.s + ?, b.i + ? from a, b where a.s = b.i order by 1,2;

select * from c order by 1,2;

delete from c;

$char, $100, $char, $100, $char, $100, $char, $100
insert into c(s, i) select a.s + ? + b.i + ?, a.s + ? + b.i + ? from a, b where a.s = b.i order by 1;

$char, $100, $char, $100, $char, $100, $char, $100
update c set s= s + ? + i + ?, i = s + ? + i + ?;

select * from c order by 1,2;

create unique index u_idx  on a(s);

select s from a order by s;

insert into a(s) values(4) on duplicate key update s = 5;

select s from a order by s;

replace into a set s = 5;

select * from a where s < 10 order by s;

select * from b where i < '10' order by i;

select s+5 from a order by s;

insert into a(s) values ('next query should fail');

select s+5 from a order by s;

drop table a;
drop table b;
drop table c;

create table a (col date);

insert into a values('2010-01-01');

insert into a values('2010-01-01 12:00:00');

insert into a values('2010-01-01 12:00:00.000');

insert into a values('12:00:00');

insert into a values('asdf');

insert into a values('2010');

insert into a values('{1,2,3}');

insert into a values(date'2010-01-01');

insert into a values(20100101);

insert into a values(0.2010e4);

insert into a values(2010.0f);

insert into a values({'2010','01','01'});

insert into a values({1,2,3});

insert into a values({1.1,2.1,3.1});

insert into a values({1.1f,2.1f,3.1f});

insert into a values({0.1e1,0.2e1,0.3e1});

insert into a values({'1',2,3});

insert into a values({'1','2','3'});

insert into a values({'1',2,'2010-01-01'});

select * from a order by col;

drop table a;

create table a (col set of integer);

insert into a values('2010-01-01');

insert into a values('2010-01-01 12:00:00');

insert into a values('2010-01-01 12:00:00.000');

insert into a values('12:00:00');

insert into a values('asdf');

insert into a values('2010');

insert into a values('{1,2,3}');

insert into a values(date'2010-01-01');

insert into a values(20100101);

insert into a values(0.2010e4);

insert into a values(2010.0f);

insert into a values({'2010','01','01'});

insert into a values({1,2,3});

insert into a values({1.1,2.1,3.1});

insert into a values({1.1f,2.1f,3.1f});

insert into a values({0.1e1,0.2e1,0.3e1});

insert into a values({'1',2,3});

insert into a values({'1','2','3'});

insert into a values({'1',2,'2010-01-01'});

select * from a order by 1;

drop table a;

create table a (col integer);

insert into a values('2010-01-01');

insert into a values('2010-01-01 12:00:00');

insert into a values('2010-01-01 12:00:00.000');

insert into a values('12:00:00');

insert into a values('asdf');

insert into a values('2010');

insert into a values('{1,2,3}');

insert into a values(date'2010-01-01');

insert into a values(20100101);

insert into a values(0.2010e4);

insert into a values(2010.0f);

insert into a values({'2010','01','01'});

insert into a values({1,2,3});

insert into a values({1.1,2.1,3.1});

insert into a values({1.1f,2.1f,3.1f});

insert into a values({0.1e1,0.2e1,0.3e1});

insert into a values({'1',2,3});

insert into a values({'1','2','3'});

insert into a values({'1',2,'2010-01-01'});

select * from a order by 1;

drop table a;

create table a (col int);

$char, $1, $char, $2
insert into a values(?+?);

$char, $0
insert into a values('1'+?);

select col from a order by col;

drop table a;

create table a (col varchar(255));

$char, $1, $char, $2
insert into a values(?+?);

$int, $10
insert into a values('1'+?);

select col from a order by col;

drop table a;


-- insert from select 

create table int_table (i int);

create table varchar_table (c varchar(255));

insert into varchar_table values ('10'),('20'),('30'),('40'),('50');

insert into int_table (select c from varchar_table);

update int_table set i = i*'10' where i <= '20';

replace into int_table set i = '70';

select * from int_table order by 1;

drop table int_table;

drop table varchar_table;


create table float_table (i float);

create table varchar_table (c varchar(255));

insert into varchar_table values ('10.3'),('20.3'),('30.3'),('40.3'),('50.3');

insert into float_table (select c from varchar_table);

update float_table set i = i*'10' where i <= '20';

replace into float_table set i = '70';

select * from float_table order by 1;

drop table float_table;

drop table varchar_table;


create table double_table (i double);

create table varchar_table (c varchar(255));

insert into varchar_table values ('10.3'),('20.3'),('30.3'),('40.3'),('50.3');

insert into double_table (select c from varchar_table);

update double_table set i = i*'10' where i <= '20';

replace into double_table set i = '70';

select * from double_table order by 1;

drop table double_table;

drop table varchar_table;


create table smallint_table (i smallint);

create table varchar_table (c varchar(255));

insert into varchar_table values ('10'),('20'),('30'),('40'),('50');

insert into smallint_table (select c from varchar_table);

update smallint_table set i = i*'10' where i <= '20';

replace into smallint_table set i = '70';

select * from smallint_table order by 1;

drop table smallint_table;

drop table varchar_table;


create table monetary_table (i monetary);

create table varchar_table (c varchar(255));

insert into varchar_table values ('10'),('20'),('30'),('40'),('50');

insert into monetary_table (select c from varchar_table);

update monetary_table set i = i*'10' where i <= '20';

replace into monetary_table set i = '70';

select * from monetary_table order by 1;

drop table monetary_table;

drop table varchar_table;


create table numeric_table (i numeric(10,5));

create table varchar_table (c varchar(255));

insert into varchar_table values ('10'),('20'),('30'),('40'),('50');

insert into numeric_table (select c from varchar_table);

update numeric_table set i = i*'10' where i <= '20';

replace into numeric_table set i = '70';

select * from numeric_table order by 1;

drop table numeric_table;

drop table varchar_table;


create table datetime_table (d date, t time, dt datetime, ts timestamp);

create table varchar_table (ds varchar(255),ts varchar(255), dts varchar(255), tss varchar(255));

insert into varchar_table values ('2010-01-01','12:00:00 am','2010-01-01 12:00:00.123 am','2010-01-01 12:00:00 am'),
('2009-01-01','11:00:00 am','2009-01-01 11:00:00.123 am','2009-01-01 11:00:00 am');

insert into datetime_table (select c from varchar_table);

update datetime_table set d = d + 10 where (t > '06:00:00');

replace into datetime_table set d = '2009-09-09';

replace into datetime_table set t = '11:11:11 am';

replace into datetime_table set dt = '2009-09-09 11:11:11.111 am';

replace into datetime_table set ts = '2009-09-09 11:11:11 am';

select * from datetime_table order by 1;

drop table datetime_table;

drop table varchar_table;


create table types_table (i int, f float, db double, s smallint, d date, t time, dt datetime, ts timestamp);

create table varchar_table (istr varchar(255), fs varchar(255), dbs varchar(255), ss varchar(255), ds varchar(255),ts varchar(255), dts varchar(255), tss varchar(255));

insert into types_table values (1,3.5,4.7,2,date'2010-01-01',time'12:00:00 am',datetime'2010-01-01 12:00:00.123 am',timestamp'2010-01-01 12:00:00 am'),
(2,7.5,9.7,4,date'2009-01-01',time'11:00:00 am',datetime'2009-01-01 11:00:00.123 am',timestamp'2009-01-01 11:00:00 am');

insert into varchar_table (select c from types_table);

update into varchar_table set istr = sign(istr) where fs > 2;

select * from varchar_table order by 1;

drop table types_table;

drop table varchar_table;
