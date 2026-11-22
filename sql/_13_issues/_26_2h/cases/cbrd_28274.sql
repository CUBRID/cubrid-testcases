/**
 *  This test case verifies CBRD-28274: rows stored in an older representation of a
 *  partitioned table keep their values when ALTER ... REORGANIZE / COALESCE / REMOVE
 *  PARTITIONING moves them to another partition or to the main class.
 *
 *  Before the fix a row written before ADD COLUMN or DROP COLUMN was copied byte for byte,
 *  and only its representation id was replaced by the latest one. The values were read in
 *  the wrong places: the partition key and other columns became NULL or garbage, a NOT NULL
 *  column failed, or no partition matched. Now such a row is rebuilt in the latest
 *  representation before it is redistributed.
 *
 *  Each case changes the columns of a partitioned table, moves the rows, and checks the row
 *  count, the sums of the values, the rows that keep their original values, and an index
 *  scan against a full scan.
 *
 *  Coverage:
 *    Case 1:  RANGE, REORGANIZE after ADD COLUMN and DROP COLUMN, then merge back
 *    Case 2:  RANGE, REMOVE PARTITIONING with rows of the older and the latest representation
 *    Case 3:  HASH, COALESCE 6 to 2 (four partitions redistributed)
 *    Case 4:  HASH, REMOVE PARTITIONING
 *    Case 5:  LIST, REORGANIZE after the partition key moved to another position
 *    Case 6:  RANGE, REORGANIZE after ADD COLUMN FIRST and ADD COLUMN AFTER
 *    Case 7:  non-partitioned table with older rows changed to a partitioned table (control)
 */

drop table if exists t1, t2, t3, t4, t5, t6, t7;


evaluate 'Case 1: RANGE, REORGANIZE after ADD COLUMN and DROP COLUMN, then merge back';
create table t1 (id int primary key, v varchar(100), c char(20))
  partition by range (id) (partition p0 values less than (100), partition p1 values less than maxvalue);
insert into t1 select level, 'v' || level, 'c' || level from db_root connect by level <= 200;
alter table t1 add column x varchar(50) default 'dflt';
alter table t1 add column y int not null default 7;
alter table t1 drop column c;
create index i_t1_y on t1 (y);
alter table t1 reorganize partition p0 into (partition p00 values less than (50), partition p01 values less than (100));
select count(*), sum(id), sum(y), count(distinct x), sum(length(v)) from t1;
select count(*) from t1 where id is null or y is null or x <> 'dflt' or v <> 'v' || id;
select count(*) from t1__p__p00;
select count(*) from t1__p__p01;
select count(*) from t1 where y = 7 using index i_t1_y;
select count(*) from t1 where y = 7 using index none;
alter table t1 reorganize partition p00, p01 into (partition p0 values less than (100));
select count(*), sum(id), sum(y) from t1;
select count(*) from t1__p__p0;


evaluate 'Case 2: RANGE, REMOVE PARTITIONING with rows of the older and the latest representation';
create table t2 (id int primary key, c char(20), v varchar(30))
  partition by range (id) (partition p0 values less than (50), partition p1 values less than maxvalue);
insert into t2 select level, 'c' || level, 'v' || level from db_root connect by level <= 100;
alter table t2 drop column c;
alter table t2 add column y varchar(10) default 'dy';
insert into t2 (id, v, y) select level + 100, 'n' || level, 'y' || level from db_root connect by level <= 20;
create index i_t2_y on t2 (y);
alter table t2 remove partitioning;
select count(*), sum(id), count(y), sum(length(v)) from t2;
select count(*) from t2 where id <= 100 and (v <> 'v' || id or y <> 'dy');
select count(*) from t2 where id > 100 and (v <> 'n' || (id - 100) or y <> 'y' || (id - 100));
select count(*) from t2 where y = 'dy' using index i_t2_y;
select count(*) from t2 where y = 'dy' using index none;


