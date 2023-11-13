--+ server-message on

-- OK if a function with the same name as an already existing one is defined with 'OR REPLACE' clause


create or replace function t(i int) return int as
begin
    return null;
end;

create or replace function t(s string) return int as
begin
    dbms_output.put_line('s=' || s);
    return 7;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

select t('OK');

drop function t;

--+ server-message off
