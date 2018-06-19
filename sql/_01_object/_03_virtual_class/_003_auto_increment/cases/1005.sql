--[er]create vclass for created class with condition 'int not null auto_increment ',that is an error for setting the auto_increment field's value to be not null before the auto_increment

create class xoo ( id int not null auto_increment ,
                   title varchar(100));

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
