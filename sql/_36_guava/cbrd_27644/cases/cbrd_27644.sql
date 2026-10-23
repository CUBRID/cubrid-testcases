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
 *   Q13 non-deterministic term (drandom) : not pushed, it keeps only some rows
 *       of a partition (x = 0 rows fail, the others pass)
 *   Q14 PARTITION BY expression which matches no select list item, such as a
 *       function (elt, json_object) : the query runs without an error
 *   Q15 any deterministic expression on keys of an exact type (integer,
 *       date) : pushed, NUMERIC expression : not pushed (see Q19)
 *   Q16 expression on a non-key column, on a value with a time zone, or on a
 *       floating point value : not pushed
 *   Q17 LIKE on a case insensitive collation key is rewritten to a range in
 *       the same collation : pushed
 *   Q18 term with a variable assignment (@a := ...) : not pushed, neither into
 *       an inline view with analytic functions nor into the outer joined inline
 *       view kept by an OR term (it was evaluated twice there)
 *   Q19 NUMERIC key whose values have different scales (1.0 and 1.00 are in
 *       the same partition) : a direct comparison is pushed, an expression such
 *       as a string conversion is not
 */
drop table if exists tbl1, h1, e1, e2, o1, n1;
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
--@queryplan
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
--@queryplan
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

evaluate 'Q13. non-deterministic term';
create table e1 (id int primary key, g int, x int, n numeric (10, 2), d date, dt datetimetz, f double);
insert into e1 select rownum, mod (rownum, 7), mod (rownum, 5), mod (rownum, 4) * 0.5,
  date'2024-01-01' + mod (rownum, 10),
  decode (mod (rownum, 2), 0, datetimetz'2024-01-01 09:00:00 +09:00', datetimetz'2024-01-01 00:00:00 +00:00'),
  decode (mod (rownum, 3), 0, -0.0, 1, 0.0, 1.5)
  from db_class a, db_class b limit 300;
create index ie1_g on e1 (g);
create index ie1_d on e1 (d);
update statistics on e1 with fullscan;
--@queryplan
select /*+ recompile */ T.g, count (*), min (T.cnt), max (T.cnt)
from (select g, x, count (*) over (partition by g) cnt from e1) T
where T.x > drandom ()
group by T.g order by 1;
select /*+ recompile no_push_pred */ T.g, count (*), min (T.cnt), max (T.cnt)
from (select g, x, count (*) over (partition by g) cnt from e1) T
where T.x > drandom ()
group by T.g order by 1;

evaluate 'Q14. PARTITION BY expression which matches no select list item';
select /*+ recompile */ * from (select elt (x + 1, 'p', 'q', 'r', 's', 't') e, count (*) over (partition by elt (g, 'p', 'q')) cnt from e1) T
where T.e = 'p' order by 2, 1 limit 3;
select /*+ recompile */ * from (select json_object ('x', x) j, count (*) over (partition by json_object ('g', g)) cnt from e1) T
where T.j is not null order by 2, 1 limit 3;
select /*+ recompile */ * from (select g, x, count (*) over (partition by elt (g, 'p', 'q')) cnt from e1) T
where T.g = 1 order by 3, 2 limit 3;

evaluate 'Q15. deterministic expression on keys of an exact type';
--@queryplan
select /*+ recompile */ T.g, count (*), max (T.cnt)
from (select g, count (*) over (partition by g) cnt from e1) T
where mod (T.g, 3) = 0 or T.g + 0 = 1
group by T.g order by 1;
select /*+ recompile no_push_pred */ T.g, count (*), max (T.cnt)
from (select g, count (*) over (partition by g) cnt from e1) T
where mod (T.g, 3) = 0 or T.g + 0 = 1
group by T.g order by 1;
--@queryplan
select /*+ recompile */ T.d, count (*), max (T.cnt), max (T.rn)
from (select d, count (*) over (partition by d) cnt, row_number () over (partition by d order by id) rn from e1) T
where to_char (T.d, 'YYYYMMDD') like '2024010%' and day (T.d) > 7
group by T.d order by 1;
select /*+ recompile no_push_pred */ T.d, count (*), max (T.cnt), max (T.rn)
from (select d, count (*) over (partition by d) cnt, row_number () over (partition by d order by id) rn from e1) T
where to_char (T.d, 'YYYYMMDD') like '2024010%' and day (T.d) > 7
group by T.d order by 1;
--@queryplan
select /*+ recompile */ T.n, count (*), max (T.cnt)
from (select n, count (*) over (partition by n) cnt from e1) T
where T.n * 2 = 1
group by T.n order by 1;
select /*+ recompile no_push_pred */ T.n, count (*), max (T.cnt)
from (select n, count (*) over (partition by n) cnt from e1) T
where T.n * 2 = 1
group by T.n order by 1;

