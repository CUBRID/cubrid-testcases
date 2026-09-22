/**
 *  This test case verifies CBRD-27465: memoize and first-key stop for the inner
 *  of an unnested NL SEMI / ANTI JOIN (follow-up of CBRD-26872).
 *
 *  CBRD-26872 unnests WHERE [NOT] EXISTS / [NOT] IN into an NL semi / anti join.
 *  The subquery form had two devices the unnested form lost: the LIMIT 1 the
 *  rewriter adds (a key limit of 1 on the inner index scan, so the btree stops
 *  at the first key) and the subquery result cache. The NL-join memoize (CBRD-26345)
 *  also skipped semi / anti inners. An EXISTS whose correlated column has few
 *  distinct values therefore re-read the whole key range for every outer row.
 *
 *  The fix (engine PR #7991) gives the semi / anti inner index scan a key limit
 *  of 1 (merged with a user KEYLIMIT by LEAST) and a match-only memoize mode
 *  that remembers, per outer key, whether the inner matched. "show trace" shows
 *  a MEMOIZE line under the inner scan of a semi / anti join.
 *
 *  CTP runs SQL tests with test_mode=yes, which masks volatile trace values
 *  (time, readkeys, hit / miss, size) and identifier digits to '?'. The
 *  assertions are therefore the MEMOIZE line, the plan shape (semi join /
 *  anti join, index scan, rewritten query) and the result parity below.
 *  readkeys is masked, so the first-key stop is asserted by a result that
 *  depends on the user KEYLIMIT surviving the merge (Case 11), not by a count.
 *
 *  Correctness: every unnested query is followed by the same query with the
 *  NO_UNNEST hint (nested subquery, no memoize), and the two result blocks must
 *  match, proving the cached match / no-match answer is applied to the right
 *  outer rows.
 *
 *  Coverage:
 *    Case 1:  EXISTS -> NL semi join, MEMOIZE line, result = NO_UNNEST
 *    Case 2:  NOT EXISTS -> NL anti join, MEMOIZE line, result = NO_UNNEST
 *    Case 3:  correlated IN -> NL semi join, memoized (the ON is synthesized
 *             from the IN operands)
 *    Case 4:  correlated NOT IN on NOT NULL columns -> NL anti join, memoized
 *    Case 5:  inner with a data filter (column not in the index): still
 *             memoized, key limit not applied (the filter could reject the
 *             first key), result = NO_UNNEST
 *    Case 6:  key filter that rejects every key: semi = 0, anti = all rows,
 *             memoized in both (the anti survive path re-enters the inner and
 *             must not record a second "no match" per outer row)
 *    Case 7:  anti join over keys that match and keys that do not, row list,
 *             a cached no-match after a cached match emits the outer row once
 *    Case 8:  NULL correlation value never matches, anti keeps the row
 *    Case 9:  semi / anti inner followed by another join
 *    Case 10: user KEYLIMIT on the inner: the plan keeps it (rewritten query)
 *    Case 11: user KEYLIMIT with an offset: LEAST(count, 1) keeps the offset,
 *             so EXISTS holds only for keys with more entries than the offset,
 *             a merge that dropped the user limit would match every key
 *    Case 12: unique inner: memoize gives up (hit ratio 0), result unchanged
 *    Case 13: memoize_memory_limit=0: falls back, no MEMOIZE line, result unchanged
 *    Case 14: partitioned inner: one memo across the partitions (CBRD-24541 shape)
 *    Case 15: partitioned outer x partitioned inner, a key present in two
 *             inner partitions is emitted once, then a semi inner with a join to a
 *             partitioned table
 */

drop table if exists subquery_big;
drop table if exists subquery_small;

create table subquery_big (col1 int, col2 char(1), col3 int, col4 char(1), col5 int primary key, col6 int);
insert into subquery_big
select mod(rownum,5000)+1, chr(65+mod(rownum,26)), mod(rownum,2500)+999, chr(65+mod(rownum,3)), rownum, mod(rownum,3)+1
  from db_class a, db_class b, db_class c, db_class d limit 20000;
