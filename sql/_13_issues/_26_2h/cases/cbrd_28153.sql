/**
 *  This test case verifies CBRD-28153: BIT_AND, BIT_OR and BIT_XOR with DISTINCT
 *  return the bitwise result over the distinct values.
 *
 *  Before the fix the DISTINCT list of these functions was folded as a SUM, so
 *  BIT_AND(DISTINCT a), BIT_OR(DISTINCT a) and BIT_XOR(DISTINCT a) all returned the
 *  sum of the distinct values, and a debug server aborted. Now the serial scan, the
 *  sort GROUP BY and the parallel buildvalue gather fold the distinct values with
 *  the bitwise operator of each function.
 *
 *  Most cases print the values and OK or NOK. The reference is the same function
 *  without DISTINCT over a derived table of the distinct values. The other queries
 *  print the values only.
 *
 *  Coverage:
 *    Case 1:  the issue query, 1 1 2 5 5 9 gives 0, 15, 15
 *    Case 2:  0 to 99 gives 0, 127, 0
 *    Case 3:  GROUP BY gives 126 and 127 for BIT_OR
 *    Case 4:  one distinct value gives that value
 *    Case 5:  an empty table and all NULL give NULL, NULL is ignored
 *    Case 6:  negative values
 *    Case 7:  the largest and the smallest BIGINT
 *    Case 8:  SMALLINT, INT and BIGINT columns
 *    Case 9:  expression arguments
 *    Case 10: BIT_XOR with and without DISTINCT differ
 *    Case 11: other DISTINCT aggregates and MEDIAN in the same select list keep their values
 *    Case 12: sort GROUP BY over ten groups
 *    Case 13: HAVING on BIT_OR(DISTINCT)
 *    Case 14: parallel heap scan with gather buildvalue matches its NO_PARALLEL_SCAN twin
 *    Case 15: parallel GROUP BY matches its NO_PARALLEL_SCAN twin and the reference
 *    Case 16: a correlated subquery folds the distinct values again for each outer row
 *    Case 17: GROUP BY with all-NULL groups and a one-value group between groups of
 *             several values starts each group from its own first value
 *    Case 18: the group rows of GROUP BY WITH ROLLUP
 */

drop table if exists t_six, t_hund, t_one, t_empty, t_null, t_mix, t_neg, t_big, t_types, t_expr, t_xor, t_grp, t_par;

create table t_six (a int);
insert into t_six values (1), (1), (2), (5), (5), (9);
create table t_hund (id int, a int);
insert into t_hund select rownum, mod(rownum, 100) from db_class a, db_class b limit 1000;
create table t_one (a int);
insert into t_one values (7), (7), (7);
create table t_empty (a int);
create table t_null (a int);
insert into t_null values (null), (null);
create table t_mix (a int);
insert into t_mix values (null), (3), (3), (12), (null);
create table t_neg (a int);
insert into t_neg values (-1), (-2), (5), (5);
create table t_big (a bigint);
insert into t_big values (9223372036854775807), (-9223372036854775808), (0), (0);
create table t_types (s smallint, i int, b bigint);
insert into t_types values (6, 6, 6), (6, 6, 6), (10, 10, 10), (3, 3, 3), (-4, -4, -4);
create table t_expr (a int, b int);
insert into t_expr select mod(rownum, 23), mod(rownum, 5) from db_class a, db_class b limit 500;
create table t_xor (a int);
insert into t_xor values (3), (3), (5);
-- groups 2 and 4 hold only NULL, group 5 one value, and they sit between groups of several values
create table t_grp (g int, a int);
insert into t_grp values (1, 3), (1, 3), (1, 12), (2, null), (2, null), (3, 5), (3, 6), (3, 5), (4, null), (5, 9);


evaluate 'Case 1: the issue query; result = 0, 15, 15';
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_six) x,
     (select bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct a from t_six) s) y;


evaluate 'Case 2: 0 to 99; result = 0, 127, 0';
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_hund) x,
     (select bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct a from t_hund) s) y;


evaluate 'Case 3: GROUP BY; result = 126, 127';
select mod(id, 2) k, bit_or(distinct a) o from t_hund group by mod(id, 2) order by 1;


evaluate 'Case 4: one distinct value; result = 7, 7, 7';
select bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a) from t_one;


