drop table if exists t;

create table t (a int);
drop view if exists mvcc_info_on_t;
create view mvcc_info_on_t as select t.a from t;
drop table if exists t;
create table t (a int);
insert into t values (1);
select * from mvcc_info_on_t;
drop table if exists t;
create table t (a int);
insert into t values (2);
select * from mvcc_info_on_t;

drop view  mvcc_info_on_t;
drop table t;
