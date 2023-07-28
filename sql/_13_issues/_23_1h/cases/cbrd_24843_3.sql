/* ----------------------------------------
 *
 * test case 37:
 *
 * 1. t_child_a, t_child_b, t_parent_a, t_parent_b [o]
 * 2. (t_child_a, t_parent_a), (t_child_a, t_parent_a) [o]
 * 3. (no_merge t_child_a, t_parent_a), (no_merge t_child_a, t_parent_a) [o]
 * 4. t_child_a, t_parent_a, t_parent_a + PT_RANGE (ansi‑style) [x]
 * 5. t_child_a, t_parent_a, t_parent_a + PT_RANGE [o]
 * 6. (t_child_a, t_parent_a) [o]
 * 7. (t_child_a, t_parent_a) + PT_RANGE [o]
 *
 * ---------------------------------------- */
 
drop table if exists t_child_a, t_child_b;
drop table if exists t_parent_a, t_parent_b;
create table t_parent_a (a int primary key, b int);
create table t_parent_b (a int primary key, b int);
create table t_child_a (a int auto_increment primary key, b int, p_a int references t_parent_a);
create table t_child_b (a int auto_increment primary key, b int, p_a int references t_parent_b);
insert into t_parent_a values (1, 2), (2, 4), (3, 6), (4, 8), (5, 10), (6, 12), (7, 14), (8, 16), (9, 18);
insert into t_parent_b values (1, 3), (2, 6), (3, 9), (4, 12), (5, 15), (6, 18), (7, 21), (8, 24), (9, 27);
insert into t_child_a select null, (b * -1), NULL from t_parent_a;
insert into t_child_a select null, (b * -1) * 1000, a from t_parent_a;
insert into t_child_b select null, (b * -1), NULL from t_parent_b;
insert into t_child_b select null, (b * -1) * 1000, a from t_parent_b;
update statistics on t_child_a, t_child_b, t_parent_a, t_parent_b with fullscan;

set trace on;


/* 1. t_child_a, t_child_b, t_parent_a, t_parent_b */
/* ansi‑style */
select /*+ recompile */
    ca.*, cb.*
from
    t_child_a as ca
    inner join t_child_b as cb on ca.b = cb.b
    inner join t_parent_a as pa on ca.p_a = pa.a
    inner join t_parent_b as pb on cb.p_a = pb.a
where
    pa.a = 3 and pb.a = 2;
show trace;

select /*+ recompile */
    ca.*, cb.*
from
    t_child_a as ca,
    t_child_b as cb,
    t_parent_a as pa,
    t_parent_b as pb
where
    ca.b = cb.b
    and ca.p_a = pa.a
    and cb.p_a = pb.a
    and pa.a = 3 and pb.a = 2;
show trace;


/* 2. (t_child_a, t_parent_a), (t_child_a, t_parent_a) */
/* ansi‑style */
select /*+ recompile */
    a.*, b.*
from
    (select c.* from t_child_a as c inner join t_parent_a as p on c.p_a = p.a where c.a % 2 = 0) as a
    inner join
    (select c.* from t_child_a as c inner join t_parent_a as p on c.p_a = p.a where c.a % 3 = 0) as b
    on a.b = b.b;
show trace;

select /*+ recompile */
    a.*, b.*
from
    (select c.* from t_child_a as c, t_parent_a as p where c.p_a = p.a and c.a % 2 = 0) as a,
    (select c.* from t_child_a as c, t_parent_a as p where c.p_a = p.a and c.a % 3 = 0) as b
where
    a.b = b.b;
show trace;


/* 3. (no_merge t_child_a, t_parent_a), (no_merge t_child_a, t_parent_a) */
/* ansi‑style */
select /*+ recompile */
    a.*, b.*
from
    (select /* no_merge */ c.* from t_child_a as c inner join t_parent_a as p on c.p_a = p.a where c.a % 2 = 0) as a
    inner join
    (select /* no_merge */ c.* from t_child_a as c inner join t_parent_a as p on c.p_a = p.a where c.a % 3 = 0) as b
    on a.b = b.b;
show trace;

select /*+ recompile */
    a.*, b.*
from
    (select /* no_merge */ c.* from t_child_a as c, t_parent_a as p where c.p_a = p.a and c.a % 2 = 0) as a,
    (select /* no_merge */ c.* from t_child_a as c, t_parent_a as p where c.p_a = p.a and c.a % 3 = 0) as b
where
    a.b = b.b;
show trace;


/* 4. t_child_a, t_parent_a, t_parent_a + PT_RANGE (ansi‑style) */
/* ansi‑style */
select /*+ recompile ordered */
    c.*
from
    t_child_a as c
    inner join t_parent_a as pa on c.p_a = pa.a
    inner join t_parent_a as pb on c.p_a = pb.a
where
    pa.a = 7
    and pb.a in (6, 7, 8);
show trace;


/* ansi‑style */
select /*+ recompile ordered no_eliminate_join */
    c.*
from
    t_child_a as c
    inner join t_parent_a as pa on c.p_a = pa.a
    inner join t_parent_a as pb on c.p_a = pb.a
where
    pa.a = 7
    and pb.a in (6, 7, 8);
show trace;


/* 5. t_child_a, t_parent_a, t_parent_a + PT_RANGE */
select /*+ recompile ordered */
    c.*
from
    t_child_a as c,
    t_parent_a as pa,
    t_parent_a as pb
where
    c.p_a = pa.a
    and c.p_a = pb.a
    and pa.a = 7
    and pb.a in (6, 7, 8);
show trace;

select /*+ recompile ordered no_eliminate_join */
    c.*
from
    t_child_a as c,
    t_parent_a as pa,
    t_parent_a as pb
where
    c.p_a = pa.a
    and c.p_a = pb.a
    and pa.a = 7
    and pb.a in (6, 7, 8);
show trace;


/* 6. (t_child_a, t_parent_a) */
/* ansi‑style */
select /*+ recompile */
    t.*
from
    (
        select /* no_merge */
            c.*
        from
            t_child_a as c
            inner join t_parent_a as p on c.p_a = p.a
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
            t_child_a as c,
            t_parent_a as p
        where
            c.p_a = p.a
    ) as t
where
    t.p_a = 8;
show trace;


/* 7. (t_child_a, t_parent_a) + PT_RANGE */
/* ansi‑style */
select /*+ recompile */
    t.*
from
    (
        select /* no_merge */
            c.*
        from
            t_child_a as c
            inner join t_parent_a as p on c.p_a = p.a
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
            t_child_a as c,
            t_parent_a as p
        where
            c.p_a = p.a
    ) as t
where
    t.p_a > 8;
show trace;

set trace off;

drop table if exists t_child_a, t_child_b;
drop table if exists t_parent_a, t_parent_b;