create table subquery_small (col1 int primary key, col2 char(1), col3 int, col4 char(1), col5 char(1), col6 int);
insert into subquery_small
select rownum, chr(65+mod(rownum,26)), rownum+99999, chr(65+mod(rownum,26)), chr(65+mod(rownum,3)), mod(rownum,3)+1
  from db_class a, db_class b, db_class c, db_class d limit 5000;
create index idx_col2_col1_col3 on subquery_small (col2, col1, col3);
update statistics on all classes with fullscan;

set trace on;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 1: EXISTS, unnested -> NL semi join with a MEMOIZE line; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 'X' from subquery_small where col2=a.col4);
show trace;
-- nested reference: result must match the block above
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select /*+ NO_UNNEST */ 'X' from subquery_small where col2=a.col4);


evaluate 'Case 2: NOT EXISTS, unnested -> NL anti join with a MEMOIZE line; result = NO_UNNEST';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 'X' from subquery_small where col2=a.col4);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select /*+ NO_UNNEST */ 'X' from subquery_small where col2=a.col4);


evaluate 'Case 3: correlated IN -> NL semi join, memoized; result = NO_UNNEST';
-- the IN forms carry no join predicate of their own: the ON is 'in_inner.g = in_outer.g' synthesized
-- from the IN operands plus the correlated WHERE. The outer has 15 (k, g) pairs and the 12 inner
-- rows cover 9 of them, so both the semi and the anti side keep rows (15 memo keys).
drop table if exists in_outer;
drop table if exists in_inner;
create table in_outer (a int primary key, k int not null, g int not null);
insert into in_outer select rownum, mod(rownum, 3), mod(rownum, 5) from db_class a, db_class b, db_class c limit 600;
create table in_inner (a int primary key, k int not null, g int not null);
insert into in_inner select rownum, mod(rownum, 3), mod(rownum, 7) from db_class a, db_class b limit 12;
create index i_in_inner_k_g on in_inner (k, g);
update statistics on all classes with fullscan;
select /*+ recompile parallel(0) */ count(*), min(k), max(g) from in_outer o where o.g in (select i.g from in_inner i where i.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*), min(k), max(g) from in_outer o where o.g in (select /*+ NO_UNNEST */ i.g from in_inner i where i.k = o.k);


evaluate 'Case 4: correlated NOT IN on NOT NULL columns -> NL anti join, memoized; result = NO_UNNEST';
-- NOT IN unnests only when both operands are NOT NULL (a NULL on either side would make NOT IN unknown).
select /*+ recompile parallel(0) */ count(*), min(k), max(g) from in_outer o where o.g not in (select i.g from in_inner i where i.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*), min(k), max(g) from in_outer o where o.g not in (select /*+ NO_UNNEST */ i.g from in_inner i where i.k = o.k);
-- row list: the anti-joined rows must be exactly the nested ones
select /*+ recompile parallel(0) */ a, k, g from in_outer o where o.g not in (select i.g from in_inner i where i.k = o.k) and a <= 40 order by 1;
select /*+ recompile parallel(0) */ a, k, g from in_outer o where o.g not in (select /*+ NO_UNNEST */ i.g from in_inner i where i.k = o.k) and a <= 40 order by 1;
drop table in_outer;
drop table in_inner;


evaluate 'Case 5: data filter on a non-index column: memoized, no key limit; result = NO_UNNEST';
-- col6 is not in idx_col2_col1_col3, so the inner keeps a data filter that can reject the first key;
-- the key limit of 1 is withheld for such an inner, the memoize still applies.
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4 and col6=3);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select /*+ NO_UNNEST */ 1 from subquery_small where col2=a.col4 and col6=3);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 1 from subquery_small where col2=a.col4 and col6=3);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select /*+ NO_UNNEST */ 1 from subquery_small where col2=a.col4 and col6=3);


evaluate 'Case 6: key filter that rejects every key: semi = 0, anti = all rows, memoized in both';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4 and col1 < 0);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 1 from subquery_small where col2=a.col4 and col1 < 0);
show trace;


