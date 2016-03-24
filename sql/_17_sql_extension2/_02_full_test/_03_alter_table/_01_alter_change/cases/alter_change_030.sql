--+ holdcas on;
--unique key (on the single column) related change


create table coo(col1 time unique, col2 monetary, col3 nchar varying(20));
insert into coo values(time'22:22:22 PM', 234.55, n'aaa');
insert into coo values(time'23:23:23 PM', 523423.32, n'bbb');
insert into coo values(time'11:11:11 PM', 2342.22, n'ccc');

select * from coo order by 1;


--unique key -> unique key
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col1 col4 time unique;
alter table coo change col4 col4 string unique;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col5 time unique;
alter table coo change col5 col4 string unique;
insert into coo values('10:10:10 am', 234.342, n'bbb');
show columns incoo;

--unique key -> no unique key
alter table coo change col4 col4 string;
--[er]
insert into coo values('11:11:11 PM', 4234.8787, n'ddd'); 

--no unique key -> unique key
--1. normal change
alter table coo change col2 col2 monetary unique;
show columns incoo;
--2. when there are duplicated values in the column
set system parameters 'alter_table_change_type_strict=yes';
--[er]
alter table coo change col3 col3 nchar varying(20) unique first;
set system parameters 'alter_table_change_type_strict=no';
--[er]
alter table coo change col3 col3 nchar varying(20) unique first;

insert into coo values('2:2:2', 23456.756756, n'ddd');

select * from coo order by 1,2;


drop table coo;

commit;
--+ holdcas off;
