

--insert data with all data type including blob&clob
drop table if exists lprocess2_tb;
create table lprocess2_tb(
        id int primary key not null auto_increment,
        groupid int ,
        groupid1 int ,
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

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(1,1,'aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(1,2,'bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(1,1,null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(1,2,null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(1,1,'ccc', n'ccc', n'cccc', b'1111', b'1011', 23, 24, 25, 26, 27, 28, '5/7/2011', '8:41:22 pm', '05/20/1985 8:16:00 pm', {11, 22,23}, {'ghj','yut','yuta'}, {70,80,90,100}, bit_to_blob(B'1110001011'), char_to_clob('astring'));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(1,2,'ddd', n'ddd', n'dddd', b'11111', b'11011', 22, 34, 35, 36, 37, 38, '5/21/2011', '9:41:22 pm', '05/20/1984 8:16:00 pm', {11, 22,23,24}, {'ghj','yut','yuta','ayuta'}, {70,80,90,100,120}, bit_to_blob(B'11100010111'), char_to_clob('bstring'));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(2,2,'aaa2', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(2,1,'bbb2', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(2,2,null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(2,1,null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(2,2,'ccc2', n'ccc', n'cccc', b'1111', b'1011', 23, 24, 25, 26, 27, 28, '5/7/2011', '8:41:22 pm', '05/20/1985 8:16:00 pm', {11, 22,23}, {'ghj','yut','yuta'}, {70,80,90,100}, bit_to_blob(B'1110001011'), char_to_clob('astring'));

insert into lprocess2_tb (groupid, groupid1, col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(2,1,'ddd2', n'ddd', n'dddd', b'11111', b'11011', 22, 34, 35, 36, 37, 38, '5/21/2011', '9:41:22 pm', '05/20/1984 8:16:00 pm', {11, 22,23,24}, {'ghj','yut','yuta','ayuta'}, {70,80,90,100,120}, bit_to_blob(B'11100010111'), char_to_clob('bstring'));

--boundary test
--select groupid, col8, first_value(col8) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8,col8) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value((1)) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(0xbb) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(2+1) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(2+1) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(null) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(null+1) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1+null) over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1) over(partition by 1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1) over(partition by 1 order by 1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1) over(partition by 1 order by col8) as ret_val from  lprocess2_tb order by 1,2,3;
--select groupid, col8, first_value(col8) over(partition by 1 order by 1) as ret_val from  lprocess2_tb order by 1,2,3;
--select groupid, col8, first_value(col8) over(partition by 1 order by 1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) over(order by 1,2 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) over(order by col8) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(null+1) respect nulls over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1>1) respect nulls over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1=1) respect nulls over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(1<1) respect nulls over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(max(col8)) respect nulls over() as ret_val from  lprocess2_tb order by 1,2,3;
--select groupid, col8, first_value(abs(groupid)) respect nulls over() as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc,col8 asc, col8 desc, col8 asc, col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) over (partition by groupid,groupid1 order by col8) as ret_val from  lprocess2_tb order by 1,2,3;



--first_value
select groupid, col8, first_value(col8) over(partition by groupid order by col8) as ret_val from lprocess2_tb order by 1,2,3;
select id, col8, first_value(col8) over(order by col8) as ret_val from lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) over(partition by groupid order by col8) as ret_val from  lprocess2_tb where col8 is not null order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8) as ret_val from  lprocess2_tb where col8 is not null order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8) as ret_val from  lprocess2_tb where col8 is not null order by 1,2,3;
select groupid, col8, first_value(col8) over(partition by groupid order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc) as ret_val,first_value(col8)  over(partition by groupid order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 asc) as ret_val, first_value(col8)  over(partition by groupid order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val,first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc) as ret_val,first_value(col8) respect nulls over(partition by groupid order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 asc) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val,first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc) as ret_val,first_value(col8) ignore nulls over(partition by groupid order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 asc) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val,first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

drop table if exists tree;
create table tree as select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc) as ret_val,first_value(col8) ignore nulls over(partition by groupid order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 asc) as ret_val, first_value(col8) ignore nulls over(partition by groupid order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col8, first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val,first_value(col8) ignore nulls over(partition by groupid order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;

select groupid, groupid1, col8, first_value(col8) over(partition by groupid, groupid1 order by col8) as ret_val from lprocess2_tb order by 1,2,3;
select id, col8, first_value(col8) over(order by col8) as ret_val from lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) over(partition by groupid, groupid1 order by col8) as ret_val from  lprocess2_tb where col8 is not null order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8) as ret_val from  lprocess2_tb where col8 is not null order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8) as ret_val from  lprocess2_tb where col8 is not null order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) over(partition by groupid, groupid1 order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc) as ret_val,first_value(col8)  over(partition by groupid, groupid1 order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 asc) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val,first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8)  over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val,first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val,first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) respect nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val,first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val,first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

drop table if exists tree;
create table tree as select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val,first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col8, first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val,first_value(col8) ignore nulls over(partition by groupid, groupid1 order by col8 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;


drop table if exists lprocess2_tb;
