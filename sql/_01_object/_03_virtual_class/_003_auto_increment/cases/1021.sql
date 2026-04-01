-- create vclass for created class with int data type auto_increment field,insert data to this class,select data from this class,insert data to this class by specify the auto_increment field,select data from this class,drop class 


create class xoo ( id int auto_increment ,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, title) values (10,'qqq');
insert into xoo(id, title) values (11,'www');
insert into xoo(id, title) values (12,'eee');

select * from xoo order by 1;

insert into xoo(title) values ('ddd');

select * from xoo order by 1;
create vclass vxoo (
	id int, 
	title varchar(100)
) as select * from xoo;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo;
