create table tree(id int not null, parentid int, text varchar(32));

insert into tree(parentid,text) values(null,'A');
insert into tree values(null,null,'A');
insert into tree values(1,null,'A');

drop table tree;
