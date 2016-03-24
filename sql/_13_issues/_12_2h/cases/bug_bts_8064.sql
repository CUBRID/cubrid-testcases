--TEST: [Merge Statement] A partition can be updated with a merge statement and invalid values can be inserted into the partition table.


drop table if exists t1, t2;


create table t1(id bigint, col1 varchar)
partition by range(id)
(partition p1 values less than (10),
partition p2 values less than (20)
);
insert into t1 values(1, 'aaa');
insert into t1 values(3, 'bbb');
insert into t1 values(15, 'ccc');
insert into t1 values(17, 'ddd');


create table t2(id bigint primary key, col1 varchar(1024));
insert into t2 values(1, 'bbb');
insert into t2 values(38, 'ddd');


--TEST: [er]
merge into t1__p__p1 tt
using t2
on tt.col1=t2.col1
when matched then
update set tt.id=t2.id
when not matched then
insert values(t2.id, t2.col1);


--TEST: [er]
merge into t1__p__p2 tt
using t2
on tt.col1=t2.col1
when not matched then
insert values(t2.id, t2.col1);


--TEST: [er]
merge into t1__p__p1 tt
using t2
on tt.col1=t2.col1
when matched then
update set tt.id=t2.id
delete where tt.a > 0;


--TEST: [er]
merge into t1__p__p2 tt
using t2
on tt.col1=t2.col1
when matched then
update set tt.id=t2.id
delete where tt.a > 0
when not matched then
insert values(t2.id, t2.col1);


drop table t1, t2;


create table t1(id bigint PRIMARY KEY, col1 varchar) 
partition by hash(id) partitions 30;

insert into t1 values(1, 'aaa');
insert into t1 values(3, 'bbb');
insert into t1 values(15, 'ccc');
insert into t1 values(17, 'ddd');
insert into t1 values(29, 'eee');
insert into t1 values(21, 'fff');
insert into t1 values(33, 'ggg');
insert into t1 values(37, 'ddd');
insert into t1 values(35, 'hhh');
insert into t1 values(47, 'iii');
insert into t1 values(49, 'jjj');

create table t2(col1 varchar(1024), id bigint primary key) 
partition by hash(id) partitions 50;
insert into t2 values('bbb', 2);
insert into t2 values('ddd', 38);
insert into t2 values('fff', 14);
insert into t2 values('hhh', 12);
insert into t2 values('jjj', 22);
insert into t2 values('kkk', 8);
insert into t2 values('ooo', 46);
insert into t2 values('sss', 28);
insert into t2 values('zzz', 99);

--test: below will throw core file.
merge into t1__p__p4 tt 
using t2 
on tt.col1=t2.col1 
when matched then 
update set tt.id=t2.id 
delete where tt.id=33 
when not matched then 
insert values(t2.id, t2.col1);


drop table t1, t2;
