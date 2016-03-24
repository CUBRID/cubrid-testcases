drop table if exists t1;
drop table if exists t2;

CREATE TABLE t1 ( a varchar(10));
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');
insert into t1 values ('A');

CREATE TABLE t2 ( a varchar(10) unique);
insert into t2 select * from t1 ON DUPLICATE KEY UPDATE a='A' ;
select * from t2;
drop t1,t2;
