--+ server-message on

-- normal: if static sql select statement results in no data, NO_DATA_FOUND exception must be raised.


create or replace procedure t(i int) as
    c varchar(1);
begin
    select dummy into c from dual where dummy = 'Y';
exception
when no_data_found then
    dbms_output.put_line('OK');
    raise;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