evaluate 'Case 5: empty table and all NULL; result = NULL, then 0, 15, 15 with NULL ignored';
select bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a) from t_empty;
select bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a) from t_null;
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_mix) x,
     (select bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct a from t_mix) s) y;


evaluate 'Case 6: negative values; result = 4, -1, 4';
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_neg) x,
     (select bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct a from t_neg) s) y;


evaluate 'Case 7: largest and smallest BIGINT; result = 0, -1, -1';
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_big) x,
     (select bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct a from t_big) s) y;


evaluate 'Case 8: SMALLINT, INT and BIGINT columns; result = 0, -1, -13 for each';
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct s) n, bit_or(distinct s) o, bit_xor(distinct s) x from t_types) x,
     (select bit_and(s) n, bit_or(s) o, bit_xor(s) x from (select distinct s from t_types) z) y;
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct i) n, bit_or(distinct i) o, bit_xor(distinct i) x from t_types) x,
     (select bit_and(i) n, bit_or(i) o, bit_xor(i) x from (select distinct i from t_types) z) y;
select x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select bit_and(distinct b) n, bit_or(distinct b) o, bit_xor(distinct b) x from t_types) x,
     (select bit_and(b) n, bit_or(b) o, bit_xor(b) x from (select distinct b from t_types) z) y;


evaluate 'Case 9: expression arguments';
select x.v, y.v, case when x.v <=> y.v then 'OK' else 'NOK' end as result
from (select bit_xor(distinct mod(a, 7)) v from t_hund) x,
     (select bit_xor(k) v from (select distinct mod(a, 7) k from t_hund) z) y;
select x.v, y.v, case when x.v <=> y.v then 'OK' else 'NOK' end as result
from (select bit_or(distinct a + b) v from t_expr) x,
     (select bit_or(k) v from (select distinct a + b k from t_expr) z) y;


evaluate 'Case 10: with and without DISTINCT; result = 1, 1, 7, 7, 6, 5';
select bit_and(distinct a), bit_and(a), bit_or(distinct a), bit_or(a), bit_xor(distinct a), bit_xor(a) from t_xor;


evaluate 'Case 11: other DISTINCT aggregates and MEDIAN keep their values';
select sum(distinct a), count(distinct a), avg(distinct a), group_concat(distinct a order by a), round(stddev(distinct a), 6), median(a),
       bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a)
from t_six;
select sum(distinct a), count(distinct a), avg(distinct a), round(variance(distinct a), 6), median(a),
       bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a)
from t_hund;


evaluate 'Case 12: sort GROUP BY over ten groups';
select x.k, x.n, x.o, x.x, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x then 'OK' else 'NOK' end as result
from (select mod(id, 10) k, bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_hund group by mod(id, 10)) x,
     (select k, bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct mod(id, 10) k, a from t_hund) s group by k) y
where x.k = y.k
order by 1;


evaluate 'Case 13: HAVING; result = 1, 127';
select mod(id, 2) k, bit_or(distinct a) o from t_hund group by mod(id, 2) having bit_or(distinct a) > 126 order by 1;


-- 6000 rows of about 130 bytes with three md5 strings each (incompressible): 57 heap pages,
-- past the parallel heap scan threshold of 32 pages that CTP test_mode=yes sets
create table t_par (id int, a int, b bigint, pad varchar(100));
insert into t_par
select rownum, if(mod(rownum, 97) = 0, null, mod(rownum, 1001)), mod(rownum * 7919, 65536),
       concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7))
from db_class a, db_class b, db_class c, db_class d limit 6000;
update statistics on t_par with fullscan;

set trace on;

evaluate 'Case 14: parallel buildvalue; result = parallel workers line with gather buildvalue';
select p.n, p.o, p.x, p.bx, case when p.n <=> s.n and p.o <=> s.o and p.x <=> s.x and p.bx <=> s.bx then 'OK' else 'NOK' end as result
from (select /*+ PARALLEL(4) */ bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x, bit_xor(distinct b) bx from t_par) p,
     (select /*+ NO_PARALLEL_SCAN */ bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x, bit_xor(distinct b) bx from t_par) s;
