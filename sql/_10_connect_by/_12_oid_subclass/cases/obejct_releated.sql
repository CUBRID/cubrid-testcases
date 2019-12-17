--+ holdcas on;
CREATE TABLE tree2 (a int, text VARCHAR(32));
alter class tree2 add attribute id tree2;
alter class tree2 add attribute parentid tree2;

insert into tree2(a,id, parentid, text) values (1, null, null, 'A') into oidx;
update tree2 set id = oidx where a =1;
insert into tree2(a,id, parentid, text) values (2, null, (select tree2 from tree2 where a=1), 'AB') into oid1;
update tree2 set id = oid1 where a =2;
insert into tree2(a,id, parentid, text) values (3, null, (select tree2 from tree2 where a=2), 'ABC') into oid1;
update tree2 set id = oid1 where a =3;

select a, text, sys_connect_by_path(text,'/')
from tree2
start with parentid is null
connect by prior id=parentid
order by a;

select a, text, sys_connect_by_path(text,'/')
from tree2
start with parentid = oidx
connect by prior id=parentid
order by a;

select a, text, sys_connect_by_path(text,'/')
from tree2
start with parentid is null
connect by id=parentid
order by a;

drop tree2

CREATE TABLE tree(ID INT, ParentID INT, text VARCHAR(32));

INSERT INTO tree VALUES (2,NULL,'B');
INSERT INTO tree VALUES (6,2,'BB');
INSERT INTO tree VALUES (7,6,'BBA');

select id, parentid, sys_connect_by_path(text,'/')
	from tree
        start with parentid is null
	connect by prior id=parentid
	order by id;

drop tree;

--+ holdcas off;
