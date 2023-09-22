--+ server-message on

-- error: assigning to an unupdatable for-record

create or replace procedure t(i int) as
    j int;
begin
    for j in (select * from dual) loop
        j := 7;
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';
