--+ holdcas on;
--not null related change


create table coo(col1 int not null, col2 char(20) not null, col3 bit(10));

insert into coo values(10, 'aaa', B'10101');
insert into coo values(20, 'bbb', null);


--not null -> none
alter table coo change col1 col1 int after col3;
insert into coo(col2) values('ccc');
select * from coo order by 1;

--not null -> not null
alter table coo change col2 col2 char(20) not null after col1;
--[er]
insert into coo(col2) values(null);
select * from coo order by 1,2;

--none -> not null
set system parameters 'alter_table_change_type_strict=yes';
--[er]
alter table coo change col3 col3 bit(10) not null after col2;
alter table coo change col3 col3 char(10) not null after col2;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 bit(10) not null after col2;
select * from coo order by 1;
insert into coo(col2) values('ddd');


select * from coo order by 1;

drop table coo;



commit;
--+ holdcas off;
