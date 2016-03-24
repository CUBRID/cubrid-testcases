drop table if exists t1;

create table t1 (a enum('A','B') default 'A');
insert into t1 values (default);

--test: below will throw error. we expect it will be successful.
select default(a) from t1;

 
drop table if exists t1;
