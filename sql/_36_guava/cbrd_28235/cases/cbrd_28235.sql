-- Verification for CBRD-28235 : The restriction extracted from a multi-table OR copies a UUID () conjunct into the scan
-- filter, so a row has to pass two different UUID () draws and rows are lost.
-- The OR term stays in the join, so every extracted conjunct is evaluated twice. A conjunct whose second evaluation
-- draws a new value must stay out of the extracted restriction, as RAND () and SYS_GUID () already do.
-- Each joined row passes with probability 1/16: about 1000 of 16000 rows. With the copy, a row has to pass two
-- independent draws and about 62 rows are returned. The queries show only whether the count is above 500, so the
-- answer does not depend on the draws.
-- Q1 heap scan filter, Q2 UUID with the version argument, Q3 index key range on the column, Q4 SYS_GUID control.

drop table if exists t_28235_a;
drop table if exists t_28235_b;
drop table if exists t_28235_c;
create table t_28235_a (id int primary key, k int);
create table t_28235_b (id int primary key, k int);
create table t_28235_c (id int primary key, k int);
create index i_t_28235_c_k on t_28235_c (k);

insert into t_28235_a
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum, 16) from cte a, cte b limit 16000;

insert into t_28235_b
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum, 2) from cte a, cte b limit 16000;

insert into t_28235_c select id, k from t_28235_a;

update statistics on t_28235_a, t_28235_b, t_28235_c with fullscan;

evaluate 'Q1. uuid () in a multi-table OR, heap scan filter';
select case when count (*) > 500 then 'ok' else 'rows lost' end as r
from t_28235_a a, t_28235_b b
where a.id = b.id
  and ((a.k = conv (substr (uuid (), 1, 1), 16, 10) and b.k = 0)
    or (a.k = conv (substr (uuid (), 2, 1), 16, 10) and b.k = 1));

evaluate 'Q2. uuid (4) in a multi-table OR';
select case when count (*) > 500 then 'ok' else 'rows lost' end as r
from t_28235_a a, t_28235_b b
where a.id = b.id
  and ((a.k = conv (substr (uuid (4), 1, 1), 16, 10) and b.k = 0)
    or (a.k = conv (substr (uuid (4), 2, 1), 16, 10) and b.k = 1));

evaluate 'Q3. uuid () in a multi-table OR over an indexed column';
select case when count (*) > 500 then 'ok' else 'rows lost' end as r
from t_28235_c c, t_28235_b b
where c.id = b.id
  and ((c.k = conv (substr (uuid (), 1, 1), 16, 10) and b.k = 0)
    or (c.k = conv (substr (uuid (), 2, 1), 16, 10) and b.k = 1));

evaluate 'Q4. sys_guid () in the same query';
select case when count (*) > 500 then 'ok' else 'rows lost' end as r
from t_28235_a a, t_28235_b b
where a.id = b.id
  and ((a.k = conv (substr (sys_guid (), 1, 1), 16, 10) and b.k = 0)
    or (a.k = conv (substr (sys_guid (), 2, 1), 16, 10) and b.k = 1));

drop table t_28235_a;
drop table t_28235_b;
drop table t_28235_c;
