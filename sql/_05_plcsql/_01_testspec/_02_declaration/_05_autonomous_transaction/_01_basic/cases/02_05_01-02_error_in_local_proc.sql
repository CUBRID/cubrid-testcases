--+ server-message on

-- error: declared in a local procedure

create or replace procedure t(i int) as
    procedure local_proc as
        pragma autonomous_transaction;
    begin
        null;
    end;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';



--+ server-message off
