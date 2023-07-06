/* ----------------------------------------
 *
 * test case 36:
 *
 * 1. 'c.p_a = 1' -> pt_lambda_node() -> 'p.a = 1' [o]
 * 2. 'p.a = 2' -> pt_lambda_node() -> 'c.p_a = 2' [o]
 * 3. 'p.a = 3 and p.b = 3' -> pt_lambda_node() -> 'c.p_a = 3 and c.p_b = 3' [o]
 * 4. 'p.a > 3 and p.a = 4' -> pt_lambda_node() -> 'c.p_a = 4' [o]
 * 5. '(c.p_a = 5 or c.p_b = 5)' [o]
 * 6. '(p.a = 6 or p.b = 6)' [x]
 * 7. 'p.a = cast (7 as numeric (1, 0))' [o]
 * 8. 'p.a >= 8' [x]
 * 9. 'p.a in (1, 3, 5, 7, 9)' [x]
 * 10. 'p.a between 2 and 4' [x]
 * 11. 'p.a = (select a from t_parent order by a desc limit 1)' [x]
 *
 * ---------------------------------------- */

drop table if exists t_child;
drop table if exists t_parent;
create table t_parent (a int, b int, c int, primary key (a, b));
create table t_child (a int auto_increment primary key, b int);
alter table t_child add column p_a int; /* null */
alter table t_child add column p_b int; /* null */
alter table t_child add constraint foreign key (p_a, p_b) references t_parent (a, b);
insert into t_parent values (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5), (6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9);
insert into t_child select null, (b * -1), a, NULL from t_parent;
insert into t_child select null, (b * -1) * 10, NULL, b from t_parent;
insert into t_child select null, (b * -1) * 100, a, b from t_parent;
update statistics on t_child, t_parent with fullscan;

set trace on;


/* 1. 'c.p_a = 1' -> pt_lambda_node() -> 'p.a = 1' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    c.p_a = 1;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and c.p_a = 1;
show trace;


/* 2. 'p.a = 2' -> pt_lambda_node() -> 'c.p_a = 2' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a = 2;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a = 2;
show trace;


/* 3. 'p.a = 3 and p.b = 3' -> pt_lambda_node() -> 'c.p_a = 3 and c.p_b = 3' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a = 3 and p.b = 3;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a = 3 and p.b = 3;
show trace;


/* 4. 'p.a > 3 and p.a = 4' -> pt_lambda_node() -> 'c.p_a = 4' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a > 3 and p.a = 4;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a > 3 and p.a = 4;
show trace;


/* 5. '(c.p_a = 5 or c.p_b = 5)' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    (c.p_a = 5 or c.p_b = 5);
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and (c.p_a = 5 or c.p_b = 5);
show trace;


/* 6. '(p.a = 6 or p.b = 6)' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    (p.a = 6 or p.b = 6);
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and (p.a = 6 or p.b = 6);
show trace;


/* 7. 'p.a = cast (7 as numeric (1, 0))' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a = cast (7 as numeric (1, 0));
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a = cast (7 as numeric (1, 0));
show trace;


/* 8. 'p.a >= 8' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a >= 8;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a >= 8;
show trace;


/* 9. 'p.a in (1, 3, 5, 7, 9)' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a in (1, 3, 5, 7, 9);
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a in (1, 3, 5, 7, 9);
show trace;


/* 10. 'p.a between 2 and 4' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a between 2 and 4;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a between 2 and 4;
show trace;


/* 11. 'p.a = (select a from t_parent order by a desc limit 1)' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a = (select a from t_parent order by a desc limit 1);
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a = (select a from t_parent order by a desc limit 1);
show trace;

set trace off;

drop table if exists t_child;
drop table if exists t_parent;
