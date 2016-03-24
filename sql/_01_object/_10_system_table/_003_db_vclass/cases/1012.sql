--create vclass with different column name and retrieve infomation from db_vclass
create class xoo ( id int auto_increment , title varchar(100));
create unique index uni_id on xoo (id);

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

create vclass vxoo (
	id int, 
	title varchar(100)
) as select * from xoo;

select * from vxoo order by 1,2;
drop vclass vxoo;

create vclass vxoo (
	vid int, 
	vtitle varchar(100)
) as select id, title from xoo;

select * from vxoo order by 1,2;
select * from db_vclass where vclass_name = 'vxoo';
drop vclass vxoo;

drop class xoo;
