--+ server-message on
-- Verified the CBRD-25681
-- JAVASP test to granted user & ungranted user

create user ungranted_user;
create user granted_user;

evaluate 'create javasp dba.hello';
CREATE FUNCTION hello(name varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(java.lang.String) return java.lang.String';

select dba.hello('a');

evaluate 'grant to granted_user for dba.hello';
grant execute on procedure dba.hello to granted_user;

evaluate 'connect to granted_user';
call login('granted_user', '') on class db_user;
select dba.hello('a');

evaluate 'connect to ungranted_user';
call login('ungranted_user', '') on class db_user;
evaluate 'ERROR: EXECUTE authorization failure';
select dba.hello('a');

evaluate 'connect to dba & Test done';
CALL login(CLASS db_user, 'dba', '');
DROP FUNCTION hello;
DROP USER granted_user;
DROP USER ungranted_user;

--+ server-message off
