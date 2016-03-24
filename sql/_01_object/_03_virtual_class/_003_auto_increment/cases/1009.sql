-- create vclass for created  class with int  auto_increment primary key  field,insert data to this class,select data,insert data by specifying the auto_increment field's value,select data ,insert data to this class,drop class

create class xoo ( id int  auto_increment primary key  ,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;


insert into xoo(id, title) values (5, 'ddd');

select * from xoo order by 1;

insert into xoo(title) values ('eee');

select * from xoo order by 1;
create vclass vxoo (
	id int, 
	title varchar(100)
) as select * from xoo;

select * from vxoo order by 1;

drop vclass vxoo;
drop class xoo;