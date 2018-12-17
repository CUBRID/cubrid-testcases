drop table if exists foo;
create table foo (a int, b int, index i2 (b) invisible);
select index_name, class_name, status from db_index where class_name='foo';
show index from foo;
show create table foo;

create index i1 on foo (a) invisible;
show index from foo;

alter index i2 on foo visible;
show index from foo;
show create table foo;

alter index i2 on foo invisible;
show index from foo;
drop table if exists foo;

drop table if exists t1, t2;
CREATE TABLE t1 (  i INT,  j INT,  k INT,  INDEX i_idx (i) INVISIBLE);
show index from t1;

CREATE INDEX j_idx ON t1 (j) INVISIBLE ;
show index from t1;

ALTER TABLE t1 ADD INDEX k_idx (k) INVISIBLE;
show index from t1;

ALTER TABLE t1 ALTER INDEX i_idx INVISIBLE;
show index from t1;

ALTER TABLE t1 ALTER INDEX i_idx VISIBLE;
show index from t1;
show create table t1;

drop index k_idx on t1;
select index_name, class_name, status from db_index where class_name='t1' order by 1;

CREATE TABLE t2 (  i INT NOT NULL,  j INT NOT NULL,  UNIQUE j_idx (j));
show index from t2;

--err expected
ALTER TABLE t2 ALTER INDEX j_idx INVISIBLE;
show index from t2;
show create table t2;

ALTER TABLE t2 ADD PRIMARY KEY (i);
show index from t2;

--err CBRD-22259 By Design
ALTER TABLE t2 ALTER INDEX j_idx INVISIBLE;
show index from t2;
show create table t2;
select index_name, class_name, status from db_index where class_name='t2' order by 1;
drop table if exists t1, t2;

--err CBRD-22258 Won't Fix
create table t1 ( 
    id    int primary key, 
    tid   int,
    unique key idx_tid(tid) invisible
);

create table t1 (
    id    int primary key,
    tid   int,
    unique key idx_tid(tid) 
);
alter index idx_tid on t1 invisible;
show index from t1;
show create table t1;
drop table if exists t1;

