--TEST: [Merge Statement] 'Semantic: System error (translate) in ../../src/parser/view_transform.c (line: 9971)' error occurs when using a view as the target.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b char(10));
insert into t1 values(1, 'a');
insert into t1 values(2, 'b');
insert into t1 values(4, 'd');


create table t2(a int, b char(10));
insert into t2 values(1, 'A');
insert into t2 values(2, 'B');
insert into t2 values(3, 'C');

create view v as select (select a from t2 where t1.a=t2.a) a, b from t1;

--approriate error should occur
merge into v t
using t1 s
on(t.a=s.a)
when matched then
update set t.b=s.b
when not matched then
insert
values(s.a, s.b);

drop view v;
drop table t1, t2;
