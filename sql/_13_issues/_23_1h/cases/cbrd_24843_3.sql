/* ----------------------------------------
 *
 * test case 37:
 *
 * 1. t_child_1, t_child_2, t_parent_1, t_parent_2 [o]
 * 2. (t_child_1, t_parent_1), (t_child_1, t_parent_1) [o]
 * 3. (no_merge t_child_1, t_parent_1), (no_merge t_child_1, t_parent_1) [o]
 * 4. t_child_1, t_parent_1, t_parent_1 + PT_RANGE (ansi‑style) [x]
 * 5. t_child_1, t_parent_1, t_parent_1 + PT_RANGE [o]
 * 6. (t_child_1, t_parent_1) [o]
 * 7. (t_child_1, t_parent_1) + PT_RANGE [o]
 *
 * ---------------------------------------- */
 
drop table if exists t_child_1, t_child_2;
drop table if exists t_parent_1, t_parent_2;
create table t_parent_1 (a int primary key, b int);
create table t_parent_2 (a int primary key, b int);
create table t_child_1 (a int auto_increment primary key, b int, p_a int references t_parent_1);
create table t_child_2 (a int auto_increment primary key, b int, p_a int references t_parent_2);
insert into t_parent_1 values (1, 2), (2, 4), (3, 6), (4, 8), (5, 10), (6, 12), (7, 14), (8, 16), (9, 18);
insert into t_parent_2 values (1, 3), (2, 6), (3, 9), (4, 12), (5, 15), (6, 18), (7, 21), (8, 24), (9, 27);
insert into t_child_1 select null, (b * -1), NULL from t_parent_1;
insert into t_child_1 select null, (b * -1) * 1000, a from t_parent_1;
insert into t_child_2 select null, (b * -1), NULL from t_parent_2;
insert into t_child_2 select null, (b * -1) * 1000, a from t_parent_2;
update statistics on t_child_1, t_child_2, t_parent_1, t_parent_2 with fullscan;

set trace on;


/* 1. t_child_1, t_child_2, t_parent_1, t_parent_2 */
/* ansi‑style */
select /*+ recompile */
    c1.*, c2.*
from
    t_child_1 as c1
    inner join t_child_2 as c2 on c1.b = c2.b
    inner join t_parent_1 as p1 on c1.p_a = p1.a
    inner join t_parent_2 as p2 on c2.p_a = p2.a
where
    p1.a = 3 and p2.a = 2;
show trace;

select /*+ recompile */
    c1.*, c2.*
from
    t_child_1 as c1,
    t_child_2 as c2,
    t_parent_1 as p1,
    t_parent_2 as p2
where
    c1.b = c2.b
    and c1.p_a = p1.a
    and c2.p_a = p2.a
    and p1.a = 3 and p2.a = 2;
show trace;


/* 2. (t_child_1, t_parent_1), (t_child_1, t_parent_1) */
/* ansi‑style */
select /*+ recompile */
    a.*, b.*
from
    (select c.* from t_child_1 as c inner join t_parent_1 as p on c.p_a = p.a where c.a % 2 = 0) as a
    inner join
    (select c.* from t_child_1 as c inner join t_parent_1 as p on c.p_a = p.a where c.a % 3 = 0) as b
    on a.b = b.b;
show trace;

select /*+ recompile */
    a.*, b.*
from
    (select c.* from t_child_1 as c, t_parent_1 as p where c.p_a = p.a and c.a % 2 = 0) as a,
    (select c.* from t_child_1 as c, t_parent_1 as p where c.p_a = p.a and c.a % 3 = 0) as b
where
    a.b = b.b;
show trace;


/* 3. (no_merge t_child_1, t_parent_1), (no_merge t_child_1, t_parent_1) */
/* ansi‑style */
select /*+ recompile */
    a.*, b.*
from
    (select /* no_merge */ c.* from t_child_1 as c inner join t_parent_1 as p on c.p_a = p.a where c.a % 2 = 0) as a
    inner join
    (select /* no_merge */ c.* from t_child_1 as c inner join t_parent_1 as p on c.p_a = p.a where c.a % 3 = 0) as b
    on a.b = b.b;
show trace;

select /*+ recompile */
    a.*, b.*
from
    (select /* no_merge */ c.* from t_child_1 as c, t_parent_1 as p where c.p_a = p.a and c.a % 2 = 0) as a,
    (select /* no_merge */ c.* from t_child_1 as c, t_parent_1 as p where c.p_a = p.a and c.a % 3 = 0) as b
where
    a.b = b.b;
show trace;


/* 4. t_child_1, t_parent_1, t_parent_1 + PT_RANGE (ansi‑style) */
/* ansi‑style */
select /*+ recompile ordered */
    c.*
from
    t_child_1 as c
    inner join t_parent_1 as p1 on c.p_a = p1.a
    inner join t_parent_1 as p2 on c.p_a = p2.a
where
    p1.a = 7
    and p2.a in (6, 7, 8);
show trace;


/* ansi‑style */
select /*+ recompile ordered no_eliminate_join */
    c.*
from
    t_child_1 as c
    inner join t_parent_1 as p1 on c.p_a = p1.a
    inner join t_parent_1 as p2 on c.p_a = p2.a
where
    p1.a = 7
    and p2.a in (6, 7, 8);
show trace;


/* 5. t_child_1, t_parent_1, t_parent_1 + PT_RANGE */
select /*+ recompile ordered */
    c.*
from
    t_child_1 as c,
    t_parent_1 as p1,
    t_parent_1 as p2
where
    c.p_a = p1.a
    and c.p_a = p2.a
    and p1.a = 7
    and p2.a in (6, 7, 8);
show trace;

select /*+ recompile ordered no_eliminate_join */
    c.*
from
    t_child_1 as c,
    t_parent_1 as p1,
    t_parent_1 as p2
where
    c.p_a = p1.a
    and c.p_a = p2.a
    and p1.a = 7
    and p2.a in (6, 7, 8);
show trace;


/* 6. (t_child_1, t_parent_1) */
/* ansi‑style */
select /*+ recompile */
    t.*
from
    (
        select /* no_merge */
            c.*
        from
            t_child_1 as c
            inner join t_parent_1 as p on c.p_a = p.a
    ) as t
where
    t.p_a = 8;
show trace;

select /*+ recompile */
    t.*
from
    (
        select /* no_merge */
            c.*
        from
            t_child_1 as c,
            t_parent_1 as p
        where
            c.p_a = p.a
    ) as t
where
    t.p_a = 8;
show trace;


/* 7. (t_child_1, t_parent_1) + PT_RANGE */
/* ansi‑style */
select /*+ recompile */
    t.*
from
    (
        select /* no_merge */
            c.*
        from
            t_child_1 as c
            inner join t_parent_1 as p on c.p_a = p.a
    ) as t
where
    t.p_a > 8;
show trace;

select /*+ recompile */
    t.*
from
    (
        select /* no_merge */
            c.*
        from
            t_child_1 as c,
            t_parent_1 as p
        where
            c.p_a = p.a
    ) as t
where
    t.p_a > 8;
show trace;

set trace off;

drop table if exists t_child;
drop table if exists t_parent;
