--+ server-message on

-- normal: basic case with declarations in the declaration part


create or replace procedure t(i int) as
    -- pragma autonomous_transaction; not supported yet
    my_error exception;
    c constant int := 7;
    v bigint;
    cursor r is select * from dual;
    procedure poo as
    begin
        null;
    end;
    function foo return int as
    begin
        return null;
    end;
begin
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
