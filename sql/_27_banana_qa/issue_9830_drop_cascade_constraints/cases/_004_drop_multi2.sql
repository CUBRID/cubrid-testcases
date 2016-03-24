--drop related multiple tables

autocommit off;


CREATE TABLE t1 ( id INTEGER PRIMARY KEY,  name VARCHAR(10));

CREATE TABLE t2 ( id INTEGER, parent_id INTEGER primary key,
CONSTRAINT fk_parent_id1 FOREIGN KEY(parent_id) REFERENCES t1(id));

CREATE TABLE t3 ( id INTEGER, parent_id INTEGER primary key,
CONSTRAINT fk_parent_id2 FOREIGN KEY(parent_id) REFERENCES t2(parent_id));

CREATE TABLE t4 ( id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id3 FOREIGN KEY(parent_id) REFERENCES t3(parent_id));

insert into t1 values (1,'aaa'), (2, 'bbb'), (3, 'ccc');
insert into t2 values (10,1), (11,2), (12, 3);
insert into t3 values (20,1), (21,2), (22, 3);
insert into t4 values (30,1), (31,2), (32, 3);

commit;

--test: drop 2 related tables
drop table if exists t1, t2;
drop table if exists t1, t2 cascade constraints;

show index from t3;
show index from t4;
select * from t3 order by 1;
select * from t4 order by 1;

rollback;

--test: drop 2 related tables
drop table t3, t2;
drop table t3, t2 cascade constraints;

show index from t1;
show index from t4;
select * from t1 order by 1;
select * from t4 order by 1;

rollback;

--test: drop 3 related tables;
drop table t1, t2, t3;
drop table t1, t2, t3 cascade constraints;

show index from t4;
select * from t4 order by 1;

rollback;

drop table t2, t3, t1;
drop table t2, t3, t1 cascade constraints;

show index from t4;
select * from t4 order by 1;

rollback;

drop table t2, t4;
drop table t2, t4 cascade constraints;

show index from t1;
show index from t3;
select * from t1 order by 1;
select * from t3 order by 1;

rollback;

--test: drop 4 related tables, with non-exist table together
drop if exists t5, t1, t2, t3, t4;
drop if exists t5, t1, t2, t6, t3, t8, t4 cascade constraints;

rollback;

drop if exists t4, t3, t5, t2, t1, t6 cascade constraints;

rollback;

--test: drop 4 related tables
drop table t1, t2, t3, t4;
drop table t1, t2, t3, t4 cascade constraints;

rollback;

drop table t4, t3, t2, t1 cascade constraints;

rollback;

drop table t2, t1, t3, t4 cascade constraints;

rollback;

drop table t2, t3 cascade constraints;
drop table t1, t4 cascade constraints;

commit;

autocommit on;
