--+ server-message on

-- normal: basic usage of an if statement with an elsif clause


create or replace procedure t(i int) as
begin
    if 2 = 3 then
        dbms_output.put_line('then');
    elsif 3 = 3 then
        dbms_output.put_line('elseif');
    end if;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

