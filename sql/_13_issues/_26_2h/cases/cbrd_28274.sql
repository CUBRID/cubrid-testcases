/**
 *  This test case verifies CBRD-28274: partition redistribution keeps every value of the
 *  rows that were stored before ADD COLUMN or DROP COLUMN.
 *
 *  Each table gets its 200 rows first, then ADD/DROP COLUMN, so the stored rows keep the
 *  old representation. A redistribution moves them to other partitions. Before the fix
 *  REORGANIZE PARTITION reported success but read the moved rows with the wrong
 *  representation: their id became NULL and the other columns got the values of other
 *  columns (v held the dropped c). COALESCE PARTITION and REMOVE PARTITIONING failed
 *  with a NOT NULL error. Now every moved row is written in the latest representation
 *  (fixed by CUBRID/cubrid#7990).
 *
 *  Every stage checks the sums and distinct counts, the rows per partition, the NULL ids
 *  and the full values of the boundary rows.
 *
 *  Coverage:
 *    Case 1:  RANGE, ADD COLUMN x2 + DROP COLUMN, REORGANIZE r0 into r00, r01
 *    Case 2:  RANGE, REORGANIZE r00, r01 back into r0
 *    Case 3:  RANGE, REMOVE PARTITIONING
 *    Case 4:  HASH, ADD COLUMN, COALESCE PARTITION 1
 *    Case 5:  HASH, REMOVE PARTITIONING
 *    Case 6:  LIST, ADD COLUMN + DROP COLUMN, REORGANIZE p0 into p00, p01
 */

drop table if exists t_rng, t_hsh, t_lst;

-- RANGE: the rows are stored before the columns change
create table t_rng (id int primary key, v varchar(100), c char(20))
  partition by range (id) (partition r0 values less than (100), partition r1 values less than maxvalue);
insert into t_rng select level, 'v' || level, 'c' || level from db_root connect by level <= 200;
alter table t_rng add column x varchar(50) default 'dflt';
alter table t_rng add column y int default 7;
alter table t_rng drop column c;


evaluate 'Case 1: RANGE, REORGANIZE r0 into r00, r01 after ADD x2 + DROP COLUMN';
alter table t_rng reorganize partition r0 into (partition r00 values less than (50), partition r01 values less than (100));
-- expected: 200, 20100, 200, 0, 200, 692, 1, 1400, 7, 7, 0
select count(*) cnt, sum(id) sum_id, count(distinct id) dist_id, sum(case when id is null then 1 else 0 end) null_id,
       count(distinct v) dist_v, sum(length(v)) len_v, count(distinct x) dist_x, sum(y) sum_y, min(y) min_y, max(y) max_y,
       sum(case when v like 'c%' then 1 else 0 end) v_from_c
  from t_rng;
-- expected: 49, 50, 101
select (select count(*) from t_rng__p__r00) r00, (select count(*) from t_rng__p__r01) r01, (select count(*) from t_rng__p__r1) r1 from db_root;
select id, v, x, y from t_rng where id in (1, 49, 50, 99, 100, 150, 200) order by id;


evaluate 'Case 2: RANGE, REORGANIZE r00, r01 back into r0';
alter table t_rng reorganize partition r00, r01 into (partition r0 values less than (100));
select count(*) cnt, sum(id) sum_id, count(distinct id) dist_id, sum(case when id is null then 1 else 0 end) null_id,
       count(distinct v) dist_v, sum(length(v)) len_v, count(distinct x) dist_x, sum(y) sum_y, min(y) min_y, max(y) max_y,
       sum(case when v like 'c%' then 1 else 0 end) v_from_c
  from t_rng;
-- expected: 99, 101
select (select count(*) from t_rng__p__r0) r0, (select count(*) from t_rng__p__r1) r1 from db_root;
select id, v, x, y from t_rng where id in (1, 49, 50, 99, 100, 150, 200) order by id;


