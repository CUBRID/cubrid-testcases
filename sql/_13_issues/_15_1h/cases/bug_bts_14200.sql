drop table if exists t1;
create table t1(a int, b date, c nchar, d enum('red','yellow','blue','green'));
insert into t1 values(2,'2013-10-12',n'w',3);
set trace on output json;
select * from t1;
show trace;
select if (locate(database(), list_dbs())=0,'NOK','OK');
do list_dbs();
drop t1;
