drop table if exists t1;
 create table t1 (id int, b int);

insert into t1 values(1, 2000);

set optimization level 513;

SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 2000
 ORDER BY a.id
 FOR ORDERBY_NUM() BETWEEN 1 AND (SELECT COUNT(*) FROM t1);

drop table if exists t1;
 create table t1 (id int, b int);

insert into t1 values(1, 2000);

set optimization level 513;

SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 2000
 ORDER BY a.id
 FOR ORDERBY_NUM()=(select 1 from t1);

drop table if exists t1;
 create table t1 (id int, b int);

insert into t1 values(1, 2000);

set optimization level 513;

SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 2000
 ORDER BY (select 1 from t1);

drop table if exists t1;
 create table t1 (id int, b int);

insert into t1 values(1, 2000);
insert into t1 values(2, 2000);

set optimization level 513;

SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 2000
 ORDER BY (select 1 from t1);

drop table if exists t1;
 create table t1 (id int, b int);

insert into t1 values(1, 2000);
insert into t1 values(2, 3000);

set optimization level 513;

SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 2000
 ORDER BY 1 for orderby_num in (1,2,(SELECT COUNT(*) FROM t1));


SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 2000
 ORDER BY 1 for (select count(*) from t1)<3000 ;


SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 3000
 ORDER BY (SELECT COUNT(*) FROM t1),2 desc;


SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 3000
 ORDER BY (SELECT COUNT(*) FROM t1),1 desc;


SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 3000
 ORDER BY (SELECT COUNT(*) FROM t1) ,1 ;


SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 3000
 ORDER BY (SELECT COUNT(*) FROM t1),2;

insert into t1 values(3, 4000);

SELECT /*+ recompile */ *
 FROM t1 a
 WHERE a.b BETWEEN 1900 AND 3000
 ORDER BY (SELECT row_number() over() FROM t1) ;
drop t1;
