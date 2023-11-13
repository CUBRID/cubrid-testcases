--+ server-message on

-- normal: null value at runtime for a not null variable (runtime exception VALUE_ERROR)


create or replace procedure t(i int) as
    function null_value return int as
    begin
        return null;
    end;

    p_int int not null := null_value;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off
