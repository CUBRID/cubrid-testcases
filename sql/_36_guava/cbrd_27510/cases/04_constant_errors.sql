/**
 *  This test case verifies CBRD-27510: a constant whose computation or conversion fails is an error before the
 *  first row.
 *
 *  A constant here is a literal, a constant subtree over binds, or the CAST the compiler puts over a constant
 *  operand. develop computed and converted such a constant at the first row that needed it, so the same statement
 *  answered with no error when no row reached it - no row at all, a CASE branch no row takes, an operand COALESCE
 *  never reads, a term an AND short-circuits. CBRD-27510 computes and converts constants once per execution at the
 *  gate (qexec_resolve_domains), so the error comes before any row, whatever the data. A bind is wrapped in
 *  CONCAT(?, '') so that the client passes it as a string and the server computes or converts it.
 *
 *  A constant condition decides at the gate too. When it keeps every row from the constant - the arm of CASE, IF or
 *  DECODE it does not take, the operand a first constant keeps COALESCE or NVL2 from reading, the rest of AND or OR
 *  after a constant term, a false constant WHERE, a LIMIT of 0 - no error is raised, as in develop. A session
 *  variable is not a constant condition, because the statement or a stored procedure it calls may assign it.
 *
 *  The new answers are the statements of Case 1, Case 3 and Case 5 over no row (ce_e is empty) or behind a branch
 *  no row takes, and Case 9 - they fail before any row where develop answered without an error. The same statements
 *  over rows (Case 2, Case 4, Case 6) fail in develop too, and the guarded statements (Case 7, Case 8) and the
 *  conversions a row makes (Case 10) keep develop's answers.
 *
 *  Coverage:
 *    Case 1: a constant subtree whose computation fails, over no row or behind a branch no row takes
 *    Case 2: the same statements over rows
 *    Case 3: a term's constant side that does not convert to the comparison
 *    Case 4: the same comparisons over rows
 *    Case 5: a MEDIAN or PERCENTILE value that none of DOUBLE, DATETIME and TIME takes
 *    Case 6: the same MEDIAN and PERCENTILE values over rows
 *    Case 7: constants a constant condition keeps every row from, which raise no error
 *    Case 8: constant conditions holding CASE, IF, DECODE or an IN list over binds
 *    Case 9: a session variable condition, which is not a constant condition
 *    Case 10: values a row converts or compares - an assignment, a LEAD default, FIELD
 */
--+ holdcas on;
drop table if exists ce_t;
drop table if exists ce_e;
create table ce_t (a int, b varchar(10), c int);
insert into ce_t values (1, 'x', 1), (2, 'y', 2), (3, null, 3);
create index i_ce_t_ab on ce_t (a, b);
create table ce_e (a int, b varchar(10), c int);
create index i_ce_e_ab on ce_e (a, b);

-- Case 1 [EVAL]. A CASE branch no row takes, an empty table, a term an AND short-circuits, an operand COALESCE
-- never reads, an EXISTS over an empty table - each constant whose computation fails is an error before any row.
-- The same statements with a bind that converts answer as develop.
evaluate 'Case 1: a failing constant over no row or behind a branch';
prepare q from 'select a, case when a > 0 then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 'abc';
execute q using '5';
prepare q from 'select cast(concat(?, '''') as int) from ce_e';
execute q using 'abc';
execute q using '7';
prepare q from 'select a from ce_t where a < 0 and c = 100 / (? - ?)';
execute q using 1, 1;
execute q using 1, 2;
prepare q from 'select a, coalesce(a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 'abc';
prepare q from 'select a from ce_t where a > 5 and cast(concat(?, '''') as date) is null';
execute q using '2024-13-45';
prepare q from 'select a from ce_t where exists (select 1 from ce_e where ce_e.c = cast(concat(?, '''') as int))';
execute q using 'abc';
select a, case when a > 0 then a else cast('abc' as int) end from ce_t order by a;

-- The CAST the compiler puts over a constant operand (a plus, GREATEST, NULLIF next to a column) is a constant
-- subtree too.
prepare q from 'select a, a + concat(?, '''') from ce_e';
execute q using 'abc';
prepare q from 'select a, greatest(a, concat(?, '''')) from ce_e';
execute q using 'abc';
prepare q from 'select a, nullif(a, concat(?, '''')) from ce_e';
execute q using 'abc';

