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

select * from t1 where c1 in (select c5 from t2);
select * from t1 where c1 > (select avg(c5) from t2);
select c2, c4 from t1 where c3 in (select c5 * 100 from t2);

-- IN / EXISTS with invisible columns
select * from t1 where c1 in (10, 20, 30) order by id;
select c2, c4 from t1 where c3 not in (1000, 3000) order by c2;

select * from t1 where exists (
    select 1 from t2 where t2.c5 = t1.c1
) order by id;

-- invisible columns in both tables
select * from t1 where c1 in (select c5 from t2 where c5 > 10) order by id;


-- ============================================
-- [2] SUBQUERY IN FROM (DERIVED TABLE)
-- ============================================

select * from (select * from t1) as sub order by id;
select * from (select c1, c2, c3 from t1) as sub order by c1;
select sub.c1, sub.c2 from (select c1, c2, c4 from t1) as sub order by sub.c1;
/* err */ select sub.c1, sub.c2 from (select * from t1) as sub order by sub.c1;
/* err */ select * from (select * from t1) as sub where sub.c1 = 10;


-- ============================================
-- [3] SCALAR SUBQUERY IN SELECT
-- ============================================

select id, c2, (select max(c5) from t2) as max_c5 from t1 order by id;
select id, c2, c4, (select c5 from t2 where t2.id = t1.id) as matched_c5 from t1 order by id;


-- ============================================
-- [4] CORRELATED SUBQUERY
-- ============================================

select * from t1 where c1 > (select avg(c5) from t2 where t2.id <= t1.id);
select id, c2 from t1 where exists (select 1 from t2 where t2.c5 = t1.c1);


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
select id, c2, c4,
    (select max(c1) from t1 t2 where t2.c3 < t1.c3) as max_c1
from t1 order by id;

-- nested subquery in WHERE
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
with
    cte1 as (select c1, c2 from t1),
    cte2 as (select c5, c6 from t2)
select cte1.c1, cte2.c5 from cte1, cte2 where cte1.c1 < cte2.c5 order by cte1.c1;

-- CTE joining with original table
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
select * from cte;


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
