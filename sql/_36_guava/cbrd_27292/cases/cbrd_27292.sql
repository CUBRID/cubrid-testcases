/**
 *  This test case verifies CBRD-27292: a parallel scan whose spec has neither a predicate
 *  nor a "rest" regu list (constant output, e.g. SELECT 1 FROM t) keeps the mergeable list
 *  gather, and a BUILDVALUE without any aggregate never takes that gather.
 *
 *  The px_scan checker used to downgrade a heap, index or list spec with an empty predicate
 *  and an empty rest regu list to CANNOT_LIST_MERGE, so a constant-output heap scan was
 *  gathered row by row. The fix (engine PR #7767) drops that downgrade. Without it, a
 *  BUILDVALUE proc with no aggregate (a HAVING without GROUP BY or aggregate function) could
 *  reach the mergeable list gather, whose result handler reads proc.buildlist from a
 *  buildvalue node. The fix also marks every BUILDVALUE proc CANNOT_LIST_MERGE, so it stays
 *  row by row.
 *
 *  Relation to cbrd_25447: its item 19 already shows a heap constant-output scan
 *  (select null ... with an inst_num limit) gathered as mergeable list. This case adds the
 *  index scan, the list (temp) scan, the parallel = serial result check of a full
 *  constant-output scan, and the BUILDVALUE without aggregate, which cbrd_25447 does not cover.
 *
 *  Every PARALLEL statement is checked against the same statement under NO_PARALLEL_SCAN,
 *  so the answer only holds PASS/FAIL and the masked traces. CTP runs with test_mode=yes
 *  (parallel_scan_page_threshold 32). t holds 1000 rows with a 1920-byte md5 payload that
 *  does not compress, about 145 heap pages; the derived table in Case 2 keeps that payload,
 *  so its temp list is about as large. tk holds 50000 distinct keys, an index of about 70 pages.
 *
 *  Coverage:
 *    Case 1:  SELECT 1 FROM t (heap scan, empty pred + rest): mergeable list, parallel = serial
 *    Case 2:  SELECT 1 FROM a NO_MERGE derived table (list scan): mergeable list,
 *             parallel = serial. A derived table spec fetches every derived column into its
 *             pred or rest regu list, so it never had an empty pred + rest; result check only.
 *    Case 3:  SELECT 1 FROM t HAVING sys_timestamp IS NOT NULL (BUILDVALUE, no aggregate):
 *             row by row, one row valued 1 on both sides
 *    Case 4:  the same BUILDVALUE reached with a real predicate, WHERE id > 0 HAVING 1=1:
 *             row by row, one row valued 1 on both sides
 *    Case 5:  SELECT 1 FROM tk FORCE INDEX (idx_k) WHERE k > 0 (index scan, key range only):
 *             mergeable list, parallel = serial. The key column is a referenced attribute, so
 *             the index spec keeps it in its rest regu list; result check only, as in Case 2.
 *
 *  HAVING sys_timestamp IS NOT NULL never folds to a constant, so Case 3 builds a BUILDVALUE
 *  whatever happens to a constant HAVING (a constant-true HAVING without GROUP BY used to be
 *  dropped in type checking). Case 4 is the WHERE ... HAVING 1=1 shape from the engine PR review.
 */

drop table if exists t27292, h27292, tk27292, rp27292, rs27292;

create table h27292 (v varchar(2000));
insert into h27292
select (select group_concat(md5(to_char(level)) separator '') from db_root connect by level <= 30)
    || (select group_concat(md5(to_char(level + 30)) separator '') from db_root connect by level <= 30);

create table t27292 (id int, pad varchar(2000));
insert into t27292 select level, (select v from h27292) from db_root connect by level <= 1000;

create table tk27292 (k int);
insert into tk27292 select rownum from t27292 a, (select level from db_root connect by level <= 50) b;
create index idx_k on tk27292 (k);

create table rp27292 (one int);
create table rs27292 (one int);

evaluate 'Case 1: constant output over a heap scan, mergeable list; parallel = serial';
set trace on;
insert into rp27292 select /*+ recompile parallel(4) */ 1 from t27292;
show trace;
set trace off;
insert into rs27292 select /*+ recompile no_parallel_scan */ 1 from t27292;
select case when (select count(*) from rp27292) = 1000
             and (select count(*) from rs27292) = 1000
             and (select count(*) from rp27292 where one <=> 1) = 1000
             and (select count(*) from rs27292 where one <=> 1) = 1000
            then 'PASS' else 'FAIL' end as case1;
delete from rp27292;
delete from rs27292;

evaluate 'Case 2: constant output over a list scan, mergeable list; parallel = serial';
set trace on;
insert into rp27292 select /*+ recompile parallel(4) */ 1 from (select /*+ no_merge */ id, pad from t27292) d;
show trace;
set trace off;
insert into rs27292 select /*+ recompile no_parallel_scan */ 1 from (select /*+ no_merge */ id, pad from t27292) d;
select case when (select count(*) from rp27292) = 1000
             and (select count(*) from rs27292) = 1000
             and (select count(*) from rp27292 where one <=> 1) = 1000
             and (select count(*) from rs27292 where one <=> 1) = 1000
            then 'PASS' else 'FAIL' end as case2;
delete from rp27292;
delete from rs27292;

evaluate 'Case 3: BUILDVALUE without aggregate (HAVING sys_timestamp), row by row; one row valued 1';
set trace on;
select /*+ recompile parallel(4) */ 1 from t27292 having sys_timestamp is not null;
show trace;
set trace off;
select case when p.c = 1 and p.v <=> 1 and s.c = 1 and s.v <=> 1 then 'PASS' else 'FAIL' end as case3
  from (select count(*) c, max(x.one) v
          from (select /*+ recompile parallel(4) */ 1 one from t27292 having sys_timestamp is not null) x) p,
       (select count(*) c, max(x.one) v
          from (select /*+ recompile no_parallel_scan */ 1 one from t27292 having sys_timestamp is not null) x) s;

evaluate 'Case 4: BUILDVALUE without aggregate (WHERE id > 0 HAVING 1=1), row by row; one row valued 1';
set trace on;
select /*+ recompile parallel(4) */ 1 from t27292 where id > 0 having 1=1;
show trace;
set trace off;
select case when p.c = 1 and p.v <=> 1 and s.c = 1 and s.v <=> 1 then 'PASS' else 'FAIL' end as case4
  from (select count(*) c, max(x.one) v
          from (select /*+ recompile parallel(4) */ 1 one from t27292 where id > 0 having 1=1) x) p,
       (select count(*) c, max(x.one) v
          from (select /*+ recompile no_parallel_scan */ 1 one from t27292 where id > 0 having 1=1) x) s;

evaluate 'Case 5: constant output over an index scan, mergeable list; parallel = serial';
set trace on;
insert into rp27292 select /*+ recompile parallel(4) */ 1 from tk27292 force index (idx_k) where k > 0;
show trace;
set trace off;
insert into rs27292 select /*+ recompile no_parallel_scan */ 1 from tk27292 force index (idx_k) where k > 0;
select case when (select count(*) from rp27292) = 50000
             and (select count(*) from rs27292) = 50000
             and (select count(*) from rp27292 where one <=> 1) = 50000
             and (select count(*) from rs27292 where one <=> 1) = 50000
            then 'PASS' else 'FAIL' end as case5;
delete from rp27292;
delete from rs27292;

drop table if exists t27292, h27292, tk27292, rp27292, rs27292;
