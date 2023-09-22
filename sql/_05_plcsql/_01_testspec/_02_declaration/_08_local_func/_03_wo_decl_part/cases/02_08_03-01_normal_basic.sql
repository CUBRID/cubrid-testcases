--+ server-message on

-- normal: local function without a declaration in its declaration part


create or replace procedure t(i int) as
    function poo return int as
    begin
        return 7;
    end;
begin
    dbms_output.put_line('poo=' || poo);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

