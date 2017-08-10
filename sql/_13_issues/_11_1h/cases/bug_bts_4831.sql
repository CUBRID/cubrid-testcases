create table t (id int);
insert into t values (1),(2),(3);
--LIMIT clause is included.
create view v as select * from t order by id asc limit 2;
--expect two records output
select * from v;

drop view v;
drop table t;