evaluate 'Q16. expression on a non-key, a time zone value or a floating point value';
--@queryplan
select /*+ recompile */ T.g, count (*), max (T.cnt)
from (select g, x, count (*) over (partition by g) cnt from e1) T
where T.g + T.x = 3
group by T.g order by 1;
select /*+ recompile no_push_pred */ T.g, count (*), max (T.cnt)
from (select g, x, count (*) over (partition by g) cnt from e1) T
where T.g + T.x = 3
group by T.g order by 1;
select /*+ recompile */ count (*), min (T.cnt), max (T.cnt)
from (select dt, count (*) over (partition by dt) cnt from e1) T
where to_char (T.dt, 'TZH') = '+09';
select /*+ recompile no_push_pred */ count (*), min (T.cnt), max (T.cnt)
from (select dt, count (*) over (partition by dt) cnt from e1) T
where to_char (T.dt, 'TZH') = '+09';
select /*+ recompile */ count (*), min (T.cnt), max (T.cnt)
from (select f, count (*) over (partition by f) cnt from e1) T
where T.f + 0 = 0;
select /*+ recompile no_push_pred */ count (*), min (T.cnt), max (T.cnt)
from (select f, count (*) over (partition by f) cnt from e1) T
where T.f + 0 = 0;

evaluate 'Q17. LIKE on a case insensitive collation key';
insert into h1 values (4, 'ab', 'Ab'), (5, 'ab', 'aB'), (6, 'c', 'C');
--@queryplan
select /*+ recompile */ * from (select id, ci, count (*) over (partition by ci) cnt from h1) T
where T.ci like 'a%' order by id;
select /*+ recompile no_push_pred */ * from (select id, ci, count (*) over (partition by ci) cnt from h1) T
where T.ci like 'a%' order by id;

evaluate 'Q18. term with a variable assignment';
create table e2 (id int, g int);
insert into e2 select rownum, mod (rownum, 3) from db_class limit 12;
create table o1 (id int);
insert into o1 select rownum from db_class limit 12;
set @a = 0;
--@queryplan
select /*+ recompile */ T.g, count (*), min (T.cnt), max (T.cnt)
from (select g, count (*) over (partition by g) cnt from e2) T
where T.g * 0 + mod ((@a := @a + 1), 2) = 0
group by T.g order by 1;
set @a = 0;
select /*+ recompile no_push_pred */ T.g, count (*), min (T.cnt), max (T.cnt)
from (select g, count (*) over (partition by g) cnt from e2) T
where T.g * 0 + mod ((@a := @a + 1), 2) = 0
group by T.g order by 1;
set @a = 0;
--@queryplan
select /*+ recompile */ a.id, X.id, X.g
from o1 a left outer join (select id, g from e2) X on a.id = X.id
where X.g * 0 + mod ((@a := @a + 1), 2) = 0 or X.g < -1
order by 2;
select @a;
set @a = 0;
select /*+ recompile no_push_pred */ a.id, X.id, X.g
from o1 a left outer join (select id, g from e2) X on a.id = X.id
where X.g * 0 + mod ((@a := @a + 1), 2) = 0 or X.g < -1
order by 2;
select @a;

evaluate 'Q19. NUMERIC key whose values have different scales';
create table n1 (id int, k int, p numeric (5, 1), q numeric (5, 2));
insert into n1 values (1, 0, 1.0, null), (2, 1, null, 1.00), (3, 0, 1.0, null), (4, 1, null, 1.00);
--@queryplan
select /*+ recompile */ T.* from (select id, n, count (*) over (partition by n) cnt
                                  from (select id, case when k = 0 then p else q end n from n1) X) T
where T.n || '' = '1.0' order by id;
select /*+ recompile no_push_pred */ T.* from (select id, n, count (*) over (partition by n) cnt
                                               from (select id, case when k = 0 then p else q end n from n1) X) T
where T.n || '' = '1.0' order by id;
--@queryplan
select /*+ recompile */ T.* from (select id, n, count (*) over (partition by n) cnt
                                  from (select id, case when k = 0 then p else q end n from n1) X) T
where T.n = 1 order by id;
select /*+ recompile no_push_pred */ T.* from (select id, n, count (*) over (partition by n) cnt
                                               from (select id, case when k = 0 then p else q end n from n1) X) T
where T.n = 1 order by id;

drop variable @a;
drop table tbl1, h1, e1, e2, o1, n1;
