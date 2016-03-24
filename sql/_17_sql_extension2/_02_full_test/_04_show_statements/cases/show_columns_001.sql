--table with all supported types.
--Show columns after changing column types.

create class coo(
        col1 char(20),
        col2 nchar(20),
        col3 nchar varying(20),
        col4 bit(8),
        col5 bit varying(8),
        col6 numeric,
        col7 integer,
        col8 smallint,
        col9 monetary,
        col10 float,
        col11 double,
        col12 date,
        col13 time,
        col14 timestamp,
        col15 set,
        col16 multiset,
        col17 sequence,
        col18 blob,
        col19 clob
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

show columns from coo;

alter table coo change col1 aaa char(20);
alter table coo change col2 bbb nchar(20);
alter table coo change col3 ccc nchar varying(20);
alter table coo change col4 ddd bit(8);
alter table coo change col5 eee bit varying(8);
alter table coo change col6 fff numeric;
alter table coo change col7 ggg integer;
alter table coo change col8 hhh smallint;
alter table coo change col9 iii monetary;
alter table coo change col10 jjj float;
alter table coo change col11 kkk double;
alter table coo change col12 lll date;
alter table coo change col13 mmm time;
alter table coo change col14 nnn timestamp;
alter table coo change col15 ooo set;
alter table coo change col16 ppp multiset;
alter table coo change col17 qqq sequence;
alter table coo change col18 rrr blob;
alter table coo change col19 sss clob;

show columns from coo;

delete from coo;
drop table coo;


