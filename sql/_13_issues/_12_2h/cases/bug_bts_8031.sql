drop if exists t1;
drop if exists t2;

create table t1(id int, a1 varchar(10));
--below statement will fail. we expect successful result.
ALTER t1 ALTER column a1 SET DEFAULT USER;
insert into t1(id) values(1);
select * from t1;

--below statement will success.
create table t2(id int, a1 varchar(10) DEFAULT USER);
insert into t2(id) values(1);
select * from t2;

drop t1;
drop t2;
