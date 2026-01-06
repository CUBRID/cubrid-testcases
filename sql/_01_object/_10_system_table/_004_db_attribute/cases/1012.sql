-- create class and retrieve infomation from db_attribute

create class xoo ( id int auto_increment , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute
where  class_name = 'xoo' order by 1;
select * from xoo order by 1;

insert into xoo(title) select title from xoo where id = 1;

select * from xoo order by 1;

drop class xoo;
