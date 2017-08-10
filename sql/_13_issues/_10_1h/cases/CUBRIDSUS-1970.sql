CREATE TABLE tree(ID INT, ParentID INT, text VARCHAR(32));

INSERT INTO tree VALUES(1,NULL,'A');
INSERT INTO tree VALUES (2,1,'B');
INSERT INTO tree VALUES (3,2,'AA');
INSERT INTO tree VALUES (4,3,'AB');
INSERT INTO tree VALUES (5,4,'BA');
INSERT INTO tree VALUES (6,5,'BB');
INSERT INTO tree VALUES (7,6,'BBA');

insert into tree select id + 7, parentid + 7, 'x' from tree;
insert into tree select id + 14, parentid + 14, 'x' from tree;
insert into tree select id + 28, parentid + 28, 'x' from tree;
insert into tree select id + 56, parentid + 56, 'x' from tree;
insert into tree select id + 112, parentid + 112, 'x' from tree;
insert into tree select id + 124, parentid + 124, 'x' from tree;
insert into tree select id + 248, parentid + 248, 'x' from tree;
insert into tree select id + 496, parentid + 496, 'x' from tree;
insert into tree select id + 592, parentid + 592, 'x' from tree;
insert into tree select id + 1194, parentid + 1194, 'x' from tree;
insert into tree select id + 2388, parentid + 2388, 'x' from tree;
insert into tree select id + 4776, parentid + 4776, 'x' from tree;

create index i_tree_id  on tree(id);
create index i_tree_parentid  on tree(parentid);


update statistics on tree;

select id,sys_connect_by_path(text,'/') path
from tree
start with id=9990
connect by prior id=parentid;
drop tree;
