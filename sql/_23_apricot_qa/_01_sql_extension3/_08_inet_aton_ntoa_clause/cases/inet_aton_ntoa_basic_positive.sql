--+ holdcas on;
drop table if exists test;

create table test (a BIGINT UNIQUE PRIMARY KEY, b varchar(20));
select inet_aton('010.10.0xF	.  1');
select inet_aton('242 .07.56.1');
select inet_aton('89.ox9.1.2');
select * from test where a=inet_aton('1.2.3.4');
select * from test where b=inet_ntoa(3724609022);
select inet_ntoa(123.0);
select inet_ntoa(0);

drop table if exists test;

drop table if exists pp;
drop table if exists qq;

create table pp (a BIGINT UNIQUE PRIMARY KEY, b varchar(20));
create table qq (a BIGINT UNIQUE PRIMARY KEY, b varchar(20));
insert into pp values(inet_aton('210.32.0.10'),'210.32.0.10');

select '5.6.7.8' into x;
select inet_aton(:x);

prepare s from 'select a from pp where a = inet_aton(?)';
execute s using '0.0.0.1';
drop prepare s;

SET OPTIMIZATION LEVEL 257;

create index aton_index on pp(inet_ntoa(a));
select * from pp where inet_ntoa(0) = inet_ntoa(a);
update qq set b = '5.6.7.8' where inet_aton(b) = 16909060;

insert into pp values(inet_aton('0.0.1.1'),'0.0.1.1'),(inet_aton('2.3.4.5'),'2.3.4.5');

insert into qq values(78976576,inet_ntoa(78976576)),(0,(inet_ntoa(0)));

alter table qq drop index b_index;

set @v1=inet_aton('0.0.0.9'), @v2=inet_ntoa(257);
select @v1, @v2, typeof(@v1), typeof(@v2);

set @v1=inet_aton('0.0.0.9') + 2, @v2=inet_ntoa(abs(-257));
select @v1, @v2, typeof(@v1), typeof(@v2);

insert into qq values(inet_aton('6.6.6.6'),'6.6.6.6');
delete from qq where b = inet_ntoa(inet_aton('6.6.6.6'));
drop table if exists qq;
drop table if exists pp;

drop table if exists t1;
create table t1 (a INT UNIQUE PRIMARY KEY, b varchar(20));
insert into t1 values(1,'1'),(2,'2');
replace into t1 values(1, inet_ntoa('1'));
replace into t1 set a=inet_aton('0.0.0.2'), b='from 0002';
drop table if exists t1;

SET OPTIMIZATION LEVEL 1;
drop variable @v1,@v2;


--+ holdcas off;
