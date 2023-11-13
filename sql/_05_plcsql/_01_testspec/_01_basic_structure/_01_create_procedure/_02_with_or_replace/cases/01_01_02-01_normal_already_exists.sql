--+ server-message on

-- OK if a procedure with the same name as an already existing one is defined with 'OR REPLACE' clause


create or replace procedure t(i int) as
begin
    null;
end;

create or replace procedure t(s string) as
begin
    dbms_output.put_line('s=' || s);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t('OK');

drop procedure t;

--+ server-message off
