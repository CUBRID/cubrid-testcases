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
 * 12. 'c.p_a <> 1' -> pt_lambda_node() -> 'p.a <> 1' [o]
 *     'c.p_a != 1' -> pt_lambda_node() -> 'p.a != 1' [o]
 * 13. 'c.p_a like 1' -> pt_lambda_node() -> 'p.a like 1' [o]
 * 14. 'p.a = 4' -> pt_lambda_node() -> 'c.p_a = 4' group by c.b [o]
 * 15. 'p.a = 4' -> pt_lambda_node() -> 'c.p_a = 4' group by c.b having count(*) > 2 [o]
 * 16.  count(*) over ( PARTITION BY c.b ORDER BY c.a DESC) AS cnt 
 * 17.  count(*) over ( PARTITION BY p.b ORDER BY p.a DESC) AS cnt 
 * 18.  count(*) over ( PARTITION BY c.b ORDER BY p.a DESC) AS cnt 
 * 19. 'EXISTS (select a from t_parent where a = c.p_a and b = c.p_b )'
 * 20. 'NOT EXISTS (select a from t_parent where a = c.p_a and b = c.p_b )'
 * 21. scalar subquery 
 * 22. scalar subquery 
 * 23. 'connect by prior c.a=c.b' 
 * 24. union all 
 * 25. order by p.a
 * 26. order by c.a
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


/* 12. 'c.p_a <> 1' -> pt_lambda_node() -> 'p.a <> 1' */
/*     'c.p_a != 1' -> pt_lambda_node() -> 'p.a != 1' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    c.p_a <> 1;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and c.p_a <> 1;
show trace;

/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    c.p_a != 1;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and c.p_a != 1;
show trace;


/* 13. 'c.p_a <> 1' -> pt_lambda_node() -> 'p.a <> 1' */
/*     'c.p_a != 1' -> pt_lambda_node() -> 'p.a != 1' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    c.p_a like 1;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and c.p_a like 1;
show trace;


/* 14. 'p.a = 4' -> pt_lambda_node() -> 'c.p_a = 4' group by c.b */
/* ansi‑style */
select /*+ recompile */
    c.b, count(*), min(c.p_a), max(c.p_b)
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a = 4
group by c.b;
show trace;

select /*+ recompile */
    c.b, count(*), min(c.p_a), max(c.p_b)
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a = 4
group by c.b;
show trace;


/* 15. 'p.a = 4' -> pt_lambda_node() -> 'c.p_a = 4' group by c.b having count(*) > 2 */
/* ansi‑style */
select /*+ recompile */
    c.b, count(*), min(c.p_a), max(c.p_b)
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    p.a = 4
group by c.b
having count(*) >2;
show trace;

select /*+ recompile */
    c.b, count(*), min(c.p_a), max(c.p_b)
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and p.a = 4
group by c.b
having count(*) >2;
show trace;


/* 16. count(*) over ( PARTITION BY c.b ORDER BY c.a DESC) */
/* ansi‑style */
select /*+ recompile */
    c.*, count(*) over ( PARTITION BY c.b ORDER BY c.a DESC) AS cnt
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b;
show trace;

select /*+ recompile */
    c.*, count(*) over ( PARTITION BY c.b ORDER BY c.a DESC) AS cnt
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b;
show trace;


/* 17. count(*) over ( PARTITION BY p.b ORDER BY p.a DESC) */
/* ansi‑style */
select /*+ recompile */
    c.*, count(*) over ( PARTITION BY p.b ORDER BY p.a DESC) AS cnt
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b;
show trace;

select /*+ recompile */
    c.*, count(*) over ( PARTITION BY p.b ORDER BY p.a DESC) AS cnt
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b;
show trace;


/* 18. count(*) over ( PARTITION BY c.b ORDER BY p.a DESC) */
/* ansi‑style */
select /*+ recompile */
    c.*, count(*) over ( PARTITION BY c.b ORDER BY p.a DESC) AS cnt
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b;
show trace;

select /*+ recompile */
    c.*, count(*) over ( PARTITION BY c.b ORDER BY p.a DESC) AS cnt
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b;
show trace;


/* 19. 'EXISTS (select a from t_parent where a = c.p_a and b = c.p_b )' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    EXISTS (select p.a from t_parent as p, t_child as c where p.a = c.p_a and p.b = c.p_b );
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and EXISTS (select p.a from t_parent as p, t_child as c where p.a = c.p_a and p.b = c.p_b );
show trace;


/* 20. 'NOT EXISTS (select a from t_parent where a = c.p_a and b = c.p_b )' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    NOT EXISTS (select p.a from t_parent as p, t_child as c where p.a = c.p_a and p.b = c.p_b );
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and NOT EXISTS (select p.a from t_parent as p, t_child as c where p.a = c.p_a and p.b = c.p_b );
show trace;


/* 21. scala subquery */
/* ansi‑style */
select /*+ recompile */
    c.*,
    (select cc.a from t_child cc where cc.p_a=p.a and cc.p_b=p.b limit 1) chk_scala_x
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    c.p_a = 1;
show trace;

select /*+ recompile */
    c.*,
    (select cc.a from t_child cc where cc.p_a=p.a and cc.p_b=p.b limit 1) chk_scala_x
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and c.p_a = 1;
show trace;


/* 22. scala subquery */
/* ansi‑style */
select /*+ recompile */
    c.*,
    ( select pp.a from t_parent pp, t_child c where pp.a=c.a and pp.b=c.b limit 1 ) chk_scala_o
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
where
    c.p_a = 1;
show trace;

select /*+ recompile */
    c.*,
    ( select pp.a from t_parent pp, t_child c where pp.a=c.a and pp.b=c.b limit 1 ) chk_scala_o
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
    and c.p_a = 1;
show trace;


/* 23. connect by prior c.a = c.b */
/* ansi‑style */
select /*+ recompile */
    c.*,
    level
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
connect by prior c.a = c.b;
show trace;

select /*+ recompile */
    c.*,
    level
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
connect by prior c.a = c.b;
show trace;


/* 24. union all */
WITH
of_ooooo AS 
( select /*+ recompile */ 
	'ooooo', c.*
  from t_child as c, t_parent as p
  where c.p_a = p.a and c.p_b = p.b
  and c.p_a = 1 ),
of_xxxxx AS
( select /*+ recompile */ 
	'xxxxx', c.*
  from t_child as c, t_parent as p
  where c.p_a = p.a and c.p_b = p.b
  and p.a >= 8)
SELECT * FROM of_ooooo
UNION ALL
SELECT * FROM of_xxxxx
ORDER BY 1;
show trace;


/* 25. 'order by p.a' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
order by p.a;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
order by p.a;
show trace;


/* 25. 'order by c.a' */
/* ansi‑style */
select /*+ recompile */
    c.*
from
    t_parent as p
    inner join t_child as c on c.p_a = p.a and c.p_b = p.b
order by c.a;
show trace;

select /*+ recompile */
    c.*
from
    t_child as c,
    t_parent as p
where
    c.p_a = p.a and c.p_b = p.b
order by c.a;
show trace;



set trace off;

drop table if exists t_child;
drop table if exists t_parent;
