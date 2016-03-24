--create table with auto-increment int type's attriobute and retrieve info from db_attribute

create class xoo ( id int auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

update xoo set title = 'ddd' where title = 'ccc';

select * from xoo order by 1;
select * from db_attribute where class_name = 'xoo' order by 1;

drop class xoo;
