-- CBRD-26652
-- This test verifies that implicit coercion of string literals to NUMERIC no longer fails
-- due to the default semantic-check numeric domain being expanded from NUMERIC(15,9)
-- to NUMERIC(38,9). It also verifies that SMALLINT/INT/BIGINT coercion behavior remains unchanged.

drop table if exists t_autocast_num;
create table t_autocast_num
(
  id   int,
  n10  numeric(10,0),
  n20  numeric(20,0),
  n38  numeric(38,9)
);

-- Seed rows for predicate, DML, and arithmetic coercion tests.
insert into t_autocast_num values (1, 1111111, 1111111, 1111111);
insert into t_autocast_num values (2, 9999999, 123456789012345, 123456789012345);
insert into t_autocast_num values (3, 1234567, 12345678901234567890, 12345678901234567890);

evaluate 'Case 1: Core reproduction queries that previously failed during implicit string-to-NUMERIC coercion';

-- Verify that the original failing predicate on NUMERIC(10,0) now succeeds.
select id
  from t_autocast_num
 where n10 = '1111111'
 order by id;

prepare st from 'select id from t_autocast_num where n10 = ? order by id';
execute st using '1111111';
deallocate prepare st;

-- Verify that a larger integer literal also succeeds against NUMERIC(20,0).
select id
  from t_autocast_num
 where n20 = '12345678901234567890'
 order by id;

prepare st from 'select id from t_autocast_num where n20 = ? order by id';
execute st using '12345678901234567890';
deallocate prepare st;

-- Verify that implicit coercion also works in UPDATE predicates.
update t_autocast_num
   set id = id + 10
 where n10 = '9999999';

prepare st from 'update t_autocast_num set id = ? where n10 = ?';
execute st using '12', '9999999';
deallocate prepare st;

evaluate 'Case 2: Implicit coercion in IN and BETWEEN predicates';

-- Verify implicit coercion for each string literal used in an IN-list.
select id, n10
  from t_autocast_num
 where n10 in ('1111111', '9999999', '1234567')
 order by id;

prepare st from 'select id, n10 from t_autocast_num where n10 in (?, ?, ?) order by id';
execute st using '1111111', '9999999', '1234567';
deallocate prepare st;

-- Verify implicit coercion for range comparison using string literals.
select id
  from t_autocast_num
 where n10 between '1111111' and '9999999'
 order by id;

prepare st from 'select id from t_autocast_num where n10 between ? and ? order by id';
execute st using '1111111', '9999999';
deallocate prepare st;

evaluate 'Case 3: INSERT ... SELECT with implicit coercion in filter predicate';

-- Verify that INSERT ... SELECT works when the filter predicate requires implicit coercion.
insert into t_autocast_num (id, n10, n20, n38)
select id + 100, n10, n10, n10
  from t_autocast_num
 where n10 = '1234567';

-- Verify inserted rows after successful implicit coercion.
select *
  from t_autocast_num
 order by 1;

evaluate 'Case 4: DELETE with implicit coercion in predicate';

-- Verify that DELETE predicate coercion works without semantic-check precision failure.
delete from t_autocast_num where n10 = '1111111';

prepare st from 'delete from t_autocast_num where n10 = ?';
execute st using '1111111';
deallocate prepare st;

-- Verify remaining rows after DELETE.
select id, n10 from t_autocast_num order by id;

evaluate 'Case 5: Out-of-domain literal for NUMERIC(10,0) should still fail';

-- Verify that precision expansion does not allow values outside the target NUMERIC(10,0) domain.
select *
  from t_autocast_num
 where n10 = '12345678901';

prepare st from 'select * from t_autocast_num where n10 = ?';
execute st using '12345678901';
deallocate prepare st;

evaluate 'Case 6: Out-of-domain literal for NUMERIC(20,0) should still fail';

-- Verify that precision expansion does not allow values outside the target NUMERIC(20,0) domain.
select *
  from t_autocast_num
 where n20 = '123456789012345678901';

