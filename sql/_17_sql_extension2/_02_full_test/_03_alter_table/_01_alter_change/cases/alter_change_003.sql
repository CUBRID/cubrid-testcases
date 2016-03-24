--change the type of  a nchar(n) column to other types
--+ holdcas on;
create class coo(
        col1 nchar(20),
        col2 nchar(20),
        col3 nchar(20),
        col4 nchar(20),
        col5 nchar(20),
        col6 nchar(20),
        col7 nchar(20),
        col8 nchar(20),
        col9 nchar(20),
        col10 nchar(20),
        col11 nchar(20),
        col12 nchar(20),
        col13 nchar(20),
        col14 nchar(20),
        col15 nchar(20),
        col16 nchar(20),
        col17 nchar(20),
        col18 nchar(20),
        col19 nchar(20),
        col20 nchar(20),
        col21 nchar(20)
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21)
 values(n'aaa', n'bbb', n'ccc', n'ddd', n'eee', n'fff', n'ggg', n'hhh', n'iii', n'jjj', n'kkk', n'lll', n'mmm', n'nnn', n'ooo', n'ppp', n'qqq', n'rrr', n'sss', n'ttt', n'uuu');

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21)
 values(n'bbb', n'ccc', n'ddd', n'eee', n'fff', n'ggg', n'hhh', n'iii', n'jjj', n'kkk', n'lll', n'mmm', n'nnn', n'ooo', n'ppp', n'qqq', n'rrr', n'sss', n'ttt', n'uuu', n'vvv');

show columns in coo;

alter table coo change col1 aaa char(20);
--change to the same type
alter table coo change col2 bbb nchar(20);
select bbb from coo order by 1;
alter table coo change col3 ccc nchar varying(20);
select ccc from coo order by 1;
alter table coo change col4 ddd bit(8);
alter table coo change col5 eee bit varying(8);
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
alter table coo change col15 ooo set;
alter table coo change col16 ppp multiset;
alter table coo change col17 qqq sequence;
alter table coo change col18 rrr blob;
alter table coo change col19 sss clob;
alter table coo change col20 ttt varchar;
alter table coo change col21 uuu datetime;
select uuu from coo order by 1;

show columns in coo;

delete from coo;
drop table coo;

--+ holdcas off;
