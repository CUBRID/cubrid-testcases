-- create a class with a numeric type - (p.0) auto_increment field and retrieve info from db_attribute

create class xoo ( id numeric(10,0) auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;
select * from db_attribute
where  class_name = 'xoo' order by 1;
drop class xoo;
