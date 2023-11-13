--+ server-message on

-- error: identifiers in the into clause of static sql select statements must be updatable

create or replace procedure t(c varchar(1)) as
begin
    select dummy into c from dual;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
