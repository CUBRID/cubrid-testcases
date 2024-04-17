--+ server-message on

-- error: execution can reach the end of the function without encountering a return statement

create or replace function t(i int) return int as
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

create or replace function t(i int) return int as
begin
    if true then
        return 7;
    else
        null;
    end if;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

create or replace function t(i int) return int as
begin
    while true loop
        return 7;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';





--+ server-message off
