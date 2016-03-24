--TEST: [Merge Statement] Core dumped when merging into a view with a correlated subquery.


drop if exists t1, t2;

create table t1(a int, b char(10));
insert into t1 values(1, 'a');
insert into t1 values(2, 'b');
insert into t1 values(3, 'c');

create table t2(a int, b char(10));
insert into t2 values(1, 'a');
insert into t2 values(2, 'b');
insert into t2 values(3, 'c');

create view v as select (select t2.b from t2 where t1.a=t2.a) b, t1.a from t1;

--[er]
merge into v t
using t1 s
on (t.a=s.a)
when matched then
update set t.b='updated';

--[er]
merge into v t
using t1 s
on (t.a=s.a)
when matched then
update set t.b='updated'
delete where t.a < 3;

--[er]
merge into v t
using t1 s
on (t.a=s.a)
when matched then
update set t.b='updated'
when not matched then
insert values(s.a, s.b);


drop view v;
drop table t1, t2;
