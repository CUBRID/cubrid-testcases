--+ server-message on

-- normal: is and as can be used 


create or replace procedure t(i int) as
    procedure poo is
    begin
        dbms_output.put_line('poo');
    end;

    procedure boo as
    begin
        dbms_output.put_line('boo');
    end;
begin
    poo;
    boo;
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
