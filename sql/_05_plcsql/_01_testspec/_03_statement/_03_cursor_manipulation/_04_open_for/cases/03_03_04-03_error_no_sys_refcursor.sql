--+ server-message on

-- error: opening non-sys-refcursor

create or replace procedure t(i int) as
    rc int;
begin
    open rc for select coll_name, charset_name from db_collation;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

