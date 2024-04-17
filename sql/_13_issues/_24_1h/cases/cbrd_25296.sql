/* Description
This scenario verified CBRD-25296 issue.
Assertion fail on a DATETIMELTZ value to a SP's parameter of DATETIME type
*/

create or replace procedure test_proc(p DATETIME) as language java name 'SpTest.testTimestamp(java.sql.Timestamp)';
create or replace function test_func(p DATETIME) return DATETIME as language java name 'SpTest.testTimestamp(java.sql.Timestamp) return java.sql.Timestamp';

select 'test function';
select test_func(timestamp'09/01/2009 01:10:10 pm');
select test_func(TO_TIMESTAMP('09/01/2009 01:10:10 pm'));
prepare st from 'select test_func(?)';
execute st using timestamp'09/01/2009 01:10:10 pm';

select test_func(timestamptz'09/01/2009 01:10:10 pm');
select test_func(TO_TIMESTAMP_TZ('09/01/2009 01:10:10 pm'));
execute st using timestamptz'09/01/2009 01:10:10 pm';

select test_func(timestampltz'09/01/2009 01:10:10 pm');
execute st using timestampltz'09/01/2009 01:10:10 pm';

select test_func(datetime'09/01/2009 01:10:10 pm');
select test_func(TO_DATETIME('09/01/2009 01:10:10 pm'));
execute st using datetime'09/01/2009 01:10:10 pm';

select test_func(datetimetz'09/01/2009 01:10:10 pm');
select test_func(TO_DATETIME_TZ('09/01/2009 01:10:10 pm'));
execute st using datetimetz'09/01/2009 01:10:10 pm';

select test_func(datetimeltz'09/01/2009 01:10:10 pm');
execute st using datetimeltz'09/01/2009 01:10:10 pm';

select test_func('2009-09-01 01:10:10');
execute st using '2009-09-01 01:10:10';

select test_func('abc');
execute st using 'abc';
deallocate prepare st;

select 'test procedure';
call test_proc(timestamp'09/01/2009 01:10:10 pm');
call test_proc(TO_TIMESTAMP('09/01/2009 01:10:10 pm'));
prepare st1 from 'call test_proc(?)';
execute st1 using timestamp'09/01/2009 01:10:10 pm';

call test_proc(timestamptz'09/01/2009 01:10:10 pm');
call test_proc(TO_TIMESTAMP_TZ('09/01/2009 01:10:10 pm'));
execute st1 using timestamptz'09/01/2009 01:10:10 pm';

call test_proc(timestampltz'09/01/2009 01:10:10 pm');
execute st1 using timestampltz'09/01/2009 01:10:10 pm';

call test_proc(datetime'09/01/2009 01:10:10 pm');
call test_proc(TO_DATETIME('09/01/2009 01:10:10 pm'));
execute st1 using datetime'09/01/2009 01:10:10 pm';

call test_proc(datetimetz'09/01/2009 01:10:10 pm');
call test_proc(TO_DATETIME_TZ('09/01/2009 01:10:10 pm'));
execute st1 using datetimetz'09/01/2009 01:10:10 pm';

call test_proc(datetimeltz'09/01/2009 01:10:10 pm');
execute st1 using datetimeltz'09/01/2009 01:10:10 pm';

call test_proc('2009-09-01 01:10:10');
execute st1 using '2009-09-01 01:10:10';

call test_proc('abc');
execute st1 using 'abc';
deallocate prepare st1;

drop procedure test_proc;
drop function test_func;
