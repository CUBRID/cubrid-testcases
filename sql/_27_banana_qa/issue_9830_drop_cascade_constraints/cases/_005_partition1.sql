--drop multiple non-related partition tables

autocommit off;

--group 1
CREATE TABLE a_parent (id INTEGER PRIMARY KEY,  name VARCHAR(10))
PARTITION BY RANGE(id) (
	PARTITION p1 VALUES LESS THAN (10),
	PARTITION p2 VALUES LESS THAN (20),
	PARTITION p3 VALUES LESS THAN (30)
);
CREATE TABLE b_child (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent(id));

insert into a_parent values (1,'aaa'), (10, 'bbb'), (20, 'ccc');
insert into b_child values (10,1), (11,10), (12,20);

--group 2
CREATE TABLE a_parent1 (id INTEGER PRIMARY KEY,  name VARCHAR(10))
PARTITION BY HASH(id) PARTITIONS 3;
CREATE TABLE b_child1 (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent1(id))
PARTITION BY HASH(id) PARTITIONS 3;

insert into a_parent1 values (1,'aaa');
insert into b_child1 values (10,1), (11,1), (12, 1);

--group 3
CREATE TABLE a_parent2 (id INTEGER, name VARCHAR(10),primary key(id,name))
PARTITION BY LIST(name) (
	PARTITION p1 VALUES IN ('A', 'B', 'C'),
	PARTITION p2 VALUES IN ('aa', 'bb', 'cc'),
	PARTITION p3 VALUES IN ('aaa', 'bbb', 'ccc')
);
CREATE TABLE b_child2 (id INTEGER , parent_id INTEGER,name varchar(10),
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id,name) REFERENCES a_parent2(id,name))
PARTITION BY HASH(id) PARTITIONS 3;

insert into a_parent2 values (1,'aaa');
insert into b_child2 values (10,1,'aaa'), (11,1,'aaa'), (12, 1,'aaa');

--group 4
CREATE TABLE a_parent3 (id INTEGER PRIMARY KEY,  name VARCHAR(10));
ALTER TABLE a_parent3 PARTITION BY HASH(id) PARTITIONS 5;
CREATE TABLE b_child3 (id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent3(id));

insert into a_parent3 values (1,'aaa');
insert into b_child3 values (10,1), (11,1), (12, 1);


commit;

--test: drop 2 tables
drop table a_parent__p__p1, a_parent2__p__p2 cascade constraints;
drop table a_parent, a_parent2 cascade constraints;

show index from b_child;
show index from b_child2;
select * from b_child order by 1;
select * from b_child2 order by 1;

rollback;

--test: drop 4 tables
drop if exists a_parent__p__p1, a_parent1__p__p2, a_parent2, a_parent3__p__p4 cascade constraints; 
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
drop table a_parent__p__p1, b_child2__p__p2 cascade constraints;
drop table a_parent, b_child cascade constraints;

rollback;


--test: drop multiple tables with pk and table with fk
drop table a_parent, b_child, a_parent1, b_child1, a_parent2, b_child2, a_parent3, b_child3;
drop table a_parent, b_child, a_parent1, b_child1, a_parent2, b_child2, a_parent3, b_child3 cascade constraints;

rollback;

drop a_parent, a_parent1, a_parent2, a_parent3, b_child, b_child1, b_child2, b_child3;
drop a_parent, a_parent1, a_parent2, a_parent3, b_child, b_child1, b_child2, b_child3 cascade constraints;

rollback;

drop a_parent, b_child, a_parent2, b_child3, a_parent1, b_child2, a_parent3, b_child1;
drop a_parent, b_child, a_parent2, b_child3, a_parent1, b_child2, a_parent3, b_child1 cascade constraints;


commit;


autocommit on;


