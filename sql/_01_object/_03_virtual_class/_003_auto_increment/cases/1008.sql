--[er]create vclass for created create which insert data to this class,insert data,cause one or more unique constraint violations

create class xoo ( id int  auto_increment unique  ,
                   title varchar(100));

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

select * from xoo order by 1;

insert into xoo(id, title) values (4,'ddd');

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