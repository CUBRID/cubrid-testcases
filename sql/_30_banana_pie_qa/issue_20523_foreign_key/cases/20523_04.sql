-- TEST CASE For:
-- [CBRD-20523] Foreign Key Referential
--   Constraints on check on INSERT/UPDATE
-- Notice:
--   We changed the rule to check 'Foreign Key
--   Referential Constraints' on INSERT/UPDATE
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'

drop table if exists t2, t1;

CREATE TABLE t1 (
    a INT,
    b TIMESTAMP,
    d MONETARY,
    e INT,
	primary key(a, b, d)
) PARTITION BY RANGE (a) (
    PARTITION t1_1000 VALUES LESS THAN (1000),
    PARTITION t1_3000 VALUES LESS THAN (3000)
);

CREATE TABLE t2 (
	id INT,
    a INT,
    b TIMESTAMP,
    d MONETARY,
    e INT,
	primary key(id), 
	foreign key(a, b, d) references t1(a, b, d)
) PARTITION BY RANGE (id) (
    PARTITION t2_10 VALUES LESS THAN (10),
    PARTITION t2_20 VALUES LESS THAN (20)
);

insert into t1 values(100, '13:15:45 10/31/2008', 100,1);
insert into t1 values(1000, '13:15:45 10/31/2008', 100000,1);
insert into t1 values(2000, '13:15:45 10/31/2008', 100000,1);

-- normal cases
insert into t2 values(1, 100, '13:15:45 10/31/2008', 100,1);
insert into t2 values(13, null, null, null, null);

-- one or more NULL
insert into t2 values(2, null, '13:15:45 10/31/2008', 200,1);
insert into t2 values(11, 1000, null, 100000,1);
insert into t2 values(12, 32000, null, null,1);
select * from t2 order by 1;

-- invalid foreign key
update t1 set a=101 where a=100;
update t2 set a=101 where a=100;
insert into t2 values(3, 101, '13:15:45 10/31/2008', 100,1);
select * from t2 order by 1;

-- can be updated
update t2 set a=null where a=100;
select * from t2 order by 1;

drop table if exists t2, t1;

