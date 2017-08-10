drop tree, tree1, tree2, tree3;

CREATE TABLE tree(ID INT, ParentID INT, text VARCHAR(32));
create table tree1 under tree;
create table tree2 under tree;
create table tree3 under tree2

INSERT INTO tree1 VALUES(1,NULL,'A');
INSERT INTO tree2 VALUES (2,NULL,'B');
INSERT INTO tree1 VALUES (3,1,'AA');
INSERT INTO tree2 VALUES (4,1,'AB');
INSERT INTO tree1 VALUES (5,2,'BA');
INSERT INTO tree2 VALUES (6,2,'BB');
INSERT INTO tree1 VALUES (7,1,'BBA');
INSERT INTO tree2 VALUES (2,6,'BBA');

select id, parentid, text, level
	from all tree
	start with parentid is null
	connect by nocycle prior id=parentid
	order by id;


select id, parentid, text, level
	from all tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

drop tree, tree1, tree2, tree3;

CREATE TABLE tree(ID INT, ParentID INT, text VARCHAR(32));

INSERT INTO tree VALUES(1,NULL,'A');
INSERT INTO tree VALUES (2,NULL,'B');
INSERT INTO tree VALUES (3,1,'AA');
INSERT INTO tree VALUES (4,1,'AB');
INSERT INTO tree VALUES (5,2,'BA');
INSERT INTO tree VALUES (6,2,'BB');
INSERT INTO tree VALUES (7,1,'BBA');
INSERT INTO tree VALUES (2,6,'BBA');

select id, parentid, text, level
	from all tree
	start with parentid is null
	connect by nocycle prior id=parentid
	order by id;

select id, parentid, text, level
	from all tree
	start with parentid is null
	connect by prior id=parentid
	order by id;

drop tree;
