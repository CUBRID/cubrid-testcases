/**
 *  This test case verifies CBRD-27862: the binary searches of a B-tree node compare the key image of a
 *  single-column SHORT, INTEGER or BIGINT index with the search key, instead of reading each key into a
 *  DB_VALUE, when the search key has the index's type and compares without a conversion. Every check compares
 *  an index scan with a full scan of the same table; each mismatch count must be 0.
 *
 *  The table has ascending, descending and unique indexes, one key with 5,000 rows (its OIDs overflow the leaf
 *  record), and rows deleted and updated before the checks. A leaf record's key starts after more than the first
 *  object's OID where the record holds the class OID of a subclass row (Case 5) or the insert and delete MVCCIDs
 *  that vacuum has not cleared (Case 6).
 *
 *  Coverage:
 *    Case 1: equality on present, missing and boundary keys (SHORT, INT, BIGINT, unique, descending)
 *    Case 2: ranges with open and closed bounds, descending indexes, rows read in index order
 *    Case 3: bounds of other types (NUMERIC, DOUBLE, string, out-of-range constants), which compare through
 *            DB_VALUEs as before
 *    Case 4: the inner index scan of a nested-loop join, searched once per outer row
 *    Case 5: a unique index shared by a class hierarchy, whose records of subclass rows hold their class OID,
 *            and a key of another class of the hierarchy, which is still a duplicate
 *    Case 6: keys inserted, deleted and updated by a transaction that is still open, so that their records keep
 *            its MVCCIDs (the transaction rolls back at the end)
 */

drop table if exists t27862;
drop table if exists h27862a;
drop table if exists h27862b;
drop table if exists h27862;
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
-- deleted and updated rows: these commit, so vacuum may clear their records' MVCCIDs before the checks (Case 6 does not)
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
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where i > v and i <= v + 3500 using index ix_i)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where i > v and i <= v + 3500 using index none);
select 'rng_s', count (*) from (select x - 1001 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where s >= v and s < v + 13 using index ix_s)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where s >= v and s < v + 13 using index none);
select 'rng_b', count (*) from (select cast (x * 41 - 2000 as bigint) * 1000000007 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where b between v and v + 50000000000 using index ix_b)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where b between v and v + 50000000000 using index none);
select 'rng_idsc', count (*) from (select x * 31 - 1501 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where idsc < v and idsc >= v - 40 using index ix_idsc)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where idsc < v and idsc >= v - 40 using index none);
select 'rng_bdsc', count (*) from (select cast (x * 31 - 1501 as bigint) * 3000000019 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where bdsc <= v and bdsc > v - 90000000000 using index ix_bdsc)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where bdsc <= v and bdsc > v - 90000000000 using index none);
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

evaluate 'Case 5: a unique index shared by a class hierarchy';
-- the subclasses share the unique index of h27862; a leaf record of a subclass row also holds the row's class OID
create table h27862 (k int unique, c int);
create table h27862a under h27862;
create table h27862b under h27862;
insert into h27862 select (a.x + 100 * b.x) * 4, 0 from d27862 a, d27862 b where b.x < 20;
insert into h27862a select (a.x + 100 * b.x) * 4 + 1, 1 from d27862 a, d27862 b where b.x < 20;
insert into h27862b select (a.x + 100 * b.x) * 4 + 2, 2 from d27862 a, d27862 b where b.x < 20;
select 'h_eq', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from all h27862 where k = v using index u_h27862_k) a, (select count (*) from all h27862 where k = v using index none) b
        from (select x * 81 v from d27862) q) r;
select 'h_eq_sub', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from h27862a where k = v using index u_h27862_k) + (select count (*) from h27862b where k = v using index u_h27862_k) a,
               (select count (*) from h27862a where k = v using index none) + (select count (*) from h27862b where k = v using index none) b
        from (select x * 81 v from d27862) q) r;
select 'h_rng', count (*) from (select x * 81 v from d27862) q
  where (select count (*) || ':' || coalesce (sum (k), 0) from all h27862 where k > v and k <= v + 37 using index u_h27862_k)
     <> (select count (*) || ':' || coalesce (sum (k), 0) from all h27862 where k > v and k <= v + 37 using index none);
-- a key of another class of the hierarchy is a duplicate
insert into h27862b values (401, 9);
insert into h27862 values (402, 9);
insert into h27862a values (400, 9);
select 'h_dup', count (*) from all h27862 where k in (400, 401, 402) using index none;

