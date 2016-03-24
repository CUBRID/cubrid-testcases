--create table with enum type column in various forms.
--+ holdcas on;

drop table if exists t1;
create table t1 (i int, e1 enum('A', 'B'));
show full columns from t1;

insert into t1 values (1, 'A'), (2, 'B');
select * from t1 order by 1, 2;

drop table t1;

commit;
--+ holdcas off;
