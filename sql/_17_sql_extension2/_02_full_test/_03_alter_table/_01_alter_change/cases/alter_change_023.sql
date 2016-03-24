--+ holdcas on;
--change column with constraints


create table coo(col1 int primary key, col2 char(5), col3 datetime, col4 set);

insert into coo values(1, 'abc', datetime'2010-11-19 15:01:12.222', {1,2,3});
insert into coo values(2, 'abc', datetime'1989-10-23 22:32:12.534', {5,6,7});
insert into coo values(10, 'ghij', datetime'3/12/2150 10:10:10.111', {'a','b','c'});

select * from coo order by 1;

--[er]
insert into coo(col1) values(2);


--??, change the primary key column to not null (succeed, but pk will remain in mysql)
alter table coo change col1 col5 int not null;
--??
insert into coo(col5) values(2);


--[er] change col2 which has duplicate values to unique
alter table coo change col2 col1 char(5) unique first;


--?? column size shortening that will cause loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col1 char(1) first;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col1 char(1) first;
select * from coo order by 1,2,3;


--?? change datetime column to primary key
alter table coo change col3 col3 datetime primary key unique not null;
--change datetime column to a column with default value
alter table coo change col3 col10 datetime not null default '2010-11-19 15:01:12.333' after col1;
insert into coo(col5) values(20);
select * from coo order by 1,2,3;
show columns in coo;


alter table coo change col4 col22 sequence(int) shared {11,22,33};
select * from coo order by 1,2,3;
insert into coo(col5, col22) values(30, {444, 666, 888});
select * from coo order by 1,2,3;
show columns in coo;


drop table coo;






commit;
--+ holdcas off;
