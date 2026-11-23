/**
 *  This test case verifies CBRD-27717: REORGANIZE PARTITION reuses an existing partition when its
 *  name is written in a different letter case than when the partition was created.
 *
 *  The semantic check matched the reused name case-insensitively, but do_create_partition looked up
 *  the partition class with the name as typed, while partition class names are stored in lower
 *  case. The lookup failed without an error, so the statement succeeded with only the new
 *  partitions created: the range or value list of the reused partition was not updated and its
 *  rows were not moved. Debug builds stopped at an assert. The fix (engine PR #8231) looks the
 *  partition up by its lower case name and reports an error if it is still not found.
 *
 *  Each case prints the partitions from db_partition, the rows of each partition, and the
 *  partition a row inserted after the reorganization goes to. PARTITION (...) in the queries is
 *  written in lower case so that only the REORGANIZE statement depends on the letter case.
 *
 *  Coverage:
 *    Case 1:  the reported query, RANGE with MAXVALUE, split pmax and reuse it as PMAX
 *    Case 2:  RANGE without MAXVALUE, split a middle partition and reuse it in upper case
 *    Case 3:  RANGE, merge two partitions into one of them named in upper case
 *    Case 4:  RANGE, the reused partition comes first in the INTO list
 *    Case 5:  LIST, split a partition and reuse it in mixed case
 *    Case 6:  a quoted mixed case name
 *    Case 7:  the same letter case and a new name (passes before the fix as well)
 *    Case 8:  DDL on the reused partition afterwards: RENAME TABLE, another REORGANIZE and
 *             DROP PARTITION, each with the name in yet another letter case
 *    Case 9:  a table with a primary key and a secondary index, checked by index scans and
 *             a duplicate key in the reused partition
 */

drop table if exists t1, t2, t3, t4, t5, t6, t7a, t7b, t8, t8r, t9;


evaluate 'Case 1: RANGE with MAXVALUE, split pmax and reuse it as PMAX';
create table t1 (id int, part_date int, content varchar(100))
partition by range (part_date) (
    partition p202611 values less than (20261201),
    partition p202612 values less than (20270101),
    partition pmax values less than maxvalue
);
insert into t1 values (1, 20261115, 'NOV');
insert into t1 values (2, 20261215, 'DEC');
insert into t1 values (3, 20270115, 'JAN_BEFORE');
insert into t1 values (4, 20270215, 'FEB_BEFORE');
insert into t1 values (5, 20270415, 'MAX_BEFORE');

alter table t1 reorganize partition PMAX into (
    partition P202701 values less than (20270201),
    partition P202702 values less than (20270301),
    partition PMAX values less than maxvalue
);
insert into t1 values (6, 20270120, 'JAN_AFTER');
insert into t1 values (7, 20270220, 'FEB_AFTER');
insert into t1 values (8, 20270420, 'MAX_AFTER');

select partition_name, partition_values from db_partition where class_name = 't1' order by 1;
select 'p202701' p, id, content from t1 partition (p202701)
union all select 'p202702', id, content from t1 partition (p202702)
union all select 'pmax', id, content from t1 partition (pmax)
order by 1, 2;
-- pruning by the new ranges
select id from t1 where part_date between 20270101 and 20270131 order by 1;
select id from t1 where part_date >= 20270301 order by 1;
drop table t1;


evaluate 'Case 2: RANGE without MAXVALUE, split a middle partition and reuse it in upper case';
create table t2 (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition p2 values less than (20),
    partition p3 values less than (30)
);
insert into t2 values (1, 5), (2, 12), (3, 17), (4, 25);

alter table t2 reorganize partition p2 into (
    partition p2a values less than (15),
    partition P2 values less than (20)
);
insert into t2 values (5, 13), (6, 18);

select partition_name, partition_values from db_partition where class_name = 't2' order by 1;
select 'p2a' p, id, v from t2 partition (p2a)
union all select 'p2', id, v from t2 partition (p2)
order by 1, 2;
drop table t2;


evaluate 'Case 3: RANGE, merge two partitions into one of them named in upper case';
create table t3 (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition p2 values less than (20),
    partition p3 values less than (30)
);
insert into t3 values (1, 5), (2, 15), (3, 25);

alter table t3 reorganize partition p1, p2 into (
    partition P2 values less than (20)
);
insert into t3 values (4, 7);

select partition_name, partition_values from db_partition where class_name = 't3' order by 1;
select 'p2' p, id, v from t3 partition (p2)
union all select 'p3', id, v from t3 partition (p3)
order by 1, 2;
drop table t3;


evaluate 'Case 4: RANGE, the reused partition comes first in the INTO list';
create table t4 (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition p2 values less than (20)
);
insert into t4 values (1, 5), (2, 12), (3, 18);

alter table t4 reorganize partition p2 into (
    partition P2 values less than (15),
    partition p2b values less than (20)
);
insert into t4 values (4, 13), (5, 17);

select partition_name, partition_values from db_partition where class_name = 't4' order by 1;
select 'p2' p, id, v from t4 partition (p2)
union all select 'p2b', id, v from t4 partition (p2b)
order by 1, 2;
drop table t4;


