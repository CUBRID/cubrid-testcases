--+ server-message on

-- normal: local function can call itself


create or replace procedure t(i int) as
    function poo(i int) return int as
    begin
        if i <= 0 then
            return -1;
        else
            dbms_output.put_line('i=' || i);
            return poo(i - 1);
        end if;
    end;
begin
    dbms_output.put_line('poo=' || poo(i));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