evaluate 'Case 3: HASH, COALESCE 6 to 2 (four partitions redistributed)';
create table t3 (id int primary key, c char(20), v varchar(30)) partition by hash (id) partitions 6;
insert into t3 select level, 'c' || level, 'v' || level from db_root connect by level <= 300;
alter table t3 add column x varchar(20) default 'dx';
insert into t3 (id, c, v, x) select level + 300, 'k' || level, 'w' || level, 'x' || level from db_root connect by level <= 30;
alter table t3 drop column c;
create index i_t3_x on t3 (x);
alter table t3 coalesce partition 4;
select count(*), sum(id), count(x), sum(length(v)) from t3;
select count(*) from t3 where id <= 300 and (v <> 'v' || id or x <> 'dx');
select count(*) from t3 where id > 300 and (v <> 'w' || (id - 300) or x <> 'x' || (id - 300));
select count(*) from t3 where x = 'dx' using index i_t3_x;
select count(*) from t3 where x = 'dx' using index none;


evaluate 'Case 4: HASH, REMOVE PARTITIONING';
create table t4 (id int primary key, c char(20), v varchar(30)) partition by hash (id) partitions 3;
insert into t4 select level, 'c' || level, 'v' || level from db_root connect by level <= 60;
alter table t4 drop column c;
alter table t4 add column y bigint not null default 9;
create index i_t4_y on t4 (y);
alter table t4 remove partitioning;
select count(*), sum(id), sum(y), sum(length(v)) from t4;
select count(*) from t4 where v <> 'v' || id;
select count(*) from t4 where y = 9 using index i_t4_y;
select count(*) from t4 where y = 9 using index none;


evaluate 'Case 5: LIST, REORGANIZE after the partition key moved to another position';
create table t5 (id int, c char(20), g int, v varchar(30))
  partition by list (g) (partition p0 values in (0, 1, 2), partition p1 values in (3, 4));
insert into t5 select level, 'c' || level, mod (level, 5), 'v' || level from db_root connect by level <= 50;
alter table t5 drop column c;
alter table t5 add column y int default 3;
create index i_t5_y on t5 (y);
alter table t5 reorganize partition p0 into (partition p00 values in (0), partition p01 values in (1, 2));
select count(*), sum(id), sum(g), sum(y) from t5;
select count(*) from t5 where g <> mod (id, 5) or v <> 'v' || id;
select count(*) from t5__p__p00;
select count(*) from t5__p__p01;
select count(*) from t5 where y = 3 using index i_t5_y;
select count(*) from t5 where y = 3 using index none;


evaluate 'Case 6: RANGE, REORGANIZE after ADD COLUMN FIRST and ADD COLUMN AFTER';
create table t6 (id int primary key, v varchar(30), n int)
  partition by range (id) (partition p0 values less than (50), partition p1 values less than maxvalue);
insert into t6 select level, 'v' || level, level * 10 from db_root connect by level <= 60;
alter table t6 add column f varchar(10) default 'ff' first;
alter table t6 add column a int default 5 after id;
create index i_t6_a on t6 (a);
alter table t6 reorganize partition p0 into (partition p00 values less than (20), partition p01 values less than (50));
select count(*), sum(id), sum(a), sum(n), count(f) from t6;
select count(*) from t6 where f <> 'ff' or v <> 'v' || id or n <> id * 10;
select count(*) from t6__p__p00;
select count(*) from t6__p__p01;
select count(*) from t6 where a = 5 using index i_t6_a;
select count(*) from t6 where a = 5 using index none;


evaluate 'Case 7: non-partitioned table with older rows changed to a partitioned table (control)';
create table t7 (id int primary key, v varchar(100), c char(20));
insert into t7 select level, 'v' || level, 'c' || level from db_root connect by level <= 200;
alter table t7 drop column c;
alter table t7 add column y int default 7;
alter table t7 partition by range (id) (partition p0 values less than (100), partition p1 values less than maxvalue);
select count(*), sum(id), sum(y), sum(length(v)) from t7;
select count(*) from t7 where v <> 'v' || id;
select count(*) from t7__p__p0;


drop table t1, t2, t3, t4, t5, t6, t7;
