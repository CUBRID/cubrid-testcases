--change the type of a multiset column to other types

create class coo(
        col1 multiset,
        col2 multiset,
        col3 multiset,
        col4 multiset,
        col5 multiset,
        col6 multiset,
        col7 multiset,
        col8 multiset,
        col9 multiset,
        col10 multiset,
        col11 multiset,
        col12 multiset,
        col13 multiset,
        col14 multiset,
        col15 multiset,
        col16 multiset,
        col17 multiset,
        col18 multiset,
        col19 multiset,
	col20 multiset
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values({22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, 
	{22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44}, {22, 33, 44});

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values({100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, 
	{100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300}, {100, 200, 300});

show columns in coo;

alter table coo change col1 aaa char(20);
select * from coo order by 1;
alter table coo change col2 bbb nchar(20);
select * from coo order by 1;
alter table coo change col3 ccc nchar varying(20);
select * from coo order by 1;
alter table coo change col4 ddd bit(100);
select * from coo order by 1;
alter table coo change col5 eee bit varying(100);
select * from coo order by 1;
alter table coo change col6 fff numeric;
select * from coo order by 1;
alter table coo change col7 ggg integer;
select * from coo order by 1;
alter table coo change col8 hhh smallint;
select * from coo order by 1;
alter table coo change col9 iii monetary;
select * from coo order by 1;
alter table coo change col10 jjj float;
select * from coo order by 1;
alter table coo change col11 kkk double;
select * from coo order by 1;
alter table coo change col12 lll date;
select * from coo order by 1;
alter table coo change col13 mmm time;
select * from coo order by 1;
alter table coo change col14 nnn timestamp;
select * from coo order by 1;
alter table coo change col15 ooo set;
select * from coo order by 1;
alter table coo change col16 ppp multiset;
select * from coo order by 1;
--change to the same type
alter table coo change col17 qqq sequence;
select * from coo order by 1;
alter table coo change col18 rrr blob;
select * from coo order by 1;
alter table coo change col19 sss clob;
select * from coo order by 1;
alter table coo change col20 ttt datetime;
select * from coo order by 1;

show columns in coo;

delete from coo;
drop table coo;


