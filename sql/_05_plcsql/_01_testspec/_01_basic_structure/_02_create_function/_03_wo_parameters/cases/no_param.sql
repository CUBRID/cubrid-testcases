--+ server-message on
/*
Verification for CBRD-24818
if don't need to parameter then '()' is not need
*/
create function func_plcsql() return int as language plcsql
begin
    dbms_output.put_line('no param');
        return 0;
end;

select func_plcsql() from dual;

drop function func_plcsql;

-- no param
create function func_plcsql return int as language plcsql
begin
    dbms_output.put_line('no param');
	return 0;
end;

select func_plcsql() from dual;

drop function func_plcsql;


--+ server-message off
