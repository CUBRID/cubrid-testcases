--+ holdcas on;
-- misc tests : result truncation

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


set system parameters 'error_log_level=warning';

set system parameters 'group_concat_max_len=20';

select group_concat(t2 order by 1) from tab1 group by i1;

set system parameters 'group_concat_max_len=1024';

select group_concat(t2 order by 1) from tab1 group by i1;

drop table tab1;


create table tab1 (name char varying(20), i int);
insert into tab1 values('gigi',2);
insert into tab1 values('gigi',1);
insert into tab1 values('gogu',3);
insert into tab1 values('gogu',2);
insert into tab1 values('maria',1);
insert into tab1 values('maria',2);
insert into tab1 values('ion',2);
insert into tab1 values('ion',2);
insert into tab1 values('ion',2);

set system parameters 'error_log_level=warning';

set system parameters 'group_concat_max_len=7';

select group_concat(name order by 1) from tab1 group by i;

set system parameters 'group_concat_max_len=1024';

select group_concat(name order by 1) from tab1 group by i;

drop table tab1;


commit;
--+ holdcas off;
