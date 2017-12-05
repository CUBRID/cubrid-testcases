drop table if exists t;
create table t ( a json , id int, s varchar(10));
insert into t(s) values ('aaa');
select * from t;
create view v_t ( id int, s varchar(10)) as select * from t union all select * from t;
select * from v_t;
drop view v_t;
drop table if exists t;
