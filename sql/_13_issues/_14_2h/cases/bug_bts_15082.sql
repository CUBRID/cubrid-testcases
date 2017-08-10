drop table if exists t;
create table t (i varchar (10));
insert into t values ('1');
select max(i) x from t having x < '1';
drop table if exists t;