prepare st from 'select * from t_autocast_num where n20 = ?';
execute st using '123456789012345678901';
deallocate prepare st;

evaluate 'Case 7: Implicit coercion in comparison predicate with ORDER BY';

-- Verify that coercion succeeds in the predicate and does not affect ORDER BY execution.
select id, n10
  from t_autocast_num
 where n10 > '1000000'
 order by n10, id;

prepare st from 'select id, n10 from t_autocast_num where n10 > ? order by n10, id';
execute st using '1000000';
deallocate prepare st;

evaluate 'Case 8: Arithmetic expression with implicit coercion of string literal';

-- Verify that arithmetic expression operands can be coerced from string literal to numeric.
select id, n10 + '1'
  from t_autocast_num
 where id in (3, 12)
 order by id;

prepare st from 'select id, n10 + ? from t_autocast_num where id in (?, ?) order by id';
execute st using '1', '3', '12';
deallocate prepare st;

evaluate 'Case 9: Fractional string literal coercion into NUMERIC(38,9)';

-- Verify that a fractional string literal can be assigned to NUMERIC(38,9).
update t_autocast_num set n38 = '0.123456789' where id = 3;

prepare st from 'update t_autocast_num set n38 = ? where id = ?';
execute st using '0.123456789', '3';
deallocate prepare st;

-- Verify that comparison against the same fractional string literal succeeds.
select id, cast(n38 as numeric(38,9))
  from t_autocast_num
 where n38 = '0.123456789'
 order by id;

prepare st from 'select id, cast(n38 as numeric(38,9)) from t_autocast_num where n38 = ? order by id';
execute st using '0.123456789';
deallocate prepare st;

drop table if exists t_autocast_num;

drop table if exists t_autocast_l;
drop table if exists t_autocast_r;

create table t_autocast_l (id int, n10 numeric(10,0));
create table t_autocast_r (id int, n10 numeric(10,0));

-- Seed rows for JOIN-related coercion tests.
insert into t_autocast_l values (1, 1111111);
insert into t_autocast_l values (2, 2222222);
insert into t_autocast_r values (10, 1111111);
insert into t_autocast_r values (20, 3333333);

evaluate 'Case 10: JOIN predicate with string literal coerced to NUMERIC';

-- Verify that implicit coercion also works inside JOIN predicates.
select l.id, r.id
  from t_autocast_l l
  join t_autocast_r r
    on l.n10 = '1111111' and r.n10 = '1111111'
 order by l.id, r.id;

prepare st from 'select l.id, r.id from t_autocast_l l join t_autocast_r r on l.n10 = ? and r.n10 = ? order by l.id, r.id';
execute st using '1111111', '1111111';
deallocate prepare st;

evaluate 'Case 11: JOIN against derived-table string literal';

-- Verify coercion when the string literal comes from a derived table column.
select l.id
  from t_autocast_l l
  join (select '2222222' as s) x
    on l.n10 = x.s
 order by l.id;

prepare st from 'select l.id from t_autocast_l l join (select ? as s) x on l.n10 = x.s order by l.id';
execute st using '2222222';
deallocate prepare st;

drop table if exists t_autocast_l;
drop table if exists t_autocast_r;

drop table if exists t_autocast_int;
create table t_autocast_int
(
  id int,
  s  smallint,
  i  int,
  b  bigint
);

-- Verify that fixed coercion rules for SMALLINT, INT, and BIGINT remain unchanged.
insert into t_autocast_int values (1, 32767, 2147483647, 9223372036854775807);
insert into t_autocast_int values (2, -32768, -2147483648, -9223372036854775808);

evaluate 'Case 12: SMALLINT comparisons with string literals';

-- Verify unchanged SMALLINT coercion behavior for valid upper/lower boundary values.
select id
  from t_autocast_int
 where s = '32767'
 order by id;

select id
  from t_autocast_int
 where s = '-32768'
 order by id;

