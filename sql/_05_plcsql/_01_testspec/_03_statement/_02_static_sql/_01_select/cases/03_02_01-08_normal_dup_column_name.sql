--+ server-message on

create or replace procedure t(k int) as
    i int;
    s string;
begin
    select coll_id X, coll_name X into i, s from db_collation;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
