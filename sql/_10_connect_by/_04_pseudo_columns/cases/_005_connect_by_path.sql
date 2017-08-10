--+ holdcas on;
create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
	from tree
	where sys_connect_by_path(text,'/') LIKE '%A'
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by sys_connect_by_path(text,'/') desc,id;

select sys_connect_by_path(id,'\') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

set system parameters 'compat_mode=mysql';
select sys_connect_by_path(id,'\\') as [path]
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;
set system parameters 'compat_mode=cubrid';

select id, sys_connect_by_path(trim(text),'/') from tree
start with parentid is null
connect by prior to_char(id)=to_char(parentid)
order by id;

drop table tree;
commit;
--+ holdcas off;
