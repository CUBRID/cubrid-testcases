--TEST: [Merge Statement] Invalid value can be set to the column of a list partition table in a merge statement.


create table t1(id1 int, str1 char(50))
partition by list(str1) (
partition p1 values in ('aaa', 'bbb', 'ccc'),
partition p2 values in ('ddd', 'eee', 'fff')
);
insert into t1 values(1, 'aaa'), (2, 'ddd'), (3, 'fff');

create table t2(id2 int, str2 varchar);
insert into t2 values(2, 'invalid'), (3, 'invalid'), (4, 'invalid');

--[er] update with invalid value
merge into t1
using t2
on (t2.id2=t1.id1)
when matched then
update
set t1.str1=t2.str2;

--[er] insert with invalid value
merge into t1
using t2
on (t2.id2=t1.id1)
when matched then
update set t1.str1='ccc'
when not matched then
insert values(t2.id2, t2.str2);

select * from t1 order by id1;

drop table t1, t2;