show trace;
select /*+ PARALLEL(4) */ sum(distinct a), count(distinct a), avg(distinct a), median(a),
       bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a) from t_par;
show trace;
select /*+ NO_PARALLEL_SCAN */ sum(distinct a), count(distinct a), avg(distinct a), median(a),
       bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a) from t_par;

set trace off;

select p.n, p.o, p.x, case when p.n <=> r.n and p.o <=> r.o and p.x <=> r.x then 'OK' else 'NOK' end as result
from (select /*+ PARALLEL(4) */ bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_par) p,
     (select bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct a from t_par) d) r;

evaluate 'Case 15: parallel GROUP BY; result = the same rows twice, then OK for each group';
set trace on;
select /*+ PARALLEL(4) */ mod(id, 7) k, bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a), bit_xor(distinct b) from t_par group by mod(id, 7) order by 1;
show trace;
select /*+ NO_PARALLEL_SCAN */ mod(id, 7) k, bit_and(distinct a), bit_or(distinct a), bit_xor(distinct a), bit_xor(distinct b) from t_par group by mod(id, 7) order by 1;
show trace;
set trace off;
-- NO_PARALLEL_SCAN makes only the scan serial and the GROUPBY of the twin still runs in parallel,
-- so the parallel rows are also compared with the reference over the distinct values
select x.k, x.n, x.o, x.x, x.bx, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x and x.bx <=> z.bx then 'OK' else 'NOK' end as result
from (select /*+ PARALLEL(4) */ mod(id, 7) k, bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x, bit_xor(distinct b) bx from t_par group by mod(id, 7)) x,
     (select k, bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct mod(id, 7) k, a from t_par) s group by k) y,
     (select k, bit_xor(b) bx from (select distinct mod(id, 7) k, b from t_par) s group by k) z
where x.k = y.k and x.k = z.k
order by 1;

evaluate 'Case 16: correlated subquery, the distinct values folded again for each outer row; result = OK for each row';
-- the subquery runs once per group of t_hund, so each run has to start from an empty accumulator
select t.k, t.o, t.x, t.ro, t.r, case when t.o <=> t.ro and t.x <=> t.r then 'OK' else 'NOK' end as result
from (select g.k,
             (select bit_or(distinct h.a) from t_hund h where mod(h.id, 10) = g.k) o,
             (select bit_xor(distinct h.a) from t_hund h where mod(h.id, 10) = g.k) x,
             (select bit_or(z.a) from (select distinct h.a from t_hund h where mod(h.id, 10) = g.k) z) ro,
             (select bit_xor(z.a) from (select distinct h.a from t_hund h where mod(h.id, 10) = g.k) z) r
      from (select distinct mod(id, 10) k from t_hund) g) t
order by 1;


evaluate 'Case 17: GROUP BY with all-NULL groups and a one-value group; result = OK for each group';
-- p is BIT_XOR without DISTINCT in the same select list: it must keep its own value next to the DISTINCT ones
select x.g, x.n, x.o, x.x, x.p, case when x.n <=> y.n and x.o <=> y.o and x.x <=> y.x and x.p <=> z.p then 'OK' else 'NOK' end as result
from (select g, bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x, bit_xor(a) p from t_grp group by g) x,
     (select g, bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct g, a from t_grp) s group by g) y,
     (select g, bit_xor(a) p from t_grp group by g) z
where x.g = y.g and x.g = z.g
order by 1;

evaluate 'Case 18: GROUP BY WITH ROLLUP; result = OK for each group row';
-- the join keeps the two group rows and compares them with the reference, and the total row (k is NULL) drops out
select r.k, r.n, r.o, r.x, case when r.n <=> y.n and r.o <=> y.o and r.x <=> y.x then 'OK' else 'NOK' end as result
from (select mod(id, 2) k, bit_and(distinct a) n, bit_or(distinct a) o, bit_xor(distinct a) x from t_hund group by mod(id, 2) with rollup) r,
     (select k, bit_and(a) n, bit_or(a) o, bit_xor(a) x from (select distinct mod(id, 2) k, a from t_hund) s group by k) y
where r.k = y.k
order by 1;

drop table t_six, t_hund, t_one, t_empty, t_null, t_mix, t_neg, t_big, t_types, t_expr, t_xor, t_grp, t_par;
