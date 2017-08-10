-- misc tests : wrong separators, special cases

create table tab1 (name char varying, t1 time, d1 date, d2 datetime, t2 timestamp,i1 integer ,b bit varying);
insert into tab1 values('gigi',time'11:21:31',date'2001-10-10',datetime'2002-11-01 03:11:45',timestamp'2006-10-02 21:21:10',3,b'001011101100');
insert into tab1 values('gigi',time'11:21:31',date'2011-10-10',datetime'2002-01-01 03:11:45',timestamp'2006-10-12 21:21:10',5,b'111011001011');
insert into tab1 values('gogu',time'01:21:31',date'2001-06-10',datetime'1992-11-01 03:11:45',timestamp'1986-10-02 21:21:10',4,b'11101100');
insert into tab1 values('gogu',time'11:21:31',date'2001-06-10',datetime'2012-11-01 03:11:45',timestamp'2002-06-02 21:21:10',3,b'1110');
insert into tab1 values('maria',time'18:21:31',date'2001-09-10',datetime'1994-11-01 03:11:45',timestamp'1986-10-02 21:21:10',5,b'11001100');
insert into tab1 values('maria',time'19:21:31',date'2021-02-10',datetime'1994-11-01 03:11:45',timestamp'2002-06-02 21:21:10',2,b'11101101');
insert into tab1 values('ion',time'18:21:11',date'1991-09-10',datetime'1998-11-01 03:11:45',timestamp'1981-10-02 21:21:10',6,b'111010000101');
insert into tab1 values('ion',time'19:21:18',date'2000-02-10',datetime'1994-11-08 03:11:45',timestamp'1981-10-02 21:21:10',5,b'011001001111');
insert into tab1 values('ion',time'19:21:18',date'2000-02-10',datetime'1994-11-08 03:11:45',timestamp'1981-10-02 21:21:10',5,b'011001001111');


select i1,group_concat(name order by 1 separator 2) from tab1 group by i1;

select name,group_concat(distinct i1 order by 1 separator 2) from tab1 group by name;

select name,group_concat(t1 order by 1 separator time'12:31:11') from tab1 group by name;

select i1,group_concat(name order by 1 separator NULL) from tab1 group by i1;

select name,group_concat(b order by 1 separator '+') from tab1 group by name;

select name,group_concat(i1 order by 1 separator '') from tab1 group by name;

select name,group_concat(i1+1 order by 1 separator '+') from tab1 group by name;

select name,group_concat(distinct (i1+1) order by 1 separator '+') from tab1 group by name;

select name,group_concat(concat(d1,t1) order by 1 separator '+') from tab1 group by name;

select name,group_concat(concat_ws(d1,t1,' ') order by 1 separator '+') from tab1 group by name;

select name,group_concat(distinct concat_ws(d1,t1,' ') order by 1 separator '+') from tab1 group by name;

select i1,group_concat('bla' order by 1 separator '+') from tab1 group by i1;


drop table tab1;

