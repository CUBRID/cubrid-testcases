create TABLE t1 (a int, b int);
insert into t1 values (1, 1);
select a as field1, sum(distinct b) from t1 group by field1 with rollup;
drop table t1;

drop table if exists tab1;
create table tab1 (name char varying, t1 time, d1 date, d2 datetime, t2 timestamp,i1 integer ,b bit varying);
insert into tab1 values('alice',time'11:21:31',date'2001-10-10',datetime'2002-11-01 03:11:45',timestamp'2006-10-02 21:21:10',3,b'001011101100');
insert into tab1 values('alice',time'11:21:31',date'2011-10-10',datetime'2002-01-01 03:11:45',timestamp'2006-10-12 21:21:10',5,b'111011001011');
insert into tab1 values('george',time'01:21:31',date'2001-06-10',datetime'1992-11-01 03:11:45',timestamp'1986-10-02 21:21:10',4,b'11101100');
insert into tab1 values('george',time'11:21:31',date'2001-06-10',datetime'2012-11-01 03:11:45',timestamp'2002-06-02 21:21:10',3,b'1110');
insert into tab1 values('mary',time'18:21:31',date'2001-09-10',datetime'1994-11-01 03:11:45',timestamp'1986-10-02 21:21:10',5,b'11001100');
insert into tab1 values('mary',time'19:21:31',date'2021-02-10',datetime'1994-11-01 03:11:45',timestamp'2002-06-02 21:21:10',2,b'11101101');
insert into tab1 values('john',time'18:21:11',date'1991-09-10',datetime'1998-11-01 03:11:45',timestamp'1981-10-02 21:21:10',6,b'111010000101');
insert into tab1 values('john',time'19:21:18',date'2000-02-10',datetime'1994-11-08 03:11:45',timestamp'1981-10-02 21:21:10',5,b'011001001111');
insert into tab1 values('john',time'19:21:18',date'2000-02-10',datetime'1994-11-08 03:11:45',timestamp'1981-10-02 21:21:10',5,b'011001001111');

select i1,group_concat(name+'_' order by 1 separator ';') as field2 from tab1 group by i1 with rollup order by i1,field2;
drop table tab1;

create table tab1 (name varchar(100), i2 integer, i1 integer);
insert into tab1 values('george',10,3);
insert into tab1 values('alice',10,5);
insert into tab1 values('george',10,4);
insert into tab1 values('george',10,3);
insert into tab1 values('john',10,5);
insert into tab1 values('mary',10,2);
insert into tab1 values('john',10,6);
insert into tab1 values('john',10,5);

select i1, i2, count(name), count(distinct name) from tab1 group by i1, i2 with rollup order by i1,i2;
drop table tab1;
