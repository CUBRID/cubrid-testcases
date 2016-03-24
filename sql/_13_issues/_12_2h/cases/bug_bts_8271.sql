--TEST: [Merge Statement] Result is inconsistent with Oracle when using constant filter predicate in a merge statement.


drop table if exists t1, t2;

create table t1(a int);
insert into t1 values(1);
insert into t1 values(2);

create table t2(a int);
insert into t2 values(3);
insert into t2 values(4);

--error occurs in oracle
merge into t1 using t2
on (1=1)
when matched then
update set t1.a=t2.a;

merge into t1 using t2
on (2>1)
when matched then
update set t1.a=t2.a;

merge into t1 using t2
on (date'1999-12-12' > '1999-12-11')
when matched then
update set t1.a=t2.a;

select * from t1 order by 1;

drop table t1, t2;


--client side
create table t1(a int);
insert into t1 values(1);
insert into t1 values(2);

create table t2(a int);
insert into t2 values(3);
insert into t2 values(4);

create trigger tr before update on t1 execute insert into t2 values(999);

merge into t1 using t2
on ('a'='a')
when matched then
update set t1.a=t2.a;

select * from t1 order by 1;
select * from t2 order by 1;

drop table t1, t2;
