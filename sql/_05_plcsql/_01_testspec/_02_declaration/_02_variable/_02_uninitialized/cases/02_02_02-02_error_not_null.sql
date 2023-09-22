--+ server-message on

-- error: not null without an initial value

create or replace procedure t(i int) as
    p_boolean not null boolean;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

