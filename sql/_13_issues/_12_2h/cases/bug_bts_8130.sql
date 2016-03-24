drop table if exists t1;
drop table if exists t2;

create table t1(a int);create table t2(a int);
insert into t1(a) values(1), (2);
insert into t2(a) values(3), (4), (5);
select * from t1 union all select * from t2 order by 1;

drop table t1;
drop table t2;

create table t1(a int primary key);create table t2(a int primary key);
insert into t1(a) values(1), (2);
insert into t2(a) values(3), (4), (5);
select a from t1 where a>0 union all select a from t2 where a>0 order by 1;

drop table t1;
drop table t2;

create table t1(a int auto_increment, b char(1000));create table t2(a int, b char(1000));
insert into t1(b) values('1');
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t1(b) select b from t1;
insert into t2(a, b) values(10000, '10000');
select count ( * ) from (select * from t1 union all select * from t2) T order by 1;
delete from t2;
insert into t2(a, b) select a, b from t1;
delete from t1;
select count( * ) from (select * from t1 union all select * from t2) T order by 1;

drop table t1;
drop table t2;