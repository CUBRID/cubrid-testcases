/**
 *  This test case verifies CBRD-27299: a parallel hash join may evaluate a declared function in
 *  its join predicates; an undeclared one keeps it serial wherever workers would evaluate it.
 *
 *  Before the fix only the outer-join ON terms were checked, and any function there made the
 *  join serial. An undeclared function in the WHERE of an outer join or in an inner-join
 *  residual term reached the workers, and the pre-fix optdebug server aborted. The fix checks
 *  ON terms, outer-join WHERE terms and inner-join residual terms, and passes declared ones.
 *
 *  The line "(parallel workers: ...)" under PROBE marks a parallel hash join. Joins return at
 *  most 500 rows, so the scan over the result stays serial on every build. Undeclared calls stay
 *  near 2000 per statement (x.a > 48000): each one sends rights to the broker. Every query is
 *  followed by its no_parallel_hash_join twin and the result blocks must match. The shapes the
 *  pre-fix server aborted on are last (Cases 10 to 13).
 *
 *  Coverage:
 *    Case 1:  declared Java function in an inner-join residual term, with and without owner
 *    Case 2:  declared PL/CSQL function in an inner-join residual term
 *    Case 3:  declared function in the WHERE of an outer join
 *    Case 4:  declared function in the ON of an outer join
 *    Case 5:  undeclared function in the ON of an outer join stays serial
 *    Case 6:  nested functions: only all-declared nesting is parallel
 *    Case 7:  undeclared function in the hash key: the join stays parallel
 *    Case 8:  hints: parallel(1) is serial, no hint is parallel
 *    Case 9:  CREATE OR REPLACE removes and restores the declaration
 *    Case 10: undeclared function in an inner-join residual term stays serial
 *    Case 11: one undeclared among three residual terms (first, middle, last)
 *    Case 12: undeclared PL/CSQL function with static SQL in a residual term
 *    Case 13: undeclared function in the WHERE of an outer join stays serial
 */

drop table if exists t_big, t_mid, t_code;

-- 65536 rows of (int, int): 145 heap pages, far over the 2-page hash join floor of test_mode
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 65536;
-- 50000 rows: b = a - 5 when a is a multiple of 100, else a + 5, so f(x.b) > y.b holds for 500
-- rows; queries with an undeclared function add x.a > 48000 (2000 pairs, 20 rows); the outer
-- joins of Cases 4 and 5 keep x.a in (44000, 50000]: 6000 result rows, under 10 list pages
create table t_mid (a int, b int);
insert into t_mid select a, case when mod(a, 100) = 0 then a - 5 else a + 5 end from t_big where a <= 50000;
-- one row per value 1 to 5, read by the static SQL of f_sqlc
create table t_code (c int);
insert into t_code values (1), (2), (3), (4), (5);
update statistics on t_big, t_mid, t_code with fullscan;

