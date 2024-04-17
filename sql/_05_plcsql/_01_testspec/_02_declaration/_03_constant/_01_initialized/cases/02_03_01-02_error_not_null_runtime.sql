--+ server-message on

-- normal: null value at runtime for a not null constant (runtime exception VALUE_ERROR)


create or replace procedure t(i int) as
    function null_value return int as
    begin
        return null;
    end;

    p_int constant int not null := null_value;

begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off
