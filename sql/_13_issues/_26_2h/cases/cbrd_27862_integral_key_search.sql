/**
 *  This test case verifies CBRD-27862: the binary searches of a B-tree node compare the key image of a
 *  single-column SHORT, INTEGER or BIGINT index with the search key, instead of reading each key into a
 *  DB_VALUE, when the search key has the index's type and compares without a conversion. Every check compares
 *  an index scan with a full scan of the same table; each mismatch count must be 0.
 *
 *  The table has ascending, descending and unique indexes, one key with 5,000 rows (its OIDs overflow the leaf
 *  record) and records left with delete and update marks.
 *
 *  Coverage:
 *    Case 1: equality on present, missing and boundary keys (SHORT, INT, BIGINT, unique, descending)
 *    Case 2: ranges with open and closed bounds, descending indexes, rows read in index order
 *    Case 3: bounds of other types (NUMERIC, DOUBLE, string, out-of-range constants), which compare through
 *            DB_VALUEs as before
 *    Case 4: the inner index scan of a nested-loop join, searched once per outer row
 */

drop table if exists t27862;
drop table if exists d27862;

create table d27862 (x int);
insert into d27862 with recursive r (n) as (select 0 union all select n + 1 from r where n < 99) select n from r;

create table t27862 (id int primary key, s short, i int, b bigint, iu int, idsc int, bdsc bigint);
insert into t27862
  select a.x + 100 * b.x + 10000 * c.x,
         cast ((a.x + 100 * b.x + 10000 * c.x) % 2000 - 1000 as short),
         ((a.x + 100 * b.x + 10000 * c.x) % 5003) * 7 - 17000,
         cast (((a.x + 100 * b.x + 10000 * c.x) % 4001 - 2000) as bigint) * 1000000007,
         (a.x + 100 * b.x + 10000 * c.x) * 3 - 50000,
         (a.x + 100 * b.x + 10000 * c.x) % 3001 - 1500,
         cast (((a.x + 100 * b.x + 10000 * c.x) % 2999 - 1500) as bigint) * 3000000019
  from d27862 a, d27862 b, d27862 c where c.x < 6;
-- one key with 5,000 rows
insert into t27862 select 60000 + a.x + 100 * b.x, 7, 7, 7, 200000 + a.x + 100 * b.x, 7, 7 from d27862 a, d27862 b where b.x < 50;
create index ix_s on t27862 (s);
create index ix_i on t27862 (i);
create index ix_b on t27862 (b);
create unique index ux_iu on t27862 (iu);
create index ix_idsc on t27862 (idsc desc);
create index ix_bdsc on t27862 (bdsc desc);
-- records left with delete and update marks
delete from t27862 where id % 97 = 3;
update t27862 set i = i + 1, s = s + 1 where id % 89 = 5;
update statistics on t27862;

evaluate 'Case 1: equality';
select 'eq_s', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where s = v using index ix_s) a, (select count (*) from t27862 where s = v using index none) b
        from (select cast (x - 1001 as short) v from d27862 where x % 4 = 1 union all select cast (7 as short) union all select cast (-1000 as short)
              union all select cast (999 as short) union all select cast (32767 as short) union all select cast (-32768 as short)) q) r;
select 'eq_i', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where i = v using index ix_i) a, (select count (*) from t27862 where i = v using index none) b
        from (select x * 351 - 17000 v from d27862 where x % 4 = 1 union all select 7 union all select -17000 union all select 18014
              union all select 2147483647 union all select -2147483648) q) r;
select 'eq_b', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where b = v using index ix_b) a, (select count (*) from t27862 where b = v using index none) b
        from (select cast (x * 41 - 2000 as bigint) * 1000000007 v from d27862 where x % 4 = 1 union all select cast (7 as bigint)
              union all select cast (9223372036854775807 as bigint) union all select cast (-9223372036854775807 as bigint)) q) r;
select 'eq_iu', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where iu = v using index ux_iu) a, (select count (*) from t27862 where iu = v using index none) b
        from (select x * 1801 - 50000 v from d27862 where x % 4 = 1 union all select -50000 union all select 129997 union all select 129998) q) r;
select 'eq_idsc', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where idsc = v using index ix_idsc) a, (select count (*) from t27862 where idsc = v using index none) b
        from (select x * 31 - 1501 v from d27862 where x % 4 = 1 union all select 7 union all select -1500 union all select 1500) q) r;
