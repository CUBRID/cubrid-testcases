/**
 *  CBRD-27704: with LIMIT or ROWNUM, an expression wrapping an analytic function must keep its
 *  value, and the select list items after it must keep their own values.
 *
 *  A SELECT with analytic functions writes an intermediate list during the scan and builds the
 *  final select list from it afterwards. Under the LIMIT optimization (ROW_NUMBER, RANK,
 *  DENSE_RANK, FIRST_VALUE whose OVER order is empty or covered by the index) that second step
 *  was skipped, so the intermediate list was returned as is: ROW_NUMBER () OVER () + 100 printed
 *  1, 2, 3, and the following columns printed the wrong intermediate values.
 *
 *  The queries that take the optimization have no ORDER BY (it would turn LIMIT into
 *  orderby_num ()), so their rows come in heap order or in the order of the forced index.
 *
 *  Coverage:
 *  1    the reported queries, and the shapes that were already right (no LIMIT, bare items)
 *  2    ROWNUM in the WHERE clause instead of LIMIT
 *  3    other wrapping expressions: IF, DECODE, arithmetic with a column
 *  4    the OVER order covered by a forced index scan (sort skipped)
 *  5    RANK, DENSE_RANK, FIRST_VALUE, the other functions the optimization takes
 *  6    LIMIT with an offset: the skipped rows still count, and no returned row is lost
 *  7    ROWNUM in the select list, at any depth of an expression: the optimization is not used
 *  8    the same query inside a derived table and a named view
 *  9    an OVER order the index does not cover: the optimization is not used
 */

drop table if exists p, q;

create table p (g int, x int);
insert into p values (1, 1), (1, 2), (1, 3);

create table q (g int, x int);
insert into q values (1, 10), (1, 20), (2, 30), (2, 40), (2, 50);
create index i_q_gx on q (g, x);


evaluate 'Case 1: the reported queries -- with LIMIT, then without LIMIT, then bare items with LIMIT';
select /*+ recompile */ case when x > 1 then row_number() over () end as r, g from p limit 3;
select /*+ recompile */ case when x > 1 then row_number() over () end as r, g from p;
select /*+ recompile */ case when x > 99 then row_number() over () end as r, g from p limit 3;
select /*+ recompile */ row_number() over () + 100 as r from p limit 3;
select /*+ recompile */ row_number() over () + 100 as r from p;
select /*+ recompile */ row_number() over () as r, g from p limit 3;


evaluate 'Case 2: ROWNUM in the WHERE clause instead of LIMIT, with columns after the analytic function';
select /*+ recompile */ row_number() over () + 100 as r, g, x from q where rownum <= 3;


evaluate 'Case 3: other expressions wrapping the analytic function';
select /*+ recompile */ if(x > 15, row_number() over (), -1) as r, g, x from q limit 3;
select /*+ recompile */ decode(g, 1, row_number() over (), 0) as r, x from q limit 3;
select /*+ recompile */ x * 10 + row_number() over () as r, g from q limit 3;


evaluate 'Case 4: the OVER order is covered by the forced index scan, so the sort is skipped as well';
select /*+ recompile */ row_number() over (partition by g order by x) + 100 as r, g, x from q where g > 0 using index i_q_gx(+) limit 4;
select /*+ recompile */ case when g = 2 then row_number() over (partition by g order by x) end as r, g, x from q where g > 0 using index i_q_gx(+) limit 4;


evaluate 'Case 5: RANK, DENSE_RANK and FIRST_VALUE, the other functions the optimization takes';
select /*+ recompile */ rank() over (order by g) + 100 as rk, dense_rank() over (order by g) + 200 as dr, first_value(x) over (order by g) + 1000 as fv, x from q where g > 0 using index i_q_gx(+) limit 4;


evaluate 'Case 6: LIMIT with an offset -- the skipped row still counts for the analytic function, and no returned row is lost';
select /*+ recompile */ row_number() over () + 100 as r, x from q limit 1, 3;


evaluate 'Case 7: ROWNUM in the select list, alone and inside an expression -- the optimization is not used';
select /*+ recompile */ rownum as rn, row_number() over () + 100 as r, x from q where rownum <= 3;
select /*+ recompile */ rownum * 1000 + row_number() over () as v, x from q where rownum <= 3;


evaluate 'Case 8: the same query inside a derived table and a named view';
select /*+ recompile */ r, g from (select row_number() over () + 100 as r, g, x from q limit 3) s order by r;
create or replace view v_q as select row_number() over () + 100 as r, g, x from q limit 3;
select /*+ recompile */ r, x from v_q order by r;


evaluate 'Case 9: an OVER order the index does not cover -- the optimization is not used';
select /*+ recompile */ row_number() over (order by x desc) + 100 as r, x from q limit 3;


drop view v_q;
drop table p, q;
