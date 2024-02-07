--+ server-message on

-- normal: local function with a parameter


create or replace procedure t(i int) as
    function poo(i int) return int as
    begin
        return i;
    end;
begin
    dbms_output.put_line('poo(i - 2)=' || poo(i - 2));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
