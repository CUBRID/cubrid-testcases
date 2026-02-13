-- ============================================
-- AGGREGATION TESTS - INVISIBLE COLUMN
-- GROUP BY / HAVING / WINDOW FUNCTIONS / UNION / INTERSECT / DIFFERENCE
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
insert into t1(id, c1, c2, c3, c4) values (4, 15, 150, 1500, 'd');

insert into t2(id, c5, c6, c7) values (1, 15, 150, 'x');
insert into t2(id, c5, c6, c7) values (2, 25, 250, 'y');
insert into t2(id, c5, c6, c7) values (4, 35, 350, 'z');


-- ============================================
-- [1] AGGREGATE FUNCTIONS
-- ============================================

-- aggregate invisible columns without GROUP BY
select count(*), sum(c1), avg(c1), max(c1), min(c1) from t1;
select count(*), sum(c3), avg(c3), max(c3), min(c3) from t1;
select sum(c1 + c3), avg(c2) from t1;


-- ============================================
-- [2] GROUP BY WITH INVISIBLE COLUMNS
-- ============================================

-- GROUP BY invisible column
select c1, count(*) from t1 group by c1 order by c1;
select c2, sum(c1) from t1 group by c2 order by c2;
select c1, c3, avg(c2) from t1 group by c1, c3 order by c1;

-- GROUP BY visible, aggregate invisible
select c2, max(c1), min(c3) from t1 group by c2 order by c2;
select c4, sum(c1), avg(c3) from t1 group by c4 order by c4;


-- ============================================
-- [3] HAVING WITH INVISIBLE COLUMNS
-- ============================================

select c2, count(*) from t1 group by c2 having max(c1) > 15 order by c2;
select c4, sum(c1) from t1 group by c4 having sum(c3) > 1500 order by c4;

-- complex HAVING with invisible columns
select c2, count(*), max(c1), sum(c3)
from t1
group by c2
having max(c1) > 15 and sum(c3) < 5000
order by c2;


-- ============================================
-- [4] WINDOW FUNCTIONS WITH INVISIBLE COLUMNS
-- ============================================

select id, c1, c2,
       row_number() over (order by c1) as rn,
       rank() over (order by c1) as rnk
from t1
order by c1;

select id, c2, c1,
       sum(c1) over (partition by c2 order by c1) as running_sum
from t1
order by c2, c1;

-- window function in subquery with invisible column
select t1.id, t1.c2, sub.avg_c5
from t1
join (
    select id, c5, avg(c6) over () as avg_c5
    from t2
) sub on t1.id = sub.id
where t1.c1 > sub.c5
order by t1.id;


-- ============================================
-- [5] UNION / UNION ALL
-- ============================================

-- UNION with invisible columns
select * from t1 union select * from t1;
select c2, c4 from t1 union select c2, c4 from t1;

-- UNION ALL
select c1, c2 from t1 union all select c5, c6 from t2 order by 1;
select c1, c3 from t1 union all select c5, c5 from t2 order by 1;

-- mixed visible and invisible in UNION
select c1, c2, c3 from t1 union select c5, c6, c5 from t2 order by 1;

-- UNION with aggregation on invisible columns
select 'table1' as source, sum(c1) as sum_invis from t1
union all
select 'table2' as source, sum(c5) from t2;


-- ============================================
-- [6] INTERSECT / DIFFERENCE
-- ============================================

select c1 from t1 intersect select c5 from t2;
select c2 from t1 intersect select c6 from t2;

select c1 from t1 difference select c5 from t2 order by 1;
select id from t1 difference select id from t2 order by 1;


-- ============================================
-- Cleanup
-- ============================================

drop table if exists t1;
drop table if exists t2;
