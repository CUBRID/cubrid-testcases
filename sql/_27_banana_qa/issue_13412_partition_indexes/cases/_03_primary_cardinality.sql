drop table if exists t;
create table t(i int ) partition by range(i)
(
partition p0 values less than (5),
partition p1 values less than (25),
partition p2 values less than (35),
partition p3 values less than (45)
);
insert into t values(1),(2),(3),(4);
insert into t values(21),(22),(23),(24);
insert into t values(31),(32),(33),(34);
insert into t values(41),(42),(43),(44);
create index idx_local on t(i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;

show index in t__p__p1;
show index in t__p__p2;
show index in t__p__p3;

drop table if exists t;
create table t(i int primary key ) partition by range(i)
(
partition p0 values less than (5),
partition p1 values less than (25),
partition p2 values less than (35),
partition p3 values less than (45)
);
insert into t values(1),(2),(3),(4);
insert into t values(21),(22),(23),(24);
insert into t values(31),(32),(33),(34);
insert into t values(41),(42),(43),(44);
create index idx_local on t(i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;

show index in t__p__p1;
show index in t__p__p2;
show index in t__p__p3;
drop table t;


drop table if exists t1;
CREATE TABLE t1( i1 INTEGER ,
i2 INTEGER not null,
i3 INTEGER unique,
s1 VARCHAR(10),
s2 VARCHAR(10),
s3 VARCHAR(10) ,UNIQUE(i3,s3)) partition by list(i3)
(
partition p0 values in (1),
partition p1 values in (2),
partition p2 values in (3)
);

CREATE INDEX i_t1_i1 ON t1(i1 DESC);
CREATE INDEX i_t1_i1_s1 on t1(i1,s1);
CREATE UNIQUE INDEX i_t1_i3_s2 ON t1(i3,s2);

INSERT INTO t1 VALUES (1,1,1,'abc','abc','abc');
INSERT INTO t1 VALUES (2,2,2,'zabc','zabc','zabc');
INSERT INTO t1 VALUES (2,3,3,'+abc','+abc','+abc');
update statistics on t1 with fullscan;
SELECT INDEX_CARDINALITY('t1','i_t1_i1',0);
SELECT INDEX_CARDINALITY('t1','i_t1_i1_s1',0);
SELECT INDEX_CARDINALITY('t1','i_t1_i1_s1',1);
SELECT INDEX_CARDINALITY('t1','i_t1_i3_s2',0);
SELECT INDEX_CARDINALITY('t1','i_t1_i3_s2',1);
SELECT INDEX_CARDINALITY('t1','u_t1_i3_s3',1);

SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i1',0);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i1_s1',0);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i1_s1',1);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i3_s2',0);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i3_s2',1);
SELECT INDEX_CARDINALITY('t1__p__p0','u_t1_i3_s3',0);
SELECT INDEX_CARDINALITY('t1__p__p0','u_t1_i3_s3',1);


drop table if exists t1;
CREATE TABLE t1( i1 INTEGER ,
i2 INTEGER not null,
i3 INTEGER unique,
s1 VARCHAR(10),
s2 VARCHAR(10),
s3 VARCHAR(10) ,primary key(i3,s3)) partition by list(i3)
(
partition p0 values in (1),
partition p1 values in (2),
partition p2 values in (3)
);

CREATE INDEX i_t1_i1 ON t1(i1 DESC);
CREATE INDEX i_t1_i1_s1 on t1(i1,s1);
CREATE UNIQUE INDEX i_t1_i3_s2 ON t1(i3,s2);

INSERT INTO t1 VALUES (1,1,1,'abc','abc','abc');
INSERT INTO t1 VALUES (2,2,2,'zabc','zabc','zabc');
INSERT INTO t1 VALUES (2,3,3,'+abc','+abc','+abc');
update statistics on t1 with fullscan;
SELECT INDEX_CARDINALITY('t1','i_t1_i1',0);
SELECT INDEX_CARDINALITY('t1','i_t1_i1_s1',0);
SELECT INDEX_CARDINALITY('t1','i_t1_i1_s1',1);
SELECT INDEX_CARDINALITY('t1','i_t1_i3_s2',0);
SELECT INDEX_CARDINALITY('t1','i_t1_i3_s2',1);
SELECT INDEX_CARDINALITY('t1','pk_t1_i3_s3',0);
SELECT INDEX_CARDINALITY('t1','pk_t1_i3_s3',1);

SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i1',0);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i1_s1',0);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i1_s1',1);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i3_s2',0);
SELECT INDEX_CARDINALITY('t1__p__p0','i_t1_i3_s2',1);
SELECT INDEX_CARDINALITY('t1__p__p0','pk_t1_i3_s3',0);
SELECT INDEX_CARDINALITY('t1__p__p0','pk_t1_i3_s3',1);

drop table t1;