select 'eq_bdsc', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where bdsc = v using index ix_bdsc) a, (select count (*) from t27862 where bdsc = v using index none) b
        from (select cast (x * 31 - 1501 as bigint) * 3000000019 v from d27862 where x % 4 = 1 union all select cast (7 as bigint)) q) r;

evaluate 'Case 2: ranges and index order';
select 'rng_i', count (*) from (select x * 351 - 17000 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || sum (id) from t27862 where i > v and i <= v + 3500 using index ix_i)
     <> (select count (*) || ':' || sum (id) from t27862 where i > v and i <= v + 3500 using index none);
select 'rng_s', count (*) from (select x - 1001 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || sum (id) from t27862 where s >= v and s < v + 13 using index ix_s)
     <> (select count (*) || ':' || sum (id) from t27862 where s >= v and s < v + 13 using index none);
select 'rng_b', count (*) from (select cast (x * 41 - 2000 as bigint) * 1000000007 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || sum (id) from t27862 where b between v and v + 50000000000 using index ix_b)
     <> (select count (*) || ':' || sum (id) from t27862 where b between v and v + 50000000000 using index none);
select 'rng_idsc', count (*) from (select x * 31 - 1501 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || sum (id) from t27862 where idsc < v and idsc >= v - 40 using index ix_idsc)
     <> (select count (*) || ':' || sum (id) from t27862 where idsc < v and idsc >= v - 40 using index none);
select 'rng_bdsc', count (*) from (select cast (x * 31 - 1501 as bigint) * 3000000019 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || sum (id) from t27862 where bdsc <= v and bdsc > v - 90000000000 using index ix_bdsc)
     <> (select count (*) || ':' || sum (id) from t27862 where bdsc <= v and bdsc > v - 90000000000 using index none);
select 'ord_idsc', idsc, id from t27862 where idsc between -3 and 3 using index ix_idsc order by idsc desc, id limit 12;
select 'ord_i', i, id from t27862 where i >= 100 using index ix_i order by i, id limit 8;

evaluate 'Case 3: bounds of other types';
select 'mix1', (select count (*) from t27862 where i = 7.0 using index ix_i) - (select count (*) from t27862 where i = 7.0 using index none);
select 'mix2', (select count (*) from t27862 where i < 7.5e0 and i > -10.5 using index ix_i) - (select count (*) from t27862 where i < 7.5e0 and i > -10.5 using index none);
select 'mix3', (select count (*) from t27862 where s = 70000 using index ix_s) - (select count (*) from t27862 where s = 70000 using index none);
select 'mix4', (select count (*) from t27862 where b = 7 using index ix_b) - (select count (*) from t27862 where b = 7 using index none);
select 'mix5', (select count (*) from t27862 where i = '7' using index ix_i) - (select count (*) from t27862 where i = '7' using index none);
select 'mix6', (select count (*) from t27862 where b > 2147483648 using index ix_b) - (select count (*) from t27862 where b > 2147483648 using index none);
select 'mix7', (select count (*) from t27862 where s in (7, 8, -1000, 999) using index ix_s) - (select count (*) from t27862 where s in (7, 8, -1000, 999) using index none);

evaluate 'Case 4: the inner index scan of a nested-loop join';
select 'nl_i', (select /*+ ordered use_nl */ count (*) || ':' || sum (o.x + n.id) from d27862 o, t27862 n where n.i = o.x * 351 - 17000 using index n.ix_i)
             = (select count (*) || ':' || sum (o.x + n.id) from d27862 o, t27862 n where n.i = o.x * 351 - 17000 using index none);
select 'nl_s', (select /*+ ordered use_nl */ count (*) from d27862 o, t27862 n where n.s = o.x - 50 using index n.ix_s)
             - (select count (*) from d27862 o, t27862 n where n.s = o.x - 50 using index none);
select 'nl_iu', (select /*+ ordered use_nl */ count (*) from t27862 o, t27862 n where n.iu = o.i * 3 and o.id < 3000 using index n.ux_iu)
              - (select count (*) from t27862 o, t27862 n where n.iu = o.i * 3 and o.id < 3000 using index none);
select 'nl_idsc', (select /*+ ordered use_nl */ count (*) from d27862 o, t27862 n where n.idsc = o.x - 50 using index n.ix_idsc)
                - (select count (*) from d27862 o, t27862 n where n.idsc = o.x - 50 using index none);

drop table t27862;
drop table d27862;