create function f_jp(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
create function f_jn(x int) return int as language java name 'SpTest.testInt(int) return int';
create function f_pp(n int) return int parallel_enable as begin return n + 1; end;
create function f_sqlc(x int) return int as n int; begin select count(*) into n from t_code where c = mod(x - 1, 5) + 1; return x + n; end;
create function f_tg(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';

set trace on;


evaluate 'Case 1: declared Java function in an inner-join residual term, with and without owner; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b;
show trace;
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and dba.f_jp(x.b) > y.b;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b;


evaluate 'Case 2: declared PL/CSQL function in an inner-join residual term; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_pp(x.b) > y.b;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_pp(x.b) > y.b;


evaluate 'Case 3: declared function in the WHERE of an outer join; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x left join t_mid y on x.a = y.a where x.a <= 50000 and f_jp(x.b) > nvl(y.b, 0) + 3;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x left join t_mid y on x.a = y.a where x.a <= 50000 and f_jp(x.b) > nvl(y.b, 0) + 3;


evaluate 'Case 4: declared function in the ON of an outer join; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), count(y.a), sum(x.a) from t_big x left join t_mid y on x.a = y.a and y.b < x.b and f_jp(x.b) > y.b where x.a > 44000 and x.a <= 50000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), count(y.a), sum(x.a) from t_big x left join t_mid y on x.a = y.a and y.b < x.b and f_jp(x.b) > y.b where x.a > 44000 and x.a <= 50000;


evaluate 'Case 5: undeclared function in the ON of an outer join stays serial; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), count(y.a), sum(x.a) from t_big x left join t_mid y on x.a = y.a and y.b < x.b and f_jn(x.b) > y.b where x.a > 44000 and x.a <= 50000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), count(y.a), sum(x.a) from t_big x left join t_mid y on x.a = y.a and y.b < x.b and f_jn(x.b) > y.b where x.a > 44000 and x.a <= 50000;


evaluate 'Case 6: nested functions: only all-declared nesting is parallel; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(f_pp(x.b)) > y.b + 1;
show trace;
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(f_jn(x.b)) > y.b + 1 and x.a > 48000;
show trace;
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jn(f_jp(x.b)) > y.b + 1 and x.a > 48000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jn(f_jp(x.b)) > y.b + 1 and x.a > 48000;


evaluate 'Case 7: undeclared function in the hash key: the join stays parallel; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = f_jn(y.a) - 1 and x.b > y.b + 3 and y.a > 48000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = f_jn(y.a) - 1 and x.b > y.b + 3 and y.a > 48000;


evaluate 'Case 8: hints: parallel(1) is serial, no hint is parallel; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(1) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b;
show trace;
select /*+ recompile use_hash */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b;


evaluate 'Case 9: CREATE OR REPLACE removes and restores the declaration; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_tg(x.b) > y.b and x.a > 48000;
show trace;
create or replace function f_tg(x int) return int as language java name 'SpTest.testInt(int) return int';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_tg(x.b) > y.b and x.a > 48000;
show trace;
create or replace function f_tg(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_tg(x.b) > y.b and x.a > 48000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_tg(x.b) > y.b and x.a > 48000;


evaluate 'Case 10: undeclared function in an inner-join residual term stays serial; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jn(x.b) > y.b and x.a > 48000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jn(x.b) > y.b and x.a > 48000;


evaluate 'Case 11: one undeclared among three residual terms (first, middle, last); result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jn(x.b) > y.b - 3 and f_jp(x.b) > y.b and f_pp(x.b) > y.b - 3 and x.a > 48000;
show trace;
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b - 3 and f_jn(x.b) > y.b and f_pp(x.b) > y.b - 3 and x.a > 48000;
show trace;
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b - 3 and f_pp(x.b) > y.b - 3 and f_jn(x.b) > y.b and x.a > 48000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_jp(x.b) > y.b - 3 and f_pp(x.b) > y.b - 3 and f_jn(x.b) > y.b and x.a > 48000;


evaluate 'Case 12: undeclared PL/CSQL function with static SQL in a residual term; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_sqlc(x.b) > y.b and x.a > 48000;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x, t_mid y where x.a = y.a and f_sqlc(x.b) > y.b and x.a > 48000;


evaluate 'Case 13: undeclared function in the WHERE of an outer join stays serial; result = no_parallel_hash_join';
select /*+ recompile use_hash parallel(4) */ count(*), sum(x.a) from t_big x left join t_mid y on x.a = y.a where x.a > 48000 and x.a <= 50000 and f_jn(x.b) > nvl(y.b, 0) + 3;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile use_hash no_parallel_hash_join */ count(*), sum(x.a) from t_big x left join t_mid y on x.a = y.a where x.a > 48000 and x.a <= 50000 and f_jn(x.b) > nvl(y.b, 0) + 3;

drop function f_jp, f_jn, f_pp, f_sqlc, f_tg;
drop table t_big, t_mid, t_code;
