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
name 'SpTest2.typetestinteger(java.lang.String) return java.lang.Integer';

select pro_plcsql() from dual;
select pro_java('1') from dual;

drop procedure pro_plcsql;
drop procedure pro_java;

--+ server-message off