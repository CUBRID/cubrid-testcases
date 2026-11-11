/**
 *  This test case verifies CBRD-27802: a hash GROUP BY whose output reads only group keys and aggregates
 *  aggregates each group's rows in the order the scan gives them.
 *
 *  Before the change the hash GROUP BY set each group's first row aside and aggregated it after the other rows,
 *  so an aggregate whose result depends on the order of its input gave another result than with
 *  no_hash_aggregate. Now the first row is aggregated first. The pre-fix build fails this file by design.
 *
 *  The table is small, so its heap is scanned serially in insert order and no group leaves the hash table, and
 *  on it the sort GROUP BY (no_hash_aggregate) aggregates in the same order: each twin block must match.
 *  Group 1 has three rows, group 2 one row, which no order changes.
 *
 *  Coverage:
 *    Case 1:  JSON_ARRAYAGG lists the rows in input order
 *    Case 2:  JSON_OBJECTAGG keeps the first value of a duplicate key
 *    Case 3:  MAX and MIN under utf8_en_ci return the first of equal strings
 *    Case 4:  MAX of DATETIMETZ returns the first of equal instants with its own time zone
 *    Case 5:  SUM of SMALLINT overflows when the running sum does, in input order
 *    Case 6:  SUM of DOUBLE rounds in input order
 *    Case 7:  a non-key column in the select list keeps the order before the change, no twin
 */

drop table if exists t_ord;

-- 4 rows in one heap page: insert order is scan order
create table t_ord (g int, a int, b int, d double, sm smallint, s varchar(10) collate utf8_en_ci, j varchar(5), tz datetimetz);
insert into t_ord values (1, 1, 10, 1e16, 30000, 'a', 'x', datetimetz '2020-01-01 10:00:00 +09:00');
insert into t_ord values (1, 2, 10, 1, 10000, 'A', 'y', datetimetz '2020-01-01 01:00:00 +00:00');
insert into t_ord values (1, 3, 10, 1, -10000, 'a', 'z', datetimetz '2020-01-01 10:00:00 +09:00');
insert into t_ord values (2, 9, 20, 5, 1, 'q', 'w', datetimetz '2020-01-01 10:00:00 +09:00');
update statistics on t_ord with fullscan;


evaluate 'Case 1: JSON_ARRAYAGG in input order; result = no_hash_aggregate';
select /*+ recompile */ g, json_arrayagg(a) from t_ord group by g;
select /*+ recompile no_hash_aggregate */ g, json_arrayagg(a) from t_ord group by g;


evaluate 'Case 2: JSON_OBJECTAGG keeps the first value of a duplicate key; result = no_hash_aggregate';
select /*+ recompile */ g, json_objectagg('k', j) from t_ord group by g;
select /*+ recompile no_hash_aggregate */ g, json_objectagg('k', j) from t_ord group by g;


evaluate 'Case 3: MAX and MIN of equal strings under utf8_en_ci; result = no_hash_aggregate';
select /*+ recompile */ g, max(s), min(s) from t_ord group by g;
select /*+ recompile no_hash_aggregate */ g, max(s), min(s) from t_ord group by g;


evaluate 'Case 4: MAX of equal DATETIMETZ instants; result = no_hash_aggregate';
select /*+ recompile */ g, max(tz) from t_ord group by g;
select /*+ recompile no_hash_aggregate */ g, max(tz) from t_ord group by g;


evaluate 'Case 5: SUM of SMALLINT overflows in input order; result = no_hash_aggregate';
select /*+ recompile */ g, sum(sm) from t_ord group by g;
select /*+ recompile no_hash_aggregate */ g, sum(sm) from t_ord group by g;


evaluate 'Case 6: SUM of DOUBLE rounds in input order; result = no_hash_aggregate';
select /*+ recompile */ g, cast(sum(d) - 1e16 as bigint) from t_ord group by g;
select /*+ recompile no_hash_aggregate */ g, cast(sum(d) - 1e16 as bigint) from t_ord group by g;


evaluate 'Case 7: a non-key column keeps the first row aside, the order before the change';
select /*+ recompile */ g, b, json_arrayagg(a), json_objectagg('k', j) from t_ord group by g;

drop table t_ord;
