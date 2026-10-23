/**
 *  This test case verifies CBRD-27397 (engine PR #7943).
 *
 *  CBRD-26872 unnests WHERE [NOT] EXISTS / [NOT] IN into an NL semi / anti join whose inner
 *  is searched once per outer row and stays behind the side it depends on. This fix adds,
 *  for a SEMI inner joined by equalities on plain columns, a DISTINCT form that may come
 *  first and probe the outer by index, or be an input of a merge join; rewrites the SEMI
 *  JOIN to an INNER JOIN when the equalities cover the
 *  inner's PRIMARY KEY or a NOT NULL UNIQUE key; unnests a NOT IN whose operands the WHERE
 *  keeps non-NULL; rewrites an uncorrelated IN to a SEMI JOIN before the derived-table
 *  rewrite; lets the DISTINCT form come ahead of its dependency only when every outer join
 *  node is already placed; and turns an outer join into an inner join when a SEMI JOIN ON
 *  rejects NULL on its null-supplying side, keeping the SEMI JOIN behind a RIGHT OUTER JOIN
 *  that fills a node it reads otherwise. ORDERED / LEADING leave no DISTINCT form, and a
 *  user KEYLIMIT keeps the subquery as written.
 *
 *  A query with the NO_UNNEST hint that follows an unnested one gives the reference result
 *  and the two must match. Every query is followed by show trace, which shows the plan shape
 *  (semi / anti / inner join, SORT (distinct) and where it sits) and the rewritten query.
 *
 *  Coverage:
 *    Case 1:  SEMI inner read with DISTINCT and placed first, the outer probed by index
 *    Case 2:  DISTINCT input of a merge join on two join columns
 *    Case 3:  a plain join before the SEMI inner, the DISTINCT inner attached after it as
 *             the merge input
 *    Case 4:  SEMI -> INNER JOIN on a PRIMARY KEY and on a NOT NULL UNIQUE key; no rewrite
 *             on half of a composite key or on a key compared through a CAST
 *    Case 5:  uncorrelated IN -> SEMI JOIN, inner without and with an index
 *    Case 6:  ORDERED and LEADING: the outer first, no DISTINCT form; KEYLIMIT: subquery
 *             kept, no INNER rewrite
 *    Case 7:  SEMI ON reads the null-supplying side of a LEFT OUTER JOIN through an INNER JOIN
 *             node: the SEMI inner stays behind the outer join; and reads it directly together
 *             with the preserved side (the shape that returned wrong rows in review)
 *    Case 8:  the same with a RIGHT OUTER JOIN
 *    Case 9:  an uncorrelated IN reads the null-supplying side: the SEMI ON rejects NULL, so the
 *             outer join becomes an inner join, also when the subquery table has a PRIMARY KEY
 *             and the SEMI itself becomes an INNER JOIN; where it does not, the SEMI stays
 *             behind the RIGHT OUTER JOIN
 *    Case 10: SEMI ON reads only the preserved side: an outer join in the query does not take the
 *             DISTINCT form away, it is still the merge input after its dependency
 *    Case 11: NOT IN -> ANTI JOIN on a column the WHERE keeps non-NULL, also beside a NOT IN
 *             on a LIMIT subquery that stays nested; no rewrite when the WHERE (<> ALL on a
 *             set column) excludes no NULL
 */

drop table if exists t_o, t_i;

-- t_o 600 rows: k 1..20 (30 rows each), g 1..5, indexes on k and (k, g)
create table t_o (id int primary key, k int not null, g int not null);
insert into t_o select rownum, mod(rownum, 20) + 1, mod(rownum, 5) + 1 from db_class a, db_class b limit 600;
create index i_t_o_k on t_o (k);
create index i_t_o_k_g on t_o (k, g);
-- t_i 1000 rows, no index: k 11..210 and g 1..200, every value five times, so duplicates on k, g and (k, g);
-- half of the outer's k values and all of its g values are matched
create table t_i (k int not null, g int not null);
insert into t_i select mod(rownum, 200) + 11, mod(rownum * 7, 200) + 1 from db_class a, db_class b limit 1000;
update statistics on t_o, t_i with fullscan;

set trace on;


evaluate 'Case 1: SEMI inner read with DISTINCT and placed first, the outer probed by index';
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_i where t_i.k = t_o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ NO_UNNEST */ 1 from t_i where t_i.k = t_o.k);
show trace;


evaluate 'Case 2: DISTINCT input of a merge join on two join columns';
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ use_merge(t_i) */ 1 from t_i where t_i.k = t_o.k and t_i.g = t_o.g);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ NO_UNNEST */ 1 from t_i where t_i.k = t_o.k and t_i.g = t_o.g);
show trace;


