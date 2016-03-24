--TEST: [Merge Statement] merge_insert_clause does not work when using a FALSE constant filter predicate in a merge statement.


autocommit off;

drop table if exists t1;
drop table if exists t2;


create table t1(a int, b int);
insert into t1 values(1, 1);
create table t2(a int, b int);
insert into t2 values(1, 100);
insert into t2 values(2, 200);

commit;

merge into t1
using t2
on (1=0)
when matched then
update set t1.b=t2.b
when not matched then
insert values(t2.a, t2.b);

select if (count(*)=3, 'ok', 'nok') from t1;

rollback;


merge into t1
using t2
on ('aaa'='AAA')
when matched then
update set t1.b=t2.b
when not matched then
insert values(t2.a, t2.b);

select if (count(*)=3, 'ok', 'nok') from t1;

rollback;


merge into t1
using t2
on (12>120)
when matched then
update set t1.b=t2.b
when not matched then
insert values(t2.a, t2.b);

select if (count(*)=3, 'ok', 'nok') from t1;

rollback;


merge into t1
using t2
on (false)
when matched then
update set t1.b=t2.b
when not matched then
insert values(t2.a, t2.b);

select if (count(*)=3, 'ok', 'nok') from t1;

rollback;


drop table t1, t2;
commit;

autocommit on;
