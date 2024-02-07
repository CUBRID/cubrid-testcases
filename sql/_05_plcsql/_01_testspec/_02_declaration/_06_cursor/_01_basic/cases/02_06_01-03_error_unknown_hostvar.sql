--+ server-message on

-- error: unknown host variables in the definition of a cursor

create table tbl (i int, j int);

create or replace procedure t(k int) as
    cursor c is select * from tbl where i >= bbb and j >= bbb;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

drop table tbl;

--+ server-message off
