-- Verification for CBRD-26825
-- Check a semantic error occurs during query execution when a single view is created by combining a simple SELECT query and a CONNECT BY query using UNION.

drop table if exists tbl_a;
drop view if exists v_tbl_a;

create table tbl_a (cd varchar(20), p_cd varchar(20));

insert into tbl_a values ('10000001', '10000000'),('10000002', '10000001');

evaluate 'case #1 : connect by - table error 1 : order siblings by expr integer value when the SELECT column is an expression rather than a column name.';
select cd || 'yy' as cd, p_cd
from   tbl_a a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by 1;

evaluate 'case #2 : connect by - table error 2 : When expr is an expression in order siblings by expr(use substring function).';
select cd || 'yy' as cd, p_cd
from   tbl_a a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 3, 2);

evaluate 'case #3 : connect by - table error 3 : When expr is an expression in order siblings by expr(use substr function)';
select cd || 'yy' as cd, p_cd
from   tbl_a a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by substr(cd, 3, 2);

evaluate 'case #4 : union - alter vclass v_tbl_a add query';
create view v_tbl_a( cd varchar(20), p_cd varchar(20)) as select cd, p_cd from tbl_a;
alter vclass [v_tbl_a] add query
select cd, p_cd
from   ( select '10000000' AS cd, NULL AS p_cd
         union
         select cd, p_cd from [tbl_a]
       ) a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by 1;

-- Cases #5-7: every sibling of v_tbl_a ties on the ORDER SIBLINGS BY key
-- ('10000001yy' and '10000002yy' are each duplicated by the UNION ALL
-- inside the view, and substring(cd,3,2)/substr(cd,3,2) return the same
-- value for every row too), so these three cases do not by themselves
-- prove the sort key is honored for real siblings -- see cases #12-22 for
-- that. The row order asserted below is CUBRID's actual tie-break output
-- for this exact query/data, verified stable across 6 repeated runs in
-- one session and across 5 independent fresh sessions.
evaluate 'case #5 : connect by - view : order siblings by expr integer value when the SELECT column is an expression rather than a column name.';
select cd || 'yy' as cd, p_cd
from   [v_tbl_a] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by 1;

evaluate 'case #6 : connect by - view : When expr is an expression in order siblings by expr(use substring function).';
select cd || 'yy' as cd, p_cd
from   [v_tbl_a] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 3, 2);

evaluate 'case #7 : connect by - view : When expr is an expression in order siblings by expr(use substr function)';
select cd || 'yy' as cd, p_cd
from   [v_tbl_a] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by substr(cd, 3, 2);

drop view if exists v_tbl_a;

-- Case #8 intentionally omits the column-type list that case #4's
-- "create view v_tbl_a(cd varchar(20), p_cd varchar(20))" declares
-- explicitly, so this covers the type-inferred-from-SELECT path (relies
-- on CBRD-26845) alongside case #4's explicit-type path for the same
-- UNION + CONNECT BY view query.
evaluate 'case #8 : union - create view [v_tbl_a] as select';
create view [v_tbl_a] as
select cd, p_cd
from   ( select '10000000' AS cd, NULL AS p_cd
         union
         select cd, p_cd from [tbl_a]
       ) a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by 1;

evaluate 'case #9 : connect by - view : order siblings by expr integer value when the SELECT column is an expression rather than a column name.';
select cd || 'yy' as cd, p_cd
from   [v_tbl_a] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by 1;

evaluate 'case #10 : connect by - view : When expr is an expression in order siblings by expr(use substring function).';
select cd || 'yy' as cd, p_cd
from   [v_tbl_a] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 3, 2);

evaluate 'case #11 : connect by - view : When expr is an expression in order siblings by expr(use substr function)';
select cd || 'yy' as cd, p_cd
from   [v_tbl_a] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by substr(cd, 3, 2);

drop table if exists tbl_a;
drop view if exists v_tbl_a;

create table tbl_b (cd varchar(20), p_cd varchar(20));

insert into tbl_b values ('10000001', '10000000'),
('10300001', '10000001'),
('10100001', '10000001'),
('10200001', '10000001');

evaluate 'case #12 : connect by - table : order siblings by expression actually sorts siblings(use substring function)';
select cd || 'yy' as cd, p_cd
from tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 3, 2);

evaluate 'case #13 : connect by - table : order siblings by expr integer value with desc';
select cd || 'yy' as cd, p_cd
from tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by 1 desc;

evaluate 'case #14 : connect by - table : order siblings by explicit cast expression';
select cd || 'yy' as cd, p_cd
from tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by cast(cd as varchar(20));

evaluate 'case #15 : union - create view [v_tbl_b] as select with real siblings for sorts';
create view [v_tbl_b] as
select cd, p_cd
from ( select '10000000' as cd, null as p_cd
union
select cd, p_cd from [tbl_b]
) a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by 1;

evaluate 'case #16 : connect by - view : order siblings by expression sorts real siblings on view expansion';
select cd || 'yy' as cd, p_cd
from [v_tbl_b] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 3, 2);

evaluate 'case #17 : connect by - table : ORDER SIBLINGS BY ordinal pointing to a PLAIN column (base-column reuse path)';
select cd, p_cd
from   tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by 1;

evaluate 'case #18 : connect by - table : ORDER SIBLINGS BY a bare base column name while projecting an expression (reuse path)';
select cd || 'yy' as cd, p_cd
from   tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by cd;

evaluate 'case #19 : connect by - table : multiple ORDER SIBLINGS BY keys (tie on 1st expr, broken by 2nd)';
select cd || 'yy' as cd, p_cd
from   tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 1, 2), substr(cd, 3, 2);

evaluate 'case #20 : connect by - table : mixed ordinal + expression ORDER SIBLINGS BY keys';
select cd || 'yy' as cd, p_cd
from   tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by 2, substring(cd, 3, 2);

evaluate 'case #21 : connect by - table : ORDER SIBLINGS BY expression with DESC';
select cd || 'yy' as cd, p_cd
from   tbl_b a
start with a.p_cd = '10000000'
connect by prior a.cd = a.p_cd
order siblings by substring(cd, 3, 2) desc;

evaluate 'case #22 : connect by - view : ORDER SIBLINGS BY a bare base column on view expansion (reuse path)';
select cd || 'yy' as cd, p_cd
from   [v_tbl_b] a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by cd;

drop table if exists tbl_b;
drop view if exists v_tbl_b;
