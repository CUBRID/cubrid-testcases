--change multiple columns in one statement


create class coo(
        col1 char(20),
        col2 char(20),
        col3 char(20),
        col4 char(20),
        col5 char(20),
        col6 char(20),
        col7 char(20),
        col8 char(20),
        col9 char(20),
        col10 char(20),
        col11 char(20),
        col12 char(20),
        col13 char(20),
        col14 char(20),
        col15 char(20),
        col16 char(20),
        col17 char(20),
        col18 char(20),
        col19 char(20),
	col20 char(20)
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values('aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg', 'hhh', 'iii', 'jjj', 'kkk', 'lll', 'mmm', 'nnn', 'ooo', 'ppp', 'qqq', 'rrr', 'sss', 'ttt');

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values('bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg', 'hhh', 'iii', 'jjj', 'kkk', 'lll', 'mmm', 'nnn', 'ooo', 'ppp', 'qqq', 'rrr', 'sss', 'ttt', 'uuu');

show columns in coo;

--change to the same type
alter table coo change col1 aaa char(20), change col2 bbb nchar(20);
select col1, col2 from coo order by 1;

alter table coo change col3 ccc nchar varying(20);
select col3 from coo order by 1;

alter table coo change col4 ddd bit(8), change col5 eee bit varying(8);
select col4, col5 from coo order by 1;

alter table coo change col6 fff numeric, change col7 ggg integer primary key;
select col6, col7 from coo order by 1;

alter table coo change col8 hhh smallint not null, change col9 iii monetary, change col10 jjj float default 10.01;
select hhh, iii, jjj from coo order by 1;

alter table coo change col11 kkk double unique, change col12 lll date;
select col11, col12 from coo order by 1;

alter table coo change col13 mmm time, change col14 nnn timestamp not null;
select mmm, nnn from coo order by 1;

alter table coo change col15 ooo set, change col16 ppp multiset, change col17 qqq sequence, change col18 rrr blob, change col19 sss clob;
select col15, col16, col17, col18, col19 from coo order by 1;

--change the same column twice in one statement
alter table coo change col20 sss varchar, change col20 ttt varchar(100);
select * from coo order by 1;

show columns in coo;

delete from coo;
drop table coo;


