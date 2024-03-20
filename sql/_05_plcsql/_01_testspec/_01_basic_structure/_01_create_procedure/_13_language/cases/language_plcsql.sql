--+ server-message on

-- plcsql
create procedure pro_plcsql() as language plcsql
begin
    dbms_output.put_line('test');
end;

create function func_plcsql() return int as language plcsql
begin
    dbms_output.put_line('test');
	return 0;
end;

select pro_plcsql() from dual;
select func_plcsql() from dual;

drop procedure pro_plcsql;
drop function func_plcsql;

--+ server-message off