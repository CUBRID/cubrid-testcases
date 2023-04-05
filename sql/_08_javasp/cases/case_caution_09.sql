CREATE PROCEDURE teststringdigit(x inout char(5)) AS LANGUAGE JAVA NAME 'SpTest7.ptypeteststring(java.lang.String[])';

select 'abcdefg' into x from dual;
CALL teststringdigit(x);
select x;

DROP PROCEDURE teststringdigit;
