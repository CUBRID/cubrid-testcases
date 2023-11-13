--+ server-message on

-- normal: basic usage of parenthesis


create or replace procedure t(i int) as
begin
    dbms_output.put_line('(2+3)*2=' || ((2 + 3) * 2));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
