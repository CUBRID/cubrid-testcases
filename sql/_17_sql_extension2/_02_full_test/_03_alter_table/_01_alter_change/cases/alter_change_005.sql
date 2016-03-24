--change the type of  a bit(n) column to other types

create class coo(
        col1 bit(20),
        col2 bit(20),
        col3 bit(20),
        col4 bit(20),
        col5 bit(20),
        col6 bit(20),
        col7 bit(20),
        col8 bit(20),
        col9 bit(20),
        col10 bit(20),
        col11 bit(20),
        col12 bit(20),
        col13 bit(20),
        col14 bit(20),
        col15 bit(20),
        col16 bit(20),
        col17 bit(20),
        col18 bit(20),
        col19 bit(20),
        col20 bit(20),
        col21 bit(20)
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21)
 values(B'1011', B'1000', B'1001', B'1010', B'0001', B'0011', B'0101', B'11110', B'1110', B'1111', B'10111', B'1101', B'10101', B'11001', B'11011', B'11111', B'10010', B'10101', B'11101', B'1001', B'10011');

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21)
 values(B'1000', B'1001', B'1010', B'0001', B'0011', B'0101', B'11110', B'1110', B'1111', B'10111', B'1101', B'10101', B'11001', B'11011', B'11111', B'10010', B'10101', B'11101', B'1001', B'10011', B'010101');

show columns in coo;

alter table coo change col1 aaa char(20);

alter table coo change col2 bbb nchar(20);
select bbb from coo order by 1;
alter table coo change col3 ccc nchar varying(20);
select ccc from coo order by 1;

--change to the same type
alter table coo change col4 ddd bit(8);
select ddd from coo order by 1;
alter table coo change col5 eee bit varying(8);
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


