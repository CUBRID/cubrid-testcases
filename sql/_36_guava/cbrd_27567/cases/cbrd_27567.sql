/**
 *  This test case verifies CBRD-27567: an NL-join inner that is memoized must
 *  return the same rows as without memoize when its predicate or the select
 *  list holds a correlated subquery.
 *
 *  The memo (CBRD-26345) keys the inner by the values its scan reads from the
 *  outer rows. Its key builder took every constant it found in the inner
 *  predicates and in the correlated subqueries attached to the inner. That
 *  included the result of a correlated scalar subquery and the accumulator of
 *  an aggregate inside it, which the subquery computes for every inner row
 *  after the memo is probed. The key stored for a row then held that row's
 *  subquery result, while the key probed for the next outer row held the
 *  result of the last inner row read, so inner rows went missing (the JIRA
 *  query returned 82 instead of 100). A replayed row also skipped the per-row
 *  reset of the subqueries attached to the inner, so a select-list subquery,
 *  which the plan attaches to the innermost scan, kept a result that was not
 *  computed for that row.
 *
 *  The fix (engine PR #8114) keys a correlated subquery by its correlated
 *  references, the outer columns it reads (the same rule the subquery result
 *  cache uses), including those in aggregate arguments, HAVING and rownum
 *  predicates, never by a value the subquery computes. A subquery with GROUP
 *  BY, analytic functions or CONNECT BY is not memoized. A replayed row resets
 *  the inner's correlated subqueries as the scan does, so a select-list
 *  subquery runs again for it, while a subquery only the inner predicate reads
 *  does not run on replay.
 *
 *  CTP runs SQL tests with test_mode=yes, which masks volatile trace values
 *  (time, hit / miss, size) to '?'. The assertions are therefore the MEMOIZE
 *  line under the inner scan (printed only when the memo had a hit) and the
 *  result parity: every memoized query is followed by the same query with
 *  memoize_memory_limit=0 (no memo), and the two result blocks must match.
 *
 *  Coverage:
 *    Case 1:  the JIRA query, aggregate scalar subquery in the inner predicate
 *    Case 2:  Case 1 with the subquery result cache off
 *    Case 3:  non-aggregate scalar subquery in the inner predicate
 *    Case 4:  select-list subquery on the memoized inner, result cache off
 *    Case 5:  Case 4 with the subquery result cache on
 *    Case 6:  outer column read only in the aggregate argument of the subquery
 *    Case 7:  outer column read only in the HAVING of the subquery
 *    Case 8:  nested subquery inside the predicate subquery
 *    Case 9:  scalar subquery correlated only to the outer table, NULL for
 *             some outer rows
 *    Case 10: IN subquery correlated only to the outer table
 */

drop table if exists cz, cx, cy, cs;

-- one driving row, so the rows of the outer table o0 come in index order
create table cz (nu int);
insert into cz values (1);
-- 30 rows, 10 per nu value: the 10 outer rows with nu = 1 all probe the inner o1 with the same key
create table cx (pk int primary key, nn int not null, nu int);
insert into cx select rownum, mod(rownum, 13), mod(rownum, 3) from db_class a, db_class b limit 30;
create index i_cx_nu on cx (nu);
-- outer table for Cases 6, 7, 9 and 10: 12 rows with nu = 1, g repeats 1, 2, 0, so 3 memo keys
create table cy (pk int primary key, nu int, g int);
insert into cy select rownum, 1, mod(rownum, 3) from db_class a, db_class b limit 12;
create index i_cy_nu on cy (nu);
-- the table the subqueries read, v is not indexed so that a subquery reading it fetches rows
create table cs (pk int primary key, v int);
insert into cs values (1, 1), (2, 2), (3, 3), (4, 4);
update statistics on cz, cx, cy, cs with fullscan;

