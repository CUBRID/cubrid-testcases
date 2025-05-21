-- Verification of bug fix: Check for null pointer exception after error with non-parsable Time argument 

create or replace procedure test(a Time) as language java name 'SpTest.testTime(java.sql.Time)';

-- TypeMismatchException: String not parsable by Time.
call test('aa');

-- NPE should not occur due to call test('aa'): Parsed int value.
call test(1);

drop procedure test;
