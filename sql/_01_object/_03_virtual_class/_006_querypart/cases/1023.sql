-- create vclass using two queries

create class xoo ( id int auto_increment , title varchar(100));
create unique index uni_id on xoo (id);

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');

create vclass vxoo (
	id int, 
	title varchar(100)
) as select id,title from xoo WHERE id=1 UNION ALL SELECT * FROM xoo WHERE id=2;

create vclass vxoo1 (
	id int, 
	title varchar(100)
) as select * FROM vxoo WHERE id=1 UNION ALL select * FROM vxoo WHERE id=2;

select * from vxoo1;
drop vclass vxoo;
drop vclass vxoo1;

drop class xoo;