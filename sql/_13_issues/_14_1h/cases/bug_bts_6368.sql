drop table if exists t;
drop table if exists t1;

create class t(b bit(4));
create class t1(b bit(2));
insert into t values(X'1');
set optimization level 2;
insert /*+ insert_execution_mode(2) */ into t1 select * from t;
set optimization level 258;
insert /*+ insert_execution_mode(2) */ into t1 select * from t;
set optimization level 514;
insert /*+ insert_execution_mode(2) */ into t1 select * from t;
set optimization level 513;
drop table if exists t;
drop table if exists t1;
