--+ server-message on

-- error: into clause in the definition of a cursor

drop table if exists tbl;
create table tbl (i int, j int);

create or replace procedure t(b int) as
    x int;
    cursor c is select i into x from tbl where i >= b and j >= b;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

drop table tbl;

--+ server-message off
