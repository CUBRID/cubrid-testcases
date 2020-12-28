drop table if exists t1;
create table t1 (ID int);
--@queryplan
show create table t1;
drop table t1;
