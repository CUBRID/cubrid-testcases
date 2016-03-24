--+ holdcas on;
--primary key (on the single column) related change


create table coo(col1 time primary key, col2 monetary, col3 nchar varying(20));
insert into coo values(time'22:22:22 PM', 234.55, n'aaa');
insert into coo values(time'23:23:23 PM', 523423.32, n'bbb');
insert into coo values(time'11:11:11 PM', 2342.22, n'ccc');

select * from coo order by 1;


--primary key -> primary key
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col1 col4 time primary key;
alter table coo change col4 col4 string primary key;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col5 time primary key after col3;
alter table coo change col5 col4 string primary key;
insert into coo values(234.342, n'bbb', '10:10:10 am');
show columns in coo;

--primary key -> no primary key
alter table coo change col4 col4 string;
show columns in coo;
--[er] primary key maintained, can't be created
alter table coo change col3 col3 nchar varying(20) primary key;


--no primary key -> primary key
alter table coo drop primary key;
show columns in coo;
--1. normal change
alter table coo change col2 col2 monetary primary key;
show columns in coo;
alter table coo drop primary key;
--2. when there are duplicated values in the column
set system parameters 'alter_table_change_type_strict=yes';
--[er]
alter table coo change col3 col3 nchar varying(20) primary key first;
set system parameters 'alter_table_change_type_strict=no';
--??
alter table coo change col3 col3 nchar varying(20) primary key first;

insert into coo values(23456.756756, n'ddd', '2:2:2');

select * from coo order by 1,2;


drop table coo;

commit;
--+ holdcas off;
