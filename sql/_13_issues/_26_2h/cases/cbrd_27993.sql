/**
 *  This test case verifies CBRD-27993: memoize keys an NL inner by a column of a scan after it,
 *  and splits or loses the rows of one key.
 *
 *  The memoize key of an NL inner is now the outer scans columns that its terms and its derived
 *  tables read, chosen when the query is compiled. Memoize and the correlated subquery cache no
 *  longer reuse a result that reads or assigns a session variable or calls a stored function that
 *  is not DETERMINISTIC. Every result is compared with a twin run with memoize off
 *  (memoize_memory_limit=0) or with the NO_SUBQUERY_CACHE hint. A trace shows MEMOIZE or
 *  SUBQUERY_CACHE only when the cache was hit, so the presence of the line is what a case checks.
 *
 *  Coverage:
 *    Case 1:  3-way NL join, the middle scan keyed by the outer scan only; result = memoize off
 *    Case 2:  Case 1 with a hash and a range partitioned middle table; result = memoize off
 *    Case 3:  derived table inner correlated to the outer row, with a join term; result = memoize off
 *    Case 4:  correlated derived table after an ANTI and a SEMI JOIN inner; result = memoize off
 *    Case 5:  session variable assigned and read by the inner; result = memoize off, no MEMOIZE
 *    Case 6:  session variable in a correlated subquery; result = NO_SUBQUERY_CACHE, no SUBQUERY_CACHE
 *    Case 7:  stored function in the inner term; NOT DETERMINISTIC is called as often as with memoize off
 *    Case 8:  GROUP BY, analytic, HAVING, CONNECT BY, join and UNION subqueries in the inner term are memoized
 *    Case 9:  inner that reads no outer value, NL inside a correlated subquery, uncorrelated derived inner
 */
drop table if exists t_out, t_mid, t_last, t_mid_hash, t_mid_range;
drop table if exists t_drv_out, t_drv_src, t_semi_out, t_semi_in;
drop table if exists t_sv_out, t_sv_in, t_fn_out, t_fn_in, t_sq_out, t_sq_in, t_sq_sub;
drop serial if exists s_calls;


evaluate 'Case 1: 3-way NL join, the middle scan keyed by the outer scan only; result = memoize off';
-- t_mid and t_last share k and c: the WHERE terms of t_last follow the range term of t_mid
create table t_out (id int, a int, b int);
insert into t_out select rownum, mod(rownum * 7, 30) + 5, mod(rownum * 11, 25) from db_class a, db_class b limit 200;
create table t_mid (k int, c int, v int);
insert into t_mid select mod(rownum * 3, 50), mod(rownum * 7, 60) - 5, rownum from db_class a, db_class b limit 400;
create index i_mid_kc on t_mid (k, c);
create table t_last (k int, c int, v int);
insert into t_last select k, c, v * 3 from t_mid;
create index i_last_kc on t_last (k, c);
update statistics on t_out, t_mid, t_last with fullscan;
set trace on;
select /*+ recompile ordered use_nl */ count (*), sum (y.v) from t_out o, t_mid x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
show trace;
set trace off;
select /*+ recompile ordered use_hash */ count (*), sum (y.v) from t_out o, t_mid x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ count (*), sum (y.v) from t_out o, t_mid x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 2: Case 1 with a hash and a range partitioned middle table; result = memoize off';
create table t_mid_hash (k int, c int, v int) partition by hash (c) partitions 4;
insert into t_mid_hash select * from t_mid;
create index i_midh_kc on t_mid_hash (k, c);
create table t_mid_range (k int, c int, v int) partition by range (c) (partition p_low values less than (10), partition p_mid values less than (30), partition p_high values less than maxvalue);
insert into t_mid_range select * from t_mid;
create index i_midr_kc on t_mid_range (k, c);
update statistics on t_mid_hash, t_mid_range with fullscan;
select /*+ recompile ordered use_nl */ count (*), sum (y.v) from t_out o, t_mid_hash x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
select /*+ recompile ordered use_nl */ count (*), sum (y.v) from t_out o, t_mid_range x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ count (*), sum (y.v) from t_out o, t_mid_hash x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
select /*+ recompile ordered use_nl */ count (*), sum (y.v) from t_out o, t_mid_range x, t_last y where x.k = o.a and x.c > o.b and x.k > 10 and y.k = x.k + 0 and y.c = x.c;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 3: derived table inner correlated to the outer row, with a join term; result = memoize off';
-- d is made again for every row of t_drv_out and reads its g; the join term reads only its nu
create table t_drv_out (pk int primary key, nu int, g int);
insert into t_drv_out select rownum, 1, mod(rownum, 3) from db_class a, db_class b limit 12;
create table t_drv_src (pk int primary key, v int);
insert into t_drv_src values (1, 1), (2, 2), (3, 3), (4, 4);
update statistics on t_drv_out, t_drv_src with fullscan;
select /*+ recompile use_nl ordered */ o.g, sum (d.cnt), count (*) from t_drv_out o, (select x.pk, count (*) over () cnt from t_drv_src x where x.pk <= o.g + 1) d where d.pk <= o.nu + 1 group by o.g order by 1;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ o.g, sum (d.cnt), count (*) from t_drv_out o, (select x.pk, count (*) over () cnt from t_drv_src x where x.pk <= o.g + 1) d where d.pk <= o.nu + 1 group by o.g order by 1;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 4: correlated derived table after an ANTI and a SEMI JOIN inner; result = memoize off';
create table t_semi_out (c1 int, c2 int);
create table t_semi_in (c1 int primary key, c2 int);
insert into t_semi_out values (1, 10), (2, 20), (3, 30);
insert into t_semi_in values (1, 10), (3, 30), (4, 40);
update statistics on t_semi_out, t_semi_in with fullscan;
select /*+ recompile use_nl ordered */ o.pk, o.g, d.cnt from t_drv_out o anti join t_drv_src a on a.pk = o.g + 4, (select count (*) cnt from t_drv_src x where x.pk <= o.g + 1) d order by 1;
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t_semi_out o semi join t_semi_in a on a.c1 = o.c1, (select count (*) as cnt from t_semi_in x where x.c2 <= o.c2) d order by 1;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile use_nl ordered */ o.pk, o.g, d.cnt from t_drv_out o anti join t_drv_src a on a.pk = o.g + 4, (select count (*) cnt from t_drv_src x where x.pk <= o.g + 1) d order by 1;
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t_semi_out o semi join t_semi_in a on a.c1 = o.c1, (select count (*) as cnt from t_semi_in x where x.c2 <= o.c2) d order by 1;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 5: session variable assigned and read by the inner; result = memoize off, no MEMOIZE';
-- the select list adds 5 to v for every joined row, and the inner term reads v
create table t_sv_out (id int, a int);
insert into t_sv_out select rownum, mod(rownum, 2) from db_class limit 8;
create table t_sv_in (k int, c int);
insert into t_sv_in select mod(rownum, 2), rownum from db_class limit 40;
create index i_sv_kc on t_sv_in (k, c);
update statistics on t_sv_out, t_sv_in with fullscan;
set @v = 0;
select /*+ recompile ordered use_nl */ count (*), sum (x.c), max (@v := @v + 5) from t_sv_out o, t_sv_in x where x.k = o.a and x.c < @v + 5;
set system parameters 'memoize_memory_limit=0';
set @v = 0;
select /*+ recompile ordered use_nl */ count (*), sum (x.c), max (@v := @v + 5) from t_sv_out o, t_sv_in x where x.k = o.a and x.c < @v + 5;
set system parameters 'memoize_memory_limit=default';
-- v is only read here, and the inner is still not memoized
set @v = 100;
set trace on;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sv_out o, t_sv_in x where x.k = o.a and x.c < @v;
show trace;
set trace off;


