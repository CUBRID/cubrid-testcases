/**
 *  This test case verifies CBRD-27361: a hash GROUP BY whose table overflows finishes the leftovers by hashing them
 *  again (the hash merge), which meets two groups only when their hashes are equal, and when the order of the groups
 *  does not reach the result (agg_hash_respect_order=no, or a DISTINCT over the groups) it writes the merged groups
 *  out without the sort that brings equal keys together.  Keys that compare equal in other spellings must make one
 *  group, as on the sort path.
 *
 *  Data: 60,000 groups g, a key k of 110 bytes each (the default max_agg_hash_size cannot hold them: the leftovers
 *  are merged), 8 rows a group spaced 10,000 rows apart.  The other columns hold one value of g per group, written
 *  in two or three spellings across its rows: a case-insensitive collation's 'ab' / 'AB' / 'Ab', NUMERIC 5.0 / 5.00,
 *  DOUBLE -0 / +0, INT / BIGINT, DATE / DATETIME, TIMESTAMP / DATETIME, MONETARY / DOUBLE, an ENUM / its string, and an
 *  accent-insensitive collation with expansions' 'cafe' / 'café'.  CHAR / VARCHAR through a CASE stays two keys (the
 *  VARCHAR result keeps the CHAR's padding: 120,000 groups, as on the sort path).
 *
 *  Coverage:
 *    Case 1: GROUP BY k and a spelled key with agg_hash_respect_order=no -- 60,000 groups and 480,000 rows for each spelled key
 *    Case 2: a DISTINCT over the same groups (agg_hash_respect_order=yes)
 *    Case 3: the sort path (NO_HASH_AGGREGATE) gives the same answers
 */

drop table if exists t_ge;
create table t_ge (k varchar(120), g int, r int, s varchar(16) collate utf8_en_ci, a numeric(10,1), b numeric(11,2),
                   z double, c8 char(8), v8 varchar(8), i int, d date, ts timestamp, dt datetime, m monetary,
                   e enum ('x', 'y', 'z'), de varchar (40) collate utf8_de_exp_ai_ci);
insert into t_ge
  select 'group-' || lpad (cast (g as varchar), 6, '0') || repeat ('-', 98), g, r,
         decode (mod (r, 3), 0, 'ab', 1, 'AB', 'Ab') || cast (mod (g, 97) as varchar),
         mod (g, 1000) / 2, mod (g, 1000) / 2, case when mod (r, 2) = 0 then -1.0e0 * 0.0e0 else 0.0e0 end,
         cast (mod (g, 1000) as varchar), cast (mod (g, 1000) as varchar), mod (g, 1000),
         adddate (date '2020-01-01', mod (g, 365)), adddate (timestamp '2020-01-01 00:00:00', mod (g, 365)),
         adddate (datetime '2020-01-01 00:00:00.000', mod (g, 365)), cast (mod (g, 1000) as monetary),
         mod (g, 3) + 1, decode (mod (r, 2), 0, 'cafe', 'café') || cast (mod (g, 97) as varchar)
  from (select mod (n - 1, 10000) + 10000 * cast (trunc ((n - 1) / 80000) as int) g,
               cast (trunc (mod (n - 1, 80000) / 10000) as int) r
        from (select (a - 1) * 960 + b as n
              from (select level as a from db_root connect by level <= 500) x,
                   (select level as b from db_root connect by level <= 960) y) z) w;
select count (*), count (distinct g), sum (r), count (distinct s), count (distinct z) from t_ge;

evaluate 'Case 1: GROUP BY k and a spelled key, agg_hash_respect_order=no';
set system parameters 'agg_hash_respect_order=no';
select /*+ recompile */ 'ci', count (*), sum (c) from (select k, s, count (*) c from t_ge group by k, s) x;
select /*+ recompile */ 'numeric', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then a else b end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then a else b end) x;
select /*+ recompile */ 'zero', count (*), sum (c) from (select k, z, count (*) c from t_ge group by k, z) x;
select /*+ recompile */ 'char', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then c8 else v8 end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then c8 else v8 end) x;
select /*+ recompile */ 'bigint', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then i else cast (i as bigint) end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then i else cast (i as bigint) end) x;
select /*+ recompile */ 'date', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then d else cast (d as datetime) end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then d else cast (d as datetime) end) x;
select /*+ recompile */ 'timestamp', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then ts else dt end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then ts else dt end) x;
select /*+ recompile */ 'monetary', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then m else cast (m as double) end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then m else cast (m as double) end) x;
select /*+ recompile */ 'enum', count (*), sum (c) from (select k, case when mod (r, 2) = 0 then e else cast (e as varchar (1)) end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then e else cast (e as varchar (1)) end) x;
select /*+ recompile */ 'exp_ai', count (*), sum (c) from (select k, de, count (*) c from t_ge group by k, de) x;

evaluate 'Case 2: a DISTINCT over the groups, agg_hash_respect_order=yes';
set system parameters 'agg_hash_respect_order=yes';
select /*+ recompile */ 'ci', count (*), sum (c) from (select distinct k, s, count (*) c from t_ge group by k, s) x;
select /*+ recompile */ 'numeric', count (*), sum (c) from (select distinct k, case when mod (r, 2) = 0 then a else b end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then a else b end) x;
select /*+ recompile */ 'zero', count (*), sum (c) from (select distinct k, z, count (*) c from t_ge group by k, z) x;
select /*+ recompile */ 'char', count (*), sum (c) from (select distinct k, case when mod (r, 2) = 0 then c8 else v8 end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then c8 else v8 end) x;
select /*+ recompile */ 'timestamp', count (*), sum (c) from (select distinct k, case when mod (r, 2) = 0 then ts else dt end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then ts else dt end) x;
select /*+ recompile */ 'exp_ai', count (*), sum (c) from (select distinct k, de, count (*) c from t_ge group by k, de) x;

evaluate 'Case 3: the sort path gives the same answers';
select /*+ recompile */ 'ci', count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ k, s, count (*) c from t_ge group by k, s) x;
select /*+ recompile */ 'numeric', count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ k, case when mod (r, 2) = 0 then a else b end kk, count (*) c from t_ge group by k, case when mod (r, 2) = 0 then a else b end) x;
select /*+ recompile */ 'zero', count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ k, z, count (*) c from t_ge group by k, z) x;
select /*+ recompile */ 'exp_ai', count (*), sum (c) from (select /*+ NO_HASH_AGGREGATE */ k, de, count (*) c from t_ge group by k, de) x;

drop table t_ge;
