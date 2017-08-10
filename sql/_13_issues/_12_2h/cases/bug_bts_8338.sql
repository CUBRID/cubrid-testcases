drop table if exists t1;
create table t1(id int auto_increment, mgrid int unique, dummy int);
insert into t1(dummy) values(1);
insert into t1(dummy) select dummy from t1;
insert into t1(dummy) select dummy from t1;
select count(*) from t1;
drop table t1;
