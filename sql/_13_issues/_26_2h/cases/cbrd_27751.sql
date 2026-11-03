/**
 *  This test case verifies CBRD-27751: a GROUP BY skip (group by nosort) plan must not split one
 *  group into several rows. Two sources of the split are fixed, both of them already avoided by
 *  ORDER BY skip:
 *    - index_scan_in_oid_order=yes sorts the OIDs of every batch of a non-covered index scan, so
 *      the rows of one key do not arrive together
 *    - a prefix index (col(n)) orders only the first n characters, so one index key holds several
 *      column values and its order is not the order of the column
 *  Every query is read back against the same query over the heap (IGNORE INDEX) or against the
 *  group count, neither of which depends on the index order. Cases 1 and 5 are Case 14 and Case 16
 *  of the develop test cbrd_27664, which covers the same two fixes.
 *  CTP masks digits, so a count in the trace proves nothing: the plan line is what names the scan.
 *  Coverage:
 *    Case 1: index_scan_in_oid_order=yes on a non-covered GROUP BY skip scan
 *    Case 2: the same parameter on a covered scan, which never sorted the OIDs
 *    Case 3: the same parameter, counting the groups of a derived table and of an early LIMIT
 *    Case 4: the same parameter with ORDER BY skip, which read the index order before the fix too
 *    Case 5: a prefix index does not order the groups
 *    Case 6: a prefix index kept in the plan by FORCE INDEX, with MIN and MAX, HAVING, descending
 *    Case 7: a prefix index whose length covers the whole value gives up the skip as well
 *    Case 8: keys shorter than the prefix and the empty string, with the parameter on
 */

drop table if exists t_digit, t_main, t_pfx, t_pfxw;

-- ten digits for the cross joins below
create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 200000 rows: g has 35 keys of 5714 or 5715 rows, v is not in i_g so a query reading it is not
-- covered and its scan sorts the OIDs when the parameter below is on
create table t_main (id int primary key, g int not null, v int);
insert into t_main select rownum, mod(rownum, 35), mod(rownum * 7, 1000) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e, t_digit f limit 200000;
create index i_g on t_main (g);
-- 1000 rows over 7 values that all share the three-character prefix: i_p holds one key for them
create table t_pfx (s varchar(20) not null, x int);
insert into t_pfx select 'abc' || mod(id, 7), id from t_main where id <= 1000;
create index i_p on t_pfx (s(3));
-- the same 7 groups where the prefix is as long as the column: one index key per value
create table t_pfxw (s varchar(3) not null, x int);
insert into t_pfxw select 'a' || mod(id, 7), id from t_main where id <= 1000;
create index i_pw on t_pfxw (s(3));
update statistics on t_digit, t_main, t_pfx, t_pfxw with fullscan;

set trace on;


-- one setting for Cases 1 to 4; Case 8 sets it again for the prefix index
set system parameters 'index_scan_in_oid_order=yes';

evaluate 'Case 1: index_scan_in_oid_order=yes on a non-covered GROUP BY skip scan; result = IGNORE INDEX';
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by count(*), g;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_main ignore index (i_g) where g between 0 and 34 group by g order by count(*), g;


evaluate 'Case 2: the same parameter on a covered scan, which never sorted the OIDs; result = IGNORE INDEX';
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by count(*), g;
show trace;
select /*+ recompile */ g, count(*) from t_main ignore index (i_g) where g between 0 and 34 group by g order by count(*), g;


evaluate 'Case 3: the same parameter, the group count of a derived table and of an early LIMIT; result = IGNORE INDEX';
select count(*), sum(c), sum(sv) from (select /*+ recompile */ g, count(*) c, sum(v) sv from t_main force index (i_g) where g between 0 and 34 group by g) x;
show trace;
select count(*), sum(c), sum(sv) from (select /*+ recompile */ g, count(*) c, sum(v) sv from t_main ignore index (i_g) where g between 0 and 34 group by g) x;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by g limit 3;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_main ignore index (i_g) where g between 0 and 34 group by g order by g limit 3;


evaluate 'Case 4: the same parameter with ORDER BY skip, which read the index order before the fix too';
-- v sits in the predicate only: that keeps the scan non-covered, which is the shape the parameter
-- acts on, while the answer holds the key column alone and pins no row order inside one key. The
-- OID sort makes the two keys interleave (1, 0, 1, ...) instead of staying in index order.
select /*+ recompile */ g from t_main force index (i_g) where g between 0 and 1 and v >= 0 order by g limit 5;
show trace;
set system parameters 'index_scan_in_oid_order=default';


evaluate 'Case 5: a prefix index does not order the groups; result = IGNORE INDEX';
select /*+ recompile */ s, count(*), sum(x) from t_pfx where s > '' group by s order by s;
show trace;
select /*+ recompile */ s, count(*), sum(x) from t_pfx ignore index (i_p) where s > '' group by s order by s;


evaluate 'Case 6: a prefix index kept in the plan by FORCE INDEX, with MIN and MAX, HAVING, descending; result = IGNORE INDEX';
select /*+ recompile */ s, count(*), sum(x) from t_pfx force index (i_p) where s > '' group by s order by s;
show trace;
select /*+ recompile */ s, count(*), sum(x) from t_pfx ignore index (i_p) where s > '' group by s order by s;
select /*+ recompile */ s, min(x), max(x) from t_pfx force index (i_p) where s > '' group by s having count(*) > 142 order by s;
show trace;
select /*+ recompile */ s, min(x), max(x) from t_pfx ignore index (i_p) where s > '' group by s having count(*) > 142 order by s;
select /*+ recompile */ s, count(*) from t_pfx force index (i_p) where s > '' group by s order by s desc;
show trace;
select /*+ recompile */ s, count(*) from t_pfx ignore index (i_p) where s > '' group by s order by s desc;


evaluate 'Case 7: a prefix index whose length covers the whole value gives up the skip as well; result = IGNORE INDEX';
select /*+ recompile */ s, count(*), sum(x) from t_pfxw force index (i_pw) where s > '' group by s order by s;
show trace;
select /*+ recompile */ s, count(*), sum(x) from t_pfxw ignore index (i_pw) where s > '' group by s order by s;


evaluate 'Case 8: keys shorter than the prefix and the empty string, with the parameter on; result = IGNORE INDEX';
insert into t_pfx values ('', -1), ('ab', -2), ('ab', -3);
update statistics on t_pfx with fullscan;
set system parameters 'index_scan_in_oid_order=yes';
select /*+ recompile */ s, count(*), sum(x) from t_pfx force index (i_p) where s >= '' group by s order by s;
show trace;
select /*+ recompile */ s, count(*), sum(x) from t_pfx ignore index (i_p) where s >= '' group by s order by s;
set system parameters 'index_scan_in_oid_order=default';


set trace off;

drop table t_digit, t_main, t_pfx, t_pfxw;