-- Case 2 [EVAL-ROWS]. The same failures over rows, where develop raised the same error at the first row.
evaluate 'Case 2: the same failing constants over rows';
prepare q from 'select cast(concat(?, '''') as int) from ce_t';
execute q using 'abc';
prepare q from 'select a, case when a > 1 then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 'abc';
prepare q from 'select a from ce_t where a > 0 and c = 100 / (? - ?)';
execute q using 1, 1;
prepare q from 'select a, a + concat(?, '''') from ce_t order by a';
execute q using 'abc';
prepare q from 'select a, greatest(a, concat(?, '''')), least(a, concat(?, '''')) from ce_t order by a';
execute q using 'abc', 'abc';
prepare q from 'select a, nullif(a, concat(?, '''')) from ce_t order by a';
execute q using 'abc';

-- Case 3 [CMP]. A term's constant side that does not convert to the comparison - = and IN over an empty table or
-- behind a term an AND short-circuits - is an error before any row (-181).
evaluate 'Case 3: a comparison constant that does not convert';
prepare q from 'select a from ce_e where c = concat(?, '''')';
execute q using 'abc';
execute q using '2';
prepare q from 'select a from ce_t where a < 0 and c = concat(?, '''')';
execute q using 'abc';
prepare q from 'select a from ce_e where c in (1, concat(?, ''''))';
execute q using 'abc';
prepare q from 'select a from ce_t where a < 0 and c in (1, concat(?, ''''))';
execute q using 'abc';

-- Case 4 [CMP-ROWS]. The same comparisons over rows, where develop raised the same error.
evaluate 'Case 4: the same comparisons over rows';
prepare q from 'select a from ce_t where c = concat(?, '''') order by a';
execute q using 'abc';
execute q using '2';
prepare q from 'select a from ce_t where c in (1, concat(?, '''')) order by a';
execute q using 'abc';
prepare q from 'select a from ce_t where (a < 0 and c = concat(?, '''')) or a = 1 order by a';
execute q using 'abc';

-- Case 5 [INTERP]. A MEDIAN or PERCENTILE value that none of DOUBLE, DATETIME and TIME takes (a bind 'abc', a
-- literal 'abc', a BIT literal, a session variable) is -1118 before any row, as an aggregate and as an analytic
-- function.
evaluate 'Case 5: MEDIAN and PERCENTILE values of no class';
prepare q from 'select median(?) from ce_e';
execute q using 'abc';
execute q using '2.5';
prepare q from 'select median(?) from ce_t where a < 0';
execute q using 'abc';
select median('abc') from ce_e;
select median(B'0001') from ce_e;
prepare q from 'select a, median(?) over () from ce_e';
execute q using 'abc';
prepare q from 'select percentile_cont(0.5) within group (order by ?) from ce_e';
execute q using 'abc';
set @ce_m = 'abc';
select median(@ce_m) from ce_e;

-- Case 6 [INTERP-ROWS]. The same values over rows, where develop raised the same error at the first row.
evaluate 'Case 6: the same MEDIAN and PERCENTILE values over rows';
prepare q from 'select median(?) from ce_t';
execute q using 'abc';
prepare q from 'select a, median(?) over () from ce_t order by a';
execute q using 'abc';
select median(B'0001') from ce_t;
select a, median(B'0001') over () from ce_t order by a;
select median(@ce_m) from ce_t;

