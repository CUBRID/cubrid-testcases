--+ server-message on

-- normal: basic usage of a return statement with a value


create or replace function t(i int) return int as
begin
    return i - 1;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

select t(7);

drop function t;


--+ server-message off
