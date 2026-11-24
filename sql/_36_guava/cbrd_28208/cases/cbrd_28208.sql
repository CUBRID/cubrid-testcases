/**
 *  This test case verifies CBRD-28208: five defects of queries with analytic functions.
 *
 *  Case 1: [regression of CBRD-27683] a top-level query whose streamed analytic group has more waiting
 *          rows than max_agg_hash_size (2M by default) wrote the rows that go to a list file with the
 *          wrong tuple header, and their plain columns came out NULL.
 *  Case 2: an analytic function over an aggregate with a USING INDEX clause crashed the client, since
 *          the clause moved to the derived table of the aggregate was not resolved.
 *  Case 3: an analytic function ordered DESC whose sort is skipped over an index key list scan
 *          (IN, OR of equalities) was computed in ascending order. The keys are read in the order of the
 *          sort, by the first column they differ at (a multi-column IN, a column fixed by an equality).
 *  Case 4: multi range optimization was applied to a query with analytic functions, which then saw
 *          the top N rows only.
 *  Case 5: a constant column of a merged view or derived table used in PARTITION BY / ORDER BY of an
 *          analytic function was read as a select list position (errors, a wrong result through the
 *          plan cache, a client crash). The position of a constant select list item failed as well.
 *
 *  Where a query has a reference, the reference follows it and must return the same rows.
 */

drop table if exists t_digit, t_spill, t_agg, t_klist, t_klist2, t_outer, t_mcol, t_mro, t_const;
drop view if exists v_const;

create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- Case 1: 30000 rows of about 170 bytes, in two partitions of 15000 rows. The wide column itself is selected,
-- so that the waiting rows are larger than max_agg_hash_size
create table t_spill (id int primary key, g int not null, a int, v varchar(200));
insert into t_spill
  select n, mod(n, 2), mod(n, 7), lpad('w' || n, 150, 'x')
    from (select d1.i + d2.i * 10 + d3.i * 100 + d4.i * 1000 + d5.i * 10000 + 1 as n
            from t_digit d1, t_digit d2, t_digit d3, t_digit d4, t_digit d5
           where d5.i < 3) x;
commit;

-- the last rows are the ones that go to the list file
select id, v, count(*) over () as c from t_spill order by id desc limit 3;
select id, v, count(*) over () as c from t_spill order by id limit 3;
select id, v, a, sum(a) over (partition by g) as s from t_spill order by id desc limit 4;
select id, v, cast(round(percent_rank() over (order by g) * 10000) as int) as p from t_spill order by id desc limit 4;
select id, v, ntile(3) over (order by id) as n, max(id) over () as m from t_spill order by id desc limit 3;
select id, v, nth_value(id, 2) over (partition by g order by id) as n, count(*) over (partition by g) as c
  from t_spill order by id desc limit 4;
-- reference: inside a derived table the rows were correct
select count(*) as cnt, count(id) as cnt_id, count(v) as cnt_v, min(c) as min_c, max(c) as max_c
  from (select id, v, count(*) over () as c from t_spill) x;

-- Case 2
create table t_agg (a int, b int, v int);
insert into t_agg select mod(d1.i + d2.i * 10, 10), mod(d1.i + d2.i * 10, 7), d1.i + d2.i * 10 + 1 from t_digit d1, t_digit d2;
create index i_agg_a on t_agg (a);

select a, sum(v), rank() over (order by sum(v)) as r from t_agg where a > 0 group by a using index i_agg_a(+) order by a;
select a, sum(v), rank() over (order by sum(v) desc) as r from t_agg where a > 0 group by a using index i_agg_a order by a;
select a, sum(v), rank() over (order by sum(v)) as r from t_agg where a > 0 group by a using index t_agg.i_agg_a(+) order by a;
select a, sum(v), rank() over (order by sum(v)) as r from t_agg where a > 0 group by a using index i_agg_a(-) order by a;
select a, sum(v), rank() over (order by sum(v)) as r from t_agg where a > 0 group by a using index none order by a;
select count(*), max(v), row_number() over (order by count(*)) as r from t_agg where a > 5 using index i_agg_a(+);
-- an index name of no table of the query is ignored, as it is without the analytic function
select a, sum(v), rank() over (order by sum(v)) as r from t_agg where a > 0 group by a using index i_no_such order by a;
select a, sum(v) from t_agg where a > 7 group by a using index i_no_such order by a;

-- Case 3
create table t_klist (id int primary key, a int not null, e int);
insert into t_klist select d1.i + d2.i * 10 + d3.i * 100 + 1, mod(d1.i + d2.i * 10 + d3.i * 100, 6), d1.i from t_digit d1, t_digit d2, t_digit d3 where d3.i < 3;
create index i_klist_ad on t_klist (a desc);
create table t_klist2 (id int primary key, a int not null, b int not null);
insert into t_klist2 select id, a, mod(id, 4) from t_klist;
create index i_klist2_a on t_klist2 (a);
create index i_klist2_adb on t_klist2 (a desc, b);
create index i_klist2_ab on t_klist2 (a, b desc);
create table t_mcol (c1 int, c2 int, c3 int);
insert into t_mcol select d1.i / 3 + 1, mod(d1.i + d2.i * 10, 6) + 1, d1.i + d2.i * 10 from t_digit d1, t_digit d2;
create index i_mcol on t_mcol (c1 desc, c2);
create table t_outer (k int primary key, a int);
insert into t_outer values (1, 1), (2, 3), (3, 5);
update statistics on t_klist, t_klist2, t_outer, t_mcol with fullscan;

