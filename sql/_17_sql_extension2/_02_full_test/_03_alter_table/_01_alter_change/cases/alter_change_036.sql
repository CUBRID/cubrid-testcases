--class hierachy related change, superclass


--super class
create table coo(col1 int unique, col2 varchar not null, col3 set default {1,2,3});

insert into coo values(1, 'aaa', {2, 5, 7});
insert into coo values(20, 'ddd', {4, 7, 9, 3});
insert into coo(col1, col2) values(63, 'rrr');

--create subclass
create class sub_coo under coo;
insert into sub_coo(col1, col2) values(11, 'rrr');
insert into sub_coo values(21, 'ddd', {4, 7, 9, 3});
select * from sub_coo order by 1;

--create sub-subclass
create class sub_sub_coo under sub_coo;
insert into sub_sub_coo values(22, 'ddd', {4, 7, 9, 3});
select * from sub_sub_coo order by 1;


--[er] change column of a superclass
alter table coo change col1 col8 int unique;

--[er] change column of a class which are both super and sub classes
alter table sub_coo change col2 col2 char(20);

--[er] change column of a class with no subclasses
alter table sub_sub_coo change col3 col5 multiset default{2,3,4};
insert into sub_sub_coo(col1, col2) values(55, 'fff');

select * from sub_sub_coo order by 1;


drop table coo;
drop table sub_coo;
drop table sub_sub_coo;

drop table if exists sub_coo;
drop table if exists sub_sub_coo;

