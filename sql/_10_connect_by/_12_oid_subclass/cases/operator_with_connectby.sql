--+ holdcas on;
CREATE TABLE tree(ID INT, ParentID INT, text VARCHAR(32));
create table tree1 under tree;
create table tree2 under tree;
create table tree3 under tree2;

INSERT INTO tree1 VALUES(1,NULL,'A');
INSERT INTO tree2 VALUES (2,NULL,'B');
INSERT INTO tree1 VALUES (3,1,'AA');
INSERT INTO tree2 VALUES (4,1,'AB');
INSERT INTO tree1 VALUES (5,2,'BA');
INSERT INTO tree2 VALUES (6,2,'BB');
INSERT INTO tree3 VALUES (7,6,'BBA');

select id || level , parentid, text, level - 2
	from all tree
	where level< 3 
	start with parentid is null
	connect by prior id= to_number(trim(to_char(parentid)))
	order by id;

set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';

select concat(id, level) , parentid, text, level - 2
	from all tree
	where level< 3 
	start with parentid is null
	connect by prior id= to_number(trim(to_char(parentid)))
	order by id;

set system parameters 'ansi_quotes=no';
set system parameters 'compat_mode=cubrid';

select id, parentid, text, to_char(level) + '000'
	from all tree
	where level< 3 and id > 2
	start with parentid is null
	connect by prior id= to_number(trim(to_char(parentid)))
	order by id;

select id, parentid, text, to_char(level)
	from all tree
	where level< 3 
	start with parentid is null
	connect by prior id= to_number(trim(to_char(parentid)))
difference
select id, parentid, text, to_char(level)
	from all tree
	where level< 3 
	start with parentid is null
	connect by prior id= to_number(trim(to_char(parentid)))
	order by id;

select x.id , y.id
from tree x, (
    select id, parentid, text, to_char(level) + '000'
	from all tree
	where level< 3 and id > 2
	start with parentid is null
	connect by prior id= to_number(trim(to_char(parentid)))
	order by id
    ) y
where x.id = y.id;

drop tree, tree1, tree2, tree3;


commit;
--+ holdcas off;
