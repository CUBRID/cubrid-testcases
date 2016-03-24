--auto_increment related change


create table coo(col1 int auto_increment, col2 int, col3 float);

insert into coo(col2, col3) values(33, 454.22342342);
insert into coo(col2, col3) values(44, 23784.23423);
insert into coo(col2, col3) values(55, 237431.21312);


--auto_increment -> auto_increment
alter table coo change col1 col1 bigint auto_increment not null after col3;
insert into coo(col2, col3) values(66, 234.23423424232);
select * from coo order by 1;

--auto_increment -> none
alter table coo change col1 col1 bigint not null first;

--none -> auto_increment
alter table coo change col2 col2 smallint auto_increment;
insert into coo(col1, col3) values(10, 232.2998988);
insert into coo(col1, col3) values(10, 232.2998988);
insert into coo(col1, col3) values(10, 232.2998988);
select * from coo order by 1,2;

--[er]
alter table coo change col3 col3 float auto_increment;


drop table coo;
