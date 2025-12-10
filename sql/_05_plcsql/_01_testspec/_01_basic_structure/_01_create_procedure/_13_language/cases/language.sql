--+ server-message on
/*
Verification for CBRD-24811
language statement extend
choose the 'java' or 'plcsql'

The 'language java' is legacy supported on stored procedure.
but needs to be checked after extend the language statement by pl/csql.
*/

-- plcsql
create procedure pro_plcsql() as language plcsql
begin
    dbms_output.put_line('test');
end;

-- java sp
create procedure pro_java(i string) as language java
name 'SpTest2.typetestinteger(java.lang.String)';

call pro_plcsql();
call pro_java('1');

drop procedure pro_plcsql;
drop procedure pro_java;

--+ server-message off
