drop table if exists t;
create table t (a int);
insert into t values (0), (0);
create unique index u on t(a); 
create unique index u on t(a) with online; 
create unique index u on t(a) with online parallel 2; 
drop table if exists t;
drop table if exists t1;

create class t1(col1 int, col2 TIME);

INSERT INTO t1 VALUES (1, '14:24:00');
INSERT INTO t1 VALUES (3, '14:24:00');
create unique index i_online_col2 on t1(col2) with online parallel 2;
UPDATE t1 SET col1=2 WHERE col1=3;

--test: cub_server crashed
DELETE  FROM t1 WHERE col1=2;
drop table if exists t1;
