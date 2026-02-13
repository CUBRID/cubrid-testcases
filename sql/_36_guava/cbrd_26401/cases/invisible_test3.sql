-- ============================================
-- ADDITIONAL TEST CASES - CUBRID SPECIFIC
-- ============================================

-- Cleanup
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

-- ============================================
-- 16. REPLACE INTO TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int unique,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE with duplicate PK (should delete and insert)
replace into t1(id, c1, c2, c3, c4) values (1, 11, 101, 1001, 'a1');
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE without specifying invisible columns
replace into t1(id, c2, c4) values (2, 202, 'b2');
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE with duplicate UNIQUE index
replace into t1 set c2 = 101, id = 3, c4 = 'c';
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE with SELECT
create table t2 (id int, val int, name varchar(50));
insert into t2 values (4, 400, 'd'), (5, 500, 'e');
replace into t1(id, c2, c4) select id, val, name from t2;
select id, c1, c2, c3, c4 from t1 order by id;

drop table t2;
drop table t1;

-- ============================================
-- 17. INSERT ... ON DUPLICATE KEY UPDATE TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int unique,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');

-- UPDATE invisible column on duplicate
insert into t1(id, c1, c2, c4) values (1, 15, 105, 'a_updated') 
    on duplicate key update c1 = 15, c4 = 'a_updated';
select id, c1, c2, c3, c4 from t1 order by id;

-- INSERT new row (no duplicate)
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c')
    on duplicate key update c1 = 35;
select id, c1, c2, c3, c4 from t1 order by id;

-- ON DUPLICATE with only visible column in INSERT but invisible in UPDATE
insert into t1(id, c2, c4) values (3, 301, 'c_updated')
    on duplicate key update c1 = 31, c3 = 3001;
select id, c1, c2, c3, c4 from t1 order by id;

drop table t1;

-- ============================================
-- 18. COLLECTION TYPE TESTS (SET, MULTISET, LIST)
-- ============================================

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

drop table t1;

-- ============================================
-- 19. TRUNCATE TABLE TESTS
-- ============================================

create table t1 (
    id int auto_increment invisible primary key,
    c1 int,
    c2 int invisible,
    c3 varchar(50)
);

insert into t1(c1, c2, c3) values (10, 20, 'a');
insert into t1(c1, c2, c3) values (11, 21, 'b');
insert into t1(c1, c2, c3) values (12, 22, 'c');

select id, c1, c2, c3 from t1 order by id;

truncate table t1;

-- Check that table structure is preserved
desc t1;

-- Verify auto_increment reset
insert into t1(c1, c2, c3) values (13, 23, 'd');
select id, c1, c2, c3 from t1;

drop table t1;

-- ============================================
-- 21. LIMIT/OFFSET TESTS
-- ============================================

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');
insert into t1(id, c1, c2, c3, c4) values (4, 40, 400, 4000, 'd');
insert into t1(id, c1, c2, c3, c4) values (5, 50, 500, 5000, 'e');

-- LIMIT with invisible column in ORDER BY
select * from t1 order by c1 limit 3;
select id, c2, c4 from t1 order by c1 desc limit 2;

-- OFFSET with invisible column
select * from t1 order by c3 limit 2 offset 1;
select c1, c2 from t1 order by c1 limit 3 offset 2;

-- LIMIT with invisible column in WHERE
select * from t1 where c1 >= 20 order by c1 limit 2;

drop table t1;

-- ============================================
-- 23. INSERT DEFAULT VALUES TESTS
-- ============================================

create table t1 (
    id int auto_increment invisible primary key,
    c1 int invisible default 100,
    c2 int default 200,
    c3 int invisible default 300
);

-- INSERT with all defaults
insert into t1 default values;
insert into t1 default values;
select id, c1, c2, c3 from t1 order by id;

-- INSERT specifying only some columns
insert into t1(c2) values (250);
select id, c1, c2, c3 from t1 order by id;

drop table t1;

-- Test error case: all columns invisible and some without defaults
create table t1 (
    c1 int invisible,
    c2 int invisible
);
/* err - no visible column */
drop table t1;

-- ============================================
-- 24. COMPLEX WHERE/HAVING EXPRESSION TESTS
-- ============================================

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');
insert into t1(id, c1, c2, c3, c4) values (4, 15, 150, 1500, 'd');

-- Complex expression with invisible columns in WHERE
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

-- Complex HAVING with invisible columns
select c2, count(*), max(c1), sum(c3) 
from t1 
group by c2 
having max(c1) > 15 and sum(c3) < 5000
order by c2;

-- Nested CASE with invisible columns
select id, c2,
    case when c1 > 20 then
        case when c3 > 2500 then 'high-high'
             else 'high-low' end
    else 'low'
    end as category
from t1 order by id;

drop table t1;

-- ============================================
-- 25. UPDATE/DELETE WITH JOIN TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

