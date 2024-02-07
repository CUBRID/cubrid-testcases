--+ server-message on

-- normal: local procedure can call itself


create or replace procedure t(i int) as
    procedure poo(i int) as
    begin
        if i <= 0 then
            return;
        else
            dbms_output.put_line('i=' || i);
            poo(i - 1);
        end if;
    end;
begin
    poo(i);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
