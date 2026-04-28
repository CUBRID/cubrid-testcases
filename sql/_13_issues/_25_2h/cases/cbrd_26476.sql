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

create or replace view v2 as
select b.c7 from t2 b where b.c5 = 3 order by b.c6;

-- -----------------------
-- General Tests
-- -----------------------

-- Previously (buggy builds): could error ("data overflow on data type \"smallint\"") or crash.
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
evaluate '1. Inline view + rownum';

update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select c7 from (select b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select c8 from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;

select c1, c2, c3, c4 from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
evaluate '2. View + rownum';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select c7 from v2 where rownum = 1),
  a.c4 = (select c8 from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;

select c1, c2, c3, c4 from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
evaluate '3. no_merge';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select c7 from (select /*+ no_merge */ b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select c8 from (select /*+ no_merge */ b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;

select c1, c2, c3, c4 from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
evaluate '4. limit';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select b.c7 from t2 b where b.c5 = 3 order by b.c6 limit 1),
  a.c4 = (select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1)
where
  a.c1 = 1;

select c1, c2, c3, c4 from t1;

-- reset
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
evaluate '5. correlated subquery';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select b.c7 from t2 b where b.c5 = a.c1 + 2 /* 3 */ order by b.c6 limit 1),
  a.c4 = (select b.c8 from t2 b where b.c5 = a.c1 + 3 /* 4 */ order by b.c6 limit 1)
where
  a.c1 = 1;

select c1, c2, c3, c4 from t1;

-- Increase hidden-column pressure by ordering on multiple columns not in select list
-- Expected: 1 row affected; t1 updated to (c2='y', c3=7, c4=8).
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

select c1, c2, c3, c4 from t1;

-- Multi-row update (same uncorrelated scalar subquery reused per updated row)
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

select c1, c2, c3, c4 from t1 order by c1;

-- Scalar subquery returns NULL (no matching row) - should set to NULL without error
-- Expected: 1 row affected; t1 updated to (c2='y', c3=NULL, c4=8).
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

select c1, c2, c3, c4 from t1 where c1 = 1;

-- -----------------------
-- Constant value handling
-- -----------------------

delete from t1;
insert into t1 values (1, 'n', -3, -4);

evaluate '9. constant value #1 (select constant from inline view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select 50 from (select b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select 100 from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '10. constant value #2 (tmp_col in inline view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select b.c7, 200 tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select tmp_col from (select b.c8, 300 tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '11. constant value #2 (tmp_col + view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select c7, 200 tmp_col from v2) where rownum = 1),
  a.c4 = (select tmp_col from (select b.c8, 300 tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '12. constant value #2 (tmp_col + no_merge + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select /*+ no_merge */ b.c7, 200 tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select tmp_col from (select /*+ no_merge */ b.c8, 300 tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '13. constant value #2 (tmp_col + limit)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select b.c7, 200 tmp_col from t2 b where b.c5 = 3 order by b.c6) t limit 1),
  a.c4 = (select tmp_col from (select b.c8, 300 tmp_col from t2 b where b.c5 = 4 order by b.c6) t limit 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '14. constant value #2 (tmp_col + correlated subquery + limit)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select b.c7, 200 tmp_col from t2 b where b.c5 = a.c1 + 2 /* 3 */ order by b.c6) t limit 1),
  a.c4 = (select tmp_col from (select b.c8, 300 tmp_col from t2 b where b.c5 = a.c1 + 3 /* 4 */ order by b.c6) t limit 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- ----------------------
-- Binding value handling
-- ----------------------

evaluate '15. bind value #1 (select bind from inline view + rownum)';
prepare u15 from
  'update /*+ recompile */ t1 a set a.c2 = ''y'', a.c3 = (select ? from (select b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1), a.c4 = (select ? from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1) where a.c1 = 1';
execute u15 using 555, 66;
deallocate prepare u15;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '16. bind value #2 (tmp_col bind in inline view + rownum)';
prepare u16 from
  'update /*+ recompile */ t1 a set a.c2 = ''y'', a.c3 = (select tmp_col from (select b.c7, ? tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1), a.c4 = (select tmp_col from (select b.c8, ? tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1) where a.c1 = 1';
execute u16 using 777, 88;
deallocate prepare u16;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '17. bind value #2 (tmp_col bind + view + rownum)';
prepare u17 from
  'update /*+ recompile */ t1 a set a.c2 = ''y'', a.c3 = (select tmp_col from (select c7, ? tmp_col from v2) where rownum = 1), a.c4 = (select tmp_col from (select b.c8, ? tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1) where a.c1 = 1';
execute u17 using 777, 88;
deallocate prepare u17;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '18. bind value #2 (tmp_col bind + no_merge + rownum)';
prepare u18 from
  'update /*+ recompile */ t1 a set a.c2 = ''y'', a.c3 = (select tmp_col from (select /*+ no_merge */ b.c7, ? tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1), a.c4 = (select tmp_col from (select /*+ no_merge */ b.c8, ? tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1) where a.c1 = 1';
execute u18 using 777, 88;
deallocate prepare u18;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '19. bind value #2 (tmp_col bind + limit)';
prepare u19 from
  'update /*+ recompile */ t1 a set a.c2 = ''y'', a.c3 = (select tmp_col from (select b.c7, ? tmp_col from t2 b where b.c5 = 3 order by b.c6) t limit 1), a.c4 = (select tmp_col from (select b.c8, ? tmp_col from t2 b where b.c5 = 4 order by b.c6) t limit 1) where a.c1 = 1';
execute u19 using 777, 88;
deallocate prepare u19;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '20. bind value #2 (tmp_col bind + correlated subquery + limit)';
prepare u20 from
  'update /*+ recompile */ t1 a set a.c2 = ''y'', a.c3 = (select tmp_col from (select b.c7, ? tmp_col from t2 b where b.c5 = a.c1 + 2 /* 3 */ order by b.c6) t limit 1), a.c4 = (select tmp_col from (select b.c8, ? tmp_col from t2 b where b.c5 = a.c1 + 3 /* 4 */ order by b.c6) t limit 1) where a.c1 = 1';
execute u20 using 777, 88;
deallocate prepare u20;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------
-- Function handling
-- -----------------

evaluate '21. function #1 (function in scalar subquery)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select nvl(null, 300) from (select b.c7 from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select sign(c8) from (select b.c8 from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '22. function #2 (tmp_col function in inline view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select sign(b.c7) tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select tmp_col from (select sign(b.c8) tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '23. function #2 (tmp_col function + view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select sign(c7) tmp_col from v2) where rownum = 1),
  a.c4 = (select tmp_col from (select sign(b.c8) tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '24. function #2 (tmp_col function + no_merge + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select /*+ no_merge */ sign(b.c7) tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select tmp_col from (select /*+ no_merge */ sign(b.c8) tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '25. function #2 (tmp_col function + limit)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select sign(b.c7) tmp_col from t2 b where b.c5 = 3 order by b.c6) t limit 1),
  a.c4 = (select tmp_col from (select sign(b.c8) tmp_col from t2 b where b.c5 = 4 order by b.c6) t limit 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '26. function #2 (tmp_col function + correlated subquery + limit)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select sign(b.c7) tmp_col from t2 b where b.c5 = a.c1 + 2 /* 3 */ order by b.c6) t limit 1),
  a.c4 = (select tmp_col from (select sign(b.c8) tmp_col from t2 b where b.c5 = a.c1 + 3 /* 4 */ order by b.c6) t limit 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------------------------------------------------------------------
-- Multi-argument function handling (DECODE)
-- -----------------------------------------------------------------------------

-- Note: Use expressions where the argument column is not separately projected in the select list.

evaluate '27. decode() #1 (inline view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select decode(b.c7, 7, 10, 70, 20, b.c8) tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select tmp_col from (select decode(b.c8, 8, 12, -8, 34, 56) tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select * from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '28. decode() #2 (view + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select decode(c7, 7, 10, 70, 20, 30) tmp_col from v2) where rownum = 1),
  a.c4 = (select tmp_col from (select decode(b.c8, 8, 12, -8, 34, 56) tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '29. decode() #3 (no_merge + rownum)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select /*+ no_merge */ decode(b.c7, 7, 10, 70, 20, b.c8) tmp_col from t2 b where b.c5 = 3 order by b.c6) where rownum = 1),
  a.c4 = (select tmp_col from (select /*+ no_merge */ decode(b.c8, 8, 12, -8, 34, 56) tmp_col from t2 b where b.c5 = 4 order by b.c6) where rownum = 1)
where
  a.c1 = 1;
select * from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '30. decode() #4 (limit)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select decode(b.c7, 7, 10, 70, 20, b.c8) tmp_col from t2 b where b.c5 = 3 order by b.c6) t limit 1),
  a.c4 = (select tmp_col from (select decode(b.c8, 8, 12, -8, 34, 56) tmp_col from t2 b where b.c5 = 4 order by b.c6) t limit 1)
where
  a.c1 = 1;
select * from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

evaluate '31. decode() #5 (correlated subquery + limit)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (select tmp_col from (select decode(b.c7, 7, 10, 70, 20, b.c8) tmp_col from t2 b where b.c5 = a.c1 + 2 /* 3 */ order by b.c6) t limit 1),
  a.c4 = (select tmp_col from (select decode(b.c8, 8, 12, -8, 34, 56) tmp_col from t2 b where b.c5 = a.c1 + 3 /* 4 */ order by b.c6) t limit 1)
where
  a.c1 = 1;
select c1, c2, c3, c4 from t1;
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- -----------------------------------------------------------------------------
-- GROUP BY handling
-- -----------------------------------------------------------------------------

-- Keep ORDER BY column out of select list (hidden-column risk) but make query valid via aggregate
evaluate '32. group by + order by (aggregate select, order by grouped column)';
update /*+ recompile */
  t1 a
set
  a.c2 = 'y',
  a.c3 = (
    select max_c7
    from (
      select max(b.c7) as max_c7
      from t2 b
      where b.c5 = 3
      group by b.c6
      order by b.c6
    )
    where rownum = 1
  ),
  a.c4 = (
    select max_c8
    from (
      select max(b.c8) as max_c8
      from t2 b
      where b.c5 = 4
      group by b.c6
      order by b.c6
    )
    where rownum = 1
  )
where
  a.c1 = 1;

select c1, c2, c3, c4 from t1;

-- Multi-column SET from scalar subquery (tuple assignment)
evaluate '33. multi-column set (c3,c4) = (select ...) with ORDER BY hidden cols';
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

update /*+ recompile */ t1 a
set    a.c2 = 'y'
     , (a.c3, a.c4) = (select c7, c8
                       from (select b.c7, b.c8
                             from   t2 b
                             where  b.c5 in (3, 4)
                             order by b.c6, b.c5
                           )
                     where rownum = 1
                   )
where a.c1 = 1;

select * from t1;

-- Scalar subquery returns more than one row (should error, must not crash)
evaluate '34. scalar subquery returns more than one row (must error, no crash)';
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;
-- This subquery returns 2 rows because b.c5 = 3 has two rows (c6=1 and c6=2)
-- expected: error (subquery returns more than one row)

update /*+ recompile */ t1 a
set    a.c2 = 'y'
     , a.c3 = (select b.c7 from t2 b where b.c5 = 3 order by b.c6)
     , a.c4 = (select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1)
where  a.c1 = 1;

update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

-- LIMIT with OFFSET in scalar subquery (mapping stability)
evaluate '35. scalar subquery with LIMIT offset (2nd row)';
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

update /*+ recompile */ t1 a
set    a.c2 = 'y'
     , a.c3 = (select b.c7 from t2 b where b.c5 = 3 order by b.c6 limit 1, 1)
     , a.c4 = (select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1)
where  a.c1 = 1;

select * from t1;
-- Same scalar subquery reused in multiple assignments
evaluate '36. reuse same scalar subquery expression across multiple assignments';
update t1 set c2 = 'n', c3 = -3, c4 = -4 where c1 = 1;

update /*+ recompile */ t1 a
set    a.c2 = 'y'
     , a.c3 = (select b.c7 from t2 b where b.c5 = 3 order by b.c6 limit 1)
     , a.c4 = (select cast((select b.c8 from t2 b where b.c5 = 4 order by b.c6 limit 1) as smallint))
where  a.c1 = 1;
select c1, c2, c3, c4 from t1;

--When the ORDER BY expression is not in the select list.
evaluate '37. ORDER BY expression';
update t1 set c2='n', c3=-3, c4=-4 where c1=1;

update /*+ recompile */ t1 a
set    a.c2='y'
     , a.c3 = (select c7 from (select b.c7 from t2 b where b.c5=3 order by abs(b.c7)) where rownum=1)
     , a.c4 = (select c8 from (select b.c8 from t2 b where b.c5=4 order by abs(b.c8)) where rownum=1)
where a.c1=1;

select c1,c2,c3,c4 from t1;

--DISTINCT + ORDER BY (hidden column + distinct execution path) in inline view
evaluate '38. DISTINCT + ORDER BY (hidden cols + distinct path)';
update t1 set c2='n', c3=-3, c4=-4 where c1=1;

update /*+ recompile */ t1 a
set    a.c2='y'
     , a.c3 = (select c7 from (select distinct b.c7 from t2 b where b.c5=3 limit 1) where rownum=1)
     , a.c4 = (select c8 from (select distinct b.c8 from t2 b where b.c5=4 limit 1) where rownum=1)
where a.c1=1;
select c1,c2,c3,c4 from t1;

--A scalar subquery inside another scalar subquery (nested)
evaluate '39. Nested scalar subquery inside scalar subquery';
update t1 set c2='n', c3=-3, c4=-4 where c1=1;

update /*+ recompile */ t1 a
set    a.c2='y'
     , a.c3 = (select (select b.c7 from t2 b where b.c5=3 order by b.c6 limit 1) from dual)
     , a.c4 = (select (select b.c8 from t2 b where b.c5=4 order by b.c6 limit 1) from dual)
where a.c1=1;
select c1,c2,c3,c4 from t1;

--In UPDATE, the set clause subquery contains UNION ALL
evaluate '40. Scalar subquery with UNION ALL';
update t1 set c2='n', c3=-3, c4=-4 where c1=1;

update /*+ recompile */ t1 a
set    a.c2='y'
     , a.c3 = (select x.c7 
               from (select b.c7, b.c6 from t2 b where b.c5=3
                     union all
                     select b.c7, b.c6 from t2 b where b.c5=3
                    ) x
               order by x.c6
               limit 1)
     , a.c4 = (select b.c8 from t2 b where b.c5=4 order by b.c6 limit 1)
where a.c1=1;
select c1,c2,c3,c4 from t1;

--Prepared statement repeat execution
evaluate '41. Prepared statement repeated execution';
update t1 set c2='n', c3=-3, c4=-4 where c1=1;

prepare u41 from
'update /*+ recompile */ t1 a
 set    a.c2 = ''y''
      , a.c3 = (select c7 from (select b.c7 from t2 b where b.c5=3 order by b.c6) where rownum=1)
      , a.c4 = (select c8 from (select b.c8 from t2 b where b.c5=4 order by b.c6) where rownum=1)
where a.c1 = 1';
execute u41;
execute u41;
execute u41;
deallocate prepare u41;
select c1,c2,c3,c4 from t1;

-- cleanup
drop view if exists v2;
drop table if exists t1;
drop table if exists t2;

