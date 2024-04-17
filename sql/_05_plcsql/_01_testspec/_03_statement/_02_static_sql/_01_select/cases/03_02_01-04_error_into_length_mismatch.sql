--+ server-message on

-- error: the lengths of into clause and the select list must match

create or replace procedure t(c out varchar(1)) as
    d varchar(1);
begin
    select dummy into c, d from dual;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