evaluate 'Case 6: session variable in a correlated subquery; result = NO_SUBQUERY_CACHE, no SUBQUERY_CACHE';
-- the select list assigns v after the subquery that reads it, row by row
create table t_sq_out (id int, a int);
insert into t_sq_out select rownum, mod(rownum, 2) from db_class limit 8;
create table t_sq_in (k int, c int);
insert into t_sq_in select mod(rownum, 2), rownum from db_class limit 40;
update statistics on t_sq_out, t_sq_in with fullscan;
set @v = 0;
select sum (n), max (w) from (select o.id, (select count (*) from t_sq_in x where x.k = o.a and x.c < @v + 5) n, (@v := @v + 5) w from t_sq_out o) s;
set @v = 0;
select sum (n), max (w) from (select o.id, (select /*+ NO_SUBQUERY_CACHE */ count (*) from t_sq_in x where x.k = o.a and x.c < @v + 5) n, (@v := @v + 5) w from t_sq_out o) s;
set @v = 100;
set trace on;
select /*+ recompile */ sum (n) from (select o.id, (select count (*) from t_sq_in x where x.k = o.a and x.c < @v) n from t_sq_out o) s;
show trace;
set trace off;
drop variable @v;


evaluate 'Case 7: stored function in the inner term; NOT DETERMINISTIC is called as often as with memoize off';
-- f_nondet takes a value from s_calls on every call, so its current value counts the calls
create serial s_calls;
create table t_fn_out (id int, a int);
insert into t_fn_out select rownum, mod(rownum, 2) from db_class limit 10;
create table t_fn_in (k int);
insert into t_fn_in values (0), (1);
update statistics on t_fn_out, t_fn_in with fullscan;
create or replace function f_det (x int) return int deterministic as begin return x; end;
create or replace function f_nondet (x int) return int as begin return x + 0 * s_calls.next_value; end;
set trace on;
select /*+ recompile ordered use_nl */ count (*) from t_fn_out t, t_fn_in c where c.k = f_det (t.a);
show trace;
select /*+ recompile ordered use_nl */ count (*) from t_fn_out t, t_fn_in c where c.k = f_nondet (t.a);
show trace;
set trace off;
select s_calls.current_value;
drop serial s_calls;
create serial s_calls;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ count (*) from t_fn_out t, t_fn_in c where c.k = f_nondet (t.a);
set system parameters 'memoize_memory_limit=default';
select s_calls.current_value;
-- f_det redeclared NOT DETERMINISTIC: the next compile of the same query does not memoize it
create or replace function f_det (x int) return int as begin return x + 0 * s_calls.next_value; end;
set trace on;
select /*+ recompile ordered use_nl */ count (*) from t_fn_out t, t_fn_in c where c.k = f_det (t.a);
show trace;
set trace off;


