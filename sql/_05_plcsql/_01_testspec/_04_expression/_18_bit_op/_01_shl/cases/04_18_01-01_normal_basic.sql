--+ server-message on

-- normal: basic usage of operator '<<'


create or replace procedure t(i int) as
begin
    dbms_output.put_line(20 << 1);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

