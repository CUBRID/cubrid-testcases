--drop multiple non-related tables

autocommit off;

--group 1
CREATE TABLE a_parent (id INTEGER PRIMARY KEY,  name VARCHAR(10));
CREATE TABLE b_child (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent(id));

insert into a_parent values (1,'aaa');
insert into b_child values (10,1), (11,1), (12, 1);

--group 2
CREATE TABLE a_parent1 (id INTEGER PRIMARY KEY,  name VARCHAR(10));
CREATE TABLE b_child1 (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent1(id));

insert into a_parent1 values (1,'aaa');
insert into b_child1 values (10,1), (11,1), (12, 1);

--group 3
CREATE TABLE a_parent2 (id INTEGER PRIMARY KEY,  name VARCHAR(10));
CREATE TABLE b_child2 (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent2(id));

insert into a_parent2 values (1,'aaa');
insert into b_child2 values (10,1), (11,1), (12, 1);

--group 4
CREATE TABLE a_parent3 (id INTEGER PRIMARY KEY,  name VARCHAR(10));
CREATE TABLE b_child3 (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent3(id));

insert into a_parent3 values (1,'aaa');
insert into b_child3 values (10,1), (11,1), (12, 1);

commit;

--test: drop 2 tables
drop table a_parent, a_parent2 cascade constraints;

show index from b_child;
show index from b_child2;
select * from b_child order by 1;
select * from b_child2 order by 1;

rollback;

--test: drop 4 tables
drop if exists a_parent, a_parent1, a_parent2, a_parent3; 
drop if exists a_parent, a_parent1, a_parent2, a_parent3 cascade constraints; 
show index from b_child;
show index from b_child1;
show index from b_child2;
show index from b_child3;
select * from b_child1 order by 1;
select * from b_child3 order by 1;

rollback;

--test: drop table with pk and table with fk
drop table a_parent, b_child;
drop table a_parent, b_child cascade constraints;

rollback;

--test: drop multiple tables with pk and table with fk
drop table a_parent, b_child, a_parent1, b_child1, a_parent2, b_child2, a_parent3, b_child3;
drop table a_parent, b_child, a_parent1, b_child1, a_parent2, b_child2, a_parent3, b_child3 cascade constraints;

rollback;

drop a_parent, a_parent1, a_parent2, a_parent3, b_child, b_child1, b_child2, b_child3;
drop a_parent, a_parent1, a_parent2, a_parent3, b_child, b_child1, b_child2, b_child3 cascade constraints;

rollback;

drop a_parent, a_parent1, b_child2, b_child3 cascade constraints;

rollback;

drop if exists a_parent4, b_child, a_parent2, b_child3, a_parent1, b_child2, a_parent3, b_child1;
drop if exists a_parent4, b_child, a_parent2, b_child3, a_parent1, b_child2, a_parent3, b_child1, a_parent cascade constraints;


commit;


autocommit on;


