--+ server-message on
/*
Verification for CBRD-24811
language statement extend
choose the 'java' or 'plcsql'

The 'language java' is legacy supported on stored procedure.
but needs to be checked after extend the language statement by pl/csql.
*/

-- plcsql
create function func_plcsql() return int as language plcsql
begin
    dbms_output.put_line('test');
	return 0;
end;

-- java sp
create function func_java(i string) return string as language java
name 'SpTest2.typetestinteger(java.lang.String) return java.lang.Integer';


select func_plcsql() from dual;
select func_java('1') from dual;

drop function func_plcsql;
drop function func_java;

--+ server-message off
