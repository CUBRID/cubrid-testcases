--[er]type of vclass's column with mismatched column type
create class xoo ( id int auto_increment , title varchar(100));
create unique index uni_id on xoo (id);

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

create vclass vxoo (
	id string, 
	title varchar(100)
) as select * from xoo;

select * from vxoo;
drop vclass vxoo;

drop class xoo;
