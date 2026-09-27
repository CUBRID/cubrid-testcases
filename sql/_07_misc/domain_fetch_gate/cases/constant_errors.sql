--+ holdcas on;
-- workspace#367 (map #312, dpin-17i): a constant whose computation or conversion fails - a literal, a constant subtree
-- over binds - is an error before any row, the user's decision of 2026-09-27. It fails the same with no row, in a CASE
-- branch no row takes, in an operand COALESCE never reads and under a term an AND short-circuits, where develop raised
-- the error only at the first row that computed it. A bind is wrapped in concat (?, '') so that the client passes it
-- as a string and the server computes or converts it. Each [...-ROWS] block repeats the statement over rows, where
-- develop raised the same error. [GUARD] pins develop's answers where a constant condition keeps every row from the
-- constant. [KEEP] pins develop's answers where the row converts or compares the value - an assignment, a LEAD / LAG
-- default, FIELD's comparisons, which answer by rank.
drop table if exists ce_t;
drop table if exists ce_e;
create table ce_t (a int, b varchar(10), c int);
insert into ce_t values (1, 'x', 1), (2, 'y', 2), (3, null, 3);
create index i_ce_t_ab on ce_t (a, b);
create table ce_e (a int, b varchar(10), c int);
create index i_ce_e_ab on ce_e (a, b);

-- [EVAL] a constant subtree whose computation fails (D-367-01)
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
-- the cast the compiler puts over a constant operand is a constant subtree too
prepare q from 'select a, a + concat(?, '''') from ce_e';
execute q using 'abc';
prepare q from 'select a, greatest(a, concat(?, '''')) from ce_e';
execute q using 'abc';
prepare q from 'select a, nullif(a, concat(?, '''')) from ce_e';
execute q using 'abc';

-- [EVAL-ROWS] the same over rows
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

-- [CMP] a term's constant side that does not convert to the comparison (D-367-02)
prepare q from 'select a from ce_e where c = concat(?, '''')';
execute q using 'abc';
execute q using '2';
prepare q from 'select a from ce_t where a < 0 and c = concat(?, '''')';
execute q using 'abc';
prepare q from 'select a from ce_e where c in (1, concat(?, ''''))';
execute q using 'abc';
prepare q from 'select a from ce_t where a < 0 and c in (1, concat(?, ''''))';
execute q using 'abc';

-- [CMP-ROWS] the same over rows
prepare q from 'select a from ce_t where c = concat(?, '''') order by a';
execute q using 'abc';
execute q using '2';
prepare q from 'select a from ce_t where c in (1, concat(?, '''')) order by a';
execute q using 'abc';
prepare q from 'select a from ce_t where (a < 0 and c = concat(?, '''')) or a = 1 order by a';
execute q using 'abc';

-- [INTERP] a MEDIAN / PERCENTILE value that none of DOUBLE, DATETIME, TIME takes (D-367-04)
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

-- [INTERP-ROWS] the same over rows
prepare q from 'select median(?) from ce_t';
execute q using 'abc';
prepare q from 'select a, median(?) over () from ce_t order by a';
execute q using 'abc';
select median(B'0001') from ce_t;
select a, median(B'0001') over () from ce_t order by a;
select median(@ce_m) from ce_t;

-- [GUARD] a constant no data reaches keeps develop's answer - the arm a constant condition does not take, the operand
-- a constant first one keeps COALESCE or NVL2 from reading, the rest of an AND or OR after a constant term, the
-- statement's rows under a constant WHERE that is false, the statement below a LIMIT of 0 (D-367-07, the user's
-- decision of 2026-09-27). The same statements with the constant taking the failing arm fail before any row.
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
-- the same over an open domain - a bind first - which develop infers from every operand's value at the first row
prepare q from 'select a, coalesce(?, cast(concat(?, '''') as int), a) from ce_t order by a';
execute q using 5, 'abc';
prepare q from 'select a, nvl2(?, a, cast(concat(?, '''') as int)) from ce_t order by a';
execute q using 1, 'abc';
-- the same where develop reads the constant anyway: a subquery in an arm runs before the scan, and a constant WHERE
-- term does not keep a row's filter from comparing
prepare q from 'select a, case when ? = 1 then (select cast(concat(?, '''') as int) from ce_t where a = 1) else 0 end from ce_t order by a';
execute q using 2, 'abc';
prepare q from 'select a from ce_t where ? = 1 and c = concat(?, '''') order by a';
execute q using 2, 'abc';

-- [KEEP] develop's answers where the row converts or compares the value (D-367-05)
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
deallocate prepare q;
drop table ce_t;
drop table ce_e;
--+ holdcas off;
