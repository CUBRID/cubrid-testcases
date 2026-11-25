/**
 *  This test case verifies CBRD-28141: an index range scan returns the same rows when it decides the upper key once per leaf.
 *
 *  Before the fix the scan compared every key with the upper key of the range. After it, the scan compares the
 *  first two keys of a leaf one by one, then compares the last key of the leaf once, and when that key is before
 *  the upper key it skips the compare for the rest of the leaf. The rows must not change.
 *
 *  There is no switch for the old compare, so every result is a literal value and the pre-fix build passes too
 *  (correctness TC). The sweeps put the upper key on every key and between every two keys, so it also falls on the
 *  last key of each leaf and on the first key of the next leaf. Each row of a sweep shows the count, the nearest
 *  and farthest key from the upper key and a key sum, so a row past the upper key or a missing row changes it.
 *
 *  Coverage:
 *    Case 1:  ranges of 1 to 8 keys end on every key and in every gap, upper key included
 *    Case 2:  ranges of 1 to 8 keys end on every key and in every gap, upper key excluded
 *    Case 3:  ranges of 900 keys cross a leaf and end on every key
 *    Case 4:  a non-covering scan that stops and resumes after a full OID buffer
 *    Case 5:  descending scan of the same sweeps, first key of each range is the upper end
 *    Case 6:  an index on a DESC column, upper key included and excluded
 *    Case 7:  a non-unique index whose keys hold three rows each
 *    Case 8:  leaves with a common prefix, full and partial upper keys
 *    Case 9:  a key filter on keys whose upper compare is skipped
 *    Case 10: index skip scan, one range per leading value
 *    Case 11: loose index scan, the range moves while the leaf is held
 *    Case 12: several ranges in one scan from OR and IN
 *    Case 13: every key is an overflow key
 *    Case 14: a two-column index with some overflow keys on leaves with a common prefix
 */

drop table if exists t_num, t_rng, t_key, t_dup, t_pre, t_ls, t_desc, t_long, t_mix;

-- upper keys of the sweeps: every integer from 1 to 12002, so even values hit keys of t_key and odd values fall between them
create table t_num (x int primary key);
insert into t_num select rownum from db_class a, db_class b, db_class c limit 12002;
-- the same upper keys with ranges of 1, 2, 3, 4 and 8 keys of t_key: lo is the lowest value the range takes
create table t_rng (w int, hi int, lo int);
insert into t_rng select w.w, n.x, n.x - 2 * w.w + 1 from t_num n, (select 1 w from db_root union all select 2 from db_root union all select 3 from db_root union all select 4 from db_root union all select 8 from db_root) w;
-- 6000 even keys; the index exists before the load, so the leaves split and get fence keys: 7 leaves of about 850 keys
create table t_key (k int primary key, v int);
insert into t_key select rownum * 2, mod(rownum * 7, 11) from db_class a, db_class b, db_class c limit 6000;
-- 2000 keys of three rows each
create table t_dup (k int, v int);
create index i_dup_k on t_dup (k);
insert into t_dup select (rownum + 2) div 3 * 2, rownum from db_class a, db_class b, db_class c limit 6000;
-- 18000 keys (a, b) with a in 0, 1, 2: 40 leaves, the leaves inside one value of a share it as a common prefix
create table t_pre (a int, b int, c int);
create index i_pre_ab on t_pre (a, b);
insert into t_pre select mod(rownum, 3), rownum, mod(rownum * 13, 17) from db_class a, db_class b, db_class c limit 18000;
-- the keys of t_pre with a third column, so a loose index scan can skip on the prefix (a, b)
create table t_ls (a int, b int, c int);
create index i_ls_abc on t_ls (a, b, c);
insert into t_ls select a, b, c from t_pre;
-- the same keys as t_key on a DESC column
create table t_desc (k int, v int);
create index i_desc_k on t_desc (k desc);
insert into t_desc select k, v from t_key;
-- 2000 keys of 2310 bytes, longer than 2048 bytes, so each one is an overflow key; ls is the key four keys below
set system parameters 'group_concat_max_len=100000';
create table t_long (n int primary key, s varchar(4000), ls varchar(10));
insert into t_long select n, lpad(n, 6, '0') || (select group_concat(sha2(n * 100 + m.x, 512) order by 1 separator '') from (select rownum x from db_class limit 18) m), lpad(n - 4, 6, '0') from (select rownum n from db_class a, db_class b limit 2000) q;
create index i_long_s on t_long (s);
-- every seventh key of t_mix is an overflow key, the others are 6 bytes; ls is a prefix of the key eight rows below
create table t_mix (a int, n int, s varchar(4000), ls varchar(10));
create index i_mix_as on t_mix (a, s);
insert into t_mix select mod(n, 2), n, case when mod(n, 7) = 0 then s else lpad(n, 6, '0') end, lpad(n - 8, 6, '0') from t_long;
update statistics on t_num, t_rng, t_key, t_dup, t_pre, t_ls, t_desc, t_long, t_mix with fullscan;


