create table t ( a int);
insert into t values (1);
insert into t values (2);
insert into t values (0);
insert into t values (null);

select  * from t where a is TRUE order by 1;
select  * from t where a is NOT FALSE order by 1;
drop table t;



