/*
 * This test case verifies CBRD-27644 : a WHERE term of the main query is pushed
 * into an inline view with analytic functions when the term is on a PARTITION BY
 * key common to all analytic functions of the inline view.
 *
 * An analytic function is computed in each partition separately. A term which
 * has the same result for all rows of a partition removes whole partitions only,
 * so filtering the rows in the inline view does not change the results.
 * The column must be a direct operand of a comparison: a function, a cast or a
 * COLLATE modifier on it can split a partition (Q12).
 *
 * Every query is run twice, without and with the NO_PUSH_PRED hint, and both
 * must give the same result. The plan of the query without the hint shows
 * whether the term is pushed (index scan on t1 in the inline view) or not.
 *   Q01 transitive term from t3.c = T.c and t3.c = 'test1' (RND-2617) : pushed
 *   Q02 term on the partition key : pushed
 *   Q03 IN, range and OR on the partition key : pushed
 *   Q04 two analytic functions with the same partition key : pushed
 *   Q05 two analytic functions with different partition keys : not pushed
 *   Q06 composite partition key (c, b), term on b : pushed
 *   Q07 analytic function without PARTITION BY : not pushed
 *   Q08 term on the analytic function result : not pushed
 *   Q09 function on the partition key : not pushed
 *   Q10 UNION ALL inline view : not pushed
 *   Q11 correlated term : not pushed
 *   Q12 case insensitive collation with a COLLATE modifier : not pushed
 */
drop table if exists tbl1, h1;
create table tbl1 (a int, b varchar, c varchar);
insert into tbl1 select rownum, 'test' || mod (rownum, 100), 'test' || mod (rownum, 1000)
  from db_class a, db_class b, db_class c limit 10000;
create index cix_cub01 on tbl1 (a, c);
create index cix_cub02 on tbl1 (c, a);
create index cix_cub03 on tbl1 (b, a);
update statistics on tbl1 with fullscan;

evaluate 'Q01. transitive term on the partition key (RND-2617)';
--@queryplan
select /*+ recompile */ T.rnum, T.c
from (select row_number () over (partition by t1.c order by t1.a) as rnum, t1.c
      from tbl1 t1, tbl1 t2 where t1.a = t2.a) T, tbl1 t3
where t3.c = T.c and t3.c = 'test1' and t3.a = 1
order by 1;
select /*+ recompile no_push_pred */ T.rnum, T.c
from (select row_number () over (partition by t1.c order by t1.a) as rnum, t1.c
      from tbl1 t1, tbl1 t2 where t1.a = t2.a) T, tbl1 t3
where t3.c = T.c and t3.c = 'test1' and t3.a = 1
order by 1;

evaluate 'Q02. term on the partition key';
--@queryplan
select /*+ recompile */ T.*
from (select t1.c, t1.a, rank () over (partition by t1.c order by t1.a desc) as rk,
             count (*) over (partition by t1.c) as cnt
      from tbl1 t1) T
where T.c = 'test2'
order by T.a;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.a, rank () over (partition by t1.c order by t1.a desc) as rk,
             count (*) over (partition by t1.c) as cnt
      from tbl1 t1) T
where T.c = 'test2'
order by T.a;

evaluate 'Q03. IN, range and OR on the partition key';
--@queryplan
select /*+ recompile */ T.c, count (*), sum (T.rnum), max (T.s)
from (select t1.c, row_number () over (partition by t1.c order by t1.a) as rnum,
             sum (t1.a) over (partition by t1.c) as s
      from tbl1 t1) T
where T.c in ('test3', 'test4') or T.c between 'test998' and 'test999'
group by T.c
order by 1;
select /*+ recompile no_push_pred */ T.c, count (*), sum (T.rnum), max (T.s)
from (select t1.c, row_number () over (partition by t1.c order by t1.a) as rnum,
             sum (t1.a) over (partition by t1.c) as s
      from tbl1 t1) T
where T.c in ('test3', 'test4') or T.c between 'test998' and 'test999'
group by T.c
order by 1;

evaluate 'Q04. two analytic functions with the same partition key';
--@queryplan
select /*+ recompile */ T.*
from (select t1.c, t1.a, lag (t1.a) over (partition by t1.c order by t1.a) as prev_a,
             first_value (t1.a) over (partition by t1.c order by t1.a desc) as last_a
      from tbl1 t1) T
where T.c = 'test5' and T.a > 3000
order by T.a;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.a, lag (t1.a) over (partition by t1.c order by t1.a) as prev_a,
             first_value (t1.a) over (partition by t1.c order by t1.a desc) as last_a
      from tbl1 t1) T
where T.c = 'test5' and T.a > 3000
order by T.a;

evaluate 'Q05. two analytic functions with different partition keys';
--@queryplan
select /*+ recompile */ T.*
from (select t1.c, t1.b, t1.a, count (*) over (partition by t1.c) as cnt_c,
             count (*) over (partition by t1.b) as cnt_b
      from tbl1 t1) T
