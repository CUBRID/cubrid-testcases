create table t1 (a int, b int);
create unique index i_t1_a on t1(a) where a%2=1;
insert into t1 values (2,1);
--test: tuple (2,1) is not in above unique index, please make spec clear for below query. I think duplication should not match.
insert into t1 values (2,1) on duplicate key update b=99;
--test: should return 2 rows.
select * from t1;

drop table t1;
