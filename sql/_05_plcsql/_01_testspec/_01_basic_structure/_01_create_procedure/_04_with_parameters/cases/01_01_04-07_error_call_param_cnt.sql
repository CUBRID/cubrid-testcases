--+ server-message on

-- 

create or replace procedure t( i int ) as
begin
    dbms_output.put_line('i=' || i);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();
call t(123, 1234);
call t(12,123,1234);

drop procedure t;


--+ server-message off

