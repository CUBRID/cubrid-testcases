--change the type of a timestamp column to other types

create class coo(
        col1 timestamp,
        col2 timestamp,
        col3 timestamp,
        col4 timestamp,
        col5 timestamp,
        col6 timestamp,
        col7 timestamp,
        col8 timestamp,
        col9 timestamp,
        col10 timestamp,
        col11 timestamp,
        col12 timestamp,
        col13 timestamp,
        col14 timestamp,
        col15 timestamp,
        col16 timestamp,
        col17 timestamp,
        col18 timestamp,
        col19 timestamp,
	col20 timestamp
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values('1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', 
	'1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am', '1/1/2008 10:35:44 am');

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values('9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', 
	'9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22', '9/28/2010 20:22:22');

show columns in coo;

alter table coo change col1 aaa char(23);
select aaa from coo order by 1;
alter table coo change col2 bbb nchar(20);
select bbb from coo order by 1;
alter table coo change col3 ccc nchar varying(20);
select ccc from coo order by 1;
alter table coo change col4 ddd bit(100);
select ddd from coo order by 1;
alter table coo change col5 eee bit varying(100);
select eee from coo order by 1;
alter table coo change col6 fff numeric;
select fff from coo order by 1;
alter table coo change col7 ggg integer;
select ggg from coo order by 1;
alter table coo change col8 hhh smallint;
select hhh from coo order by 1;
alter table coo change col9 iii monetary;
select iii from coo order by 1;
alter table coo change col10 jjj float;
select jjj from coo order by 1;
alter table coo change col11 kkk double;
select kkk from coo order by 1;
alter table coo change col12 lll date;
select lll from coo order by 1;
alter table coo change col13 mmm time;
select mmm from coo order by 1;
--change to the same type
alter table coo change col14 nnn timestamp;
select nnn from coo order by 1;
alter table coo change col15 ooo set;
select ooo from coo order by 1;
alter table coo change col16 ppp multiset;
select ppp from coo order by 1;
alter table coo change col17 qqq sequence;
select qqq from coo order by 1;
alter table coo change col18 rrr blob;
select rrr from coo order by 1;
alter table coo change col19 sss clob;
select sss from coo order by 1;
alter table coo change col20 ttt datetime;
select ttt from coo order by 1;

show columns in coo;

delete from coo;
drop table coo;


