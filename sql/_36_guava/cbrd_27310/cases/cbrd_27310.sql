/*
 * This test case verifies CBRD-27310 : a constant-true HAVING without GROUP BY
 * must not share an XASL (plan) cache entry with the same query written without
 * the HAVING clause.
 *
 * Bug: a HAVING clause without GROUP BY turns the query into a single-group
 * aggregate (one result row), but type checking folded a constant-true HAVING
 * (e.g. HAVING 1 = 1) away entirely. The rewritten query text, which is the
 * plan cache key, then became identical to the plain query, so whichever of
 * the two was compiled first served both:
 *   - plain query cached first -> the HAVING query returned every row
 *   - HAVING query cached first -> the plain query returned a single row
 *
 * Fix: pt_eval_type() keeps a TRUE marker for the HAVING clause when there is
 * no GROUP BY (pt_where_type_keep_true), so the rewritten text keeps a HAVING
 * and each query gets its own cache entry. With GROUP BY the text already
 * differs, so a constant-true HAVING is still removed there.
 *
 * Coverage (each table holds 5 qualifying rows)
 *   Case 1: plain query compiled first, then HAVING 1 = 1 -> 5 rows, then 1 row
 *   Case 2: HAVING 1 = 1 compiled first, then plain query -> 1 row, then 5 rows
 *   Case 3: both texts executed again (cache hits) keep their own results
 *   Case 4: other constant HAVING forms without GROUP BY (false, AND, OR)
 *   Case 5: aggregate select list, GROUP BY, derived table and view
 *
 * The select list is a constant because it is the only form that is legal both
 * as a plain query and as a single-group aggregate, which is what lets the two
 * query texts collide. Separate tables are used per direction so that both
 * cache orders are exercised within one run.
 */
drop table if exists plain_first;
drop table if exists having_first;
drop view if exists v_having;

create table plain_first (a int);
create table having_first (a int);
insert into plain_first values (1), (2), (3), (4), (5);
insert into having_first values (1), (2), (3), (4), (5);

-- Case 1
select 1 from plain_first where a > 0;
select 1 from plain_first where a > 0 having 1 = 1;

-- Case 2
select 1 from having_first where a > 0 having 1 = 1;
select 1 from having_first where a > 0;

-- Case 3
select 1 from plain_first where a > 0 having 1 = 1;
select 1 from plain_first where a > 0;
select 1 from having_first where a > 0;
select 1 from having_first where a > 0 having 1 = 1;

-- Case 4
select 1 from plain_first where a > 0 having 1 = 0;
select 1 from plain_first where a > 0 having 1 = 1 and 2 = 2;
select 1 from plain_first where a > 0 having 1 = 1 or 2 = 2;

-- Case 5
select count(*) from plain_first where a > 0;
select count(*) from plain_first where a > 0 having 1 = 1;
select count(*) from plain_first where a > 0 having 1 = 1 and count(*) > 10;
select a from plain_first where a > 0 group by a having 1 = 1 order by a;
select a from plain_first where a > 0 group by a having 1 = 0 order by a;
select count(*) from (select 1 from having_first where a > 0) t;
select count(*) from (select 1 from having_first where a > 0 having 1 = 1) t;
create view v_having as select 1 c from having_first where a > 0 having 1 = 1;
select * from v_having;

drop view v_having;
drop table plain_first;
drop table having_first;
