-- ============================================
-- SUBQUERY & CTE TESTS - INVISIBLE COLUMN
-- Subquery (WHERE/FROM/SELECT) / CTE / Nested / Correlated
-- ============================================

-- Setup
drop table if exists t1;
drop table if exists t2;

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

create table t2 (
    id int,
    c5 int invisible,
    c6 int,
    c7 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');

insert into t2(id, c5, c6, c7) values (1, 10, 150, 'x');
insert into t2(id, c5, c6, c7) values (2, 20, 250, 'y');
insert into t2(id, c5, c6, c7) values (4, 35, 350, 'z');


-- ============================================
-- [1] SUBQUERY IN WHERE
-- ============================================

select * from t1 where c1 in (select c5 from t2) order by 1;
select * from t1 where c1 > (select avg(c5) from t2) order by 1;
select c2, c4 from t1 where c3 in (select c5 * 100 from t2) order by 1;

-- IN / EXISTS with invisible columns
evaluate 'IN / EXISTS with invisible columns';
select * from t1 where c1 in (10, 20, 30) order by id;
select c2, c4 from t1 where c3 not in (1000, 3000) order by c2;

select * from t1 where exists (
    select 1 from t2 where t2.c5 = t1.c1
) order by id;

-- invisible columns in both tables
evaluate 'invisible columns in both tables';
select * from t1 where c1 in (select c5 from t2 where c5 > 10) order by id;


-- ============================================
-- [2] SUBQUERY IN FROM (DERIVED TABLE)
-- ============================================

select * from (select * from t1) as sub order by id;
select * from (select c1, c2, c3 from t1) as sub order by c1;
select sub.c1, sub.c2 from (select c1, c2, c4 from t1) as sub order by sub.c1;
evaluate 'err';
/* err */ select sub.c1, sub.c2 from (select * from t1) as sub order by sub.c1;
evaluate 'err';
/* err */ select * from (select * from t1) as sub where sub.c1 = 10;

-- CBRD-26506: (select * from t1) is a dummy select and is collapsed into t1 by the parser,
-- but the invisible columns of t1 must stay hidden outside of the subquery
evaluate 'CBRD-26506: dummy select - unqualified name, order by, aggregate';
evaluate 'err';
/* err */ select c1 from (select * from t1) as sub;
evaluate 'err';
/* err */ select * from (select * from t1) as sub order by sub.c3;
evaluate 'err';
/* err */ select count(c1) from (select * from t1) as sub;
select sub.* from (select * from t1) as sub order by sub.id;

evaluate 'CBRD-26506: nested dummy select';
select * from (select * from (select * from t1) as s1) as s2 order by id;
evaluate 'err';
/* err */ select s2.c1 from (select * from (select * from t1) as s1) as s2;
-- innermost subquery names the invisible columns, so they are visible outside
select s2.id, s2.c1, s2.c3 from (select * from (select id, c1, c3 from t1) as s1) as s2 order by s2.id;

evaluate 'CBRD-26506: dummy select in join';
select s.id, s.c2, t2.c6 from (select * from t1) as s join t2 on s.id = t2.id order by s.id;
evaluate 'err';
/* err */ select s.id, t2.c6 from (select * from t1) as s join t2 on s.c1 = t2.c5;
evaluate 'err';
/* err */ select t1.id from t1 join (select * from t2) as u on t1.c1 = u.c5;
select t1.id, t1.c1, u.c6 from t1 join (select * from t2) as u on t1.id = u.id order by t1.id;

evaluate 'CBRD-26506: cte with select *';
evaluate 'err';
/* err */ with cte1 as (select * from t1) select c1 from cte1;
evaluate 'err';
/* err */ with cte1 as (select * from t1) select * from cte1 where cte1.c3 > 1000;
evaluate 'err';
/* err */ select * from (with cte1 as (select * from t1) select * from cte1) as sub where sub.c1 = 10;

evaluate 'CBRD-26506: not dummy select (where, distinct, attr list)';
select * from (select * from t1 where id > 1) as sub order by id;
evaluate 'err';
/* err */ select sub.c1 from (select * from t1 where id > 1) as sub;
select * from (select distinct * from t1) as sub order by id;
evaluate 'err';
/* err */ select sub.c1 from (select distinct * from t1) as sub;
select * from (select * from t1) as sub(a, b, c) order by a;
evaluate 'err';
/* err */ select * from (select * from t1) as sub(a, b, c, d, e);

evaluate 'CBRD-26506: query plan of dummy and not dummy select';
set trace on;
select /*+ recompile */ * from (select * from t1) as sub order by id;
show trace;
select /*+ recompile */ * from (select distinct * from t1) as sub order by id;
show trace;
set trace off;


-- ============================================
-- [3] SCALAR SUBQUERY IN SELECT
-- ============================================

select id, c2, (select max(c5) from t2) as max_c5 from t1 order by id;
select id, c2, c4, (select c5 from t2 where t2.id = t1.id) as matched_c5 from t1 order by id;


-- ============================================
-- [4] CORRELATED SUBQUERY
-- ============================================

select * from t1 where c1 > (select avg(c5) from t2 where t2.id <= t1.id) order by 1;
select id, c2 from t1 where exists (select 1 from t2 where t2.c5 = t1.c1) order by 1;


-- ============================================
-- [5] NESTED SUBQUERY (TRIPLE LEVEL)
-- ============================================

select * from t1
where c1 in (
    select c1 from t1
    where c3 in (
        select c3 from t1 where c1 > 10
    )
)
order by id;

-- scalar subquery with invisible column in outer query
evaluate 'scalar subquery with invisible column in outer query';
select id, c2, c4,
    (select max(c1) from t1 t2 where t2.c3 < t1.c3) as max_c1
from t1 order by id;

-- nested subquery in WHERE
evaluate 'nested subquery in WHERE';
select id, c2, c4
from t1
where c1 > (
    select avg(c1)
    from t1
    where c3 in (
        select c5 * 100 from t2
    )
)
order by id;


-- ============================================
-- [6] CTE (WITH CLAUSE)
-- ============================================

-- basic CTE
evaluate 'basic CTE';
with cte1 as (
    select * from t1
)
select * from cte1 order by id;

with cte1 as (
    select c1, c2, c3 from t1
)
select * from cte1 order by c1;

with cte1 as (
    select c1, c2 from t1 where c1 > 10
)
select c1, c2 from cte1 order by c1;

-- multiple CTEs
evaluate 'multiple CTEs';
with
    cte1 as (select c1, c2 from t1),
    cte2 as (select c5, c6 from t2)
select cte1.c1, cte2.c5 from cte1, cte2 where cte1.c1 < cte2.c5 order by cte1.c1;

-- CTE joining with original table
evaluate 'CTE joining with original table';
with cte1 as (
    select c1, c2 from t1 where c1 > 10
)
select t1.*, cte1.c2 as cte_c2 from t1 join cte1 on t1.c1 = cte1.c1 order by t1.id;


-- ============================================
-- [7] RECURSIVE CTE
-- ============================================

with recursive cte(n, c1_val) as (
    select 1, c1 from t1 where id = 1
    union all
    select n + 1, c1_val + 10 from cte where n < 3
)
select * from cte order by 1;


-- ============================================
-- [8] CTE WITH COMPLEX MIXED SCENARIO
-- ============================================

with ranked_t1 as (
    select id, c1, c2, c3, c4,
           row_number() over (order by c1 desc) as rn
    from t1
    where c3 > 500
)
select r.id, r.c2, r.c4, r.rn, t2.c6
from ranked_t1 r
left join t2 on r.id = t2.id
where r.rn <= 2
order by r.rn;


-- ============================================
-- Cleanup
-- ============================================

drop table if exists t1;
drop table if exists t2;
