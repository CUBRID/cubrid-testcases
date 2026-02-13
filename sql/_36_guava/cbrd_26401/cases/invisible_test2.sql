-- ============================================
-- ADDITIONAL TEST CASES FOR INVISIBLE COLUMN
-- ============================================

set trace on;

-- Cleanup
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t_parent;
drop table if exists t_child;
drop view if exists v1;
drop view if exists v2;

-- ============================================
-- 1. INDEX TESTS
-- ============================================

-- Index with invisible columns
create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(100)
);

create index idx_c1 on t1(c1);
create index idx_c1_c2 on t1(c1, c2);
create index idx_c2_c1 on t1(c2, c1);
create index idx_c3_c4 on t1(c3, c4);

-- Insert data for index tests
insert into t1(id, c1, c2, c3, c4) values (1, 10, 20, 30, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 11, 21, 31, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 12, 22, 32, 'c');

update statistics on t1;


-- Index scan with invisible columns
select /*+recompile*/ c1, c2 from t1 where c1 = 10;
show trace;

select /*+recompile*/ c2 from t1 where c1 > 10 order by c1;
show trace;

select /*+recompile*/ * from t1 where c1 = 10;
show trace;

-- Covering index test
select /*+recompile*/ c1, c2 from t1 where c1 between 10 and 12 order by c1;
show trace;

-- Index with invisible column in WHERE but not in SELECT
select /*+recompile*/ c2, c4 from t1 where c1 = 11;
show trace;

drop table t1;

-- ============================================
-- 2. FOREIGN KEY TESTS
-- ============================================

-- FK with invisible columns
create table t_parent (
    id int invisible primary key,
    c1 int invisible,
    c2 int
);

-- FK referencing visible column
create table t_child (
    id int primary key,
    parent_id int,
    c3 int invisible,
    foreign key (parent_id) references t_parent(id)
);

insert into t_parent(id, c1, c2) values (1, 10, 100);
insert into t_parent(id, c1, c2) values (2, 20, 200);

insert into t_child(id, parent_id, c3) values (1, 1, 1000);
insert into t_child(id, parent_id, c3) values (2, 2, 2000);

/* err - FK violation */
insert into t_child(id, parent_id, c3) values (3, 999, 3000);

select * from t_child order by id;
select id, c3 from t_child order by id;

-- Try to make referenced column change visibility
alter table t_parent modify column id int visible;
alter table t_parent modify column id int invisible;

drop table t_child;
drop table t_parent;

-- ============================================
-- 3. SUBQUERY TESTS
-- ============================================

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

insert into t2(id, c5, c6, c7) values (1, 15, 150, 'x');
insert into t2(id, c5, c6, c7) values (2, 25, 250, 'y');
insert into t2(id, c5, c6, c7) values (4, 35, 350, 'z');

-- Subquery in WHERE with invisible column
select * from t1 where c1 in (select c5 from t2);
select * from t1 where c1 > (select avg(c5) from t2);
select c2, c4 from t1 where c3 in (select c5 * 100 from t2);

-- Subquery in FROM clause
select * from (select * from t1) as sub order by id;
select * from (select c1, c2, c3 from t1) as sub order by c1;
select sub.c1, sub.c2 from (select c1, c2, c4 from t1) as sub order by sub.c1;

-- Scalar subquery with invisible column
select id, c2, (select max(c5) from t2) as max_c5 from t1 order by id;
select id, c2, c4, (select c5 from t2 where t2.id = t1.id) as matched_c5 from t1 order by id;

-- Correlated subquery
select * from t1 where c1 > (select avg(c5) from t2 where t2.id <= t1.id);
select id, c2 from t1 where exists (select 1 from t2 where t2.c5 = t1.c1);

-- Subquery with invisible columns in both tables
select * from t1 where c1 in (select c5 from t2 where c5 > 10) order by id;

-- ============================================
-- 4. JOIN TESTS
-- ============================================

