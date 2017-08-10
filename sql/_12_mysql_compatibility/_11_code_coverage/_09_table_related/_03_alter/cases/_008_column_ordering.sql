create table tree(id_3 int);
insert into tree values (1);

alter table tree add column id_1 int first, add column id_2 int after id_1;

select * from tree;

drop table tree;
