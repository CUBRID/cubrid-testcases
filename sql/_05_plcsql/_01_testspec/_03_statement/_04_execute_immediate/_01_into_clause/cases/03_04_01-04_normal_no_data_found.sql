--+ server-message on

-- normal: if select results in zero rows, then NO_DATA_FOUND is raised


create or replace procedure t(i int) as
    charset varchar(32);
begin
    execute immediate 'select charset_name from db_collation where coll_name = ''abc''' into charset;
exception
when no_data_found then
    dbms_output.put_line('OK');
    raise;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