set trace on;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 1: aggregate scalar subquery in the inner predicate; result = memoize off';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= (select count(*) from cs where cs.pk = o1.pk) using index o0.i_cx_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= (select count(*) from cs where cs.pk = o1.pk) using index o0.i_cx_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 2: Case 1 with the subquery result cache off; result = memoize off';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= (select /*+ no_subquery_cache */ count(*) from cs where cs.pk = o1.pk) using index o0.i_cx_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= (select /*+ no_subquery_cache */ count(*) from cs where cs.pk = o1.pk) using index o0.i_cx_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 3: non-aggregate scalar subquery in the inner predicate; result = memoize off';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= nvl((select /*+ no_subquery_cache */ cs.v from cs where cs.pk = o1.pk), 0) using index o0.i_cx_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= nvl((select /*+ no_subquery_cache */ cs.v from cs where cs.pk = o1.pk), 0) using index o0.i_cx_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 4: select-list subquery on the memoized inner, result cache off; result = memoize off';
-- the plan attaches a correlated select-list subquery to the innermost scan, here the memoized o1
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk), sum((select /*+ no_subquery_cache */ cs.v * 10 from cs where cs.pk = o1.pk)), sum(o1.pk * (select /*+ no_subquery_cache */ cs.v * 10 from cs where cs.pk = o1.pk)) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu using index o0.i_cx_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk), sum((select /*+ no_subquery_cache */ cs.v * 10 from cs where cs.pk = o1.pk)), sum(o1.pk * (select /*+ no_subquery_cache */ cs.v * 10 from cs where cs.pk = o1.pk)) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu using index o0.i_cx_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';
-- row list of the same join for the first three outer rows: o1.pk 1 and 4 must show 10 and 40 for every o0 row
select /*+ recompile use_nl ordered */ o0.pk, o1.pk, (select /*+ no_subquery_cache */ cs.v * 10 from cs where cs.pk = o1.pk) v from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o0.pk <= 7 using index o0.i_cx_nu, o1.i_cx_nu order by 1, 2;
show trace;


evaluate 'Case 5: Case 4 with the subquery result cache on; result = memoize off';
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk), sum((select cs.v * 10 from cs where cs.pk = o1.pk)), sum(o1.pk * (select cs.v * 10 from cs where cs.pk = o1.pk)) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu using index o0.i_cx_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*), sum(o1.pk), sum((select cs.v * 10 from cs where cs.pk = o1.pk)), sum(o1.pk * (select cs.v * 10 from cs where cs.pk = o1.pk)) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu using index o0.i_cx_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 6: outer column only in the aggregate argument of the subquery; result = memoize off';
-- o0.g differs between outer rows with the same join key, so it must be part of the key
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn + 6 >= (select /*+ no_subquery_cache */ max(cs.v + o0.g * 3) from cs where cs.pk <= o1.pk) using index o0.i_cy_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn + 6 >= (select /*+ no_subquery_cache */ max(cs.v + o0.g * 3) from cs where cs.pk <= o1.pk) using index o0.i_cy_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 7: outer column only in the HAVING of the subquery; result = memoize off';
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= nvl((select /*+ no_subquery_cache */ count(cs.v) from cs where cs.pk <= o1.pk having count(cs.v) > o0.g + 1), 0) using index o0.i_cy_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= nvl((select /*+ no_subquery_cache */ count(cs.v) from cs where cs.pk <= o1.pk having count(cs.v) > o0.g + 1), 0) using index o0.i_cy_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 8: nested subquery inside the predicate subquery; result = memoize off';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= (select /*+ no_subquery_cache */ count(cs.v) from cs where cs.v <= (select max(c2.v) from cs c2 where c2.v <= mod(o1.pk, 5))) using index o0.i_cx_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cx o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= (select /*+ no_subquery_cache */ count(cs.v) from cs where cs.v <= (select max(c2.v) from cs c2 where c2.v <= mod(o1.pk, 5))) using index o0.i_cx_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 9: scalar subquery correlated only to the outer table, NULL for g = 0; result = memoize off';
-- the subquery reads only o0.g, so the key is the join key and o0.g: 3 keys for the 12 outer rows. It is NULL
-- for g = 0, and the rows stored for g = 0 must not be replayed for another g
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= nvl((select /*+ no_subquery_cache */ max(cs.v) from cs where cs.v <= o0.g), 0) using index o0.i_cy_nu, o1.i_cx_nu;
show trace;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn >= nvl((select /*+ no_subquery_cache */ max(cs.v) from cs where cs.v <= o0.g), 0) using index o0.i_cy_nu, o1.i_cx_nu;
set system parameters 'memoize_memory_limit=2M';


evaluate 'Case 10: IN subquery correlated only to the outer table; result = memoize off';
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn in (select /*+ no_unnest no_subquery_cache */ cs.v from cs where cs.v <= o0.g + 1) using index o0.i_cy_nu, o1.i_cx_nu;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ count(*) from cz z, cy o0, cx o1 where z.nu = o0.nu and o0.nu = o1.nu and o1.nn in (select /*+ no_unnest no_subquery_cache */ cs.v from cs where cs.v <= o0.g + 1) using index o0.i_cy_nu, o1.i_cx_nu;


set system parameters 'memoize_memory_limit=default';

drop table cz, cx, cy, cs;
