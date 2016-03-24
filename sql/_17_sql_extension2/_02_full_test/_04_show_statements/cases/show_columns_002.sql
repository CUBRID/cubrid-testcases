--show columns with constraints.

create table too(a char(20) not null primary key, b int);
create class coo(
        col1 char(20) not null foreign key references too(a),
        col2 nchar(20) default n'nchar default',
        col3 nchar varying(20) unique default n'varchar default',
        col4 bit(8) shared B'1010101',
        col5 bit varying(8),
        col6 numeric,
        col7 integer primary key auto_increment,
        col8 smallint unique,
        col9 monetary default 100,
        col10 float,
        col11 double not null,
        col12 date,
        col13 time,
        col14 timestamp not null,
        col15 set,
        col16 multiset,
        col17 sequence default {1, 2, 3},
        col18 blob,
        col19 clob
);

insert into too values('aaa', 111), ('bbb', 222), ('ccc', 3);
insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

show columns in coo;
show columns from coo where `Field`='col1';
show columns from coo where `Type`='BLOB';
show columns from coo where `Null`='NO';
show columns from coo where `Key`='PRI'; 
show columns from coo where `Key`='UNI'; 
show columns from coo where `Key`='MUL';
show columns from coo where `Default`='100';
show columns from coo where `Extra`='auto_increment'; 


alter table coo change col10 col100 float unique;
alter table coo drop column col12, col15;
 
show columns from coo;

delete from coo;
drop table coo;
drop table too;

--error
show columns from coo;


