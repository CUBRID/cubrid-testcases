--drop related multiple partition tables

autocommit off;

drop table if exists t1, t2, t3, t4;

CREATE TABLE t1 ( id INTEGER PRIMARY KEY,  name VARCHAR(10));

CREATE TABLE t2 ( id INTEGER, parent_id INTEGER primary key);

CREATE TABLE t3 ( id INTEGER, parent_id INTEGER primary key);

CREATE TABLE t4 ( id INTEGER, parent_id INTEGER);

insert into t1 values (1,'aaa'), (10, 'bbb'), (20, 'ccc');
insert into t2 values (10,1), (11,10), (12, 20);
insert into t3 values (20,1), (21,10), (22, 20);
insert into t4 values (30,1), (31,10), (32, 20);

alter table t1 partition by hash(id) partitions 10;
alter table t2 partition by range(parent_id) (
	partition p1 values less than (10),
	partition p2 values less than (20),
	partition p3 values less than (30)
);
alter table t3 partition by hash(parent_id) partitions 10;
alter table t4 partition by range(parent_id) (
        partition p1 values less than (10),
        partition p2 values less than (20),
        partition p3 values less than (30)
);

alter table t3 add constraint fk_parent_id2 FOREIGN KEY(parent_id) REFERENCES t2(parent_id);
alter table t4 add constraint fk_parent_id3 FOREIGN KEY(parent_id) REFERENCES t3(parent_id);
alter table t2 add constraint fk_parent_id1 FOREIGN KEY(parent_id) REFERENCES t1(id);

commit;

--test: [er] drop partitioned tables
drop table t1__p__p3 cascade constraints;
drop table if exists t1__p__p1, t2__p__p2 cascade constraints;
drop table if exists t1__p__p1, t2__p__p2, t3__p__p3 cascade constraints;
drop table if exists t3__p__p1, t2__p__p1, t4__p__p8 cascade constraints;
drop table if exists t2__p__p1, t3__p__p2, t1__p__p1, t4__p__p9 cascade constraints;
drop table if exists t1__p__p1, t2__p__p1, t3__p__p1, t4__p__p1, t1__p__p2, t2__p__p5, t3__p__p3, t4__p__p8 cascade constraints;

--test: drop 2 related tables
drop table if exists t1, t2;
drop table if exists t1, t2 cascade constraints;

update statistics on t3;
show index from t3;
update statistics on t4;
show index from t4;
select * from t3 order by 1;
select * from t4 order by 1;

rollback;

--test: drop 2 related tables
drop table t3, t2;
drop table t3, t2 cascade constraints;

update statistics on t1;
show index from t1;
update statistics on t4;
show index from t4;
select * from t1 order by 1;
select * from t4 order by 1;

rollback;

--test: drop 3 related tables;
drop table t1, t2, t3;
drop table t1, t2, t3 cascade constraints;

update statistics on t4;
show index from t4;
select * from t4 order by 1;

rollback;

drop table t2, t3, t1;
drop table t2, t3, t1 cascade constraints;

update statistics on t4;
show index from t4;
select * from t4 order by 1;

rollback;

drop table t2, t4;
drop table t2, t4 cascade constraints;

update statistics on t1;
show index from t1;
update statistics on t3;
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