evaluate 'Case 5: LIST, split a partition and reuse it in mixed case';
create table t5 (id int, c char(1))
partition by list (c) (
    partition pAbc values in ('a', 'b', 'c'),
    partition pD values in ('d')
);
insert into t5 values (1, 'a'), (2, 'b'), (3, 'c'), (4, 'd');

alter table t5 reorganize partition PABC into (
    partition pA values in ('a'),
    partition PaBc values in ('b', 'c')
);
insert into t5 values (5, 'a');

select partition_name, partition_values from db_partition where class_name = 't5' order by 1;
select 'pa' p, id, c from t5 partition (pa)
union all select 'pabc', id, c from t5 partition (pabc)
union all select 'pd', id, c from t5 partition (pd)
order by 1, 2;
drop table t5;


evaluate 'Case 6: a quoted mixed case name';
create table t6 (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition pmax values less than maxvalue
);
insert into t6 values (1, 5), (2, 15), (3, 25);

alter table t6 reorganize partition "PMax" into (
    partition p2 values less than (20),
    partition "PMax" values less than maxvalue
);

select partition_name, partition_values from db_partition where class_name = 't6' order by 1;
select 'p2' p, id, v from t6 partition (p2)
union all select 'pmax', id, v from t6 partition (pmax)
order by 1, 2;
drop table t6;


evaluate 'Case 7: the same letter case and a new name';
create table t7a (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition pmax values less than maxvalue
);
create table t7b (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition pmax values less than maxvalue
);
insert into t7a values (1, 5), (2, 15), (3, 25);
insert into t7b values (1, 5), (2, 15), (3, 25);

alter table t7a reorganize partition pmax into (
    partition p2 values less than (20),
    partition pmax values less than maxvalue
);
alter table t7b reorganize partition pmax into (
    partition p2 values less than (20),
    partition pmax2 values less than maxvalue
);

select class_name, partition_name, partition_values from db_partition where class_name in ('t7a', 't7b') order by 1, 2;
select 't7a.p2' p, id, v from t7a partition (p2)
union all select 't7a.pmax', id, v from t7a partition (pmax)
union all select 't7b.p2', id, v from t7b partition (p2)
union all select 't7b.pmax2', id, v from t7b partition (pmax2)
order by 1, 2;
drop table t7a, t7b;


evaluate 'Case 8: DDL on the reused partition afterwards';
create table t8 (id int, v int)
partition by range (v) (
    partition p1 values less than (10),
    partition pmax values less than maxvalue
);
insert into t8 values (1, 5), (2, 15), (3, 25);

alter table t8 reorganize partition pmax into (
    partition p2 values less than (20),
    partition PMAX values less than maxvalue
);

-- the partition classes are renamed with the stored partition name
rename table t8 as t8r;
select class_name from db_class where class_name like 't8r__p__%' order by 1;
select partition_name, partition_values from db_partition where class_name = 't8r' order by 1;
insert into t8r values (4, 35);
select 'p2' p, id, v from t8r partition (p2)
union all select 'pmax', id, v from t8r partition (pmax)
order by 1, 2;

-- reorganize the reused partition again in another letter case
alter table t8r reorganize partition Pmax into (
    partition p3 values less than (30),
    partition pMax values less than maxvalue
);
select partition_name, partition_values from db_partition where class_name = 't8r' order by 1;
select 'p3' p, id, v from t8r partition (p3)
union all select 'pmax', id, v from t8r partition (pmax)
order by 1, 2;

-- drop it in yet another letter case
alter table t8r drop partition PMax;
select partition_name, partition_values from db_partition where class_name = 't8r' order by 1;
select class_name from db_class where class_name like 't8r__p__%' order by 1;
select id, v from t8r order by 1;
drop table t8r;


evaluate 'Case 9: a table with a primary key and a secondary index';
create table t9 (id int, v int, c varchar(10), primary key (id, v))
partition by range (v) (
    partition p1 values less than (10),
    partition pmax values less than maxvalue
);
create index i_t9_c on t9 (c);
insert into t9 values (1, 5, 'a'), (2, 15, 'b'), (3, 25, 'c'), (4, 35, 'd');

alter table t9 reorganize partition pmax into (
    partition p2 values less than (20),
    partition PMAX values less than maxvalue
);
insert into t9 values (5, 16, 'e'), (6, 45, 'f');

-- the same rows by a heap scan and by index scans
select 'p2' p, id, c from t9 partition (p2)
union all select 'pmax', id, c from t9 partition (pmax)
order by 1, 2;
select 'p2' p, id, c from t9 partition (p2) where c >= 'a' using index i_t9_c
union all select 'pmax', id, c from t9 partition (pmax) where c >= 'a' using index i_t9_c
order by 1, 2;
select 'p2' p, id, v from t9 partition (p2) where id > 0 using index pk_t9_id_v
union all select 'pmax', id, v from t9 partition (pmax) where id > 0 using index pk_t9_id_v
order by 1, 2;
select id from t9 where c = 'c' order by 1;
-- a key moved into the reused partition is still unique
insert into t9 values (3, 25, 'x');
select count(*) from t9;
drop table t9;
