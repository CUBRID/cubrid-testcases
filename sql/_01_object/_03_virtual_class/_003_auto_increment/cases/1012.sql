-- create vclass for created class with threee int auto_increment field,insert data to this class,select data from this class,drop class

create class xoo ( id int auto_increment ,
		   id2 int auto_increment,
		   id3 int auto_increment,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;
create vclass vxoo (
	id int, 
	id2 int,
	id3 int,
	title varchar(100)
) as select * from xoo;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo;