-- descending index, key list
select a, min(r), max(r), count(*) from (select id, a, rank() over (order by a desc) as r from t_klist where a in (1, 3, 5)) z group by a order by a;
select a, min(r), max(r), count(*) from (select id, a, rank() over (order by a desc) as r from t_klist ignore index (i_klist_ad) where a in (1, 3, 5)) z group by a order by a;
-- OR of equalities and a range list
select a, min(r), max(r), count(*) from (select id, a, rank() over (order by a desc) as r from t_klist where a = 5 or a = 1) z group by a order by a;
select a, min(r), max(r), count(*) from (select id, a, dense_rank() over (order by a desc) as r from t_klist where a between 0 and 1 or a between 4 and 5) z group by a order by a;
select a, min(r), max(r), count(*) from (select id, a, dense_rank() over (order by a desc) as r from t_klist ignore index (i_klist_ad) where a between 0 and 1 or a between 4 and 5) z group by a order by a;
-- ascending index read backwards
select a, min(r), max(r), count(*) from (select /*+ use_desc_idx */ id, a, rank() over (order by a desc) as r from t_klist2 force index (i_klist2_a) where a in (5, 1, 3)) z group by a order by a;
-- ascending order over the descending index read backwards, and over the ascending index: not reversed
select a, min(r), max(r), count(*) from (select /*+ use_desc_idx */ id, a, rank() over (order by a) as r from t_klist where a in (1, 3, 5)) z group by a order by a;
select a, min(r), max(r), count(*) from (select id, a, rank() over (order by a) as r from t_klist2 force index (i_klist2_a) where a in (5, 1, 3)) z group by a order by a;
-- a two-column index, the key list on its first column
select a, b, min(r), max(r), count(*) from (select id, a, b, rank() over (order by a desc, b) as r from t_klist2 force index (i_klist2_adb) where a in (5, 1, 3)) z group by a, b order by a, b;
select a, b, min(r), max(r), count(*) from (select id, a, b, rank() over (order by a desc, b) as r from t_klist2 ignore index (i_klist2_a, i_klist2_adb) where a in (5, 1, 3)) z group by a, b order by a, b;
-- the first sort column is fixed by an equality and the key list is on the second, ascending one: not reversed
select a, b, min(r), max(r), count(*) from (select id, a, b, rank() over (order by a desc, b) as r from t_klist2 force index (i_klist2_adb) where a = 3 and b in (0, 2, 3)) z group by a, b order by a, b;
select a, b, min(r), max(r), count(*) from (select id, a, b, rank() over (order by a desc, b) as r from t_klist2 ignore index (i_klist2_a, i_klist2_adb) where a = 3 and b in (0, 2, 3)) z group by a, b order by a, b;
select a, b, min(r), max(r), count(*) from (select id, a, b, dense_rank() over (order by a desc, b) as r from t_klist2 force index (i_klist2_adb) where a = 3 and b between 0 and 1 or a = 3 and b between 2 and 3) z group by a, b order by a, b;
select a, b, min(r), max(r), count(*) from (select id, a, b, dense_rank() over (order by a desc, b) as r from t_klist2 ignore index (i_klist2_a, i_klist2_adb) where a = 3 and b between 0 and 1 or a = 3 and b between 2 and 3) z group by a, b order by a, b;
-- the key list is on both columns, one descending and one ascending: no order of the key list fits
select a, b, min(r), max(r), count(*) from (select id, a, b, rank() over (order by a desc, b) as r from t_klist2 force index (i_klist2_adb) where a in (1, 3, 5) and b in (0, 2)) z group by a, b order by a, b;
select a, b, min(r), max(r), count(*) from (select id, a, b, rank() over (order by a desc, b) as r from t_klist2 ignore index (i_klist2_a, i_klist2_adb) where a in (1, 3, 5) and b in (0, 2)) z group by a, b order by a, b;
-- a multi-column IN: the keys are ordered by the first column they differ at, in its direction
select c1, c2, min(r), max(r), count(*) from (select c1, c2, rank() over (order by c1 desc, c2) as r from t_mcol where (c1, c2) in ((1, 1), (1, 3), (1, 5)) using index i_mcol(+)) z group by c1, c2 order by c1, c2;
select c1, c2, min(r), max(r), count(*) from (select c1, c2, rank() over (order by c1 desc, c2) as r from t_mcol where (c1, c2) in ((1, 1), (1, 3), (1, 5)) using index none) z group by c1, c2 order by c1, c2;
select c1, c2, min(r), max(r), count(*) from (select c1, c2, rank() over (order by c1 desc, c2) as r from t_mcol where (c1, c2) in ((1, 1), (1, 2), (3, 1)) using index i_mcol(+)) z group by c1, c2 order by c1, c2;
select c1, c2, min(r), max(r), count(*) from (select c1, c2, rank() over (order by c1 desc, c2) as r from t_mcol where (c1, c2) in ((1, 1), (1, 2), (3, 1)) using index none) z group by c1, c2 order by c1, c2;
-- a single range on the second column is the same in every key, so its direction does not order them
select a, b, min(r), max(r), count(*) from (select a, b, rank() over (order by a, b desc) as r from t_klist2 force index (i_klist2_ab) where a in (1, 2) and b > 1) z group by a, b order by a, b;
select a, b, min(r), max(r), count(*) from (select a, b, rank() over (order by a, b desc) as r from t_klist2 ignore index (i_klist2_a, i_klist2_adb, i_klist2_ab) where a in (1, 2) and b > 1) z group by a, b order by a, b;
-- other functions, a nested loop join, top level with LIMIT
select a, min(f), max(f), min(c), count(*) from (select a, first_value(a) over (order by a desc) as f, count(*) over (order by a desc) as c from t_klist where a in (1, 3, 5)) z group by a order by a;
select a, min(r), max(r), count(*) from (select /*+ ordered use_nl */ x.a, rank() over (order by x.a desc) as r from t_klist x, t_outer o where x.a in (1, 3, 5) and o.a = x.a) z group by a order by a;
select a, rank() over (order by a desc) as r from t_klist where a in (1, 3, 5) limit 2;
-- a skipped ORDER BY DESC over the key list, as before
select a from t_klist where a in (1, 3, 5) order by a desc limit 2;

