/**
 *  CBRD-27144: a predicate on a session variable written in the statement is estimated
 *  with the variable's value.
 *
 *  A statement that reads a session variable is compiled at every execution and its plan
 *  is not cached, so the optimizer prices `a = @v` / `c1 > @v` with the value the variable
 *  has when the statement runs, as it prices the same constant. A variable the statement
 *  assigns itself changes while the statement runs and keeps the default estimate.
 *
 *  The verification is plan-shape based (--@fullplan masks sel/cost; the trace shows the
 *  access path of an EXECUTE). Column a is 99% 1, 0.5% 5 and 0.5% 9, with an index on a:
 *  the default equality estimate (1/NDV = 1/3) takes the index scan for any value, while
 *  the value 1 estimates 0.99 and must take the sequential scan, the value 5 the index
 *  scan. Column c1 is unique 1..10000, also indexed: `c1 > @v` with 0 must take the
 *  sequential scan (the default range estimate 0.1 took the index scan over every row).
 *  The cases that must keep the default estimate use the value 1, so that a value
 *  estimated by mistake would show as a sequential scan. Each query reads pad so that no
 *  index covers it, and returns its count so the answer stays self-checking.
 */

drop table if exists t_cbrd_27144;

create table t_cbrd_27144 (a int, c1 int, pad varchar(100));
insert into t_cbrd_27144 select 1, rownum, lpad ('x', 100, 'x') from db_class x, db_class y, db_class z limit 9900;
insert into t_cbrd_27144 select 5, 9900 + rownum, lpad ('x', 100, 'x') from db_class x, db_class y limit 50;
insert into t_cbrd_27144 select 9, 9950 + rownum, lpad ('x', 100, 'x') from db_class x, db_class y limit 50;
create index i_t_cbrd_27144_a on t_cbrd_27144 (a);
create index i_t_cbrd_27144_c1 on t_cbrd_27144 (c1);

update statistics on t_cbrd_27144 with fullscan;

-- Case 1: an equality on the skewed column follows the value
set @v = 1;
--@fullplan
select count (pad) from t_cbrd_27144 where a = @v;
set @v = 5;
--@fullplan
select count (pad) from t_cbrd_27144 where a = @v;

-- Case 2: ranges, BETWEEN and IN follow the values
set @v = 0;
--@fullplan
select count (pad) from t_cbrd_27144 where c1 > @v;
set @v = 9990;
--@fullplan
select count (pad) from t_cbrd_27144 where c1 > @v;
set @lo = 1;
set @hi = 10000;
--@fullplan
select count (pad) from t_cbrd_27144 where c1 between @lo and @hi;
set @lo = 100;
set @hi = 120;
--@fullplan
select count (pad) from t_cbrd_27144 where c1 between @lo and @hi;
set @v = 1;
set @w = 9;
--@fullplan
select count (pad) from t_cbrd_27144 where a in (@v, @w);
set @v = 5;
--@fullplan
select count (pad) from t_cbrd_27144 where a in (@v, @w);

-- Case 3: a prepared statement text with a session variable compiles at every EXECUTE,
-- each with the value the variable has then
prepare s_cbrd_27144 from 'select count (pad) from t_cbrd_27144 where a = @v';
set trace on;
set @v = 1;
execute s_cbrd_27144;
show trace;
set @v = 5;
execute s_cbrd_27144;
show trace;
set trace off;
deallocate prepare s_cbrd_27144;

-- Case 4: a variable the statement assigns keeps the default estimate (index scan for 1)
set @v = 1;
--@fullplan
select count (pad), max (@v := a) from t_cbrd_27144 where a = @v;

-- Case 5: a session variable in the USING list was already estimated with its value
-- (first-execution peek); the statement text differs from the other cases' so that no
-- plan is shared
set system parameters 'plan_cache_bind_sensitivity=yes';
prepare u_cbrd_27144 from 'select count (pad) + 1 from t_cbrd_27144 where a = ?';
set trace on;
set @v = 5;
execute u_cbrd_27144 using @v;
show trace;
set @v = 1;
execute u_cbrd_27144 using @v;
show trace;
set trace off;
deallocate prepare u_cbrd_27144;
set system parameters 'plan_cache_bind_sensitivity=default';

-- Case 6: no value the histogram can take keeps the default estimate (index scan for 1),
-- without another error than the undefined variable's own
set @v = null;
--@fullplan
select count (pad) from t_cbrd_27144 where a = @v;
--@fullplan
select count (pad) from t_cbrd_27144 where a = @undefined_cbrd_27144;
set @v = '1';
--@fullplan
select count (pad) from t_cbrd_27144 where a = @v;

-- Case 7: a numeric value of another type that equals an integer is estimated with it
set @v = 1.0e0;
--@fullplan
select count (pad) from t_cbrd_27144 where a = @v;

drop table t_cbrd_27144;
drop variable @v, @w, @lo, @hi;