evaluate 'Case 8: GROUP BY, analytic, HAVING, CONNECT BY, join and UNION subqueries in the inner term are memoized';
-- every subquery reads a column of t_sq_out o; only the DRAND one stays without MEMOIZE
create table t_sq_sub (id int, k int, v int, p int);
insert into t_sq_sub select rownum, mod(rownum, 4), mod(rownum * 3, 40), rownum - 1 from db_class a, db_class b limit 120;
drop table t_sq_out;
create table t_sq_out (id int, a int, b int);
insert into t_sq_out select rownum, mod(rownum, 4), mod(rownum, 3) from db_class a, db_class b limit 60;
drop table t_sq_in;
create table t_sq_in (id int, k int, c int);
insert into t_sq_in select rownum, mod(rownum, 4), mod(rownum * 7, 50) from db_class a, db_class b limit 200;
create index i_sq_k on t_sq_in (k);
update statistics on t_sq_sub, t_sq_out, t_sq_in with fullscan;
set trace on;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (cnt) from (select z.k, count (*) cnt from t_sq_sub z where z.v < o.b * 10 + 5 group by z.k) t);
show trace;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (r) from (select row_number () over (order by z.v) r from t_sq_sub z where z.k = o.b) t);
show trace;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select count (*) from t_sq_sub z where z.k = x.k group by z.k having count (*) > o.b + (select min (v) from t_sq_sub z2 where z2.k = o.a));
show trace;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (level) from t_sq_sub z start with z.id = 1 connect by prior (z.id + o.b * 0) = z.p and level < 4 + o.b);
show trace;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select count (*) from t_sq_sub z, t_sq_sub z2 where z.k = z2.k and z.v = o.b and z2.v < 5);
show trace;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (v) from (select v from t_sq_sub z where z.k = o.a union all select v from t_sq_sub z where z.v = o.b) t);
show trace;
select /*+ recompile ordered use_nl */ count (*) >= 0 from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (cnt) from (select z.k, count (*) cnt from t_sq_sub z where z.v < o.b * 10 + 5 and drand () < 2 group by z.k) t);
show trace;
set trace off;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (cnt) from (select z.k, count (*) cnt from t_sq_sub z where z.v < o.b * 10 + 5 group by z.k) t);
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (r) from (select row_number () over (order by z.v) r from t_sq_sub z where z.k = o.b) t);
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select count (*) from t_sq_sub z where z.k = x.k group by z.k having count (*) > o.b + (select min (v) from t_sq_sub z2 where z2.k = o.a));
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (level) from t_sq_sub z start with z.id = 1 connect by prior (z.id + o.b * 0) = z.p and level < 4 + o.b);
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select count (*) from t_sq_sub z, t_sq_sub z2 where z.k = z2.k and z.v = o.b and z2.v < 5);
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.k = o.a and x.c > (select max (v) from (select v from t_sq_sub z where z.k = o.a union all select v from t_sq_sub z where z.v = o.b) t);
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 9: inner that reads no outer value, NL inside a correlated subquery, uncorrelated derived inner';
-- the third query reads a derived table made once, which calls the NOT DETERMINISTIC f_nondet
set trace on;
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.c > 45;
show trace;
select /*+ recompile */ sum (n) from (select z.id, (select /*+ ordered use_nl */ count (*) from t_sq_out o, t_sq_in x where x.k = o.a and x.c = z.v) n from t_sq_sub z) s;
show trace;
select /*+ recompile ordered use_nl */ count (*), sum (d.c) from t_sq_out o, (select k, c, f_nondet (0) n from t_sq_in) d where d.k = o.a;
show trace;
set trace off;
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ count (*), sum (x.c) from t_sq_out o, t_sq_in x where x.c > 45;
select /*+ recompile */ sum (n) from (select z.id, (select /*+ ordered use_nl */ count (*) from t_sq_out o, t_sq_in x where x.k = o.a and x.c = z.v) n from t_sq_sub z) s;
select /*+ recompile ordered use_nl */ count (*), sum (d.c) from t_sq_out o, (select k, c, f_nondet (0) n from t_sq_in) d where d.k = o.a;
set system parameters 'memoize_memory_limit=default';


drop table if exists t_out, t_mid, t_last, t_mid_hash, t_mid_range;
drop table if exists t_drv_out, t_drv_src, t_semi_out, t_semi_in;
drop table if exists t_sv_out, t_sv_in, t_fn_out, t_fn_in, t_sq_out, t_sq_in, t_sq_sub;
drop function f_det, f_nondet;
drop serial if exists s_calls;
