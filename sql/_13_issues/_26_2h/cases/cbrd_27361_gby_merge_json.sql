/**
 *  This test case verifies CBRD-27361: a hash GROUP BY whose table overflows finishes the leftovers by hashing them
 *  again (the hash merge), and when the order of the groups does not reach the result (agg_hash_respect_order=no, or
 *  a DISTINCT over the groups) it writes the merged groups out without the sort.  A JSON key compares by a scalar's
 *  value -- true as 'true', -0.0 as 0.0 -- but hashes its text, so such keys keep the sort: JSON true and "true" (and
 *  -0.0 and 0.0) make one group, as on the sort path.
 *
 *  Data: 60,000 keys k of 110 bytes (the default max_agg_hash_size cannot hold them: the leftovers are merged), each
 *  with 4 rows of j = true and 4 rows of j = "true"; then the same rows with j = -0.0 and 0.0.
 *
 *  Coverage:
 *    Case 1: true and "true" -- GROUP BY with agg_hash_respect_order=no (with and without a parallel scan), a DISTINCT
 *            over the groups, and the sort path (NO_HASH_AGGREGATE)
 *    Case 2: -0.0 and 0.0, the same queries
 */

drop table if exists t_gj;
create table t_gj (k varchar(120), j json, h int);
insert into t_gj select 'group-' || lpad(cast(mod(n - 1, 10000) + 10000 * cast(trunc((n - 1) / 40000) as int) as varchar), 6, '0') || repeat('-', 98), cast('true' as json), 0 from (select (a - 1) * 480 + b as n from (select level as a from db_root connect by level <= 500) x, (select level as b from db_root connect by level <= 480) y) z;
insert into t_gj select 'group-' || lpad(cast(mod(n - 1, 10000) + 10000 * cast(trunc((n - 1) / 40000) as int) as varchar), 6, '0') || repeat('-', 98), cast('"true"' as json), 1 from (select (a - 1) * 480 + b as n from (select level as a from db_root connect by level <= 500) x, (select level as b from db_root connect by level <= 480) y) z;
select count (*), sum (h) from t_gj;

evaluate 'Case 1: JSON true and "true" make one group';
set system parameters 'agg_hash_respect_order=no';
select /*+ recompile */ count (*), sum (c) from (select k, j, count (*) c from t_gj group by k, j) x;
select /*+ recompile */ count (*), sum (c) from (select /*+ NO_PARALLEL_SCAN */ k, j, count (*) c from t_gj group by k, j) x;
set system parameters 'agg_hash_respect_order=yes';
select /*+ recompile */ count (*), sum (c) from (select distinct k, j, count (*) c from t_gj group by k, j) x;
select /*+ recompile */ count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ k, j, count (*) c from t_gj group by k, j) x;

evaluate 'Case 2: JSON -0.0 and 0.0 make one group';
update t_gj set j = cast ('-0.0' as json) where h = 0;
update t_gj set j = cast ('0.0' as json) where h = 1;
set system parameters 'agg_hash_respect_order=no';
select /*+ recompile */ count (*), sum (c) from (select k, j, count (*) c from t_gj group by k, j) x;
select /*+ recompile */ count (*), sum (c) from (select /*+ NO_PARALLEL_SCAN */ k, j, count (*) c from t_gj group by k, j) x;
set system parameters 'agg_hash_respect_order=yes';
select /*+ recompile */ count (*), sum (c) from (select distinct k, j, count (*) c from t_gj group by k, j) x;
select /*+ recompile */ count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ k, j, count (*) c from t_gj group by k, j) x;

drop table t_gj;
