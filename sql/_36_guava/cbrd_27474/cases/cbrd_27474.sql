-- Verification for CBRD-27474 : Use the real buffer size for repeated-probe caching and prefer plans the executor can parallelize
-- A nested loop driven by a one-page table runs serially, while a hash join over a large table scan runs in parallel.
-- When the two plans cost about the same serially, the plan the executor can parallelize must be chosen;
-- with parallel execution turned off by hints, the serial cost decides again (nested loop).

drop table if exists t_27474_d;
drop table if exists t_27474_m;
drop table if exists t_27474_b;
create table t_27474_d (id int primary key, name varchar(20));
create table t_27474_m (id int primary key, d_id int, pad char(40));
create table t_27474_b (id int primary key, m_id int, v int, pad varchar(600));

insert into t_27474_d
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 25)
select n, 'N' || n from cte;

insert into t_27474_m
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
select rownum, mod (rownum, 25) + 1, 'm' from cte a, cte b;

insert into t_27474_b
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum * 7919, 10000) + 1, mod (rownum, 100),
       md5 (rownum) || md5 (rownum + 1) || md5 (rownum + 2) || md5 (rownum + 3) || md5 (rownum + 4)
       || md5 (rownum + 5) || md5 (rownum + 6) || md5 (rownum + 7) || md5 (rownum + 8) || md5 (rownum + 9)
       || md5 (rownum + 10) || md5 (rownum + 11) || md5 (rownum + 12) || md5 (rownum + 13) || md5 (rownum + 14)
from cte a, cte b
limit 30000;

create index i_27474_m_d on t_27474_m (d_id);
create index i_27474_b_m on t_27474_b (m_id);
update statistics on t_27474_d, t_27474_m, t_27474_b with fullscan;

set trace on;

evaluate 'Q1. 12 driving rows: hash join over a parallel scan of t_27474_b';
select /*+ recompile */ count (*), sum (b.v)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id;
show trace;

evaluate 'Q2. same query, parallel execution off: serial nested loop, same result';
select /*+ recompile NO_PARALLEL_SCAN NO_PARALLEL_HASH_JOIN */ count (*), sum (b.v)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id;
show trace;

evaluate 'Q3. one driving row: nested loop is cheaper even against the parallel discount';
select /*+ recompile */ count (*), sum (b.v)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name = 'N1' and m.d_id = d.id and b.m_id = m.id;
show trace;

set trace off;
drop table t_27474_d;
drop table t_27474_m;
drop table t_27474_b;
