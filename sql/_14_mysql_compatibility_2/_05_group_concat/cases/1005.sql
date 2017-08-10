-- group_concat dates : time, date, datetime , timestamp

create table tab1 (name char varying, t1 time, d1 date, d2 datetime, t2 timestamp);
insert into tab1 values('gigi',time'11:21:31',date'2001-10-10',datetime'2002-11-01 03:11:45',timestamp'2006-10-02 21:21:10');
insert into tab1 values('gigi',time'11:21:31',date'2011-10-10',datetime'2002-01-01 03:11:45',timestamp'2006-10-12 21:21:10');
insert into tab1 values('gogu',time'01:21:31',date'2001-06-10',datetime'1992-11-01 03:11:45',timestamp'1986-10-02 21:21:10');
insert into tab1 values('gogu',time'11:21:31',date'2001-06-10',datetime'2012-11-01 03:11:45',timestamp'2002-06-02 21:21:10');
insert into tab1 values('maria',time'18:21:31',date'2001-09-10',datetime'1994-11-01 03:11:45',timestamp'1986-10-02 21:21:10');
insert into tab1 values('maria',time'19:21:31',date'2021-02-10',datetime'1994-11-01 03:11:45',timestamp'2002-06-02 21:21:10');
insert into tab1 values('ion',time'18:21:11',date'1991-09-10',datetime'1998-11-01 03:11:45',timestamp'1981-10-02 21:21:10');
insert into tab1 values('ion',time'19:21:18',date'2000-02-10',datetime'1994-11-08 03:11:45',timestamp'1981-10-02 21:21:10');


select group_concat(d1  order by 1) from tab1 order by 1;

select group_concat(all d1 order by 1 desc) from tab1 order by 1;

select group_concat(distinct d1 order by 1) from tab1 order by 1;

select group_concat(unique d1 order by 1 desc) from tab1 order by 1;


select name,group_concat(t1 order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct t1 order by 1 separator ' + ') from tab1 group by name;


select name,group_concat(d1 order by 1 desc separator ' + ') from tab1 group by name;

select name,group_concat(distinct d1 order by 1 separator ' + ') from tab1 group by name;



select name,group_concat(d2 order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct d2 order by 1 separator ' + ') from tab1 group by name;



select name,group_concat(t2 order by 1 separator ' + ') from tab1 group by name;

select name,group_concat(distinct t2 order by 1 separator ' + ') from tab1 group by name;


drop table tab1;