prepare st from 'select id from t_autocast_int where s = ? order by id';
execute st using '32767';
execute st using '-32768';
deallocate prepare st;

evaluate 'Case 13: SMALLINT overflow should still fail';

-- Verify that values exceeding SMALLINT range are still rejected.
select id
  from t_autocast_int
 where s = '32768'
 order by id;

prepare st from 'select id from t_autocast_int where s = ? order by id';
execute st using '32768';
deallocate prepare st;

evaluate 'Case 14: SMALLINT underflow should still fail';

-- Verify that values below SMALLINT range are still rejected.
select id
  from t_autocast_int
 where s = '-32769'
 order by id;

prepare st from 'select id from t_autocast_int where s = ? order by id';
execute st using '-32769';
deallocate prepare st;

evaluate 'Case 15: INT comparisons with string literals';

-- Verify unchanged INT coercion behavior for valid upper/lower boundary values.
select id
  from t_autocast_int
 where i = '2147483647'
 order by id;

select id
  from t_autocast_int
 where i = '-2147483648'
 order by id;

prepare st from 'select id from t_autocast_int where i = ? order by id';
execute st using '2147483647';
execute st using '-2147483648';
deallocate prepare st;

evaluate 'Case 16: INT overflow should still fail';

-- Verify that values exceeding INT range are still rejected.
select id
  from t_autocast_int
 where i = '2147483648'
 order by id;

prepare st from 'select id from t_autocast_int where i = ? order by id';
execute st using '2147483648';
deallocate prepare st;

evaluate 'Case 17: INT underflow should still fail';

-- Verify that values below INT range are still rejected.
select id
  from t_autocast_int
 where i = '-2147483649'
 order by id;

prepare st from 'select id from t_autocast_int where i = ? order by id';
execute st using '-2147483649';
deallocate prepare st;

evaluate 'Case 18: BIGINT comparisons with string literals';

-- Verify unchanged BIGINT coercion behavior for valid upper/lower boundary values.
select id
  from t_autocast_int
 where b = '9223372036854775807'
 order by id;

select id
  from t_autocast_int
 where b = '-9223372036854775808'
 order by id;

prepare st from 'select id from t_autocast_int where b = ? order by id';
execute st using '9223372036854775807';
execute st using '-9223372036854775808';
deallocate prepare st;

evaluate 'Case 19: BIGINT overflow should still fail';

-- Verify that values exceeding BIGINT range are still rejected.
select id
  from t_autocast_int
 where b = '9223372036854775808'
 order by id;

prepare st from 'select id from t_autocast_int where b = ? order by id';
execute st using '9223372036854775808';
deallocate prepare st;

evaluate 'Case 20: BIGINT underflow should still fail';

-- Verify that values below BIGINT range are still rejected.
select id
  from t_autocast_int
 where b = '-9223372036854775809'
 order by id;

prepare st from 'select id from t_autocast_int where b = ? order by id';
execute st using '-9223372036854775809';
deallocate prepare st;

drop table if exists t_autocast_int;

drop table if exists t_autocast_extra;
create table t_autocast_extra
(
  id int,
  n10 numeric(10,0),
  n20 numeric(20,0),
  n38 numeric(38,9)
);

-- Seed rows for direct assignment and predicate coercion extension cases.
insert into t_autocast_extra values (1, 0, 0, 0);
insert into t_autocast_extra values (2, -1111111, -123456789012345, -0.123456789);
insert into t_autocast_extra values (3, 1111111, 12345678901234567890, 123456789.123456789);

evaluate 'Case 21: Direct INSERT VALUES with string literal coercion';

-- Verify that direct VALUES insertion with string literals succeeds for NUMERIC targets.
insert into t_autocast_extra values (21, '1111111', '1111111', '1111111');

-- Verify inserted row after direct implicit coercion in VALUES clause.
select id, n10, n20, cast(n38 as numeric(38,9))
from t_autocast_extra
where id = 21
order by id;

evaluate 'Case 22: Direct UPDATE SET with string literal coercion';

