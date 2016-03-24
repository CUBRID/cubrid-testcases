--TEST: [Merge Statement] Data cannot be deleted after updating a range partition table in a merge statement.


drop table if exists t1, t2;

--source
create table t1(id1 int, col1 int not null);
insert into t1 values(500, 6);

--target, partition table
create table t2(id2 int, col1 varchar(10), col2 int)
partition by range(col2)
(partition p1 values less than (2),
partition p2 values less than (6),
partition p3 values less than (15));

insert into t2 values(500, 'a', 5);
insert into t2 values(500, 'a', 14);
insert into t2 values(600, 'a', 5);


merge into t2
using t1
on (t1.id1=t2.id2)
when matched then
update
set t2.col1='updated', t2.col2=t1.col1
delete where t2.col1='updated';


--data is not deleted.
select * from t2 order by 1;


drop table t1, t2;