-- INNER JOIN with invisible columns
select * from t1 inner join t2 on t1.id = t2.id order by t1.id;
select * from t1 inner join t2 on t1.c1 = t2.c5 order by t1.id;
select t1.c1, t1.c2, t2.c5, t2.c6 from t1 inner join t2 on t1.id = t2.id order by t1.id;

-- LEFT OUTER JOIN
select * from t1 left join t2 on t1.id = t2.id order by t1.id;
select * from t1 left join t2 on t1.c1 = t2.c5 order by t1.id;
select t1.*, t2.c6 from t1 left join t2 on t1.c3 = t2.c5 * 100 order by t1.id;

-- RIGHT OUTER JOIN
select * from t1 right join t2 on t1.id = t2.id order by t2.id;
select t1.c2, t2.c5, t2.c6 from t1 right join t2 on t1.c1 = t2.c5 order by t2.id;

-- CROSS JOIN
select * from t1 cross join t2 where t1.c1 < t2.c5 order by t1.id, t2.id;

-- Self join with invisible columns
select a.*, b.c2 as b_c2 from t1 a join t1 b on a.c1 = b.c1 - 10 order by a.id;

-- Multiple joins
create table t3 (id int, c8 int invisible, c9 int);
insert into t3(id, c8, c9) values (1, 111, 11);
insert into t3(id, c8, c9) values (2, 222, 22);

select * from t1 
    join t2 on t1.id = t2.id 
    join t3 on t2.id = t3.id 
order by t1.id;

select t1.c1, t2.c5, t3.c8 
from t1 
    join t2 on t1.c1 = t2.c5 
    join t3 on t2.c5 * 10 = t3.c8 
order by t1.c1;

drop table t3;

-- ============================================
-- 5. AGGREGATION AND GROUP BY TESTS
-- ============================================

-- GROUP BY with invisible column
select c1, count(*) from t1 group by c1 order by c1;
select c2, sum(c1) from t1 group by c2 order by c2;
select c1, c3, avg(c2) from t1 group by c1, c3 order by c1;

-- GROUP BY visible, aggregate invisible
select c2, max(c1), min(c3) from t1 group by c2 order by c2;
select c4, sum(c1), avg(c3) from t1 group by c4 order by c4;

-- HAVING with invisible column
select c2, count(*) from t1 group by c2 having max(c1) > 15 order by c2;
select c4, sum(c1) from t1 group by c4 having sum(c3) > 1500 order by c4;

-- Aggregate functions without GROUP BY
select count(*), sum(c1), avg(c1), max(c1), min(c1) from t1;
select count(*), sum(c3), avg(c3), max(c3), min(c3) from t1;
select sum(c1 + c3), avg(c2) from t1;

-- DISTINCT with invisible column
select distinct c1 from t1 order by c1;
select distinct c1, c2 from t1 order by c1;
select count(distinct c1) from t1;

-- ============================================
-- 6. ORDER BY TESTS
-- ============================================

-- ORDER BY invisible column
select * from t1 order by c1;
select * from t1 order by c1 desc;
select * from t1 order by c1, c3;
select c2, c4 from t1 order by c1;
select c2, c4 from t1 order by c1 desc, c3 asc;

-- ORDER BY with expression on invisible column
select * from t1 order by c1 + c3;
select c2, c4 from t1 order by c1 * 2;

-- ORDER BY invisible in subquery
select * from (select * from t1 order by c1 limit 2) as sub;

-- ============================================
-- 7. UNION/INTERSECT/DIFFERENCE TESTS
-- ============================================

-- UNION with invisible columns
select * from t1 union select * from t1;
select c2, c4 from t1 union select c2, c4 from t1;

-- UNION ALL
select c1, c2 from t1 union all select c5, c6 from t2 order by 1;
select c1, c3 from t1 union all select c5, c5 from t2 order by 1;

-- INTERSECT
select c1 from t1 intersect select c5 from t2;
select c2 from t1 intersect select c6 from t2;

-- DIFFERENCE
select c1 from t1 difference select c5 from t2 order by 1;
select id from t1 difference select id from t2 order by 1;