evaluate 'Case 3: a plain join before the SEMI inner, the DISTINCT inner attached after it as the merge input';
-- t_d 5 rows joined on g; the SEMI reads t_o.g alone, which no index covers, so the 200-value DISTINCT does not come first
drop table if exists t_d;
create table t_d (g int primary key, v int);
insert into t_d select rownum, rownum * 10 from db_class limit 5;
update statistics on t_d with fullscan;
select /*+ recompile parallel(0) */ count(*), sum(t_d.v)
  from t_o, t_d
 where t_d.g = t_o.g and t_d.v <= 20
   and exists (select /*+ use_merge(t_i) */ 1 from t_i where t_i.g = t_o.g);
show trace;
select /*+ recompile parallel(0) */ count(*), sum(t_d.v)
  from t_o, t_d
 where t_d.g = t_o.g and t_d.v <= 20
   and exists (select /*+ NO_UNNEST */ 1 from t_i where t_i.g = t_o.g);
show trace;
drop table t_d;


evaluate 'Case 4: SEMI -> INNER JOIN on a PRIMARY KEY and on a NOT NULL UNIQUE key; not on half of a composite key or on a key compared through a CAST';
-- t_pk: PRIMARY KEY id (2..200 step 2), NOT NULL UNIQUE u (1..100); t_ck: composite key (k, g); t_vc: VARCHAR key '1'..'20'
drop table if exists t_pk, t_ck, t_vc;
create table t_pk (id int primary key, u int not null unique);
insert into t_pk select rownum * 2, rownum from db_class a, db_class b limit 100;
create table t_ck (k int, g int, primary key (k, g));
insert into t_ck select mod(rownum, 20) + 1, mod(rownum, 5) + 1 from db_class a, db_class b limit 20;
create table t_vc (c varchar(10) primary key);
insert into t_vc select to_char(rownum) from db_class limit 20;
update statistics on t_pk, t_ck, t_vc with fullscan;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_pk where t_pk.id = t_o.id);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ NO_UNNEST */ 1 from t_pk where t_pk.id = t_o.id);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_pk where t_pk.u = t_o.id);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ NO_UNNEST */ 1 from t_pk where t_pk.u = t_o.id);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_ck where t_ck.k = t_o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ NO_UNNEST */ 1 from t_ck where t_ck.k = t_o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_vc where t_vc.c = t_o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ NO_UNNEST */ 1 from t_vc where t_vc.c = t_o.k);
show trace;
drop table t_ck, t_vc;


evaluate 'Case 5: uncorrelated IN -> SEMI JOIN, inner without and with an index';
select /*+ recompile parallel(0) */ count(*) from t_o where t_o.k in (select t_i.k from t_i);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where t_o.k in (select /*+ NO_UNNEST */ t_i.k from t_i);
show trace;
create index i_t_i_k on t_i (k);
update statistics on t_i with fullscan;
select /*+ recompile parallel(0) */ count(*) from t_o where t_o.k in (select t_i.k from t_i);
show trace;
drop index i_t_i_k on t_i;


evaluate 'Case 6: ORDERED and LEADING: the outer first, no DISTINCT form; KEYLIMIT: the subquery is kept, no INNER rewrite';
select /*+ recompile parallel(0) ordered */ count(*) from t_o where exists (select 1 from t_i where t_i.k = t_o.k);
show trace;
select /*+ recompile parallel(0) leading(t_o) */ count(*) from t_o where exists (select 1 from t_i where t_i.k = t_o.k);
show trace;
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_pk where t_pk.id = t_o.id using index pk_t_pk_id keylimit 1);
show trace;
drop table t_o, t_i, t_pk;


evaluate 'Case 7: SEMI ON reads the null-supplying side of a LEFT OUTER JOIN through an INNER JOIN node; the SEMI inner stays behind the outer join';
-- t_o 3000 rows (m = id mod 7); t_p 20 rows matched by id (k 0..4), the null-supplying side; t_q 20 rows matched to t_p by id;
-- t_s (k, m) = (1, 1), (2, 2), (0, 3). The SEMI reads t_p only through t_q, whose INNER JOIN ON is no ground to drop the LEFT
-- t_u: the k of t_s as a PRIMARY KEY (Case 9)
drop table if exists t_o, t_p, t_q, t_s, t_u;
create table t_o (id int, m int);
create table t_p (id int, k int);
create table t_q (id int, k int);
create table t_s (k int, m int);
create table t_u (k int primary key);
insert into t_o select rownum, mod(rownum, 7) from db_class a, db_class b, db_class c limit 3000;
insert into t_p select rownum * 2, mod(rownum, 5) from db_class a, db_class b, db_class c limit 20;
insert into t_q select rownum * 2, mod(rownum, 5) from db_class a, db_class b, db_class c limit 20;
insert into t_s select mod(rownum, 3), mod(rownum, 7) from db_class a, db_class b limit 3;
insert into t_u select k from t_s;
create index i_t_p_id on t_p (id);
create index i_t_q_id on t_q (id);
create index i_t_o_m on t_o (m);
update statistics on t_o, t_p, t_q, t_s, t_u with fullscan;
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
       inner join t_q on t_q.id = t_p.id
       semi join t_s on t_s.k = t_q.k and t_s.m = t_o.m;
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
       inner join t_q on t_q.id = t_p.id
 where exists (select /*+ NO_UNNEST */ 1 from t_s where t_s.k = t_q.k and t_s.m = t_o.m);
