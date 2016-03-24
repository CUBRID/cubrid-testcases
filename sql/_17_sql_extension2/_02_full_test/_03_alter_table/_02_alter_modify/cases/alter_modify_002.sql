--+ holdcas on;
--modify a column with constraints


create class coo(
        col1 char(20),
        col2 nchar(20),
        col3 nchar varying(20),
        col4 bit(8),
        col5 bit varying(8),
        col6 numeric,
        col7 integer primary key,
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

show columns in coo;

insert into coo(col1, col7) values(null, 111);
--change a column with not null constraint when there is already a null value in the field. 
set system parameters 'alter_table_change_type_strict=yes';   
alter table coo modify col1 char(20) not null;
set system parameters 'alter_table_change_type_strict=no';   
alter table coo modify col1 char(20) not null;
show columns in coo;
--error
--insert into table coo(col2) values('aaa');

insert into coo(col1, col4, col7) values('ccc', b'0011', 222);
--change a column with unique constraint when there are already duplicated values in the field.
alter table coo modify col4 bit varying(10) unique;
show columns in coo;
--error
--insert into table coo(col1, col4) values ('abc', b'1011');

--primary key
alter table coo modify col8 bigint primary key;
show columns in coo;
--insert into coo(col1) values ('primary key added');
select count(*) from coo;


delete from coo;
drop table coo;


commit;
--+ holdcas off;