-- Verify that direct assignment in UPDATE SET also uses the corrected coercion path.
update t_autocast_extra
set n10 = '2222222',
n20 = '2222222',
n38 = '2222222.000000000'
where id = 1;

prepare st from 'update t_autocast_extra set n10 = ?, n20 = ?, n38 = ? where id = ?';
execute st using '2222222', '2222222', '2222222.000000000', '1';
deallocate prepare st;

-- Verify updated values after direct assignment coercion.
select id, n10, n20, cast(n38 as numeric(38,9))
from t_autocast_extra
where id = 1
order by id;

evaluate 'Case 23: Negative string literal coercion for NUMERIC columns';

-- Verify that signed string literals are coerced correctly in predicates.
select id
from t_autocast_extra
where n10 = '-1111111'
order by id;

select id
from t_autocast_extra
where n20 = '-123456789012345'
order by id;

select id
from t_autocast_extra
where n38 = '-0.123456789'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '-1111111';
deallocate prepare st;
prepare st from 'select id from t_autocast_extra where n20 = ? order by id';
execute st using '-123456789012345';
deallocate prepare st;
prepare st from 'select id from t_autocast_extra where n38 = ? order by id';
execute st using '-0.123456789';
deallocate prepare st;

evaluate 'Case 24: Leading-zero string literal coercion';

-- Verify that leading zeros do not cause unexpected precision errors.
select id
from t_autocast_extra
where n10 = '0001111111'
order by id;

-- Verify that negative leading-zero strings are also handled correctly.
select id
from t_autocast_extra
where n10 = '-0001111111'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '0001111111';
execute st using '-0001111111';
deallocate prepare st;

evaluate 'Case 25: Fractional string literal against NUMERIC(10,0)';

-- Verify that a scale-compatible fractional form still matches a scale-0 target when applicable.
select id
from t_autocast_extra
where n10 = '1111111.0'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '1111111.0';
deallocate prepare st;

-- Verify behavior when a non-zero fractional part is compared to a scale-0 target.
select id
from t_autocast_extra
where n10 = '1111111.1'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '1111111.1';
deallocate prepare st;

evaluate 'Case 26: Exact boundary values for NUMERIC(10,0)';

-- Verify exact upper bound that still fits NUMERIC(10,0).
update t_autocast_extra
set n10 = '9999999999'
where id = 1;

prepare st from 'update t_autocast_extra set n10 = ? where id = ?';
execute st using '9999999999', '1';
deallocate prepare st;

select id
from t_autocast_extra
where n10 = '9999999999'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '9999999999';
deallocate prepare st;

-- Verify exact lower bound representation by direct assignment.
update t_autocast_extra
set n10 = '-9999999999'
where id = 1;

prepare st from 'update t_autocast_extra set n10 = ? where id = ?';
execute st using '-9999999999', '1';
deallocate prepare st;

select id
from t_autocast_extra
where n10 = '-9999999999'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '-9999999999';
deallocate prepare st;

evaluate 'Case 27: Boundary overflow beyond NUMERIC(10,0) should still fail';

-- Verify that one more digit beyond NUMERIC(10,0) is still rejected.
select id
from t_autocast_extra
where n10 = '10000000000'
order by id;

select id
from t_autocast_extra
where n10 = '-10000000000'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '10000000000';
execute st using '-10000000000';
deallocate prepare st;

evaluate 'Case 28: Exact boundary values for NUMERIC(20,0)';

-- Verify exact upper bound that still fits NUMERIC(20,0).
update t_autocast_extra
set n20 = '99999999999999999999'
where id = 1;

prepare st from 'update t_autocast_extra set n20 = ? where id = ?';
execute st using '99999999999999999999', '1';
deallocate prepare st;

select id
from t_autocast_extra
where n20 = '99999999999999999999'
order by id;

prepare st from 'select id from t_autocast_extra where n20 = ? order by id';
execute st using '99999999999999999999';
deallocate prepare st;