show trace;
-- the SEMI ON reads the null-supplying side t_p directly, together with the preserved side t_o
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
       semi join t_s on t_s.k = t_p.k and t_s.m = t_o.m;
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
 where exists (select /*+ NO_UNNEST */ 1 from t_s where t_s.k = t_p.k and t_s.m = t_o.m);
show trace;


evaluate 'Case 8: the same with a RIGHT OUTER JOIN';
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
       inner join t_q on t_q.id = t_p.id
       semi join t_s on t_s.k = t_q.k and t_s.m = t_o.m;
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
       inner join t_q on t_q.id = t_p.id
 where exists (select /*+ NO_UNNEST */ 1 from t_s where t_s.k = t_q.k and t_s.m = t_o.m);
show trace;


evaluate 'Case 9: an uncorrelated IN reads the null-supplying side; the SEMI ON rejects NULL, so the outer join becomes an inner join, and where it does not the SEMI stays behind the RIGHT OUTER JOIN';
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
 where t_p.k in (select k from t_s);
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
 where t_p.k in (select /*+ NO_UNNEST */ k from t_s);
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
 where t_p.k in (select k from t_s);
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
 where t_p.k in (select /*+ NO_UNNEST */ k from t_s);
show trace;
-- t_u.k is a PRIMARY KEY: the SEMI becomes an INNER JOIN, after its ON has turned the outer join into an inner join
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
 where t_p.k in (select k from t_u);
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
 where t_p.k in (select k from t_u);
show trace;
-- coalesce lets a NULL-filled t_p.k through, so the RIGHT OUTER JOIN stays and the SEMI must come after it
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
 where coalesce(t_p.k, -1) in (select k from t_s);
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_p right outer join t_o on t_o.id = t_p.id
 where coalesce(t_p.k, -1) in (select /*+ NO_UNNEST */ k from t_s);
show trace;


evaluate 'Case 10: SEMI ON reads only the preserved side; an outer join in the query does not take the DISTINCT form away, it is still the merge input after its dependency';
select /*+ recompile parallel(0) use_merge(t_s) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
       semi join t_s on t_s.m = t_o.m;
show trace;
select /*+ recompile parallel(0) */ count(*)
  from t_o left outer join t_p on t_o.id = t_p.id
 where exists (select /*+ NO_UNNEST */ 1 from t_s where t_s.m = t_o.m);
show trace;
drop table t_o, t_p, t_q, t_s, t_u;


evaluate 'Case 11: NOT IN -> ANTI JOIN on a column the WHERE keeps non-NULL; no rewrite when the NULL exclusion would not hold';
-- t_n (null, 1, 2); t_nn NOT NULL (5); t_ne empty; t_ns (null, {}), (1, {}), (2, {9})
drop table if exists t_n, t_nn, t_ne, t_ns;
create table t_n (a int);
insert into t_n values (null), (1), (2);
create table t_nn (x int not null);
insert into t_nn values (5);
create table t_ne (y int);
create table t_ns (a int, s set(int));
insert into t_ns values (null, {}), (1, {}), (2, {9});
select /*+ recompile parallel(0) */ a from t_n where a is not null and a not in (select x from t_nn) order by 1;
show trace;
select /*+ recompile parallel(0) */ a from t_n where a is not null and a not in (select /*+ NO_UNNEST */ x from t_nn) order by 1;
show trace;
-- a second NOT IN on a LIMIT subquery stays nested; the IS NOT NULL must not be folded away (NULL NOT IN empty is true)
select /*+ recompile parallel(0) */ a from t_n
 where a is not null and a not in (select x from t_nn) and a not in (select y from t_ne limit 1) order by 1;
show trace;
select /*+ recompile parallel(0) */ a from t_n
 where a is not null and a not in (select /*+ NO_UNNEST */ x from t_nn) and a not in (select /*+ NO_UNNEST */ y from t_ne limit 1) order by 1;
show trace;
select /*+ recompile parallel(0) */ a from t_ns where a <> all (s) and a not in (select x from t_nn) order by 1;
show trace;
select /*+ recompile parallel(0) */ a from t_ns where a <> all (s) and a not in (select /*+ NO_UNNEST */ x from t_nn) order by 1;
show trace;

set trace off;

drop table t_n, t_nn, t_ne, t_ns;
