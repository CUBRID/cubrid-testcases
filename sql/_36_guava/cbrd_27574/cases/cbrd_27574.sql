/*
 * CBRD-27574: x NOT IN (subquery) and x <> ALL (subquery) are TRUE when the
 * subquery returns no row, even when x is NULL. Three compile-time shortcuts
 * dropped such rows:
 *   1. 'a IS NULL AND a NOT IN (subquery)' was folded to FALSE (and
 *      'a IS NOT NULL AND a NOT IN (subquery)' dropped the IS NOT NULL).
 *   2. 'NULL NOT IN (subquery)' was folded to NULL at compile time, which also
 *      hit NULL constant columns of derived tables, views and CTEs.
 *   3. A path expression whose reference is NULL was turned into an inner path
 *      join because of 2.
 * Non-empty subqueries and literal lists keep the UNKNOWN semantics.
 */

drop table if exists t_27574_p, t_27574_a, t_27574_e, t_27574_n, t_27574_x;
drop view if exists v_27574;

create table t_27574_a (a int, b int) dont_reuse_oid;
create table t_27574_e (a int, b int);
create table t_27574_n (a int, b int);
create table t_27574_x (a int, b int);
create table t_27574_p (a int, r t_27574_a);

insert into t_27574_a values (1, null), (2, 10), (3, 20);
insert into t_27574_n values (1, 20), (2, 30);
insert into t_27574_x values (2, 5), (3, null);
insert into t_27574_p (a, r) values (1, null);
insert into t_27574_p (a, r) select 2, x from t_27574_a x where x.a = 1;
insert into t_27574_p (a, r) select 3, x from t_27574_a x where x.a = 2;
create view v_27574 as select a, cast (null as int) as c from t_27574_a;

-- 1. IS NULL / IS NOT NULL combined with NOT IN or <> ALL on an empty subquery
select a from t_27574_a where b is null and b not in (select b from t_27574_e) order by 1;
select a from t_27574_a where b is null and b <> all (select b from t_27574_e) order by 1;
select a from t_27574_a where b is null and b not in (select /*+ NO_UNNEST */ b from t_27574_e) order by 1;
select a from t_27574_a where b is null and b <> all (select b from t_27574_e e where e.a = t_27574_a.a) order by 1;
select a from t_27574_a where b is not null and b not in (select b from t_27574_e) order by 1;
select a from t_27574_a where b is null and b not in (select b from t_27574_e) and b < 100 order by 1;
select a from t_27574_a where not (b is null and b not in (select b from t_27574_e)) order by 1;
update t_27574_a set a = a where b is null and b not in (select b from t_27574_e);

-- 2. NULL constant on the left of NOT IN, <> ALL, NOT (IN), IN, = SOME, = ALL
select count (*) from db_root where null not in (select b from t_27574_e);
select a from t_27574_a where null not in (select b from t_27574_e) order by 1;
select count (*) from db_root where null <> all (select b from t_27574_e);
select count (*) from db_root where not (null in (select b from t_27574_e));
select count (*) from db_root where (null in (select b from t_27574_e)) is false;
select count (*) from db_root where null = some (select b from t_27574_e);
select count (*) from db_root where null = all (select b from t_27574_e);
select (null not in (select b from t_27574_e)) e1, (null in (select b from t_27574_e)) e2, (null not in (select b from t_27574_n)) n1, (null in (select b from t_27574_n)) n2 from db_root;
select case when null not in (select b from t_27574_e) then 'empty' else 'not empty' end from db_root;
select a from (select a, cast (null as int) as c from t_27574_a) v where v.c not in (select b from t_27574_e) order by 1;
select a from v_27574 where c not in (select b from t_27574_e) order by 1;
with w as (select a, cast (null as int) as c from t_27574_a) select a from w where c not in (select b from t_27574_e) order by 1;

-- 3. path expression whose reference is NULL
select a from t_27574_p where r.a not in (select b from t_27574_e) order by 1;
select a from t_27574_p where r.a not in (select b from t_27574_e e where e.a = t_27574_p.a) order by 1;
select a from t_27574_p where r.b not in (select b from t_27574_e) order by 1;

-- cases that were already right and must stay so
select a from t_27574_a where b not in (select b from t_27574_e) order by 1;
select a from t_27574_a where b is null and b not in (select b from t_27574_e where 1 = 0) order by 1;
select count (*) from db_root where null not in (select b from t_27574_e where 1 = 0);
select t_27574_a.a from t_27574_a left join t_27574_x x on x.a = t_27574_a.a where x.b not in (select b from t_27574_e) order by 1;
select t_27574_a.a from t_27574_a left join t_27574_x x on x.a = t_27574_a.a where x.b <> all (select b from t_27574_e) order by 1;
select a from t_27574_a where b is null or b not in (select b from t_27574_e) order by 1;

-- non-empty subqueries and literal lists: NULL on the left stays UNKNOWN
select a from t_27574_a where b is null and b not in (select b from t_27574_n) order by 1;
select a from t_27574_a where b not in (select b from t_27574_n) order by 1;
select count (*) from db_root where null not in (select b from t_27574_n);
select count (*) from db_root where null <> all (select b from t_27574_n);
select a from t_27574_p where r.a not in (select b from t_27574_n) order by 1;
select a from t_27574_p where r.b not in (select b from t_27574_n) order by 1;
select count (*) from db_root where null not in (1, 2);
select a from t_27574_a where b is null and b not in (1, 2) order by 1;
select a from t_27574_a where b is null and b in (select b from t_27574_e) order by 1;

drop view v_27574;
drop table t_27574_p, t_27574_a, t_27574_e, t_27574_n, t_27574_x;
