create table t (id int primary key);
insert into t values (1);
select incr(id) from t where id=1;
insert into t values (1);
select incr(id) from t where id=1;
drop table t;
