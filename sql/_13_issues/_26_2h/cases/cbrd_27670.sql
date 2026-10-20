/**
 *  This test case verifies CBRD-27670: MIN/MAX without a WHERE clause on a partitioned table
 *  skips a partition that has no value in the column.
 *
 *  MIN/MAX without a WHERE clause on an indexed column reads the lowest or highest key of each
 *  partition's index and merges them (11.3, since CBRD-24436). A partition with no value, empty
 *  or NULL in every row, gives NULL, and the merge ranked NULL below any value: MIN returned
 *  NULL, or the minimum of the partitions after the last such partition. The fix skips a NULL
 *  partition result.
 *
 *  Each MIN/MAX is checked against the same aggregate with "where <col> is not null", which
 *  reads the rows and is not merged per partition. The trace of Case 1 and Case 9 shows the
 *  indexes the aggregates are read from (agl) and no partition scan, so the cases keep checking
 *  the merge; the trace of the reference query shows the partition scans.
 *
 *  Coverage:
 *    Case 1:  issue repro, range partitions, the second and the last one empty
 *    Case 2:  issue repro, the second partition empty
 *    Case 3:  a partition whose column is NULL in every row (issue additional info)
 *    Case 4:  every partition empty, then only NULLs: MIN/MAX are NULL
 *    Case 5:  the first partition empty, the minimum in the last partition
 *    Case 6:  list partitions, VARCHAR column, the empty partition first, middle or last
 *    Case 7:  hash partitions with empty partitions
 *    Case 8:  negative values, MAX with an empty partition after the maximum
 *    Case 9:  several MIN/MAX on different indexes in one select, a descending index
 *    Case 10: NULLs and values in one partition, an all-NULL partition after it, then all-NULL
 *             partitions after the only partition with values
 */

drop table if exists pt, pn, pl, ph, pm;

evaluate 'Case 1: issue repro, p2 and p4 empty; expected 1, 25';
create table pt (i int) partition by range (i)
  (partition p1 values less than (10), partition p2 values less than (20),
   partition p3 values less than (30), partition p4 values less than maxvalue);
create index i_pt_i on pt (i);
insert into pt values (1), (5), (25);
set trace on;
select min(i), max(i) from pt;
show trace;
select min(i), max(i) from pt where i is not null;
show trace;
set trace off;


evaluate 'Case 2: issue repro, p2 empty; expected 1, 35';
insert into pt values (35);
select min(i), max(i) from pt;
select min(i), max(i) from pt where i is not null;


evaluate 'Case 3: p2 has NULL in every row; expected 1, 25';
create table pn (i int, j int) partition by range (j)
  (partition p1 values less than (10), partition p2 values less than (20),
   partition p3 values less than (30));
create index i_pn_i on pn (i);
insert into pn values (1, 1), (null, 15), (25, 25);
select min(i), max(i) from pn;
select min(i), max(i) from pn where i is not null;


evaluate 'Case 4: every partition empty, then only NULLs; expected NULL, NULL';
delete from pn;
select min(i), max(i) from pn;
insert into pn values (null, 1), (null, 15), (null, 25);
select min(i), max(i) from pn;
select min(i), max(i) from pn where i is not null;


evaluate 'Case 5: p1 empty, the minimum in the last partition; expected 22, 28';
delete from pn;
insert into pn values (null, 15), (28, 25), (22, 26);
select min(i), max(i) from pn;
select min(i), max(i) from pn where i is not null;


evaluate 'Case 6: list partitions, VARCHAR, the empty partition first, middle or last';
create table pl (s varchar(10), k int) partition by list (k)
  (partition a values in (1), partition b values in (2), partition c values in (3));
create index i_pl_s on pl (s);
insert into pl values ('m', 2), ('y', 3);
select min(s), max(s) from pl;
select min(s), max(s) from pl where s is not null;
delete from pl;
insert into pl values ('b', 1), ('m', 3);
select min(s), max(s) from pl;
select min(s), max(s) from pl where s is not null;
delete from pl;
insert into pl values ('m', 1), ('y', 2);
select min(s), max(s) from pl;
select min(s), max(s) from pl where s is not null;


evaluate 'Case 7: hash partitions, some of them empty; expected 3, 3 then 3, 4';
create table ph (i int) partition by hash (i) partitions 4;
create index i_ph_i on ph (i);
insert into ph values (3);
select min(i), max(i) from ph;
select min(i), max(i) from ph where i is not null;
insert into ph values (4);
select min(i), max(i) from ph;
select min(i), max(i) from ph where i is not null;


evaluate 'Case 8: negative values, MIN/MAX with empty partitions around them; expected -15, -5';
delete from pn;
insert into pn values (-15, 1), (-5, 25);
select min(i), max(i) from pn;
select min(i), max(i) from pn where i is not null;


evaluate 'Case 9: several MIN/MAX on different indexes, a descending index; expected 1, 25, 10, 30';
create table pm (a int, b int, k int) partition by range (k)
  (partition p1 values less than (10), partition p2 values less than (20),
   partition p3 values less than (30), partition p4 values less than maxvalue);
create index i_pm_a on pm (a);
create index i_pm_b on pm (b desc);
insert into pm values (1, null, 1), (null, 10, 15), (25, 30, 25);
set trace on;
select min(a), max(a), min(b), max(b) from pm;
show trace;
set trace off;
select min(a), max(a) from pm where a is not null;
select min(b), max(b) from pm where b is not null;


evaluate 'Case 10: NULLs and values in one partition, all-NULL partitions after it; expected 2, 9 twice';
delete from pn;
insert into pn values (null, 1), (2, 2), (null, 15), (null, 16), (null, 25), (9, 26);
select min(i), max(i) from pn;
select min(i), max(i) from pn where i is not null;
delete from pn;
insert into pn values (null, 1), (2, 2), (9, 3), (null, 15), (null, 25);
select min(i), max(i) from pn;
select min(i), max(i) from pn where i is not null;

drop table pt, pn, pl, ph, pm;
