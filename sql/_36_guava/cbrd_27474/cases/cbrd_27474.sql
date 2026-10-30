-- Verification for CBRD-27474 : Use the real buffer size for repeated-probe caching and prefer plans the executor can parallelize
-- A nested loop driven by a one-page table runs serially, while a hash join over a large table scan runs in parallel.
-- When the two plans cost about the same serially, the plan the executor can parallelize must be chosen;
-- with parallel execution turned off by hints, the serial cost decides again (nested loop).
-- A LIMIT that stops the joins turns the discount off; a LIMIT above an aggregate does not.
-- A hash join and a nested loop over its result are discounted only when the lists reach the parallel threshold.

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
select /*+ recompile */ count (*), sum (b.v), max (b.pad)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id;
show trace;

evaluate 'Q2. same query, parallel execution off: serial nested loop, same result';
select /*+ recompile NO_PARALLEL_SCAN NO_PARALLEL_HASH_JOIN */ count (*), sum (b.v), max (b.pad)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id;
show trace;

evaluate 'Q3. one driving row: nested loop is cheaper even against the parallel discount';
select /*+ recompile */ count (*), sum (b.v), max (b.pad)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name = 'N1' and m.d_id = d.id and b.m_id = m.id;
show trace;

set trace off;

-- the rows of Q4 and Q5 come in no fixed order: plans only
set optimization level 514;

evaluate 'Q4. no LIMIT: discounted, parallel nested loop driven by t_27474_b';
--@queryplan
select /*+ recompile */ b.id, m.id
from t_27474_b b, t_27474_m m
where b.m_id = m.id and b.v = 7;

evaluate 'Q5. LIMIT stops the joins: no discount, nested loop driven by t_27474_m';
--@queryplan
select /*+ recompile */ b.id, m.id
from t_27474_b b, t_27474_m m
where b.m_id = m.id and b.v = 7
limit 10;

set optimization level 1;

evaluate 'Q6. LIMIT above an aggregate does not stop the joins: discount kept';
--@queryplan
select /*+ recompile */ count (*), sum (b.v), max (b.pad)
from t_27474_d d, t_27474_m m, t_27474_b b
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id
limit 1;

evaluate 'Q7. hash join result of 256 pages or more: parallel hash join driving a parallel nested loop';
--@queryplan
select /*+ recompile ordered use_hash(b) use_nl(d) */ count (*), sum (b.v), max (b.pad)
from t_27474_m m, t_27474_b b, t_27474_d d
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id;

evaluate 'Q8. same join without b.pad, lists under 256 pages: neither the hash join nor the nested loop is discounted';
--@queryplan
select /*+ recompile ordered use_hash(b) use_nl(d) */ count (*), sum (b.v)
from t_27474_m m, t_27474_b b, t_27474_d d
where d.name in ('N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7', 'N8', 'N9', 'N10', 'N11', 'N12') and m.d_id = d.id and b.m_id = m.id;

drop table t_27474_d;
drop table t_27474_m;
drop table t_27474_b;
