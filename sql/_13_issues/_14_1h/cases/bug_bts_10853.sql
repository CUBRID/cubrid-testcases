drop table if exists t1;
create table t1(a INT unique);
insert into t1 values  (2), (3);

--note: 'LIMIT 1' is necessory for this issue.
create view v1 as select a from t1 order by a LIMIT 1;
insert into v1 values (2) ON DUPLICATE KEY update a=1;

--test: check result for above insert
select if(a in (1, 3), 'OK', 'NOK') from t1;
drop view if exists v1;
drop table if exists t1;
