/* ----------------------------------------
 *
 * test case 35:
 *
 * 1. 'c.p_b = p.b' is missing [x]
 * 2. 'c.p_a = p.a' is missing [x]
 * 3. 'c.p_b = p.b' is missing but 'c.p_a = p.a' is redundant [x]
 * 4. 'c.p_a = p.a' and 'c.p_b = p.b' are redundant [o]
 * 5. 'c.p_a = p.a and c.p_b = p.a' is a mixed match [x]
 * 6. 'c.p_a = p.a and c.p_b = p.b and c.p_a = p.a and c.p_b = p.a' is a mixed match [x]
 *
 * ---------------------------------------- */

drop table if exists t_child;
drop table if exists t_parent;
create table t_parent (a int, b int, c int, primary key (a, b));
create table t_child (a int auto_increment primary key, b int);
alter table t_child add column p_a int; /* null */
alter table t_child add column p_b int; /* null */
alter table t_child add constraint foreign key (p_a, p_b) references t_parent (a, b);
insert into t_parent values (1, 1, 1), (2, 2, 2), (3, 3, 3);
insert into t_child select null, (b * -1), a, NULL from t_parent;
insert into t_child select null, (b * -1) * 10, NULL, b from t_parent;
insert into t_child select null, (b * -1) * 100, a, b from t_parent;
update statistics on t_child, t_parent with fullscan;

set trace on;


/* 1. 'c.p_b = p.b' is missing */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a;
show trace;


/* 2. 'c.p_a = p.a' is missing */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_b = p.b;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_b = p.b;
show trace;


/* 3. 'c.p_b = p.b' is missing but 'c.p_a = p.a' is redundant */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_a = p.a;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_a = p.a;
show trace;


/* 4. 'c.p_a = p.a' and 'c.p_b = p.b' are redundant */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b and c.p_a = p.a and c.p_b = p.b;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b and c.p_a = p.a and c.p_b = p.b;
show trace;


/* 5. 'c.p_a = p.a and c.p_b = p.a' is a mixed match */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.a;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.a;
show trace;


/* 6. 'c.p_a = p.a and c.p_b = p.b and c.p_a = p.a and c.p_b = p.a' is a mixed match */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b and c.p_a = p.a and c.p_b = p.a;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b and c.p_a = p.a and c.p_b = p.a;
show trace;


set trace off;
drop table if exists t_child;
drop table if exists t_parent;

