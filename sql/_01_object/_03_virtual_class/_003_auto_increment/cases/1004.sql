--[er]create vclass for created class with condition 'int auto_increment shared',that is an error for sharing the auto_increment field's value

create class xoo ( id int auto_increment shared,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;
create vclass vxoo (
	id int, 
	title varchar(100)
) as select * from xoo;

select * from vxoo;

drop vclass vxoo;
drop class xoo;