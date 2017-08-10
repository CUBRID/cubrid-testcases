create table t (a int primary key auto_increment, b int);
insert into t values (null, 0);
select * from t;
select last_insert_id();
insert into t values (null, last_insert_id());
select * from t order by a asc;

drop table t;



