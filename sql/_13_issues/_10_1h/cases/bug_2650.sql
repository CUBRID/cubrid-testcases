--test 'now' key word
select datediff(now(),current_date);
create table t1 (now int);
insert into t1 (now) values(1);
select now from t1;
drop t1;