/*
Verification for CBRD-24811
language statement extend
choose the 'java' or 'plcsql'

The 'language java' is legacy supported on stored procedure.
but needs to be checked after extend the language statement by pl/csql.
*/

-- java sp
create procedure pro_java(i string) as language java
name 'SpTest2.typetestinteger(java.lang.String) return java.lang.Integer';

create function func_java(i string) return string as language java
name 'SpTest2.typetestinteger(java.lang.String) return java.lang.Integer';

select pro_java('1') from dual;
select func_java('2') from dual;

drop procedure pro_java;
drop function func_java;