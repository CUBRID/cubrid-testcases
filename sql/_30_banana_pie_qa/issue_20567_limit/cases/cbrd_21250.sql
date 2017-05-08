--+ holdcas on;
drop table if exists t1;

create table t1 (a int);
insert into t1 values (1), (2), (3), (4), (5), (6);

delete from t1 where a in (select a from t1 group by a limit 1, 1) limit 1;
delete from t1 where a in (select a from t1 group by a limit 1, 1) limit 1;
delete from t1 where a in (select a from t1 group by a limit 1, 1) limit 1;
delete from t1 where a in (select a from t1 group by a limit 1, 1) limit 1;
delete from t1 where a in (select a from t1 group by a limit 1, 1) limit 1;
delete from t1 where a in (select a from t1 group by a limit 0+0, 1) limit 1-0;
select * from t1 order by a;

drop table if exists t1;
--+ holdcas off;

