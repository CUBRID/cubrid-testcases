create table tree(id int auto_increment, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree(parentid,text) values(null,'B');

select * from tree order by 1,2,3;

insert into tree(parentid,text) values(null,'C');
select * from tree order by 1,2,3;

insert into tree(text) values('AA');

select * from tree order by 1,2,3;

alter table tree add column idx int first;

select * from tree order by 1,2,3,4;

alter table tree drop column idx, rename to tree2;

select * from tree order by 1,2,3;
select * from tree2 order by 1,2,3;

drop table tree;
drop table tree2;
