/**
 *  This test case verifies CBRD-27361: when the hash GROUP BY's merge of its leftovers sends a partition it
 *  cannot hold to the sort after it has already written other groups, the sort still opens its own first
 *  group. The BIGINT keys k * 4294967297 hash alike, so their partition stays over the budget at both levels
 *  of the split and goes to the sort; the plain keys are merged and written first.
 *
 *  Coverage:
 *    Case 1: 55,000 groups in a SELECT DISTINCT block, whose order the merge may disregard: every group
 *            once, each with its count
 *    Case 2: the sort path (NO_HASH_AGGREGATE) and the block without DISTINCT agree
 */

drop table if exists t_gms;
create table t_gms (k bigint, v int);
insert into t_gms select cast (level as bigint) * 4294967297, 1 from db_root connect by level <= 50000;
insert into t_gms select k, v from t_gms;
insert into t_gms select level, 1 from db_root connect by level <= 5000;
insert into t_gms select level, 1 from db_root connect by level <= 5000;

evaluate 'Case 1: a DISTINCT block, a partition over the budget goes to the sort';
select count(*), sum(c), min(c), max(c) from (select distinct k, count(*) c from t_gms group by k) x;

evaluate 'Case 2: the sort path and the block without DISTINCT agree';
select count(*), sum(c), min(c), max(c) from (select /*+ NO_HASH_AGGREGATE */ distinct k, count(*) c from t_gms group by k) x;
select count(*), sum(c), min(c), max(c) from (select k, count(*) c from t_gms group by k) x;

drop table t_gms;
