--  create vclass for created  class with condition of 'auto_increment(-100,2 , title varchar(100))',that is an error
create class xoo ( id int auto_increment(-100,2) , title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;
create vclass vxoo (
	id int, 
	title varchar(100)
) as select * from xoo;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo;
