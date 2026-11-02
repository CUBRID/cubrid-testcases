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
 *  Coverage:
 *    Case 1:  the reported view
 *    Case 2:  views with an offset in LIMIT, EXISTS and NOT EXISTS
 *    Case 3:  views with a correlated subquery, a UNION operand, and ORDER BY 2
 *    Case 4:  queries with an offset in LIMIT (wrong results without the fix)
 *    Case 5:  HAVING with an OR term on GROUPBY_NUM()
 *    Case 6:  INTERSECT and EXCEPT of rows with more than one column
 *    Case 7:  the reported static SQL of a stored procedure
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

drop table t;