-- Verify exact lower bound representation by direct assignment.
update t_autocast_extra
set n20 = '-99999999999999999999'
where id = 1;

prepare st from 'update t_autocast_extra set n20 = ? where id = ?';
execute st using '-99999999999999999999', '1';
deallocate prepare st;

select id
from t_autocast_extra
where n20 = '-99999999999999999999'
order by id;

prepare st from 'select id from t_autocast_extra where n20 = ? order by id';
execute st using '-99999999999999999999';
deallocate prepare st;

evaluate 'Case 29: Boundary overflow beyond NUMERIC(20,0) should still fail';

-- Verify that one more digit beyond NUMERIC(20,0) is still rejected.
select id
from t_autocast_extra
where n20 = '100000000000000000000'
order by id;

select id
from t_autocast_extra
where n20 = '-100000000000000000000'
order by id;

prepare st from 'select id from t_autocast_extra where n20 = ? order by id';
execute st using '100000000000000000000';
execute st using '-100000000000000000000';
deallocate prepare st;

evaluate 'Case 30: Fractional direct assignment into NUMERIC(38,9)';

-- Verify direct assignment of a large fractional string literal that depends on widened coercion precision.
update t_autocast_extra
set n38 = '11111111111111111111.123456789'
where id = 1;

select id, cast(n38 as numeric(38,9))
from t_autocast_extra
where id = 1
order by id;

prepare st from 'update t_autocast_extra set n38 = ? where id = ?';
execute st using '11111111111111111111.123456789', '1';
deallocate prepare st;

prepare st from 'select id, cast(n38 as numeric(38,9)) from t_autocast_extra where id = ? order by id';
execute st using '1';
deallocate prepare st;

evaluate 'Case 31: Whitespace-padded numeric string literal';

-- Verify coercion behavior for string literals with leading and trailing spaces.
select id
from t_autocast_extra
where n10 = ' 1111111 '
order by id;

select id
from t_autocast_extra
where n20 = ' 12345678901234567890 '
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using ' 1111111 ';
deallocate prepare st;
prepare st from 'select id from t_autocast_extra where n20 = ? order by id';
execute st using ' 12345678901234567890 ';
deallocate prepare st;

evaluate 'Case 32: Explicit plus sign in numeric string literal';

-- Verify that a leading plus sign does not break implicit coercion.
select id
from t_autocast_extra
where n10 = '+1111111'
order by id;

select id
from t_autocast_extra
where n20 = '+12345678901234567890'
order by id;

prepare st from 'select id from t_autocast_extra where n10 = ? order by id';
execute st using '+1111111';
deallocate prepare st;
prepare st from 'select id from t_autocast_extra where n20 = ? order by id';
execute st using '+12345678901234567890';
deallocate prepare st;

evaluate 'Case 33: Arithmetic expression with signed string literal';

-- Verify arithmetic evaluation when the string operand contains an explicit sign.
select id, n10 + '-1'
from t_autocast_extra
where id in (3, 21)
order by id;

prepare st from 'select id, n10 + ? from t_autocast_extra where id in (?, ?) order by id';
execute st using '-1', '3', '21';
deallocate prepare st;

evaluate 'Case 34: CASE expression with implicit numeric coercion';

-- Verify that implicit coercion also works inside CASE predicate branches.
select id,
case
when n10 = '1111111' then 'match'
when n10 = '-1111111' then 'neg_match'
else 'no_match'
end as result
from t_autocast_extra
order by id;

prepare st from 'select id, case when n10 = ? then ''match'' when n10 = ? then ''neg_match'' else ''no_match'' end as result from t_autocast_extra order by id';
execute st using '1111111', '-1111111';
deallocate prepare st;

evaluate 'Case 35: HAVING clause with implicit numeric coercion';

-- Verify coercion in HAVING after grouping.
select n10, count(*)
from t_autocast_extra
group by n10
having n10 = '1111111'
order by n10;

