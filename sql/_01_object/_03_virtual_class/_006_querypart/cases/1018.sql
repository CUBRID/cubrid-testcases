-- create vclass using 10 queries

create class xoo ( id int auto_increment , title varchar(100));
create unique index uni_id on xoo (id);

insert into xoo(title) values ('aaa');
insert into xoo(title) values ('bbb');
insert into xoo(title) values ('ccc');
insert into xoo(title) values ('ccc1');
insert into xoo(title) values ('ccc2');
insert into xoo(title) values ('ccc3');
insert into xoo(title) values ('ccc4');
insert into xoo(title) values ('ccc5');
insert into xoo(title) values ('ccc6');
insert into xoo(title) values ('ccc7');
insert into xoo(title) values ('ccc8');
insert into xoo(title) values ('ccc9');
insert into xoo(title) values ('ccc0');
insert into xoo(title) values ('ccc-');
insert into xoo(title) values ('ccc0=');
insert into xoo(title) values ('ccc-=');

create vclass vxoo (
	id int, 
	title varchar(100)
) as 
select * from xoo WHERE id=1 UNION ALL 
select * from xoo WHERE id=2 UNION ALL 
SELECT * FROM xoo WHERE id=3 UNION ALL 
SELECT * FROM xoo WHERE id=4 UNION ALL 
SELECT * FROM xoo WHERE id=5 UNION ALL 
SELECT * FROM xoo WHERE id=6 UNION ALL 
SELECT * FROM xoo WHERE id=7 UNION ALL 
SELECT * FROM xoo WHERE id=8 UNION ALL 
SELECT * FROM xoo WHERE id=9 UNION ALL 
SELECT * FROM xoo WHERE id=10 UNION ALL 
SELECT * FROM xoo WHERE id=11 ;

select * from vxoo;
drop vclass vxoo;

drop class xoo;