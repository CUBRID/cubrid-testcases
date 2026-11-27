/**
 *  This test case verifies CBRD-27361: a hash GROUP BY whose table overflows finishes the leftovers by hashing them
 *  again (the hash merge), and when the order of the groups does not reach the result (agg_hash_respect_order=no)
 *  it writes the merged groups out without the sort. A DOUBLE key of -0 and +0 compares equal, so the two must
 *  make one group there as they do on the sort path.
 *
 *  Data: the first 20,000 rows hold 10 keys (0 .. 9, so the hash is kept past the selectivity check), the next
 *  160,000 rows are distinct keys (the default max_agg_hash_size cannot hold them: the leftovers are merged), the
 *  last 7 rows are -0.0. The zero group has 2,007 rows.
 *
 *  Coverage:
 *    Case 1: agg_hash_respect_order=no -- GROUP BY and DISTINCT, with and without a parallel scan
 *    Case 2: the sort path (agg_hash_respect_order=yes, NO_HASH_AGGREGATE) gives the same answers
 */

drop table if exists t_gz;
create table t_gz (d double);
insert into t_gz select mod (n, 10) * 1.0e0 from (select (a - 1) * 100 + b as n from (select level as a from db_root connect by level <= 200) x, (select level as b from db_root connect by level <= 100) y) z;
insert into t_gz select 100.0e0 + n * 1.5e0 from (select (a - 1) * 400 + b as n from (select level as a from db_root connect by level <= 400) x, (select level as b from db_root connect by level <= 400) y) z;
insert into t_gz select -1.0e0 * 0.0e0 from db_root connect by level <= 7;
select count (*), sum (case when d = 0 then 1 else 0 end) from t_gz;

evaluate 'Case 1: the hash merge without the sort keeps -0 and +0 in one group';
set system parameters 'agg_hash_respect_order=no';
select /*+ recompile */ count (*), sum (c) from (select d, count (*) as c from t_gz group by d) x where d = 0;
select /*+ recompile */ count (*), sum (c) from (select /*+ NO_PARALLEL_SCAN */ d, count (*) as c from t_gz group by d) x where d = 0;
select /*+ recompile */ count (*) from (select distinct d from t_gz) x where d = 0;
select /*+ recompile */ count (*), sum (c) from (select d, count (*) as c from t_gz group by d) x;

evaluate 'Case 2: the sort path gives the same answers';
set system parameters 'agg_hash_respect_order=yes';
select /*+ recompile */ count (*), sum (c) from (select d, count (*) as c from t_gz group by d) x where d = 0;
select /*+ recompile */ count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ d, count (*) as c from t_gz group by d) x where d = 0;
select /*+ recompile */ count (*) from (select distinct d from t_gz) x where d = 0;
select /*+ recompile */ count (*), sum (c) from (select d, count (*) as c from t_gz group by d) x;

drop table t_gz;
