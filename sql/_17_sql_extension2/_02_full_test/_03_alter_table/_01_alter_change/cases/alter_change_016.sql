--change the type of a set(int) column to other types

create class coo(
        col1 set(int),
        col2 set(int),
        col3 set(int),
        col4 set(int),
        col5 set(int),
        col6 set(int),
        col7 set(int),
        col8 set(int),
        col9 set(int),
        col10 set(int),
        col11 set(int),
        col12 set(int),
        col13 set(int),
        col14 set(int),
        col15 set(int),
        col16 set(int),
        col17 set(int),
        col18 set(int),
        col19 set(int),
	col20 set(int)
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values({22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, 
	{22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33}, {22,33});

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values({19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, 
	{19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58}, {19,58});

show columns in coo;

alter table coo change col1 aaa char(20);
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
alter table coo change col14 nnn timestamp;
select nnn from coo order by 1;
--change to the same type
alter table coo change col15 ooo set(int);
select ooo from coo order by 1;
alter table coo change col16 ppp multiset(int);
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


