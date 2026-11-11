/**
 *  This test case verifies CBRD-28028: a simple CASE whose ELSE is a dotted name that does not exist reports the
 *  semantic error instead of killing the client
 *
 *  When a dotted name (x.y) fails to bind, its place in the parse tree is left NULL, and the error is reported with
 *  the statement printed. Printing a simple CASE read the type of its ELSE without checking it, so the client (csql,
 *  or the CAS of a JDBC connection) died with SIGSEGV. The searched CASE and DECODE already checked it.
 *
 *  Coverage:
 *    Case 1: the forms of the issue - a missing table and a missing column in the ELSE, in the select list and in
 *            WHERE
 *    Case 2: the same ELSE after more WHENs, in UPDATE, INSERT, DELETE and MERGE, in a derived table, in a JOIN ON
 *            and under UNION ALL
 *    Case 3: forms that reported the error before - an undotted name, the THEN and WHEN places, a searched CASE and
 *            DECODE
 *    Case 4: a simple CASE that binds still returns its values, with and without ELSE
 */

drop table if exists t_28028;

create table t_28028 (c0 bigint, c1 varchar(7));
insert into t_28028 values (1, 'a'), (2, 'b');

evaluate 'Case 1: the ELSE of a simple CASE is a missing dotted name; result = semantic error';
select case 1 when 1 then 1 else x.y end from db_root;
select case t_28028.c1 when 'a' then 1 else t0.c0 end from t_28028;
select case t_28028.c1 when 'a' then 1 else t_28028.nosuch end from t_28028;
select * from t_28028 where (case t_28028.c1 when 'a' then 1 else t0.c0 end) = 1;

evaluate 'Case 2: the same ELSE in other places; result = semantic error';
select case c1 when 'a' then 1 when 'b' then 2 else t0.c0 end from t_28028;
update t_28028 set c0 = case c1 when 'a' then 1 else t0.c0 end;
insert into t_28028 (c0) values (case 1 when 1 then 1 else t0.c0 end);
delete from t_28028 where case c1 when 'a' then 1 else t0.c0 end = 1;
merge into t_28028 using t_28028 s on (t_28028.c0 = s.c0) when matched then update set t_28028.c1 = case s.c1 when 'a' then 'x' else t0.c1 end;
select * from (select case c1 when 'a' then 1 else t0.c0 end as x from t_28028) d;
select * from t_28028 a join t_28028 b on case a.c1 when 'a' then 1 else t0.c0 end = b.c0;
select case c1 when 'a' then 1 else t0.c0 end from t_28028 union all select 1 from t_28028;

evaluate 'Case 3: forms that reported the error before; result = semantic error';
select case t_28028.c1 when 'a' then 1 else nosuch end from t_28028;
select case t_28028.c1 when 'a' then t0.c0 else 1 end from t_28028;
select case t_28028.c1 when t0.c0 then 1 else 2 end from t_28028;
select case when t_28028.c1 = 'a' then 1 else t0.c0 end from t_28028;
select decode (t_28028.c1, 'a', 1, t0.c0) from t_28028;

evaluate 'Case 4: a simple CASE that binds; result = 1, 2 then 1, NULL and the table unchanged';
select c0, case c1 when 'a' then 1 else c0 end as x from t_28028 order by c0;
select c0, case c1 when 'a' then 1 end as x from t_28028 order by c0;
select * from t_28028 order by c0;

drop table t_28028;