evaluate 'Case 7: anti join over keys that match and keys that do not; a cached no-match after a cached match emits the outer row once';
drop table if exists mix_outer;
drop table if exists mix_inner;
create table mix_outer (a int primary key, k int);
insert into mix_outer select rownum, mod(rownum, 5) from db_class a, db_class b, db_class c limit 300;
create table mix_inner (a int primary key, k int);
insert into mix_inner select rownum, mod(rownum, 5) from db_class a, db_class b limit 40;
delete from mix_inner where k = 4;
create index i_mix_inner_k on mix_inner (k);
update statistics on all classes with fullscan;
select /*+ recompile parallel(0) */ count(*), min(k), max(k) from mix_outer o where not exists (select 1 from mix_inner i where i.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*), min(k), max(k) from mix_outer o where not exists (select /*+ NO_UNNEST */ 1 from mix_inner i where i.k = o.k);
select /*+ recompile parallel(0) */ a, k from mix_outer o where not exists (select 1 from mix_inner i where i.k = o.k) and a <= 60 order by 1;
select /*+ recompile parallel(0) */ a, k from mix_outer o where not exists (select /*+ NO_UNNEST */ 1 from mix_inner i where i.k = o.k) and a <= 60 order by 1;
select /*+ recompile parallel(0) */ count(*) from mix_outer o where exists (select 1 from mix_inner i where i.k = o.k);
drop table mix_outer;
drop table mix_inner;


evaluate 'Case 8: NULL correlation value never matches; anti keeps the row';
insert into subquery_big values (1, 'A', 1, NULL, 30001, 1);
insert into subquery_big values (2, 'B', 2, NULL, 30002, 2);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 1 from subquery_small where col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select /*+ NO_UNNEST */ 1 from subquery_small where col2=a.col4);
delete from subquery_big where col5 in (30001, 30002);


evaluate 'Case 9: semi / anti inner followed by another join';
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and exists (select 1 from subquery_small c where c.col2=a.col4);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and exists (select /*+ NO_UNNEST */ 1 from subquery_small c where c.col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and not exists (select 1 from subquery_small c where c.col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and not exists (select /*+ NO_UNNEST */ 1 from subquery_small c where c.col2=a.col4);


evaluate 'Case 10: user KEYLIMIT on the inner survives the merge: the rewritten query keeps it';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4 using index idx_col2_col1_col3 keylimit 5);
show trace;


evaluate 'Case 11: user KEYLIMIT with an offset: EXISTS holds only for keys with more entries than the offset';
-- klim_inner has 1 / 2 / 3 / 5 entries for k = 1 / 2 / 3 / 4 and none for k = 0, 5; the index is
-- (k, a) so each entry is its own key. With 'keylimit 2, 5' the merged upper limit is LEAST(5, 1) = 1
-- and the lower limit 2 is kept: the scan skips two keys, so only k = 3 and k = 4 match. A merge that
-- replaced the user limit with a plain 1 would match k = 1..4; one that dropped the engine limit
-- would give the same rows but read up to five keys per outer row. The nested twin uses the same
-- KEYLIMIT and must agree.
drop table if exists klim_outer;
drop table if exists klim_inner;
create table klim_outer (a int primary key, k int);
insert into klim_outer select rownum, mod(rownum, 6) from db_class a, db_class b, db_class c limit 300;
create table klim_inner (a int primary key, k int);
insert into klim_inner values (1, 1), (2, 2), (3, 2), (4, 3), (5, 3), (6, 3), (7, 4), (8, 4), (9, 4), (10, 4), (11, 4);
create index i_klim_inner_k_a on klim_inner (k, a);
update statistics on all classes with fullscan;
select /*+ recompile parallel(0) */ k, count(*) from klim_outer o where exists (select 1 from klim_inner i where i.k = o.k using index i_klim_inner_k_a keylimit 2, 5) group by k order by k;
show trace;
select /*+ recompile parallel(0) */ k, count(*) from klim_outer o where exists (select /*+ NO_UNNEST */ 1 from klim_inner i where i.k = o.k using index i_klim_inner_k_a keylimit 2, 5) group by k order by k;
select /*+ recompile parallel(0) */ k, count(*) from klim_outer o where not exists (select 1 from klim_inner i where i.k = o.k using index i_klim_inner_k_a keylimit 2, 5) group by k order by k;
select /*+ recompile parallel(0) */ k, count(*) from klim_outer o where not exists (select /*+ NO_UNNEST */ 1 from klim_inner i where i.k = o.k using index i_klim_inner_k_a keylimit 2, 5) group by k order by k;
-- without the offset every key with at least one entry matches (k = 1..4)
select /*+ recompile parallel(0) */ k, count(*) from klim_outer o where exists (select 1 from klim_inner i where i.k = o.k using index i_klim_inner_k_a keylimit 5) group by k order by k;
select /*+ recompile parallel(0) */ k, count(*) from klim_outer o where exists (select /*+ NO_UNNEST */ 1 from klim_inner i where i.k = o.k using index i_klim_inner_k_a keylimit 5) group by k order by k;
drop table klim_outer;
drop table klim_inner;


evaluate 'Case 12: unique inner: memoize gives up (hit ratio 0), result unchanged';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col1=a.col1);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select /*+ NO_UNNEST */ 1 from subquery_small where col1=a.col1);