-- Mixed visible and invisible in set operations
select c1, c2, c3 from t1 union select c5, c6, c5 from t2 order by 1;

-- ============================================
-- 8. CTE (WITH CLAUSE) TESTS
-- ============================================

-- CTE with invisible columns
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

-- Multiple CTEs
with 
    cte1 as (select c1, c2 from t1),
    cte2 as (select c5, c6 from t2)
select cte1.c1, cte2.c5 from cte1, cte2 where cte1.c1 < cte2.c5 order by cte1.c1;

-- Recursive CTE with invisible column
with recursive cte(n, c1_val) as (
    select 1, c1 from t1 where id = 1
    union all
    select n + 1, c1_val + 10 from cte where n < 3
)
select * from cte;

-- CTE joining with original table
with cte1 as (
    select c1, c2 from t1 where c1 > 10
)
select t1.*, cte1.c2 as cte_c2 from t1 join cte1 on t1.c1 = cte1.c1 order by t1.id;

-- ============================================
-- 9. CREATE TABLE AS SELECT (CTAS) TESTS
-- ============================================

-- CTAS with * (invisible columns not copied)
create table t_ctas1 as select * from t1;
desc t_ctas1;
select * from t_ctas1 order by id;

-- CTAS with explicit invisible columns
create table t_ctas2 as select id, c1, c2, c3, c4 from t1;
desc t_ctas2;
select * from t_ctas2 order by id;

-- CTAS with WHERE clause using invisible column
create table t_ctas3 as select * from t1 where c1 > 15;
desc t_ctas3;
select * from t_ctas3 order by id;

-- CTAS with JOIN
create table t_ctas4 as 
    select t1.id, t1.c2, t2.c6 
    from t1 join t2 on t1.id = t2.id;
desc t_ctas4;
select * from t_ctas4 order by id;

-- CTAS with aggregation
create table t_ctas5 as 
    select c2, count(*) as cnt, sum(c1) as sum_c1 
    from t1 
    group by c2;
desc t_ctas5;
select * from t_ctas5 order by c2;

drop table t_ctas1;
drop table t_ctas2;
drop table t_ctas3;
drop table t_ctas4;
drop table t_ctas5;

-- ============================================
-- 10. CREATE TABLE LIKE TESTS
-- ============================================

-- LIKE clause (invisible columns should be preserved)
create table t_like1 like t1;
desc t_like1;
show create table t_like1;

insert into t_like1(id, c1, c2, c3, c4) values (10, 100, 1000, 10000, 'like1');
select * from t_like1;
select id, c1, c2, c3, c4 from t_like1;

drop table t_like1;

-- ============================================
-- 11. MERGE TESTS
-- ============================================

