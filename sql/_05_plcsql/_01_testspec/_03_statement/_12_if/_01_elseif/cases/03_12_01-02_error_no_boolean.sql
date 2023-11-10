--+ server-message on

-- error: condition in the elseif clause is not boolean

create or replace procedure t(i int) as
begin
    if 2 = 3 then
        dbms_output.put_line('then');
    elsif 'false' then
        dbms_output.put_line('elseif');
    end if;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';