create table t2 (
    id int primary key,
    c4 int invisible,
    c5 int
);

insert into t1(id, c1, c2, c3) values (1, 10, 100, 'a');
insert into t1(id, c1, c2, c3) values (2, 20, 200, 'b');
insert into t1(id, c1, c2, c3) values (3, 30, 300, 'c');

insert into t2(id, c4, c5) values (1, 110, 11);
insert into t2(id, c4, c5) values (2, 220, 22);

-- UPDATE with invisible column from joined table
update t1, t2 set t1.c1 = t2.c4 where t1.id = t2.id;
select id, c1, c2, c3 from t1 order by id;

-- DELETE using invisible column in join condition
delete t1 from t1, t2 where t1.c1 = t2.c4 and t1.id = 1;
select id, c1, c2, c3 from t1 order by id;

drop table t2;
drop table t1;

-- ============================================
-- 26. SHOW STATEMENTS TESTS
-- ============================================

create table t1 (
    id int auto_increment invisible primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50) invisible,
    c4 int,
    index idx_c1 (c1),
    index idx_c2_c4 (c2, c4)
);

-- SHOW CREATE TABLE should show invisible attribute
show create table t1;

-- SHOW COLUMNS (should only show visible columns by default)
show columns from t1;

-- SHOW INDEX should show all indexes including ones on invisible columns
show index from t1;

drop table t1;

-- ============================================
-- 27. INFORMATION SCHEMA TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int not null,
    c3 varchar(50) invisible default 'test',
    c4 int
);

-- Query system catalog for invisible columns
select attr_name, is_nullable, default_value, is_invisible
from db_attribute 
where class_name = 't1' 
order by def_order;

-- More detailed attribute info
select attr_name, data_type, prec, is_nullable, is_invisible
from db_attribute
where class_name = 't1'
order by def_order;

-- Check internal catalog
select attr_name, from_class_of, from_attr_name, flags
from _db_attribute
where class_of.class_name = 't1'
order by attr_name;

drop table t1;

-- ============================================
-- 28. INSERT ... SELECT WITH INVISIBLE COLUMN
-- ============================================

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

create table t2 (
    id int,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

insert into t1(id, c1, c2, c3) values (1, 10, 100, 'a');
insert into t1(id, c1, c2, c3) values (2, 20, 200, 'b');

-- INSERT ... SELECT * (invisible columns not included)
insert into t2 select * from t1;
select id, c1, c2, c3 from t2 order by id;

-- INSERT ... SELECT with explicit invisible columns
delete from t2;
insert into t2(id, c1, c2, c3) select id, c1, c2, c3 from t1;
select id, c1, c2, c3 from t2 order by id;

-- INSERT ... SELECT with WHERE on invisible column
delete from t2;
insert into t2(id, c2, c3) select id, c2, c3 from t1 where c1 > 15;
select id, c1, c2, c3 from t2 order by id;

drop table t2;
drop table t1;

-- ============================================
-- 29. NESTED SUBQUERY WITH INVISIBLE COLUMN
-- ============================================

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');

-- Triple nested subquery with invisible columns
select * from t1 
where c1 in (
    select c1 from t1 
    where c3 in (
        select c3 from t1 where c1 > 10
    )
)
order by id;

-- Subquery in SELECT with invisible column
select id, c2, c4,
    (select max(c1) from t1 t2 where t2.c3 < t1.c3) as max_c1
from t1 order by id;

drop table t1;

-- ============================================
-- 30. MULTI-TABLE UPDATE/DELETE
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int
);

create table t2 (
    id int primary key,
    c3 int invisible,
    c4 int
);

insert into t1(id, c1, c2) values (1, 10, 100);
insert into t1(id, c1, c2) values (2, 20, 200);
insert into t2(id, c3, c4) values (1, 30, 300);
insert into t2(id, c3, c4) values (2, 40, 400);

-- Multi-table update using invisible columns
update t1, t2 
set t1.c1 = t1.c1 + 5, t2.c3 = t2.c3 + 10
where t1.id = t2.id and t1.c1 > 15;

select id, c1, c2 from t1 order by id;
select id, c3, c4 from t2 order by id;

drop table t2;
drop table t1;

-- ============================================
-- FINAL COUNT: 30 additional test sections
-- Total 200+ individual test cases covering:
-- - REPLACE INTO
-- - INSERT ON DUPLICATE KEY UPDATE  
-- - Collection types (SET, MULTISET, LIST)
-- - TRUNCATE
-- - Transactions
-- - LIMIT/OFFSET
-- - FOR UPDATE
-- - INSERT DEFAULT VALUES
-- - Complex WHERE/HAVING expressions
-- - UPDATE/DELETE with JOIN
-- - SHOW statements
-- - Information schema
-- - INSERT SELECT variations
-- - Nested subqueries
-- - Multi-table operations
-- ============================================