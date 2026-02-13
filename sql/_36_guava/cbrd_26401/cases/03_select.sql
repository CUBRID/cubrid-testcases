-- ============================================
-- SELECT TESTS - INVISIBLE COLUMN
-- Basic SELECT / WHERE / ORDER BY / LIMIT / OFFSET
-- ============================================

set trace on;

-- Setup
drop table if exists t1;
drop table if exists t2;

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);
create index t1_c1_c2_idx on t1 (c1,c2);


insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');
insert into t1(id, c1, c2, c3, c4) values (4, 15, 150, 1500, 'd');
insert into t1(id, c1, c2, c3, c4) values (5, 50, 500, 5000, 'e');

update statistics on t1;

-- ============================================
-- [1] BASIC SELECT TESTS
-- ============================================

-- SELECT * should not show invisible columns
/* only c2 c4 visible */ select * from t1 order by id;

-- SELECT with explicit invisible columns
select /*+recompile*/ id, c1, c2, c3, c4 from t1 order by 1;
show trace;
select /*+recompile*/ * from t1 order by 1;
show trace;
select /*+recompile*/ c1, c2 from t1 order by 1;
show trace;
select /*+recompile*/ c1 from t1 order by 1;
show trace;
select /*+recompile*/ * from t1 where c1 = 1 order by 1;
show trace;
select /*+recompile*/ c1, c2 from t1 where c1 is not null order by 1;
show trace;


-- ============================================
-- [2] WHERE CLAUSE WITH INVISIBLE COLUMNS
-- ============================================

-- Simple comparison
select * from t1 where c1 = 10 order by id;
select id, c2, c4 from t1 where c1 > 15 order by id;

-- Complex expression
select * from t1 where c1 + c3 > 2000 order by id;
select id, c2, c4 from t1 where c1 * 10 = c2 order by id;
select * from t1 where c1 between 15 and 25 order by id;
select * from t1 where c3 in (1000, 2000, 3000) order by id;

-- CASE expression with invisible column
select id, c2, c4,
    case when c1 < 20 then 'low'
         when c1 < 30 then 'medium'
         else 'high' end as c1_level
from t1 order by id;

-- Nested CASE with invisible columns
select id, c2,
    case when c1 > 20 then
        case when c3 > 2500 then 'high-high'
             else 'high-low' end
    else 'low'
    end as category
from t1 order by id;


-- ============================================
-- [3] ORDER BY WITH INVISIBLE COLUMNS
-- ============================================

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
-- [4] LIMIT / OFFSET WITH INVISIBLE COLUMNS
-- ============================================

-- LIMIT with invisible column in ORDER BY
select * from t1 order by c1 limit 3;
select id, c2, c4 from t1 order by c1 desc limit 2;

-- OFFSET with invisible column
select * from t1 order by c3 limit 2 offset 1;
select c1, c2 from t1 order by c1 limit 3 offset 2;

-- LIMIT with invisible column in WHERE
select * from t1 where c1 >= 20 order by c1 limit 2;


-- ============================================
-- [5] DISTINCT WITH INVISIBLE COLUMNS
-- ============================================

select distinct c1 from t1 order by c1;
select distinct c1, c2 from t1 order by c1;
select count(distinct c1) from t1;


-- ============================================
-- [6] SELECT with COLLECTION TYPES (SET, MULTISET, LIST)
-- ============================================

drop table if exists t1;

create table t1 (
    id int,
    c1 set(int) invisible,
    c2 multiset(varchar(20)),
    c3 list(int) invisible,
    c4 int
);

insert into t1(id, c1, c2, c3, c4) values
    (1, {10, 20, 30}, {'a', 'b', 'c'}, {100, 200, 300}, 1);
insert into t1(id, c1, c2, c3, c4) values
    (2, {11, 21}, {'x', 'y'}, {110, 210}, 2);

-- SELECT * should not show invisible collections
select * from t1 order by id;

-- SELECT with invisible collections
select id, c1, c2, c3, c4 from t1 order by id;

-- WHERE clause with invisible collection
select * from t1 where 10 in c1;
select id, c2, c4 from t1 where {10, 20} subseteq c1;

-- Collection operators with invisible columns
select id, c4 from t1 where c1 superset {10};
select id, c4 from t1 where c3 seteq {100, 200, 300};

-- Update invisible collection
update t1 set c1 = c1 + {40} where id = 1;
select id, c1, c2, c3, c4 from t1 where id = 1;

drop table if exists t1;


-- ============================================
-- Cleanup
-- ============================================

drop table if exists t1;
drop table if exists t2;
