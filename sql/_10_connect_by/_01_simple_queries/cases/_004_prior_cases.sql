--+ holdcas on;
create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');

select id,parentid,text,prior id as "prior_id"
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;
	
select id,parentid,text
	from tree
	where prior id is null
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by prior id,id;

select id,parentid,text,prior length(text) as "prior_length"
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,prior (id+1) as "prior_id"
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

select id,parentid,text,prior (id || ' ' || text) as "prior_expr"
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';

select id,parentid,text,prior (concat(id, ' ', text)) as "prior_expr"
	from tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

set system parameters 'ansi_quotes=no';
set system parameters 'compat_mode=cubrid';

drop table tree;
commit;
--+ holdcas off;
