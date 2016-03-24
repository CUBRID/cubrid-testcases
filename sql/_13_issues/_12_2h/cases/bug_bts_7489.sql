--TEST: [Merge Statement] A row in the target table can be updated multiple times during the execution of a MERGE command

--+ holdcas on;

drop table if exists t1, t2;

create table t1(a int, b int);
insert into t1 values(1, 100);

create table t2(a int, b int);
insert into t2 values(1, 200);
insert into t2 values(1, 300);

--error should occur
merge into t1
using t2
on (t1.a=t2.a)
when matched then
update
set t1.b=t2.b;

select * from t1 order by 1;

drop table t1, t2;


--client side
drop table if exists t1, t2;

create table t1(a int, b int);
insert into t1 values(1, 100);

create table t2(a int, b int);
insert into t2 values(1, 200);
insert into t2 values(1, 300);

create trigger tr before update on t1 execute insert into t2 values(999, 999);

--error should occur
merge into t1
using t2
on (t1.a=t2.a)
when matched then
update
set t1.b=t2.b;

select * from t1 order by 1;
select * from t2 order by 1;
drop table t1, t2;

commit;
--+ holdcas off;
