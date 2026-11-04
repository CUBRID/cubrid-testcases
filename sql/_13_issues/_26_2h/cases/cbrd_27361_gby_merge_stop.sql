/**
 *  This test case verifies CBRD-27361: a hash GROUP BY whose table cannot hold every group finishes the
 *  leftovers by hashing them again, split into partitions by the key's hash, when the order of the groups
 *  does not reach the result (agg_hash_respect_order=no). Each partition's groups are written out as they
 *  are built, so a statement can stop in the first partition (GROUPBY_NUM() or a LIMIT on the groups) or
 *  fail there (an error raised by the HAVING clause). The results, the row counts and the error must equal
 *  the sort path's (agg_hash_respect_order=yes, and the NO_HASH_AGGREGATE hint), and the session must run
 *  the next statement after the error.
 *
 *  Data: 60,000 groups with a 110-byte key, far above the default max_agg_hash_size (2M), each group's 4 rows
 *  10,000 rows apart: the table fills on the first rows and lets the rest go, so the leftovers hold about four
 *  rows a group and the merge takes them in several partitions.
 *
 *  Coverage:
 *    Case 1: agg_hash_respect_order=no -- HAVING on the group, an outer ORDER BY ... LIMIT over every group
 *            (with the parameter off the groups come in no order, so the ORDER BY sits outside the GROUP BY block)
 *    Case 2: GROUPBY_NUM() <= 10 and LIMIT 10 on the groups stop in the first partition
 *    Case 3: a HAVING that divides by zero fails in the first partition, the next statement runs
 *    Case 4: the same with the scan kept serial (NO_PARALLEL_SCAN)
 *    Case 5: the sort path -- agg_hash_respect_order=yes and NO_HASH_AGGREGATE -- gives the same answers
 */

drop table if exists t_gm;

create table t_gm (k varchar(120), v int);
insert into t_gm select 'group-' || lpad(cast(mod(n - 1, 10000) + 10000 * cast(trunc((n - 1) / 40000) as int) as varchar), 6, '0') || repeat('-', 98), mod(n, 7) + 1 from (select (a - 1) * 480 + b as n from (select level as a from db_root connect by level <= 500) x, (select level as b from db_root connect by level <= 480) y) z;
select count(*), count(distinct k) from t_gm;

evaluate 'Case 1: the hash merge, HAVING on the group and ORDER BY ... LIMIT over every group';
set system parameters 'agg_hash_respect_order=no';
select * from (select k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x order by k limit 5;
select count(*), sum(c), sum(s) from (select k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x;
select count(*), sum(c), sum(s) from (select k, count(*) as c, sum(v) as s from t_gm group by k having sum(v) > 18) x;

evaluate 'Case 2: GROUPBY_NUM() and LIMIT on the groups stop in the first partition';
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k having groupby_num() <= 10) x;
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k having count(*) > 3 and groupby_num() <= 10) x;
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k limit 10) x;
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k having groupby_num() <= 100000) x;

evaluate 'Case 3: the HAVING divides by zero in the first partition, the next statement still runs';
select k, count(*), sum(v) from t_gm group by k having 1 / (count(*) - 4) > 0;
select count(*) from t_gm;
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k having count(*) > 3) x;

evaluate 'Case 4: the same with the scan kept serial';
select * from (select /*+ NO_PARALLEL_SCAN */ k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x order by k limit 5;
select count(*), sum(c), sum(s) from (select /*+ NO_PARALLEL_SCAN */ k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x;
select count(*), sum(c) from (select /*+ NO_PARALLEL_SCAN */ k, count(*) as c from t_gm group by k having groupby_num() <= 10) x;
select count(*), sum(c) from (select /*+ NO_PARALLEL_SCAN */ k, count(*) as c from t_gm group by k limit 10) x;
select /*+ NO_PARALLEL_SCAN */ k, count(*), sum(v) from t_gm group by k having 1 / (count(*) - 4) > 0;
select /*+ NO_PARALLEL_SCAN */ count(*) from t_gm;

evaluate 'Case 5: the sort path gives the same answers';
set system parameters 'agg_hash_respect_order=yes';
select * from (select k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x order by k limit 5;
select k, count(*), sum(v) from t_gm group by k having count(*) > 3 order by k limit 5;
select count(*), sum(c), sum(s) from (select k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x;
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k having groupby_num() <= 10) x;
select count(*), sum(c) from (select k, count(*) as c from t_gm group by k limit 10) x;
select k, count(*), sum(v) from t_gm group by k having 1 / (count(*) - 4) > 0;
select count(*) from t_gm;
select * from (select /*+ NO_HASH_AGGREGATE */ k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x order by k limit 5;
select count(*), sum(c), sum(s) from (select /*+ NO_HASH_AGGREGATE */ k, count(*) as c, sum(v) as s from t_gm group by k having count(*) > 3) x;
select count(*), sum(c) from (select /*+ NO_HASH_AGGREGATE */ k, count(*) as c from t_gm group by k having groupby_num() <= 10) x;
select /*+ NO_HASH_AGGREGATE */ k, count(*), sum(v) from t_gm group by k having 1 / (count(*) - 4) > 0;
set system parameters 'agg_hash_respect_order=default';

drop table t_gm;
