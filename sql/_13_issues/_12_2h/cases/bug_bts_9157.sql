--TEST: [PartitionEnhance] Partition table doesn't support INCR/DECR functions.

--hash partition
create table t(i int, j int) partition by hash(i) partitions 4;

insert into t values(1,  1);

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

drop table t;



--range partition
create table t(i int) partition by range(i) 
(partition p0 values less than (2),
partition p1 values less than (4));

insert into t values(1);

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select incr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

select decr(i) from t;

select * from t order by i;

drop table t;



--list partition
create table t(i int) partition by list(i) (
    partition p0 values in (1, 2, 3),
    partition p1 values in (4, 5, 6),
    partition p2 values in (7, 8, 9),
    partition p3 values in (10, 11, 12)
);

insert into t values (1);

select incr(i) from t;
--test: verify result 
select * from t order by i;

select decr(i) from t;
--test: verify result 
select * from t order by i;

select incr(i) from t;
--test: verify result 
select * from t order by i;

select incr(i) from t;
--test: verify result 
select * from t order by i;

select incr(i) from t;
--test: verify result 
select * from t order by i;

select decr(i) from t;
--test: verify result 
select * from t order by i;

drop table t;
