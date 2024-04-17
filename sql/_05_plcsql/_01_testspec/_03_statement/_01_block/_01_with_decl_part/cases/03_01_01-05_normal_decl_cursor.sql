--+ server-message on

-- normal: cursor can be declared in a block


create or replace procedure t(i int) as
begin
    declare
        cursor c is select * from dual;
    begin
        for r in c loop
            dbms_output.put_line('dummy=' || r.dummy);
        end loop;
    end;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