create table t_target (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

create table t_source (
    id int,
    c1_new int,
    c2_new int,
    c3_new varchar(50)
);

insert into t_target(id, c1, c2, c3) values (1, 10, 100, 'old1');
insert into t_target(id, c1, c2, c3) values (2, 20, 200, 'old2');

insert into t_source values (2, 25, 250, 'new2');
insert into t_source values (3, 30, 300, 'new3');

-- MERGE statement with invisible column
merge into t_target t
using t_source s on t.id = s.id
when matched then
    update set t.c1 = s.c1_new, t.c2 = s.c2_new, t.c3 = s.c3_new
when not matched then
    insert (id, c1, c2, c3) values (s.id, s.c1_new, s.c2_new, s.c3_new);

select id, c1, c2, c3 from t_target order by id;

-- MERGE with condition using invisible column
delete from t_source;
insert into t_source values (1, 15, 150, 'update1');
insert into t_source values (4, 40, 400, 'new4');

-- ORACLE cant do it (t.c1 missing) maybe ORACLE's problem
merge into t_target t
using t_source s on t.id = s.id
when matched then
    update set t.c2 = s.c2_new where t.c1 < s.c1_new
when not matched then
    insert (id, c1, c2, c3) values (s.id, s.c1_new, s.c2_new, s.c3_new);

select id, c1, c2, c3 from t_target order by id;

drop table t_source;
drop table t_target;

-- ============================================
-- 12. COMPLEX QUERY TESTS
-- ============================================

-- Window functions with invisible column
select id, c1, c2, 
       row_number() over (order by c1) as rn,
       rank() over (order by c1) as rnk
from t1
order by c1;

select id, c2, c1,
       sum(c1) over (partition by c2 order by c1) as running_sum
from t1
order by c2, c1;

-- CASE expression with invisible column
select id, c2,
       case 
           when c1 < 15 then 'low'
           when c1 < 25 then 'medium'
           else 'high'
       end as c1_range
from t1
order by id;

-- IN subquery with invisible column
select * from t1 where c1 in (10, 20, 30) order by id;
select c2, c4 from t1 where c3 not in (1000, 3000) order by c2;

-- EXISTS with invisible column
select * from t1 where exists (
    select 1 from t2 where t2.c5 = t1.c1
) order by id;

-- Complex join with subquery and invisible columns
select t1.id, t1.c2, sub.avg_c5
from t1
join (
    select id, c5, avg(c6) over () as avg_c5
    from t2
) sub on t1.id = sub.id
where t1.c1 > sub.c5
order by t1.id;

-- ============================================
-- 13. CONSTRAINT TESTS WITH INVISIBLE COLUMNS
-- ============================================

create table t_const (
    id int primary key,
    c1 int invisible unique,
    c2 int invisible not null,
    c3 int check (c3 > 0),
    c4 int invisible check (c4 > 0),
    c5 varchar(50)
);

insert into t_const(id, c1, c2, c3, c4, c5) values (1, 10, 20, 30, 40, 'a');
/* err - unique violation */
insert into t_const(id, c1, c2, c3, c4, c5) values (2, 10, 21, 31, 41, 'b');
/* err - not null violation */
insert into t_const(id, c1, c3, c4, c5) values (3, 11, 32, 42, 'c');
/* err - check violation on invisible column  There's no CHECK constraint in CUBRID */
-- insert into t_const(id, c1, c2, c3, c4, c5) values (4, 12, 22, 33, -1, 'd');

insert into t_const(id, c1, c2, c3, c4, c5) values (5, 15, 25, 35, 45, 'e');
select * from t_const order by id;
select id, c1, c2, c3, c4, c5 from t_const order by id;

drop table t_const;

-- ============================================
-- 14. ALTER TABLE TESTS (ADDITIONAL)
-- ============================================

-- Change invisible column to visible and back
alter table t1 modify column c1 int visible;
desc t1;
select * from t1 order by id;

alter table t1 modify column c1 int invisible;
desc t1;
select * from t1 order by id;

-- Change column type of invisible column
alter table t1 modify column c1 bigint;
desc t1;

alter table t1 modify column c3 bigint invisible;
desc t1;

-- Rename invisible column
alter table t1 change column c1 c1_renamed int invisible;
desc t1;
select id, c1_renamed, c2 from t1 order by id;

alter table t1 change column c1_renamed c1 int invisible;
desc t1;

-- ============================================
-- 15. MIXED SCENARIO TESTS
-- ============================================

-- Complex query with multiple features
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


-- UNION with aggregation on invisible columns
select 'table1' as source, sum(c1) as sum_invis from t1
union all
select 'table2' as source, sum(c5) from t2;

-- ============================================
-- Cleanup
-- ============================================

drop table t1;
drop table t2;

-- ============================================
-- FINAL COUNT: 100+ test cases covering:
-- - Index operations with invisible columns
-- - Foreign key constraints
-- - Subqueries (WHERE, FROM, SELECT)
-- - All JOIN types
-- - Aggregation and GROUP BY
-- - UNION/INTERSECT/DIFFERENCE
-- - CTEs (including recursive)
-- - CTAS
-- - CREATE TABLE LIKE
-- - MERGE operations
-- - Window functions
-- - Complex mixed scenarios
-- ============================================