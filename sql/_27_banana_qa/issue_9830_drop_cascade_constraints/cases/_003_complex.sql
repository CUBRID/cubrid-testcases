--drop table in hierarchical referencing structure

drop table if exists t4;
drop table if exists t3;
drop table if exists t2;
drop table if exists t1;
CREATE TABLE t1 ( id INTEGER PRIMARY KEY,  name VARCHAR(10));

CREATE TABLE t2 ( id INTEGER, parent_id INTEGER primary key,
CONSTRAINT fk_parent_id1 FOREIGN KEY(parent_id) REFERENCES t1(id));

CREATE TABLE t3 ( id INTEGER, parent_id INTEGER primary key,
CONSTRAINT fk_parent_id2 FOREIGN KEY(parent_id) REFERENCES t2(parent_id));

CREATE TABLE t4 ( id INTEGER, parent_id INTEGER primary key,
CONSTRAINT fk_parent_id3 FOREIGN KEY(parent_id) REFERENCES t3(parent_id));

insert into t1 values (1,'aaa'), (2, 'bbb'), (3, 'ccc');
insert into t2 values (10,1), (11,2), (12, 3);
insert into t3 values (20,1), (21,2), (22, 3);
insert into t4 values (30,1), (31,2), (32, 3);

drop table if exists t2 cascade constraints;

update statistics on all classes;
show index from t1;
update statistics on all classes;
show index from t3;
update statistics on all classes;
show index from t4;
select * from t1 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;

drop table t3 cascade constraints;
update statistics on all classes;
show index from t1;
update statistics on all classes;
show index from t4;
select * from t1 order by 1;
select * from t4 order by 1;

drop table t1 cascade constraints;
drop table t4 cascade constraints;