evaluate 'Case 6: keys of a transaction that is still open';
autocommit off;
-- the records of the keys this transaction inserts, deletes and updates keep its MVCCIDs: vacuum cannot clear them
-- before the rollback
insert into t27862
  select 100000 + a.x + 100 * b.x,
         cast (1001 + (a.x + 100 * b.x) % 500 as short),
         (a.x + 100 * b.x) * 7 - 16997,
         cast (((a.x + 100 * b.x) % 4001 - 2000) as bigint) * 1000000007 + 500000003,
         (a.x + 100 * b.x) * 3 - 49999,
         1501 + (a.x + 100 * b.x) % 500,
         cast (((a.x + 100 * b.x) % 2999 - 1500) as bigint) * 3000000019 + 1500000009
  from d27862 a, d27862 b where b.x < 30;
delete from t27862 where i between -3000 and -2000;
update t27862 set b = b + 1, iu = iu + 2 where id % 103 = 11 and id < 60000;
insert into h27862a select (a.x + 100 * b.x) * 4 + 3, 1 from d27862 a, d27862 b where b.x < 20;
delete from h27862b where k % 40 = 2;
select 'tx_eq_s', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where s = v using index ix_s) a, (select count (*) from t27862 where s = v using index none) b
        from (select cast (x * 7 + 990 as short) v from d27862 where x % 4 = 1) q) r;
select 'tx_eq_i', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where i = v using index ix_i) a, (select count (*) from t27862 where i = v using index none) b
        from (select x * 210 - 16997 v from d27862 where x % 4 = 1 union all select x * 7 - 3000 from d27862 where x % 4 = 1
              union all select x * 351 - 17000 from d27862 where x % 4 = 1) q) r;
select 'tx_eq_b', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where b = v using index ix_b) a, (select count (*) from t27862 where b = v using index none) b
        from (select cast (x * 41 - 2000 as bigint) * 1000000007 + 500000003 v from d27862 where x % 4 = 1
              union all select cast (x * 41 - 2000 as bigint) * 1000000007 + 1 from d27862 where x % 4 = 1
              union all select cast (x * 41 - 2000 as bigint) * 1000000007 from d27862 where x % 4 = 1) q) r;
select 'tx_eq_iu', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where iu = v using index ux_iu) a, (select count (*) from t27862 where iu = v using index none) b
        from (select x * 90 - 49999 v from d27862 where x % 4 = 1 union all select x * 3 - 44000 from d27862 where x % 4 = 1
              union all select x * 309 - 49967 from d27862 where x % 4 = 1 union all select x * 309 - 49965 from d27862 where x % 4 = 1) q) r;
select 'tx_eq_idsc', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where idsc = v using index ix_idsc) a, (select count (*) from t27862 where idsc = v using index none) b
        from (select x * 7 + 1490 v from d27862 where x % 4 = 1) q) r;
select 'tx_eq_bdsc', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from t27862 where bdsc = v using index ix_bdsc) a, (select count (*) from t27862 where bdsc = v using index none) b
        from (select cast (x * 31 - 1501 as bigint) * 3000000019 + 1500000009 v from d27862 where x % 4 = 1
              union all select cast (x * 31 - 1501 as bigint) * 3000000019 from d27862 where x % 4 = 1) q) r;
select 'tx_eq_h', sum (case when a <> b then 1 else 0 end) as mismatches, sum (a) as hits
  from (select (select count (*) from all h27862 where k = v using index u_h27862_k) a, (select count (*) from all h27862 where k = v using index none) b
        from (select x * 81 v from d27862) q) r;
select 'tx_rng_i', count (*) from (select x * 351 - 17000 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where i > v and i <= v + 3500 using index ix_i)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where i > v and i <= v + 3500 using index none);
select 'tx_rng_iu', count (*) from (select x * 1801 - 50000 v from d27862 where x % 4 = 1) q
  where (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where iu >= v and iu < v + 900 using index ux_iu)
     <> (select count (*) || ':' || coalesce (sum (id), 0) from t27862 where iu >= v and iu < v + 900 using index none);
select 'tx_rng_h', count (*) from (select x * 81 v from d27862) q
  where (select count (*) || ':' || coalesce (sum (k), 0) from all h27862 where k > v and k <= v + 37 using index u_h27862_k)
     <> (select count (*) || ':' || coalesce (sum (k), 0) from all h27862 where k > v and k <= v + 37 using index none);
-- a key this transaction inserted is a duplicate for another class of the hierarchy and for ux_iu
insert into h27862b values (403, 9);
insert into t27862 (id, iu) values (200001, -49999);
select 'tx_rows', (select count (*) from t27862), (select count (*) from all h27862);
rollback;
autocommit on;
select 'rolled_back', (select count (*) from t27862), (select count (*) from all h27862),
       (select count (*) from t27862 where iu = -49999 using index ux_iu), (select count (*) from all h27862 where k = 403 using index u_h27862_k);

drop table h27862a;
drop table h27862b;
drop table h27862;
drop table t27862;
drop table d27862;
