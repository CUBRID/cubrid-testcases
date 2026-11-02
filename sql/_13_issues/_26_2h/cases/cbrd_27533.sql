/**
 *  This test case verifies CBRD-27533: an EXISTS subquery with ORDER BY and LIMIT in a view,
 *  and EXISTS subqueries whose LIMIT, HAVING or set operation decides whether a row is returned.
 *
 *  pt_chop_to_one_select_item () removed ORDER BY of an EXISTS subquery but left LIMIT, which was rewritten
 *  to FOR ORDERBY_NUM(). A view stores its query printed after semantic check, and FOR without ORDER BY can not
 *  be parsed again, so selecting from the view failed with "unexpected 'orderby_num', expecting UPDATE".
 *  Without ORDER BY the FOR clause was not applied either, so EXISTS ignored the offset of LIMIT.
 *
 *  The fix removes an upper-bound-only LIMIT ("LIMIT n") together with ORDER BY and keeps both (and the select
 *  list) otherwise. It also scans all tuples of the subquery when FOR ORDERBY_NUM() or HAVING may filter out
 *  the first one, and keeps the select lists of INTERSECT and EXCEPT.
 *
 *  Views also failed or gave wrong results for the following, since their printed query was not the same query:
 *  - ORDER BY, FOR and LIMIT of a set operation subquery were printed after its parentheses, as clauses of the
 *    enclosing query ("for" of INTERSECT was also printed without a space).
 *  - LIMIT of a DISTINCT SELECT without ORDER BY was printed as FOR ORDERBY_NUM() without ORDER BY, and when such
 *    a view was rewritten as a derived table, its FOR ORDERBY_NUM() was dropped.
 *
 *  Coverage:
 *    Case 1:  the reported view
 *    Case 2:  views with an offset in LIMIT, EXISTS and NOT EXISTS
 *    Case 3:  views with a correlated subquery, a UNION operand, and ORDER BY 2
 *    Case 4:  queries with an offset in LIMIT (wrong results without the fix)
 *    Case 5:  HAVING with an OR term on GROUPBY_NUM()
 *    Case 6:  INTERSECT and EXCEPT of rows with more than one column
 *    Case 7:  the reported static SQL of a stored procedure
 *    Case 8:  views with a set operation subquery having ORDER BY and LIMIT (EXISTS, IN, =, UNION, EXCEPT, INTERSECT)
 *    Case 9:  views with a DISTINCT SELECT with LIMIT and without ORDER BY
 *    Case 10: views with a nested set operation, a set operation LIMIT without ORDER BY, and DISTINCT set operands
 */
drop view if exists c_v, c_v2, c_v3, c_v4, c_v5, c_v6, c_v7;
drop table if exists t;
create table t (c int);
insert into t values (3), (1), (2);

-- Case 1: the reported view
create view c_v as select c from t where exists (select c from t order by 1 limit 1) order by 1;
select * from c_v;

-- Case 2: offset in LIMIT
create view c_v2 as select c from t where exists (select c from t order by 1 limit 10, 1) order by 1;
select * from c_v2;
create view c_v3 as select c from t where not exists (select c from t order by 1 limit 10, 1) order by 1;
select * from c_v3;
create view c_v4 as select c from t where exists (select c from t order by 1 limit 2, 1) order by 1;
select * from c_v4;

-- Case 3: correlated subquery, UNION operand, ORDER BY 2
create view c_v5 as select c from t o where exists (select c from t i where i.c > o.c order by 1 limit 1) order by 1;
select * from c_v5;
create view c_v6 as select c from t where exists ((select c from t order by 1 limit 1) union (select c from t where c > 9)) order by 1;
select * from c_v6;
create view c_v7 as select c from t o where exists (select c, c * 2 from t i where i.c < o.c order by 2 desc limit 1, 1) order by 1;
select * from c_v7;
drop view c_v, c_v2, c_v3, c_v4, c_v5, c_v6, c_v7;

