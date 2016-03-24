drop table if exists t1;
create table t1(a int, b date, c nchar, d enum('red','yellow','blue','green'));
insert into t1 values(2,'2013-10-12',n'welcome',3);
set trace on output json;
select * from t1;
show trace;
select TRIM(REPLACE(list_dbs(),'demodb', ''));
do list_dbs();
drop t1;