evaluate 'Case 13: memoize_memory_limit=0: falls back, no MEMOIZE line, result unchanged';
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 'X' from subquery_small where col2=a.col4);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 'X' from subquery_small where col2=a.col4);
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 14: partitioned inner: one memo across the partitions, MEMOIZE line, correct (CBRD-24541 shape)';
drop table if exists part_outer;
drop table if exists part_inner;
create table part_outer (a int, b char(10) default 'abc');
insert into part_outer (a, b) values (1, 'a'), (2, 'b'), (3, 'c'), (1, 'd');
create table part_inner (a int, b char(10) default 'abc', primary key (a)) partition by hash (a) partitions 5;
insert into part_inner (a, b) values (1, 'e'), (3, 'f');
select /*+ recompile parallel(0) */ o.a, o.b from part_outer o where exists (select b from part_inner i where i.a = o.a) order by 1, 2;
show trace;
select /*+ recompile parallel(0) */ o.a, o.b from part_outer o where not exists (select b from part_inner i where i.a = o.a) order by 1, 2;
select /*+ recompile parallel(0) */ o.a, o.b from part_outer o where exists (select /*+ NO_UNNEST */ b from part_inner i where i.a = o.a) order by 1, 2;
select /*+ recompile parallel(0) */ o.a, o.b from part_outer o where not exists (select /*+ NO_UNNEST */ b from part_inner i where i.a = o.a) order by 1, 2;
drop table part_outer;
drop table part_inner;


evaluate 'Case 15: partitioned outer x partitioned inner; a key present in two inner partitions is emitted once';
drop table if exists pout;
drop table if exists pin;
create table pout (a int primary key, k int) partition by hash (a) partitions 3;
insert into pout select rownum, mod(rownum, 5) from db_class a, db_class b, db_class c limit 300;
create table pin (a int primary key, k int) partition by hash (a) partitions 4;
insert into pin select rownum, mod(rownum, 5) from db_class a, db_class b limit 40;
delete from pin where k = 4;
create index i_pin_k on pin (k);
update statistics on all classes with fullscan;
select /*+ recompile parallel(0) */ count(*), min(o.k), max(o.k) from pout o where exists (select 1 from pin i where i.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*), min(o.k), max(o.k) from pout o where exists (select /*+ NO_UNNEST */ 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*), min(o.k), max(o.k) from pout o where not exists (select 1 from pin i where i.k = o.k);
show trace;
select /*+ recompile parallel(0) */ count(*), min(o.k), max(o.k) from pout o where not exists (select /*+ NO_UNNEST */ 1 from pin i where i.k = o.k);
-- semi inner followed by a join to a partitioned table
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and exists (select 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and exists (select /*+ NO_UNNEST */ 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and not exists (select 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and not exists (select /*+ NO_UNNEST */ 1 from pin i where i.k = o.k);
drop table pout;
drop table pin;


set trace off;
set system parameters 'memoize_memory_limit=default';

drop table subquery_big;
drop table subquery_small;
