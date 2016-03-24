--[er]type of vclass's column and type of querypart's column are different.
create class xoo ( id int auto_increment , title varchar(100));
create unique index uni_id on xoo (id);

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

create vclass vxoo (
	id int, 
	title varchar(100)
) as select title, id from xoo;

create vclass vxoo1 (
	id int, 
	title varchar(100)
) as select title, id from vxoo;


select * from vxoo;
drop vclass vxoo;
drop vclass vxoo1;

drop class xoo;
