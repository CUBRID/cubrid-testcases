--class hierachy related change, inheritance properties


--super class
create table coo(col1 int unique, col2 varchar not null, col3 set default {1,2,3});

insert into coo values(1, 'aaa', {2, 5, 7});
insert into coo values(20, 'ddd', {4, 7, 9, 3});
insert into coo(col1, col2) values(63, 'rrr');

--create class with inheritance properties
create class 
inherit col1 of coo, col2 of coo as sub_coo;
insert into sub_coo(col1, col2) values(63, 'rrr');
insert into sub_coo values(20, 'ddd');
select * from sub_coo order by 1;


--[er] change column of a superclass
alter table coo change col1 col8 int unique;

--[er] change inherit property
alter table sub_coo change col1 col111 int not null;
alter table sub_coo change col2 col2 char(20);


drop table coo;
drop table sub_coo;

drop table if exists sub_coo;
drop table if exists coo;