-- Case 7 [GUARD]. A constant condition keeps every row from the constant, so no error is raised, as in develop -
-- the CASE, IF or DECODE arm it does not take, the operand a first constant keeps COALESCE or NVL2 from reading,
-- the rest of AND or OR after a constant term, rows under a false constant WHERE, a LIMIT of 0. The same statements
-- with the condition taking the failing arm fail before any row.
evaluate 'Case 7: constants a constant condition guards';
prepare q from 'select a, case when ? = 0 then 0 else 100 / ? end from ce_t order by a';
execute q using 0, 0;
execute q using 1, 0;
prepare q from 'select a, case when ? = 0 then 0 else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 0, 'abc';
execute q using 1, 'abc';
prepare q from 'select a, if(? > 0, a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 1, 'abc';
execute q using 0, 'abc';
prepare q from 'select a, decode(?, 1, a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 1, 'abc';
execute q using 2, 'abc';
prepare q from 'select a, coalesce(cast(? as int), cast(concat(?, '''') as int), a) from ce_t order by a';
execute q using 5, 'abc';
execute q using null, 'abc';
prepare q from 'select a, nvl2(cast(? as int), a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 1, 'abc';
execute q using null, 'abc';
prepare q from 'select a, case when ? = 1 and c = concat(?, '''') then 1 else 0 end from ce_t order by a';
execute q using 2, 'abc';
execute q using 1, 'abc';
prepare q from 'select a, case when ? = 1 or c = concat(?, '''') then 1 else 0 end from ce_t order by a';
execute q using 1, 'abc';
execute q using 2, 'abc';
prepare q from 'select cast(concat(?, '''') as int) from ce_t where ? = 1';
execute q using 'abc', 2;
execute q using 'abc', 1;
prepare q from 'select cast(concat(?, '''') as int) from ce_t limit ?';
execute q using 'abc', 0;
execute q using 'abc', 1;
prepare q from 'select a from ce_t order by a limit ?, ?+?';
execute q using '', '', '';
select a, if(current_time = current_time, a, cast('abc' as int)) from ce_t order by a;
select a, if(current_time <> current_time, a, cast('abc' as int)) from ce_t order by a;

-- The same guards over an open domain (a bind first), which develop inferred from every operand's value at the
-- first row.
prepare q from 'select a, coalesce(?, cast(concat(?, '''') as int), a) from ce_t order by a';
execute q using 5, 'abc';
prepare q from 'select a, nvl2(?, a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 1, 'abc';

-- The same where develop reads the constant anyway - a subquery in an arm runs before the scan, and a constant
-- WHERE term does not keep a row's filter from comparing.
prepare q from 'select a, case when ? = 1 then (select cast(concat(?, '''') as int) from ce_t where a = 1) else 0 end from ce_t order by a';
execute q using 2, 'abc';
prepare q from 'select a from ce_t where ? = 1 and c = concat(?, '''') order by a';
execute q using 2, 'abc';

-- Case 8 [GUARD-NESTED]. The constant condition holds a CASE, IF or DECODE node or an IN list over binds - no row
-- changes it either, so the guard holds as in develop.
evaluate 'Case 8: constant conditions holding CASE, IF, DECODE or IN';
prepare q from 'select a, case when if(? = 0, 0, 1) = 0 then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 0, 'abc';
execute q using 1, 'abc';
prepare q from 'select a, case when (case when ? = 0 then 0 else 1 end) = 0 then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 0, 'abc';
prepare q from 'select a, case when decode(?, 0, 0, 1) = 0 then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 0, 'abc';
prepare q from 'select a, if(if(? = 0, 0, 1) = 0, a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 0, 'abc';
prepare q from 'select a, case when if(? = 0, 0, 1) = 0 or c = concat(?, '''') then 1 else 0 end from ce_t order by a';
execute q using 0, 'abc';
prepare q from 'select a, coalesce(cast(if(? = 0, 1, null) as int), cast(concat(?, '''') as int), a) from ce_t order by a';
execute q using 0, 'abc';
execute q using 1, 'abc';
prepare q from 'select a, case when ? in (?, ?) then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 1, 1, 2, 'abc';
execute q using 3, 1, 2, 'abc';

-- Case 9 [VOLATILE]. A session variable condition is not a constant condition, because the statement or a stored
-- procedure it calls may assign the variable. The arm it does not take fails before any row, where develop answered
-- with rows.
evaluate 'Case 9: a session variable condition is no guard';
set @ce_g = 0;
prepare q from 'select a, case when @ce_g = 0 then a else cast(concat(?, '''') as int) end from ce_t order by a';
execute q using 'abc';

-- Case 10 [KEEP]. Where the row converts or compares the value, develop's answer stays - an UPDATE assignment, a
-- LEAD default, FIELD, which answers by rank.
evaluate 'Case 10: values a row converts or compares';
prepare q from 'update ce_e set c = concat(?, '''')';
execute q using 'abc';
prepare q from 'select a, lead(a, 1, ?) over (order by a) from ce_e';
execute q using 'abc';
prepare q from 'select a, lead(a, 1, ?) over (order by a) from ce_t order by a';
execute q using 'abc';
prepare q from 'select a, field(concat(?, ''''), a, 2) from ce_e';
execute q using 'abc';
prepare q from 'select a, field(concat(?, ''''), a, 2) from ce_t order by a';
execute q using 'abc';

drop variable @ce_m;
drop variable @ce_g;
deallocate prepare q;
drop table ce_t;
drop table ce_e;
--+ holdcas off;
