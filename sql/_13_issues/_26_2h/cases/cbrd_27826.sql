/**
 * This test case verifies CBRD-27826 (11.4-only hotfix backport, not yet
 * merged to develop - cubrid#8326): an empty or whitespace-only string
 * ('', '   ') coerced to NUMERIC is 0, the same as the other numeric types,
 * instead of erroring as CBRD-26749 made it.
 *
 * Coverage:
 * 1. the issue's own repro (6 numeric types incl. NUMERIC, column scale)
 * 2-3. zero-padding (unaffected control) and no-digit input (still errors)
 * 4. PL/CSQL NUMERIC parameter conversion
 * 5. a same-fix, non-NUMERIC NOT NULL regression the PR review found
 *
 * numeric_empty_string_as_null (pre-26749 NULL) and oracle_style_empty_string
 * are PRM_HIDDEN with no PRM_USER_CHANGE - neither is session-settable, so
 * their "=yes" behavior and the PK/ALTER regressions the review found under
 * numeric_empty_string_as_null=yes are out of this SQL test's reach.
 */

drop table if exists t1;
create table t1 (
  c_small smallint, c_int int, c_bigint bigint, c_float float, c_double double,
  c_money monetary, c_num numeric(15,0), c_num_scaled numeric(10,3)
);

evaluate 'Case 1: an empty and a whitespace-only string convert to 0 for every numeric type, including NUMERIC which used to error; NUMERIC keeps the column''s own scale';
insert into t1 values ('', '', '', '', '', '', '', '');
insert into t1 values ('   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ');
select * from t1 order by c_small, c_num_scaled;

drop table if exists t1;

evaluate 'Case 2: zero-padded strings give 0, unaffected by the fix';
drop table if exists t2;
create table t2 (c_num numeric(15,0));
insert into t2 values ('0'), ('000'), ('  0  '), ('  000  ');
select c_num from t2 order by 1;
drop table if exists t2;

evaluate 'Case 3a: a sign-only string still errors - only the pure blank/whitespace case changed';
select cast('+' as numeric(15,0));

evaluate 'Case 3b: the other sign-only string still errors';
select cast('-' as numeric(15,0));

evaluate 'Case 3c: a decimal-point-only string still errors';
select cast('.' as numeric(15,0));

evaluate 'Case 3d: a decimal-point-only string with surrounding spaces still errors';
select cast(' . ' as numeric(15,0));

evaluate 'Case 3e: a sign plus a decimal point still errors';
select cast('+.' as numeric(15,0));

evaluate 'Case 4: PL/CSQL NUMERIC parameter conversion follows the same rule as SQL';
drop function if exists pf;
create or replace function pf(a numeric) return numeric as begin return a; end;
select pf(''), pf('   ');
drop function if exists pf;

evaluate 'Case 5: return_null_on_function_errors=yes - a coercion failure that becomes NULL during INSERT ... SELECT must still violate the destination NOT NULL column instead of silently storing NULL';
set system parameters 'return_null_on_function_errors=yes';

drop table if exists s1;
create table s1 (v varchar(10));
insert into s1 values ('abc');

drop table if exists d1;
create table d1 (k int, n int not null);

insert into d1 select 1, v from s1;
select * from d1;

drop table if exists d1;
drop table if exists s1;

set system parameters 'return_null_on_function_errors=default';