-- Case 4
create table t_mro (id int primary key, a int, b int);
insert into t_mro select d1.i + d2.i * 10 + d3.i * 100 + 1, mod(d1.i + d2.i * 10 + d3.i * 100 + 1, 10), d1.i + d2.i * 10 + d3.i * 100 + 1 from t_digit d1, t_digit d2, t_digit d3;
create index i_mro_ab on t_mro (a, b);
update statistics on t_mro with fullscan;

select id, b, sum(b) over () as s, count(*) over () as c from t_mro where a in (1, 3) order by b limit 3;
select /*+ no_multi_range_opt */ id, b, sum(b) over () as s, count(*) over () as c from t_mro where a in (1, 3) order by b limit 3;
select id, b, sum(b) over () as s from t_mro where a = 1 order by b limit 3;
select id, b, rank() over (order by b desc) as r from t_mro where a in (1, 3) order by b limit 3;
select id, b, count(*) over () as c from t_mro where a in (1, 3) order by b desc limit 3;
select id, b, b + count(*) over (partition by a) as c from t_mro where a in (1, 3) order by b limit 3;
-- no analytic function
select id, b from t_mro where a in (1, 3) order by b limit 3;

-- Case 5
create table t_const (id int, c int);
insert into t_const values (1, 1), (2, 2);
create view v_const as select id, c, 5 as k, cast(null as int) as n, 'x' as s from t_const;

select c, sum(c) over (partition by k) as s from (select c, 5 as k from t_const) v order by c;
select c, sum(c) over (partition by k) as s from (select /*+ no_merge */ c, 5 as k from t_const) v order by c;
select c, sum(c) over (partition by k) as s from v_const v order by c;
select c, rank() over (order by s) as r, count(*) over (partition by n) as cnt from v_const v order by c;
select c, sum(c) over (partition by k, c order by s, id desc) as s from v_const v order by c;
select c, id, sum(id) over (partition by c) as s, row_number() over (partition by k order by id desc) as r from v_const v order by c;
select c, c + sum(c) over (partition by k order by k desc) as s, lag(c) over (partition by k order by c) as l from v_const v order by c;
-- the constant column is also in the select list
select k, c, sum(c) over (partition by k order by c) as s from v_const v order by c;
select k, s, count(*) over (partition by k, s order by n) as cnt from v_const v;
-- the analytic function is in a derived table
select d.x from (select count(*) over (partition by v.k) as x from v_const v) d;
select d.x, e.id from (select dense_rank() over (partition by v.k) as x from v_const v) d join (select id from t_const) e on d.x = e.id order by 1, 2;
-- a position written in the query is still a position, and the two statements do not share a plan
select v.c, sum(v.c) over (partition by 1) as s from t_const v order by 1;
select c, sum(c) over (partition by k) as s from (select c, 1 as k from t_const) v order by 1;
-- the position of a constant select list item
select 7, c, sum(c) over (partition by 1 order by c) as s from t_const order by c;
select 7, c, id, sum(c) over (partition by 1, 3 order by 2 desc, 1) as s from t_const order by c;
-- a position out of the select list is still an error
select c, sum(c) over (partition by 5) as s from t_const;

drop view v_const;
drop table t_digit, t_spill, t_agg, t_klist, t_klist2, t_outer, t_mcol, t_mro, t_const;
