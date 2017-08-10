-- misc tests : wrong separators, special cases

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


select i1,group_concat(name+'_' order by 1 separator ';') from tab1 group by i1;

select i1,group_concat(distinct name+'_' order by 1 separator ';') from tab1 group by i1;


select i1,group_concat(t1+10 order by 1 separator ';') from tab1 group by i1;

select i1,group_concat(distinct t1+10 order by 1 separator ';') from tab1 group by i1;


select i1,group_concat(d1-10 order by 1 separator ';') from tab1 group by i1;

select i1,group_concat(distinct d1-10 order by 1 separator ';') from tab1 group by i1;



select i1,group_concat(d2+10 order by 1 separator ';') from tab1 group by i1;

select i1,group_concat(distinct d2+10 order by 1 separator ';') from tab1 group by i1;



select i1,group_concat(t2+10 order by 1 separator ';') from tab1 group by i1;

select i1,group_concat(distinct t2+10 order by 1 separator ';') from tab1 group by i1;


select name,group_concat(i1*2 order by 1 separator ';') from tab1 group by name;

select name,group_concat(distinct i1*2 order by 1 separator ';') from tab1 group by name;

drop table tab1;

