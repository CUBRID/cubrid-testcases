-- CBRD-27465: memoize and first-key stop for an unnested SEMI / ANTI JOIN inner
--
-- CBRD-26872 unnests WHERE [NOT] EXISTS into an NL semi / anti join. The
-- subquery form gets LIMIT 1 (a key limit of 1 on the inner index scan) and
-- a subquery result cache; the unnested form had neither, so an EXISTS whose
-- correlated column has few distinct values re-read the whole key range for
-- every outer row.
--
-- Covers:
--   - unnested EXISTS / NOT EXISTS: MEMOIZE line present, result equals the
--     NO_UNNEST form
--   - inner with a data filter (column not in the index): memoized, correct
--   - inner with a key filter that rejects every key: semi = 0, anti = all,
--     memoized in both (the anti survive path re-enters the inner; it must
--     not record a second "no match" per outer row)
--   - NULL correlation value: never matches, anti keeps the row
--   - semi / anti followed by another join
--   - user KEYLIMIT on the inner merges with the engine's key limit
--   - unique inner: no memoize (hit ratio 0), result unchanged
--   - memoize_memory_limit=0: falls back, result unchanged
--   Trace numbers are masked by CTP; the assertions are the MEMOIZE line,
--   the plan shape and the result parity.

-- cleanup
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

evaluate 'EXISTS, unnested: NL semi join, MEMOIZE expected';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 'X' from subquery_small where col2=a.col4);
show trace;
evaluate 'EXISTS, NO_UNNEST: same result';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select /*+ NO_UNNEST */ 'X' from subquery_small where col2=a.col4);

evaluate 'NOT EXISTS, unnested: NL anti join, MEMOIZE expected';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 'X' from subquery_small where col2=a.col4);
show trace;
evaluate 'NOT EXISTS, NO_UNNEST: same result';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select /*+ NO_UNNEST */ 'X' from subquery_small where col2=a.col4);

evaluate 'data filter on a non-index column: memoized, correct';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4 and col6=3);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select /*+ NO_UNNEST */ 1 from subquery_small where col2=a.col4 and col6=3);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 1 from subquery_small where col2=a.col4 and col6=3);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select /*+ NO_UNNEST */ 1 from subquery_small where col2=a.col4 and col6=3);

evaluate 'key filter that rejects every key: semi 0 / anti all, both memoized';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4 and col1 < 0);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 1 from subquery_small where col2=a.col4 and col1 < 0);
show trace;

evaluate 'anti: keys that match and keys that do not, row list; a cached no-match after a cached match must emit the outer once';
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

evaluate 'NULL correlation value never matches; anti keeps the row';
insert into subquery_big values (1, 'A', 1, NULL, 30001, 1);
insert into subquery_big values (2, 'B', 2, NULL, 30002, 2);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 1 from subquery_small where col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select /*+ NO_UNNEST */ 1 from subquery_small where col2=a.col4);
delete from subquery_big where col5 in (30001, 30002);

evaluate 'semi / anti followed by another join';
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and exists (select 1 from subquery_small c where c.col2=a.col4);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and exists (select /*+ NO_UNNEST */ 1 from subquery_small c where c.col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and not exists (select 1 from subquery_small c where c.col2=a.col4);
select /*+ recompile parallel(0) */ count(*) from subquery_big a, subquery_small b where a.col1=b.col1 and b.col6=2 and not exists (select /*+ NO_UNNEST */ 1 from subquery_small c where c.col2=a.col4);

evaluate 'user KEYLIMIT on the inner merges with the key limit of 1';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col2=a.col4 using index idx_col2_col1_col3 keylimit 5);
show trace;

evaluate 'unique inner: no memoize, result unchanged';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 1 from subquery_small where col1=a.col1);
show trace;

evaluate 'memoize off: falls back, result unchanged';
set system parameters 'memoize_memory_limit=0';
select /*+ recompile parallel(0) */ count(*) from subquery_big a where exists (select 'X' from subquery_small where col2=a.col4);
show trace;
select /*+ recompile parallel(0) */ count(*) from subquery_big a where not exists (select 'X' from subquery_small where col2=a.col4);
set system parameters 'memoize_memory_limit=2M';

evaluate 'partitioned inner: one memo across partitions, MEMOIZE expected, correct (CBRD-24541 shape)';
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

evaluate 'partitioned outer x partitioned inner; a key present in two inner partitions is emitted once';
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
evaluate 'semi inner followed by a join to a partitioned table';
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and exists (select 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and exists (select /*+ NO_UNNEST */ 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and not exists (select 1 from pin i where i.k = o.k);
select /*+ recompile parallel(0) */ count(*) from subquery_big b, pout o where b.col1 = o.a and not exists (select /*+ NO_UNNEST */ 1 from pin i where i.k = o.k);
drop table pout;
drop table pin;

set trace off;
drop table subquery_big;
drop table subquery_small;