where T.c = 'test6'
order by T.a;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.b, t1.a, count (*) over (partition by t1.c) as cnt_c,
             count (*) over (partition by t1.b) as cnt_b
      from tbl1 t1) T
where T.c = 'test6'
order by T.a;

evaluate 'Q06. composite partition key, term on the second key';
--@queryplan
select /*+ recompile */ T.b, count (*), max (T.rnum), max (T.cnt)
from (select t1.c, t1.b, row_number () over (partition by t1.c, t1.b order by t1.a) as rnum,
             count (*) over (partition by t1.b, t1.c) as cnt
      from tbl1 t1) T
where T.b = 'test7'
group by T.b;
select /*+ recompile no_push_pred */ T.b, count (*), max (T.rnum), max (T.cnt)
from (select t1.c, t1.b, row_number () over (partition by t1.c, t1.b order by t1.a) as rnum,
             count (*) over (partition by t1.b, t1.c) as cnt
      from tbl1 t1) T
where T.b = 'test7'
group by T.b;

evaluate 'Q07. analytic function without PARTITION BY';
--@queryplan
select /*+ recompile */ T.*
from (select t1.c, t1.a, row_number () over (order by t1.a) as rnum from tbl1 t1) T
where T.c = 'test8'
order by T.a;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.a, row_number () over (order by t1.a) as rnum from tbl1 t1) T
where T.c = 'test8'
order by T.a;

evaluate 'Q08. term on the analytic function result';
--@queryplan
select /*+ recompile */ T.*
from (select t1.c, t1.a, row_number () over (partition by t1.c order by t1.a) as rnum from tbl1 t1) T
where T.rnum = 3 and T.c < 'test11'
order by T.c;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.a, row_number () over (partition by t1.c order by t1.a) as rnum from tbl1 t1) T
where T.rnum = 3 and T.c < 'test11'
order by T.c;

evaluate 'Q09. function on the partition key';
--@queryplan
select /*+ recompile */ T.*
from (select t1.c, t1.a, row_number () over (partition by t1.c order by t1.a) as rnum from tbl1 t1) T
where upper (T.c) = 'TEST9'
order by T.a;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.a, row_number () over (partition by t1.c order by t1.a) as rnum from tbl1 t1) T
where upper (T.c) = 'TEST9'
order by T.a;

evaluate 'Q10. UNION ALL inline view';
select /*+ recompile */ T.*
from (select t1.c, t1.a, row_number () over (partition by t1.c order by t1.a) as rnum from tbl1 t1 where t1.a < 3000
      union all
      select t1.c, t1.a, 0 from tbl1 t1 where t1.a >= 9000) T
where T.c = 'test10'
order by T.a;
select /*+ recompile no_push_pred */ T.*
from (select t1.c, t1.a, row_number () over (partition by t1.c order by t1.a) as rnum from tbl1 t1 where t1.a < 3000
      union all
      select t1.c, t1.a, 0 from tbl1 t1 where t1.a >= 9000) T
where T.c = 'test10'
order by T.a;

evaluate 'Q11. correlated term';
select /*+ recompile */ t3.a,
       (select max (T.rnum) from (select t1.c, row_number () over (partition by t1.c order by t1.a) as rnum
                                  from tbl1 t1) T where T.c = t3.c) as max_rnum
from tbl1 t3 where t3.a in (1, 2, 3)
order by 1;
select /*+ recompile */ t3.a,
       (select /*+ no_push_pred */ max (T.rnum) from (select t1.c, row_number () over (partition by t1.c order by t1.a) as rnum
                                                      from tbl1 t1) T where T.c = t3.c) as max_rnum
from tbl1 t3 where t3.a in (1, 2, 3)
order by 1;

evaluate 'Q12. case insensitive collation with a COLLATE modifier';
create table h1 (id int, c varchar (10), ci varchar (10) collate utf8_en_ci) collate utf8_bin;
insert into h1 values (1, 'a', 'A'), (2, 'a ', 'a'), (3, 'b', 'B');
select /*+ recompile */ * from (select id, ci, count (*) over (partition by ci) cnt from h1) T
where T.ci collate utf8_bin = 'a' order by id;
select /*+ recompile */ * from (select id, ci, count (*) over (partition by ci) cnt from h1) T
where T.ci = 'a' collate utf8_bin order by id;
select /*+ recompile no_push_pred */ * from (select id, ci, count (*) over (partition by ci) cnt from h1) T
where T.ci collate utf8_bin = 'a' order by id;
select /*+ recompile */ * from (select id, ci, count (*) over (partition by ci) cnt from h1) T
where T.ci = 'a' order by id;
select /*+ recompile */ * from (select id, c, count (*) over (partition by c) cnt from h1) T
where T.c = 'a' order by id;

drop table tbl1, h1;
