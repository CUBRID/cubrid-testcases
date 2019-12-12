create table tree(id int not null, parentid int, text clob);

insert into tree values(1,null,char_to_clob('A'));
insert into tree values(2,null,char_to_clob('B'));
insert into tree values(3,1,char_to_clob('AA'));
insert into tree values(4,1,char_to_clob('AB'));
insert into tree values(5,2,char_to_clob('BA'));
insert into tree values(6,2,char_to_clob('BB'));
insert into tree values(7,3,char_to_clob('AAB'));

create table tree2 like tree;
select * from db_attribute where class_name='tree2' order by attr_name asc;
select * from tree2;

delete from tree;
drop tree;
drop tree2;