prepare st from 'select n10, count(*) from t_autocast_extra group by n10 having n10 = ? order by n10';
execute st using '1111111';
deallocate prepare st;

drop table if exists t_autocast_extra;

-- ============================================
-- Prepared statement scenarios (Cases 36+)
-- These cases exercise host-variable coercion paths that are independent of the
-- static-literal path changed by CBRD-26652, and act as regression guards for
-- prepare/execute/deallocate lifecycle, multi-host-var statements, and prepared
-- DML/JOIN paths.
-- ============================================

drop table if exists t_autocast_ps;
create table t_autocast_ps
(
id int,
n10 numeric(10,0),
n20 numeric(20,0),
n38 numeric(38,9)
);

-- Seed rows for prepared-statement coverage; values mirror earlier suites.
insert into t_autocast_ps values (1, 1111111, 1111111, 1111111);
insert into t_autocast_ps values (2, 9999999, 12345678901234567890, 9999999.123456789);
insert into t_autocast_ps values (3, 1234567, 123456789012345, 0.123456789);

evaluate 'Case 36: Reuse a single prepared statement across multiple in-range string bindings';

-- Verify the plan cache is reused correctly for the coercion path under different bound values.
prepare st from 'select id from t_autocast_ps where n10 = ? order by id';
execute st using '1111111';
execute st using '9999999';
execute st using '1234567';
deallocate prepare st;

evaluate 'Case 37: Reuse a single prepared statement; out-of-domain bindings must still fail';

-- Verify a cached plan still rejects an out-of-domain bound value between two valid executions.
prepare st from 'select id from t_autocast_ps where n10 = ? order by id';
execute st using '1111111';
execute st using '12345678901';
execute st using '9999999';
deallocate prepare st;

evaluate 'Case 38: Single prepared statement with multiple host variables on different columns';

-- Verify multi-host-var coercion against two NUMERIC columns simultaneously.
prepare st from 'select id from t_autocast_ps where n10 = ? and n20 = ? order by id';
execute st using '1111111', '1111111';
deallocate prepare st;

evaluate 'Case 39: INSERT VALUES driven entirely by host variables';

-- Verify INSERT VALUES path with all host-variable bindings (int + NUMERIC of multiple precisions).
prepare st from 'insert into t_autocast_ps values (?, ?, ?, ?)';
execute st using '40', '1111111', '12345678901234567890', '0.123456789';
deallocate prepare st;

select id, n10, n20, cast(n38 as numeric(38,9))
from t_autocast_ps
where id = 40
order by id;

-- Cleanup the row inserted above so downstream cases see only the seeded rows.
delete from t_autocast_ps where id = 40;

evaluate 'Case 40: Single prepared statement bound with widely different magnitude values';

-- Verify a single prepared plan handles both small and very large bound values on NUMERIC(20,0).
prepare st from 'select id from t_autocast_ps where n20 = ? order by id';
execute st using '1111111';
execute st using '12345678901234567890';
deallocate prepare st;

drop table if exists t_autocast_ps;

drop table if exists t_autocast_psl;
drop table if exists t_autocast_psr;
create table t_autocast_psl (id int, n10 numeric(10,0));
create table t_autocast_psr (id int, n10 numeric(10,0));

-- Seed rows for JOIN-with-host-variables coverage.
insert into t_autocast_psl values (1, 1111111);
insert into t_autocast_psl values (2, 2222222);
insert into t_autocast_psr values (10, 1111111);
insert into t_autocast_psr values (20, 3333333);

evaluate 'Case 41: JOIN ON with host variables filtering both sides';

-- Verify JOIN predicate with host-variable filters on both joined tables.
prepare st from 'select l.id, r.id from t_autocast_psl l join t_autocast_psr r on l.n10 = r.n10 where l.n10 = ? and r.n10 = ? order by l.id, r.id';
execute st using '1111111', '1111111';
deallocate prepare st;

drop table if exists t_autocast_psl;
drop table if exists t_autocast_psr;
