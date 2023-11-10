--+ server-message on

-- error: the sys_refcursor must be updatable

create or replace procedure t(i int) as
    rc sys_refcursor;

    procedure poo(rc sys_refcursor) as
    begin
        open rc for select coll_name, charset_name from db_collation;
    end;
begin
    poo(rc);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