evaluate 'Case 1: ranges of 1 to 8 keys end on every key and in every gap, upper key included';
--@queryplan
select r.w, r.hi div 2000 g, count(*), min(r.hi - i.k), max(r.hi - i.k), sum(cast(i.k as bigint)) from t_rng r, t_key i where i.k between r.lo and r.hi group by r.w, r.hi div 2000 order by 1, 2;


evaluate 'Case 2: ranges of 1 to 8 keys end on every key and in every gap, upper key excluded';
--@queryplan
select r.w, r.hi div 2000 g, count(*), min(r.hi - i.k), max(r.hi - i.k), sum(cast(i.k as bigint)) from t_rng r, t_key i where i.k >= r.lo and i.k < r.hi group by r.w, r.hi div 2000 order by 1, 2;


evaluate 'Case 3: ranges of 900 keys cross a leaf and end on every key';
select o.k div 2000 g, count(*), min(o.k - i.k), max(o.k - i.k), sum(cast(i.k as bigint)) from t_key o, t_key i where i.k between o.k - 1799 and o.k group by o.k div 2000 order by 1;


evaluate 'Case 4: a non-covering scan of 18000 rows resumes after each full OID buffer';
-- no_parallel_scan keeps the scan on the serial path that the fix changed
--@queryplan
select /*+ no_parallel_scan */ count(*), sum(cast(c as bigint)), min(b), max(b) from t_pre force index (i_pre_ab) where a between 0 and 2 and b <= 17990;
select /*+ no_parallel_scan */ count(*), sum(cast(c as bigint)), min(b), max(b) from t_pre force index (i_pre_ab) where a between 0 and 2 and b < 17990;


evaluate 'Case 5: descending scan of the same sweeps';
-- a descending scan reads from the SQL upper end, so its range ends at the SQL lower end lo, a gap or a key, included or excluded
-- use_desc_idx sits in a subquery because the optimizer did not apply it to the join of Case 1
--@queryplan
select r.w, r.hi div 2000 g, sum((select /*+ use_desc_idx */ count(*) from t_key i where i.k between r.lo and r.hi)), sum((select /*+ use_desc_idx */ sum(cast(i.k as bigint)) from t_key i where i.k between r.lo and r.hi)), min((select /*+ use_desc_idx */ min(i.k) from t_key i where i.k between r.lo and r.hi) - r.lo) from t_rng r group by r.w, r.hi div 2000 order by 1, 2;
select r.w, r.hi div 2000 g, sum((select /*+ use_desc_idx */ count(*) from t_key i where i.k > r.lo and i.k <= r.hi)), sum((select /*+ use_desc_idx */ sum(cast(i.k as bigint)) from t_key i where i.k > r.lo and i.k <= r.hi)), min((select /*+ use_desc_idx */ min(i.k) from t_key i where i.k > r.lo and i.k <= r.hi) - r.lo) from t_rng r group by r.w, r.hi div 2000 order by 1, 2;


