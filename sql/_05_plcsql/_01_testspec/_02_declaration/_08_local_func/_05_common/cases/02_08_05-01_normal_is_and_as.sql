--+ server-message on

-- normal: is and as can be used


create or replace procedure t(i int) as
    function poo return int is
    begin
        return 7;
    end;

    function boo return int as
    begin
        return 77;
    end;
begin
    dbms_output.put_line('poo=' || poo);
    dbms_output.put_line('boo=' || boo);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
