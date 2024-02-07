--+ server-message on

-- error: using illegal letters in an identifier

create or replace procedure t(i int) as
    j@#$ int;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
