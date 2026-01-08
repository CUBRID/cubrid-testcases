-- Verifies the following issue: CBRD-26476
-- Tests UPDATE assignments using uncorrelated scalar subqueries that can include hidden columns
-- (e.g. ORDER BY columns) in the internal select list. The UPDATE executor must not mis-map
-- values due to hidden columns (no type mismatch errors / no crash), and must update correct values.

drop view if exists v2;
drop table if exists t1;
create table t1 (c1 numeric, c2 char(1), c3 bigint, c4 smallint);
insert into t1 values (1, 'n', -3, -4);

drop table if exists t2;
create table t2 (c5 numeric, c6 int, c7 bigint, c8 smallint);
insert into t2 values (3, 1, 7, -8);
insert into t2 values (4, 1, -7, 8);
insert into t2 values (3, 2, 70, -80);
insert into t2 values (4, 2, -70, 80);

create or replace view v2 as
select b.c7 from t2 b where b.c5 = 3 order by b.c6;

-- -----------------------------------------------------------------------------
-- Test #1 (inline view + rownum)
-- Previously (buggy builds): could error ("data overflow on data type \"smallint\"") or crash.
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
-- -----------------------------------------------------------------------------
evaluate '1. Inline view + rownum';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select c7 from (select b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select c8 from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;

select * from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------------------------------------------------------------------
-- Test #2 (view + rownum)
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
-- -----------------------------------------------------------------------------
evaluate '2. View + rownum';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select c7 from v2 where rownum = 1),
  a.c4 = (select c8 from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;

select * from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------------------------------------------------------------------
-- Test #3 (no_merge)
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
-- -----------------------------------------------------------------------------
evaluate '3. no_merge';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select c7 from (select /*+ no_merge */ b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select c8 from (select /*+ no_merge */ b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;

select * from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------------------------------------------------------------------
-- Test #4 (rownum -> limit)
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
-- -----------------------------------------------------------------------------
evaluate '4. limit';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select b.c7 from t2 b where b.c5 = 3 order by b.c6 limit 1),
  a.c4 = (select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1)
where
  a.c1 = 1;

select * from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------------------------------------------------------------------
-- Test #5 (correlated subquery)
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
-- -----------------------------------------------------------------------------
evaluate '5. correlated subquery';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select b.c7 from t2 b where b.c5 = a.c1 + 2 /* 3 */ order by b.c6 limit 1),
  a.c4 = (select b.c8 from t2 b where b.c5 = a.c1 + 3 /* 4 */ order by b.c6 limit 1)
where
  a.c1 = 1;

select * from t1;

-- Extra #1: increase hidden-column pressure by ordering on multiple columns not in select list
-- Expected: 1 row affected; same final values.
evaluate '6. Inline view ordered by multiple non-selected columns';
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (
    select c7
    from (
      select b.c7
      from t2 b
      where b.c5 = 3
      order by b.c6, b.c8
    )
    where rownum = 1
  ),
  a.c4 = (
    select c8
    from (
      select b.c8
      from t2 b
      where b.c5 = 4
      order by b.c6, b.c7
    )
    where rownum = 1
  )
where
  a.c1 = 1;

select * from t1;

-- Extra #2: multi-row update (same uncorrelated scalar subquery reused per updated row)
-- Expected: 2 rows affected; both rows updated consistently; no crash in repeated assignment loop.
evaluate '7. multi-row update using uncorrelated scalar subqueries';
delete from t1;
insert into t1 values (1, 'n', -3, -4);
insert into t1 values (2, 'n', -30, -40);

update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select b.c7 from t2 b where b.c5 = 3 order by b.c6 limit 1),
  a.c4 = (select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1);

select * from t1 order by c1;

-- Extra #3: scalar subquery returns NULL (no matching row) - should set to NULL without error
evaluate '8. scalar subquery returns NULL';
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select b.c7 from t2 b where b.c5 = 999 order by b.c6 limit 1),
  a.c4 = (select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1)
where
  a.c1 = 1;

select * from t1 where c1 = 1;

-- cleanup
drop view if exists v2;
drop table if exists t1;
drop table if exists t2;

--+ server-message off


