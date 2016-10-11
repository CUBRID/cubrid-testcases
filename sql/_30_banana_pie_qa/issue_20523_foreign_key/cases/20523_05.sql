-- TEST CASE For:
-- [CBRD-20523] Foreign Key Referential
--   Constraints on check on INSERT/UPDATE
-- Notice:
--   We changed the rule to check 'Foreign Key
--   Referential Constraints' on INSERT/UPDATE
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'

drop table if exists t2, t1;

create table t1(
	a int , 
	b char(10), 
	c smallint, 
	d varchar(20),
	primary key(a, b, c)
) partition by hash(a) partitions 5;

create table t2(
id int,
a int, 
b char(10),
c smallint, 
d enum('aa', 'bb', 'cc', 'dd', 'updated') collate euckr_bin,
primary key(id), 
foreign key(a, b, c) references t1(a, b, c)
)
partition by hash(id) partitions 3;

insert into t1 values(1, 'a', 11, 'aaa'),(2, 'b', 22, 'bbb'),(3, 'c', 33, 'ccc');

-- normal cases
insert into t2 values(1,1, 'a', 11, 'aa' );
insert into t2 values(2,null, null, null, null );
insert into t2 values(3,3, 'c', 33, 'cc' );

-- one or more NULL
insert into t2 values(4,null, 'b', 11, 'bb' );
insert into t2 values(5,123, null, 234, 'aa' );
insert into t2 values(6,123, null, null, 'dd' );
select * from t2 order by 1, 2, 3;

-- can be updated
update t2 set c=null where id=1;
select * from t2 order by 1, 2, 3;

-- invalid foreign key
insert into t2 values(7,1, 'b', 11, 'dd' );
update t2 set a=1 where id=3;

drop table if exists t2, t1;

