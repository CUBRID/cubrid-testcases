/*
 * This test case verifies CBRD-27811 : the row estimate of a grouped derived
 * table ignored HAVING, so the outer join was planned for every group.
 *
 * Bug: qo_estimate_ngroups () estimated the rows of a GROUP BY query as the
 * number of groups (the NDV of the GROUP BY columns) and never applied the
 * HAVING clause. The estimate becomes the cardinality of the derived table,
 * so a derived table that HAVING reduces to a few groups was taken as 20,000
 * rows and joined to t_ord with a hash join over a full scan of t_ord.
 *
 * Fix: the group count is multiplied by the HAVING selectivity. SUM, AVG, MIN
 * and MAX compared with constants (>, <, BETWEEN, =, IN) are estimated with
 * the histogram of the aggregated column, COUNT (*) with the histogram of the
 * GROUP BY column, and AND, OR and NOT combine them. A comparison with a host
 * variable is replanned under its value. Any other aggregate predicate takes
 * a default selectivity.
 *
 * Data: t_ord 20,000 orders, t_line 1 to 7 lines per order (80,003 rows),
 * l_qty 1..50, l_date in 2020, l_n NULL for every line of every fifth order.
 *   Case 1: sum (l_qty) > 300 -> idx-join, inner t_ord on pk_t_ord_o_id
 *           (the bug picks a hash join)
 *   Case 2: 300 < sum (l_qty), the constant on the left -> the same as Case 1
 *   Case 3: max (l_qty) > 49 -> idx-join
 *   Case 4: min (l_qty) > 40 -> idx-join
 *   Case 5: max (l_date) > date'2020-12-20' -> idx-join
 *   Case 6: count (*) > 6, from the group size -> idx-join
 *   Case 7: control, sum (l_qty) > 10 keeps almost every group -> hash join,
 *           the same before and after the fix
 *   Case 8: control, no HAVING -> hash join, the same before and after the fix
 *   Case 9: sum (l_qty) between 250 and 400 -> idx-join
 *   Case 10: max (l_qty) = 50 -> idx-join
 *   Case 11: min (l_qty) in (49, 50) -> idx-join
 *   Case 12: sum (l_qty) > 300 or max (l_qty) > 49 -> idx-join
 *   Case 13: a conjunct without an aggregate beside one with it, over GROUP BY
 *            l_oid + 1 -> idx-join
 *   Case 14: DISTINCT over the GROUP BY keeps the HAVING estimate -> idx-join
 *   Case 15: max (l_n) < 3, the all-NULL groups fail -> idx-join
 *   Case 16: control, count (*) > 1 over a UNION ALL, whose groups were not
 *            counted -> hash join (a group size of one row is not assumed)
 *   Case 17: control, sum (l_qty) > -1e30, beyond the histogram keys, keeps
 *            every group -> hash join
 *   Case 18: sum (l_qty) > ? executed with 10 -> hash join, then with 300 ->
 *            nested loops
 */
drop table if exists t_ord, t_line;

create table t_ord (o_id int primary key, o_cust int, o_pad varchar (200));
create table t_line (l_oid int, l_no int, l_qty int, l_date date, l_n int, primary key (l_oid, l_no));

insert into t_ord
  with recursive
    x (lv) as (select 1 union all select lv + 1 from x where lv < 200),
    y (lv) as (select 1 union all select lv + 1 from y where lv < 100)
  select n, mod (n, 1000), repeat ('x', 100)
    from (select (x.lv - 1) * 100 + y.lv n from x, y) z;

insert into t_line
  with recursive k (n) as (select 1 union all select n + 1 from k where n < 7)
  select o.o_id, k.n, mod (o.o_id * 31 + k.n * 17, 50) + 1, adddate (date'2020-01-01', mod (o.o_id * 7 + k.n * 3, 365)),
         case when mod (o.o_id, 5) = 0 then null else mod (o.o_id * 3 + k.n, 10) end
    from t_ord o, k
   where k.n <= 1 + mod (o.o_id * 13, 7);

update statistics on t_ord, t_line;

select count (*) from t_ord;
select count (*) from t_line;

evaluate '[1] sum (l_qty) > 300: idx-join, inner iscan t_ord on pk_t_ord_o_id';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having sum (l_qty) > 300) av where o.o_id = av.l_oid;

evaluate '[2] 300 < sum (l_qty): idx-join, inner iscan t_ord on pk_t_ord_o_id';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having 300 < sum (l_qty)) av where o.o_id = av.l_oid;

evaluate '[3] max (l_qty) > 49: idx-join, inner iscan t_ord on pk_t_ord_o_id';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having max (l_qty) > 49) av where o.o_id = av.l_oid;

evaluate '[4] min (l_qty) > 40: idx-join, inner iscan t_ord on pk_t_ord_o_id';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having min (l_qty) > 40) av where o.o_id = av.l_oid;

evaluate '[5] max (l_date) > date 2020-12-20: idx-join, inner iscan t_ord on pk_t_ord_o_id';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having max (l_date) > date'2020-12-20') av where o.o_id = av.l_oid;

evaluate '[6] count (*) > 6: idx-join, inner iscan t_ord on pk_t_ord_o_id';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having count (*) > 6) av where o.o_id = av.l_oid;

evaluate '[7] control, sum (l_qty) > 10: hash join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having sum (l_qty) > 10) av where o.o_id = av.l_oid;

evaluate '[8] control, no HAVING: hash join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid) av where o.o_id = av.l_oid;

evaluate '[9] sum (l_qty) between 250 and 400: idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having sum (l_qty) between 250 and 400) av where o.o_id = av.l_oid;

evaluate '[10] max (l_qty) = 50: idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having max (l_qty) = 50) av where o.o_id = av.l_oid;

evaluate '[11] min (l_qty) in (49, 50): idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having min (l_qty) in (49, 50)) av where o.o_id = av.l_oid;

evaluate '[12] sum (l_qty) > 300 or max (l_qty) > 49: idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having sum (l_qty) > 300 or max (l_qty) > 49) av where o.o_id = av.l_oid;

evaluate '[13] l_oid + 1 > 18000 and sum (l_qty) > 300 over GROUP BY l_oid + 1: idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid + 1 k from t_line group by l_oid + 1 having l_oid + 1 > 18000 and sum (l_qty) > 300) av where o.o_id = av.k;

evaluate '[14] DISTINCT over GROUP BY with sum (l_qty) > 300: idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select distinct count (*) + 0 k from t_line group by l_oid having sum (l_qty) > 300) av where o.o_id = av.k;

evaluate '[15] max (l_n) < 3 with all-NULL groups: idx-join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having max (l_n) < 3) av where o.o_id = av.l_oid;

evaluate '[16] control, count (*) > 1 over UNION ALL: hash join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select k from (select l_oid k from t_line union all select l_oid from t_line) u group by k having count (*) > 1) av where o.o_id = av.k;

evaluate '[17] control, sum (l_qty) > -1e30: hash join';
--@queryplan
select /*+ recompile */ count (*) from t_ord o, (select l_oid from t_line group by l_oid having sum (l_qty) > -1e30) av where o.o_id = av.l_oid;

evaluate '[18] sum (l_qty) > ? with 10: hash join, then with 300: nested loops';
--+ holdcas on;
set trace on;
prepare st from 'select count (*) from t_ord o, (select l_oid from t_line group by l_oid having sum (l_qty) > ?) av where o.o_id = av.l_oid';
execute st using 10;
show trace;
execute st using 300;
show trace;
deallocate prepare st;
set trace off;
--+ holdcas off;

drop table t_ord, t_line;
