--TEST: 'ERROR: Partition failed.' error occurs when recreating a partition table with an index after rollback.


autocommit off;

create table t2(col1 varchar(10), index i(col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc')
);

rollback;

create table t2(col1 varchar(10), index i(col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc')
);

create table t(i int);

alter table t2__p__p1 add superclass t;

drop table t;
drop table t2;

create table t2(col1 varchar(10), index i(col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc')
);

rollback;

create table t2(col1 varchar(10), index i(col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc')
);

drop table t2;

rollback;



autocommit on;
