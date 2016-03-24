--[er]create vclass for created class with 'int auto_increment default 10' field,that is an error,expecting Right_Paren in create class statement

create class xoo ( id int auto_increment default 10 ,
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