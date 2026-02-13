-- ============================================
-- JOIN TESTS - INVISIBLE COLUMN
-- INNER / OUTER / CROSS / SELF / MULTI-TABLE JOIN
-- ============================================

-- Setup
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

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
insert into t2(id, c5, c6, c7) values (2, 20, 250, 'y');
insert into t2(id, c5, c6, c7) values (4, 35, 350, 'z');


-- ============================================
-- [1] INNER JOIN
-- ============================================

select * from t1 inner join t2 on t1.id = t2.id order by t1.id;
select * from t1 inner join t2 on t1.c1 = t2.c5 order by t1.id;
select t1.c1, t1.c2, t2.c5, t2.c6 from t1 inner join t2 on t1.id = t2.id order by t1.id;


-- ============================================
-- [2] LEFT OUTER JOIN
-- ============================================

select * from t1 left join t2 on t1.id = t2.id order by t1.id;
select * from t1 left join t2 on t1.c1 = t2.c5 order by t1.id;
select t1.*, t2.c6 from t1 left join t2 on t1.c3 = t2.c5 * 100 order by t1.id;


-- ============================================
-- [3] RIGHT OUTER JOIN
-- ============================================

select * from t1 right join t2 on t1.id = t2.id order by t2.id;
select t1.c2, t2.c5, t2.c6 from t1 right join t2 on t1.c1 = t2.c5 order by t2.id;


-- ============================================
-- [4] CROSS JOIN
-- ============================================

select * from t1 cross join t2 where t1.c1 < t2.c5 order by t1.id, t2.id;


-- ============================================
-- [5] SELF JOIN
-- ============================================

select a.*, b.c2 as b_c2 from t1 a join t1 b on a.c1 = b.c1 - 10 order by a.id;


-- ============================================
-- [6] MULTIPLE TABLE JOIN (3 tables)
-- ============================================

create table t3 (id int, c8 int invisible, c9 int);
insert into t3(id, c8, c9) values (1, 111, 11);
insert into t3(id, c8, c9) values (2, 200, 22);

select * from t1
    join t2 on t1.id = t2.id
    join t3 on t2.id = t3.id
order by t1.id;

select t1.c1, t2.c5, t3.c8
from t1
    join t2 on t1.c1 = t2.c5
    join t3 on t2.c5 * 10 = t3.c8
order by t1.c1;

drop table if exists t3;


-- ============================================
-- [7] JOIN WITH COMPLEX SUBQUERY
-- ============================================

select t1.id, t1.c2, sub.avg_c5
from t1
join (
    select id, c5, avg(c6) over () as avg_c5
    from t2
) sub on t1.id = sub.id
where t1.c1 < sub.c5
order by t1.id;


-- ============================================
-- [8] NATURAL JOIN
-- ============================================

create table t1_ (id int , c1 int invisible, c2 int);

insert into t1_(id, c1, c2) values (1, 10, 100), (1,9999,100), (1,10,9999), (2, 20, 200), (2, 9999, 200), (2, 20, 9999);

select * from t1 natural join t1_;
select t1.id, t1.c1, t1.c2, t1_.id, t1_.c1, t1_.c2 from t1 natural join t1_;

alter table t1_ modify column c1 int visible;

select * from t1 natural join t1_;
select t1.id, t1.c1, t1.c2, t1_.id, t1_.c1, t1_.c2 from t1 natural join t1_;

alter table t1 modify column c1 int visible;

select * from t1 natural join t1_;
select t1.id, t1.c1, t1.c2, t1_.id, t1_.c1, t1_.c2 from t1 natural join t1_;


-- ============================================
-- Cleanup
-- ============================================

drop table if exists t1_;
drop table if exists t1;
drop table if exists t2;
