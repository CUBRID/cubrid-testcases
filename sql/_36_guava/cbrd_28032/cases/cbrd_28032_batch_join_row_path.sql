/*
 * CBRD-28032: a batched nested loop join holds outer rows only while that names heap pages to read ahead.
 * The rows it does not hold take the join's row path. Each case returns the rows of the join taken a row
 * at a time.
 *
 *    Case 1: a join of 18 tables: the scan after the 17th holds the rows of its own outer scan only
 *    Case 2: a value error in the last scan, on the second row it finds for the first row of the join,
 *            and in the scan before it. A LIMIT that ends before that row reports no error
 *    Case 3: null join values on a one-column index: inner join, left outer join, EXISTS, NOT EXISTS
 *    Case 4: null join values on the first column of a two-column index
 */

drop table if exists rp_o, rp_m, rp_l, rp_d;

create table rp_o (id int primary key, k int, kn int);
insert into rp_o select rownum, rownum, case when mod(rownum, 25) < 12 then null else mod(rownum, 40) + 1 end from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5}) c;
create table rp_m (id int primary key, k int, k2 int, v int);
insert into rp_m select rownum, mod(rownum * 37, 600) + 1, mod(rownum * 13, 300) + 1, mod(rownum * 7, 1009) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3}) d;
create index i_rp_m_k on rp_m (k);
create index i_rp_m_k2_k on rp_m (k2, k);
create table rp_l (id int primary key, k int, v int);
insert into rp_l select rownum, mod(rownum * 19, 300) + 1, mod(rownum * 11, 1013) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3}) d;
create index i_rp_l_k on rp_l (k);
create table rp_d (id int primary key, k int, v int);
insert into rp_d select rownum, rownum, rownum * 2 from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9,10,11}) b;
create index i_rp_d_k on rp_d (k);
update statistics on rp_o, rp_m, rp_l, rp_d with fullscan;

evaluate 'Case 1: a join of 18 tables';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(t1.id + t18.v)
from rp_d t1, rp_d t2, rp_d t3, rp_d t4, rp_d t5, rp_d t6, rp_d t7, rp_d t8, rp_d t9, rp_d t10, rp_d t11, rp_d t12, rp_d t13, rp_d t14, rp_d t15, rp_d t16, rp_d t17, rp_d t18
where t2.k = t1.k and t3.k = t2.k and t4.k = t3.k and t5.k = t4.k and t6.k = t5.k and t7.k = t6.k and t8.k = t7.k and t9.k = t8.k and t10.k = t9.k
  and t11.k = t10.k and t12.k = t11.k and t13.k = t12.k and t14.k = t13.k and t15.k = t14.k and t16.k = t15.k and t17.k = t16.k and t18.k = t17.k
using index t1.none, t2.i_rp_d_k(+), t3.i_rp_d_k(+), t4.i_rp_d_k(+), t5.i_rp_d_k(+), t6.i_rp_d_k(+), t7.i_rp_d_k(+), t8.i_rp_d_k(+), t9.i_rp_d_k(+), t10.i_rp_d_k(+),
  t11.i_rp_d_k(+), t12.i_rp_d_k(+), t13.i_rp_d_k(+), t14.i_rp_d_k(+), t15.i_rp_d_k(+), t16.i_rp_d_k(+), t17.i_rp_d_k(+), t18.i_rp_d_k(+);

evaluate 'Case 2: the rows of the join without the error';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(m.v), sum(l.v) from rp_o o, rp_m m, rp_l l where m.k = o.k and l.k = m.k2 using index o.none, m.i_rp_m_k(+), l.i_rp_l_k(+);
evaluate 'Case 2: rp_l 600 is the second row of rp_l for the first row of the join: division by zero';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(m.v), sum(l.v) from rp_o o, rp_m m, rp_l l where m.k = o.k and l.k = m.k2 and 1 / (l.id - 600) < 2 using index o.none, m.i_rp_m_k(+), l.i_rp_l_k(+);
evaluate 'Case 2: LIMIT 1 ends at the first row: no error';
select count(*), sum(x_id), sum(y_id) from (select /*+ recompile ordered use_nl no_parallel_scan */ o.id x_id, l.id y_id from rp_o o, rp_m m, rp_l l where m.k = o.k and l.k = m.k2 and 1 / (l.id - 600) < 2 using index o.none, m.i_rp_m_k(+), l.i_rp_l_k(+) limit 1) t;
evaluate 'Case 2: the same error in the scan in the middle, then LIMIT 1 that ends before it';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(m.v), sum(l.v) from rp_o o, rp_m m, rp_l l where m.k = o.k and l.k = m.k2 and 1 / (m.id - 1200) < 2 using index o.none, m.i_rp_m_k(+), l.i_rp_l_k(+);
select count(*), sum(x_id), sum(y_id) from (select /*+ recompile ordered use_nl no_parallel_scan */ o.id x_id, l.id y_id from rp_o o, rp_m m, rp_l l where m.k = o.k and l.k = m.k2 and 1 / (m.id - 1200) < 2 using index o.none, m.i_rp_m_k(+), l.i_rp_l_k(+) limit 1) t;

evaluate 'Case 3: null join values, inner join: 312 of the 600 rows of rp_o have a value';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), count(o.kn), sum(o.id), sum(m.v) from rp_o o, rp_m m where m.k = o.kn using index o.none, m.i_rp_m_k(+);
evaluate 'Case 3: left outer join: a row with a null value comes out once, with no row of rp_m';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), count(o.kn), count(m.id), sum(o.id), sum(m.v) from rp_o o left outer join rp_m m on m.k = o.kn using index o.none, m.i_rp_m_k(+);
evaluate 'Case 3: EXISTS and NOT EXISTS';
select /*+ recompile no_parallel_scan */ count(*), sum(o.id) from rp_o o where exists (select 1 from rp_m m where m.k = o.kn);
select /*+ recompile no_parallel_scan */ count(*), sum(o.id) from rp_o o where not exists (select 1 from rp_m m where m.k = o.kn);
evaluate 'Case 3: the null values first and then the others, and three tables';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(o.id), sum(m.v) from (select id, kn from rp_o order by kn, id limit 600) o, rp_m m where m.k = o.kn using index m.i_rp_m_k(+);
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(o.id), sum(m.v), sum(l.v) from rp_o o, rp_m m, rp_l l where m.k = o.kn and l.k = m.k2 using index o.none, m.i_rp_m_k(+), l.i_rp_l_k(+);

evaluate 'Case 4: null join values on the first column of a two-column index';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), count(o.kn), sum(o.id), sum(m.v) from rp_o o, rp_m m where m.k2 = o.kn using index o.none, m.i_rp_m_k2_k(+);
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), count(o.kn), count(m.id), sum(o.id), sum(m.v) from rp_o o left outer join rp_m m on m.k2 = o.kn and m.k > 300 using index o.none, m.i_rp_m_k2_k(+);
evaluate 'Case 4: the second column null, the first not: the rows of the first column value with k null (none)';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(o.id) from rp_o o, rp_m m where m.k2 = o.k and m.k = o.kn and o.id <= 300 using index o.none, m.i_rp_m_k2_k(+);

drop table rp_o, rp_m, rp_l, rp_d;