-- Case 4: offset in LIMIT
select c from t where exists (select c from t order by 1 limit 1) order by 1;
select c from t where exists (select c from t order by 1 limit 10, 1) order by 1;
select c from t where not exists (select c from t order by 1 limit 10, 1) order by 1;
select c from t where exists (select c from t order by 1 limit 2, 1) order by 1;
select c from t where exists (select c from t order by 1 limit 3, 1) order by 1;

-- Case 5: HAVING with an OR term
select c from t where exists (select c from t group by c having groupby_num () <= 0 or groupby_num () >= 3) order by 1;

-- Case 6: INTERSECT and EXCEPT
select c from t where exists ((select 1, 1) intersect (select 1, 2)) order by 1;
select c from t where exists ((select 1, 1) difference (select 1, 2)) order by 1;

-- Case 7: static SQL of a stored procedure
--+ server-message on
create or replace procedure p_exists_limit is
  sr sys_refcursor;
  v_c int;
begin
  open sr for select c from t where exists (select c from t order by 1 limit 1) order by 1;
  loop
    fetch sr into v_c;
    exit when sr%notfound;
    dbms_output.put_line ('c = ' || v_c);
  end loop;
  close sr;
end;
call p_exists_limit ();
--+ server-message off
drop procedure p_exists_limit;

-- Case 8: set operation subquery with ORDER BY and LIMIT
create view s_v1 as select c from t where exists ((select c from t) union (select c + 10 from t) order by 1 limit 5, 1);
select * from s_v1 order by 1;
create view s_v2 as select c from t where c in ((select c from t) union (select c + 10 from t) order by 1 limit 1, 1);
select * from s_v2 order by 1;
create view s_v3 as select c from t where c = ((select c from t) union (select c + 10 from t) order by 1 limit 1, 1);
select * from s_v3 order by 1;
create view s_v4 as select c from t where exists ((select c from t) difference (select 3) order by 1 limit 1, 1);
select * from s_v4 order by 1;
create view s_v5 as select c from t where c in ((select c from t) intersect (select c from t where c < 3) order by 1 limit 1);
select * from s_v5 order by 1;
create view s_v6 as select * from ((select c from t) union (select c + 10 from t) order by 1 limit 1, 1) d;
select * from s_v6 order by 1;
drop view s_v1, s_v2, s_v3, s_v4, s_v5, s_v6;

-- Case 9: DISTINCT SELECT with LIMIT and without ORDER BY
insert into t values (2);
create view d_v1 as select distinct c from t limit 1, 1;
select count (*) from d_v1;
create view d_v2 as select distinct c from t limit 2;
select count (*) from d_v2;
create view d_v3 as select c from t where exists (select distinct c from t limit 1, 1);
select * from d_v3 order by 1;
create view d_v4 as select c from t where exists (select distinct c from t limit 5, 1);
select * from d_v4 order by 1;
create view d_v5 as select count (*) n from (select distinct c from t limit 1, 1) d;
select * from d_v5;
drop view d_v1, d_v2, d_v3, d_v4, d_v5;
delete from t where c = 2 and rownum = 1;

-- Case 10: nested set operation, set operation LIMIT without ORDER BY, DISTINCT set operands
create view n_v1 as select c from t where exists (((select c from t) union (select c + 10 from t)) union (select 100) order by 1 limit 6, 1);
select * from n_v1 order by 1;
create view n_v2 as select c from t where c in ((select c from t) union all (select c from t) limit 1);
select count (*) from n_v2;
create view n_v3 as (select distinct c from t limit 1) union all (select c from t where c = 3);
select count (*) from n_v3;
create view n_v4 as select c from t where c in ((select distinct c from t order by 1 limit 1) union (select distinct c from t where c > 1 limit 1, 1));
select count (*) from n_v4;
create view n_v5 as select (select count (*) from ((select c from t) union (select c + 10 from t) order by 1 limit 2, 2) d) n from db_root;
select * from n_v5;
drop view n_v1, n_v2, n_v3, n_v4, n_v5;

drop table t;
