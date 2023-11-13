--+ server-message on

-- normal: is as well as as can be used.


create or replace procedure t(i int) is
begin
    dbms_output.put_line('i=' || i);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

create or replace procedure t(i int) as
begin
    dbms_output.put_line('i=' || i);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off
