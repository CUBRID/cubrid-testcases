autocommit off;
commit;
drop table if exists t1;
drop table if exists t2;
create table t1 (col int);
create table t2 (col int);
create trigger trg before update on t1 execute insert into t2 values (new.col); 
insert into t1 values (0);
drop table t2;
create table t2 (col int);
update t1 set col = 3;

select * from t1;
select * from t2;
drop table t1,t2;
autocommit on;

