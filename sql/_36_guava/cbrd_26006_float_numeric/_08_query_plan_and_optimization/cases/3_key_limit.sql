-- 3_key_limit: Numeric key limit optimization (rownum with huge NUMERIC values)

evaluate '1. Numeric key limit optimization: rownum with huge NUMERIC values';
-- setup
drop table if exists t;
create table t (id int, a varchar(20));
insert into t values (1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e'),(6,'f'),(7,'g'),(8,'h'),(9,'i'),(10,'j');
create index i_t_all on t(id, a);

evaluate '1-1. rownum > -HUGE (one-sided, negative-huge lower; key limit dropped -> return all rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum > -10000000000000000000000000000000000000000000000;
-- Expected: 10 rows

evaluate '1-2. rownum >= -HUGE (one-sided, negative-huge lower; key limit dropped -> return all rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum >= -10000000000000000000000000000000000000000000000;
-- Expected: 10 rows

evaluate '1-3. rownum < -HUGE (one-sided, negative-huge upper -> key_limit_upper = 0 -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum < -10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-4. rownum <= -HUGE (one-sided, negative-huge upper -> key_limit_upper = 0 -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum <= -10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-5. rownum > +HUGE (one-sided, positive-huge lower; key limit dropped -> rownum predicate false -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum > 10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-6. rownum >= +HUGE (one-sided, positive-huge lower; key limit dropped -> rownum predicate false -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum >= 10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-7. rownum < +HUGE (one-sided, positive-huge upper -> key_limit_upper = -1 -> return all rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum < 10000000000000000000000000000000000000000000000;
-- Expected: 10 rows

evaluate '1-8. rownum <= +HUGE (one-sided, positive-huge upper -> key_limit_upper = -1 -> return all rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum <= 10000000000000000000000000000000000000000000000;
-- Expected: 10 rows

evaluate '1-9. 5 < rownum AND rownum < +HUGE (two-sided, upper overflow -> no upper bound -> all rows after rownum > 5)';
select /*+ recompile */ id, a from t where id > 0 and 5 < rownum and rownum < 10000000000000000000000000000000000000000000000;
-- Expected: 5 rows (rownum 6..10)

evaluate '1-10. -HUGE <= rownum AND rownum <= 5 (two-sided, lower overflow -> key_limit_lower = 0 -> 5 rows)';
select /*+ recompile */ id, a from t where id > 0 and -10000000000000000000000000000000000000000000000 <= rownum and rownum <= 5;
-- Expected: 5 rows (rownum 1..5)

evaluate '1-11. 5 <= rownum AND rownum <= +HUGE (two-sided, upper overflow -> no upper bound -> all rows from rownum >= 5)';
select /*+ recompile */ id, a from t where id > 0 and 5 <= rownum and rownum <= 10000000000000000000000000000000000000000000000;
-- Expected: 6 rows (rownum 5..10)

evaluate '1-12. rownum = +HUGE (lower = BIGINT_MAX / upper = -1 -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum = 10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-13. rownum = -HUGE (both lower and upper = 0 -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum = -10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-14. -HUGE < rownum AND rownum < 5 (case1: left=INARITH fetch succeeds -> 4 rows)';
select /*+ recompile */ id, a from t where id > 0 and -10000000000000000000000000000000000000000000000 < rownum and rownum < 5;
-- Expected: 4 rows (rownum 1..4)
select /*+ recompile */ id, a from t where id > 0 and rownum between -10000000000000000000000000000000000000000000000 and cast(5 as short);
-- Expected: 5 rows (rownum 1..5)

evaluate '1-15. rownum BETWEEN -HUGE AND 5 (case2: left=POS_VALUE[int] fetch succeeds -> 5 rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum between -10000000000000000000000000000000000000000000000 and 5;
-- Expected: 5 rows (rownum 1..5)

evaluate '1-16. (BIGINT or -HUGE) < rownum AND rownum < HUGE (case3: two-sided overflow, positive sign -> 0 rows)';
select /*+ recompile */ id, a from t where id > 0 and 1000000000000000000 < rownum and rownum < 10000000000000000000000000000000000000000000001;
-- Expected: 0 rows
select /*+ recompile */ id, a from t where id > 0 and -10000000000000000000000000000000000000000000 < rownum and rownum < 10000000000000000000000000000000000000000000001;
-- Expected: 10 rows

evaluate '1-17. rownum BETWEEN (BIGINT or -HUGE) AND HUGE (case4: lower overflow -> 0, upper overflow -> -1 -> return all rows)';
select /*+ recompile */ id, a from t where id > 0 and rownum between 1000000000000000000 and 10000000000000000000000000000000000000000000000;
-- Expected: 0 rows
select /*+ recompile */ id, a from t where id > 0 and rownum between -10000000000000000000000000000000000000000000 and 10000000000000000000000000000000000000000000000;
-- Expected: 10 rows

evaluate '1-18. rownum predicate within BIGINT range (existing behavior preserved)';
select /*+ recompile */ id, a from t where id > 0 and rownum > 3 and rownum <= 7;
-- Expected: 4 rows (rownum 4..7)

evaluate '1-19. LIMIT clause: negative result preserves error handling';
select id, a from t where id > 0 limit -1;
-- Expected: Error -493 (ER_PT_SYNTAX; negative LIMIT rejected at parse stage)

evaluate '1-20. LIMIT clause with NUMERIC values exceeding BIGINT range';
select id, a from t where id > 0 limit 10000000000000000000000000000000000000000000000;
-- Expected: 10 rows
select id, a from t where id > 0 limit 10000000000000000000000000000000000000000000000, 1;
-- Expected: 0 rows
select id, a from t where id > 0 limit 1, 10000000000000000000000000000000000000000000000;
-- Expected: 9 rows
select id, a from t where id > 0 limit 10000000000000000000000000000000000000000000000, 10000000000000000000000000000000000000000000000;
-- Expected: 0 rows

evaluate '1-21. Host variable bound to NUMERIC exceeding BIGINT range (handled identically)';
PREPARE st FROM 'select /*+ recompile */ id, a from t where id > 0 and rownum < ?';
EXECUTE st USING 10000000000000000000000000000000000000000000000;
-- Expected: 10 rows

drop table if exists t;
