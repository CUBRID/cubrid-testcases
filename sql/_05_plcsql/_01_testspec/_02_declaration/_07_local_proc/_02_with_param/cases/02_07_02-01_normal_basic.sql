--+ server-message on

-- normal: local procedure with a parameter


create or replace procedure t(i int) as
    procedure poo(i int) as
    begin
        dbms_output.put_line('i=' || i);
    end;
begin
    dbms_output.put_line('i=' || i);
    poo(i - 2);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
