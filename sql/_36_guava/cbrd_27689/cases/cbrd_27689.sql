-- Verification for CBRD-27689 : Allow parallel index scan when the first ORDER BY column is DESC but the order is not skipped
-- A DESC first ORDER BY / GROUP BY column used to turn the parallel index scan off even when the sort is not done by the index.
-- Parallel scan must now be used in that case, and must still be off when ORDER BY / GROUP BY is skipped by the index.
-- The name prefix groups (Char000 .. Char009) have different sizes, so ORDER BY count DESC and ASC give different orders.

drop table if exists t_27689;
create table t_27689 (id int primary key, name varchar(40) not null, v int not null);
insert into t_27689
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 400
  )
select rownum, 'Char' || lpad (cast (floor (sqrt (rownum - 1) / 40) as int), 3, '0') || '_' || lpad (rownum, 10, '0'), mod (rownum, 1000)
from cte a, cte b
limit 150000;
create index i_27689_name on t_27689 (name);
update statistics on t_27689 with fullscan;

set trace on;

evaluate 'Q1. GROUP BY expression, ORDER BY aggregate DESC -> parallel index scan';
select /*+ recompile */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by c desc, p;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by c desc, p;

evaluate 'Q2. same query, ORDER BY aggregate ASC -> parallel index scan (unchanged)';
select /*+ recompile */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by c asc, p;
show trace;

evaluate 'Q3. ORDER BY group key DESC, not skipped -> parallel index scan';
select /*+ recompile */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by p desc;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by p desc;

evaluate 'Q4. GROUP BY expression DESC, not skipped -> parallel index scan';
select /*+ recompile */ mod (v, 3) m, count (*) c from t_27689 use index (i_27689_name) where name >= 'Char' group by mod (v, 3) desc;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ mod (v, 3) m, count (*) c from t_27689 use index (i_27689_name) where name >= 'Char' group by mod (v, 3) desc;

evaluate 'Q5. ORDER BY skipped by a descending index scan -> serial even with a PARALLEL hint, rows in descending order';
select /*+ recompile PARALLEL(4) */ name from t_27689 where name > 'Char009_0000149990' order by name desc;
show trace;

evaluate 'Q6. GROUP BY skipped by a descending index scan -> serial even with a PARALLEL hint, groups in descending order';
select /*+ recompile PARALLEL(4) */ name, count (*) from t_27689 where name > 'Char009_0000149995' group by name desc;
show trace;

set trace off;
drop table t_27689;