evaluate 'Case 6: an index on a DESC column, upper key included and excluded';
-- an ascending scan of a DESC column reads from the SQL upper end, so its range ends at the SQL lower end
select r.w, r.hi div 2000 g, count(*), min(r.hi - i.k), max(r.hi - i.k), sum(cast(i.k as bigint)) from t_rng r, t_desc i where i.k between r.lo and r.hi group by r.w, r.hi div 2000 order by 1, 2;
--@queryplan
select r.w, r.hi div 2000 g, count(*), min(i.k - r.lo), max(i.k - r.lo), sum(cast(i.k as bigint)) from t_rng r, t_desc i where i.k > r.lo and i.k <= r.hi group by r.w, r.hi div 2000 order by 1, 2;


evaluate 'Case 7: a non-unique index whose keys hold three rows each';
select r.w, r.hi div 1000 g, count(*), min(r.hi - i.k), max(r.hi - i.k), sum(cast(i.v as bigint)) from t_rng r, t_dup i where r.hi <= 4002 and i.k between r.lo and r.hi group by r.w, r.hi div 1000 order by 1, 2;


evaluate 'Case 8: leaves with a common prefix, full and partial upper keys';
--@queryplan
select o.b div 3000 g, count(*), min(o.b - i.b), max(o.b - i.b), sum(cast(i.b as bigint)) from t_pre o, t_pre i where o.a = 1 and i.a = 1 and i.b between o.b - 29 and o.b group by o.b div 3000 order by 1;
select x.a, (select count(*) from t_pre p where p.a <= x.a), (select sum(cast(p.b as bigint)) from t_pre p where p.a < x.a) from (select 0 a from db_root union all select 1 from db_root union all select 2 from db_root) x order by 1;


evaluate 'Case 9: a key filter on keys whose upper compare is skipped';
-- the upper key o.b + 1 is never a key of t_pre with a = 1, so no key equal to the upper key is dropped by the key filter
--@queryplan
select o.b div 3000 g, count(*), min(o.b - i.b), max(o.b - i.b), sum(cast(i.b as bigint)) from t_pre o, t_pre i where o.a = 1 and i.a = 1 and i.b between o.b - 29 and o.b + 1 and mod(i.b, 4) <> 0 group by o.b div 3000 order by 1;


evaluate 'Case 10: index skip scan, one range per leading value';
--@queryplan
select /*+ index_ss */ count(*), sum(cast(b as bigint)), min(b), max(b) from t_pre where b between 1000 and 9000;
select /*+ index_ss */ count(*), sum(cast(b as bigint)), min(b), max(b) from t_pre where b > 1000 and b < 9000;


evaluate 'Case 11: loose index scan, the range moves while the leaf is held';
--@queryplan
select /*+ index_ls */ a, max(b) from t_ls where a <= 1 and b > 100 group by a order by a;
--@queryplan
select /*+ index_ls */ distinct a from t_ls where a < 2 and b > 17985 order by a;


evaluate 'Case 12: several ranges in one scan from OR and IN';
--@queryplan
select n.x div 2000 g, count(*), sum(cast(i.k as bigint)), sum(cast(i.k - n.x as bigint)) from t_num n, t_key i where i.k between n.x - 7 and n.x or i.k between n.x + 1700 and n.x + 1707 group by n.x div 2000 order by 1;
select n.x div 2000 g, count(*), sum(cast(i.k as bigint)), sum(cast(i.k - n.x as bigint)) from t_num n, t_key i where i.k in (n.x - 2, n.x, n.x + 1714) group by n.x div 2000 order by 1;


evaluate 'Case 13: every key is an overflow key';
--@queryplan
select o.n div 250 g, count(*), min(o.n - cast(substr(i.s, 1, 6) as int)), max(o.n - cast(substr(i.s, 1, 6) as int)), sum(cast(substr(i.s, 1, 6) as bigint)) from t_long o, t_long i where i.s between o.ls and o.s group by o.n div 250 order by 1;


evaluate 'Case 14: a two-column index with some overflow keys on leaves with a common prefix';
--@queryplan
select o.n div 250 g, count(*), min(o.n - i.n), max(o.n - i.n), sum(cast(i.n as bigint)) from t_mix o, t_mix i where o.a = 1 and i.a = 1 and i.s between o.ls and o.s group by o.n div 250 order by 1;

set system parameters 'group_concat_max_len=default';
drop table t_num, t_rng, t_key, t_dup, t_pre, t_ls, t_desc, t_long, t_mix;
