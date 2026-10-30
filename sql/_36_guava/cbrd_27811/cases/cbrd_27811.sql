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
 * and MAX compared with a constant are estimated with the histogram of the
 * aggregated column, and COUNT (*) with the distribution of the group size.
 * Any other aggregate predicate takes the default selectivity.
 *
 * Data: t_ord 20,000 orders, t_line 1 to 7 lines per order (80,003 rows),
 * l_qty 1..50, l_date in 2020.
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
 */
drop table if exists t_ord, t_line;

create table t_ord (o_id int primary key, o_cust int, o_pad varchar (200));
create table t_line (l_oid int, l_no int, l_qty int, l_date date, primary key (l_oid, l_no));

insert into t_ord
  with recursive
    x (lv) as (select 1 union all select lv + 1 from x where lv < 200),
    y (lv) as (select 1 union all select lv + 1 from y where lv < 100)
  select n, mod (n, 1000), repeat ('x', 100)
    from (select (x.lv - 1) * 100 + y.lv n from x, y) z;

insert into t_line
  with recursive k (n) as (select 1 union all select n + 1 from k where n < 7)
  select o.o_id, k.n, mod (o.o_id * 31 + k.n * 17, 50) + 1, adddate (date'2020-01-01', mod (o.o_id * 7 + k.n * 3, 365))
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

drop table t_ord, t_line;
