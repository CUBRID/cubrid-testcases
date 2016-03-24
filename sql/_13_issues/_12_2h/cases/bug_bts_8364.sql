drop table if exists t;

create table t (i int primary key, j int, k char(10));

insert into t values (1, 1, 'a'), (2, 2, 'b'), (3, 3, 'c'), (4, 4, 'd'), (5, 5, 'e');

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3;

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i;

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i order by i;

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i order by i desc;

select /*+ recompile */ i, (select k from t where ROWNUM > 3 and ROWNUM < 5) from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i;

drop t;

create table t (i int primary key, j int, k char(10)) partition by hash(i) partitions 3; 

insert into t values (1, 1, 'a'), (2, 2, 'b'), (3, 3, 'c'), (4, 4, 'd'), (5, 5, 'e');

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3;

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i;

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i order by i;

select /*+ recompile */ i from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i order by i desc;

select /*+ recompile */ i, (select k from t where ROWNUM > 3 and ROWNUM < 5) from t where i < 100 and ROWNUM > 1 AND ROWNUM < 3 group by i;

drop t;

drop table if exists t1;

CREATE TABLE t1( b varchar(10) primary key ) ;

INSERT INTO t1(b) VALUES ('a'),('c'),('b');

select b from t1 WHERE ROWNUM <20 and rownum>0 group by b;;

drop t1;

drop table if exists t2;

CREATE TABLE t2( b int primary key) ;

INSERT INTO t2(b) VALUES (1),(2),(3);

select b from t2 WHERE ROWNUM <20 and rownum>0 group by b;;

drop t2;

