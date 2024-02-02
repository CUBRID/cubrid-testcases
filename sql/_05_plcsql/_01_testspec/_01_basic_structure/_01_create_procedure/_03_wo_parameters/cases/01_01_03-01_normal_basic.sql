--+ server-message on

-- normal: procedures that do not have parameters can be defined with or without '()'


-- with '()'
create procedure t() as
begin
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

-- without '()'
create procedure t as
begin
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;


--+ server-message off
