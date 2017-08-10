create table tree(id int not null, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAB');

create table tree2(id int not null, parentid int, text varchar(32));

insert into tree2 values(1,null,'A');
insert into tree2 values(2,null,'B');
insert into tree2 values(3,1,'AA');
insert into tree2 values(4,1,'AB');
insert into tree2 values(5,2,'BA');
insert into tree2 values(6,2,'BB');
insert into tree2 values(7,3,'AAB');

rename tree to tree2;
rename tree to tree1;
rename tree1 to tree3,tree2 to tree4;
rename tree3 to tree4,tree4 to tree5;

drop table tree3;
drop table tree4;
drop table tree;
drop table tree2;
drop table tree5;