evaluate 'Case 3: RANGE, REMOVE PARTITIONING';
alter table t_rng remove partitioning;
select count(*) cnt, sum(id) sum_id, count(distinct id) dist_id, sum(case when id is null then 1 else 0 end) null_id,
       count(distinct v) dist_v, sum(length(v)) len_v, count(distinct x) dist_x, sum(y) sum_y, min(y) min_y, max(y) max_y,
       sum(case when v like 'c%' then 1 else 0 end) v_from_c
  from t_rng;
select id, v, x, y from t_rng where id in (1, 49, 50, 99, 100, 150, 200) order by id;


-- HASH: the rows are stored before the column is added
create table t_hsh (id int primary key, v varchar(100), c char(20)) partition by hash (id) partitions 4;
insert into t_hsh select level, 'v' || level, 'c' || level from db_root connect by level <= 200;
alter table t_hsh add column y int default 7;


evaluate 'Case 4: HASH, COALESCE PARTITION 1 after ADD COLUMN';
alter table t_hsh coalesce partition 1;
-- expected: 200, 20100, 200, 0, 200, 692, 200, 692, 1400, 7, 7
select count(*) cnt, sum(id) sum_id, count(distinct id) dist_id, sum(case when id is null then 1 else 0 end) null_id,
       count(distinct v) dist_v, sum(length(v)) len_v, count(distinct c) dist_c, sum(length(trim(c))) len_c,
       sum(y) sum_y, min(y) min_y, max(y) max_y
  from t_hsh;
-- expected: 3 partitions that hold 200 rows
select count(*) parts from db_partition where class_name = 't_hsh';
select (select count(*) from t_hsh__p__p0) + (select count(*) from t_hsh__p__p1) + (select count(*) from t_hsh__p__p2) rows_in_parts from db_root;
select id, v, trim(c) c, y from t_hsh where id in (1, 49, 50, 99, 100, 150, 200) order by id;


evaluate 'Case 5: HASH, REMOVE PARTITIONING';
alter table t_hsh remove partitioning;
select count(*) cnt, sum(id) sum_id, count(distinct id) dist_id, sum(case when id is null then 1 else 0 end) null_id,
       count(distinct v) dist_v, sum(length(v)) len_v, count(distinct c) dist_c, sum(length(trim(c))) len_c,
       sum(y) sum_y, min(y) min_y, max(y) max_y
  from t_hsh;
select count(*) parts from db_partition where class_name = 't_hsh';
select id, v, trim(c) c, y from t_hsh where id in (1, 49, 50, 99, 100, 150, 200) order by id;


-- LIST: the rows are stored before the columns change; g = mod(id, 4) is the partition key
create table t_lst (id int not null, v varchar(100), c char(20), g int not null, primary key (id, g))
  partition by list (g) (partition p0 values in (0, 1), partition p1 values in (2, 3));
insert into t_lst select level, 'v' || level, 'c' || level, mod(level, 4) from db_root connect by level <= 200;
alter table t_lst add column x varchar(50) default 'dflt';
alter table t_lst drop column c;


evaluate 'Case 6: LIST, REORGANIZE p0 into p00, p01 after ADD + DROP COLUMN';
alter table t_lst reorganize partition p0 into (partition p00 values in (0), partition p01 values in (1));
-- expected: 200, 20100, 200, 0, 200, 692, 1, 300, 0
select count(*) cnt, sum(id) sum_id, count(distinct id) dist_id, sum(case when id is null then 1 else 0 end) null_id,
       count(distinct v) dist_v, sum(length(v)) len_v, count(distinct x) dist_x, sum(g) sum_g,
       sum(case when v like 'c%' or g <> mod(id, 4) then 1 else 0 end) bad_rows
  from t_lst;
-- expected: 50, 50, 100
select (select count(*) from t_lst__p__p00) p00, (select count(*) from t_lst__p__p01) p01, (select count(*) from t_lst__p__p1) p1 from db_root;
select id, v, g, x from t_lst where id in (1, 4, 49, 50, 99, 100, 150, 200) order by id;


drop table t_rng, t_hsh, t_lst;
