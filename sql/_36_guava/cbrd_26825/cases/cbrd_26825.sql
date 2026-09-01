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

create view v_tbl_a( cd varchar(20), p_cd varchar(20)) as select cd, p_cd from tbl_a;

evaluate 'case #4 : union - alter vclass v_tbl_a add query';
alter vclass [v_tbl_a] add query
select cd, p_cd
from   ( select '10000000' AS cd, NULL AS p_cd
         union
         select cd, p_cd from [tbl_a]
       ) a
start with a.p_cd is null
connect by prior a.cd = a.p_cd
order siblings by 1;

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

drop table if exists tbl_b;
drop view if exists v_tbl_b;
