--+ server-message on

-- normal: if static sql select statement results in more than one rows, TOO_MANY_ROWS exception must be raised.


create or replace procedure t(i int) as
    c varchar(255);
begin
    select class_name into c from db_class;
exception
when too_many_rows then
    dbms_output.put_line('OK');
    raise;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
