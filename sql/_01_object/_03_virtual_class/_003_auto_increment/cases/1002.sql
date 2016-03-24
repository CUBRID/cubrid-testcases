--[er]create vclass for created class using a int data type auto_increment(2,-1) constraint,that is an error,Increase value of an auto increment constraint should be greater than 0

create class xoo ( id int auto_increment(2,-1) , title varchar(100));

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