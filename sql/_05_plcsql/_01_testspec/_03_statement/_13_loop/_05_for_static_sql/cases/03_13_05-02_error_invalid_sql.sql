--+ server-message on

-- error: static sql is not a select statement

drop table if exists tbl;
create table tbl(i int);

create or replace procedure t(i int) as
begin
    for r in (insert into tbl values (7)) loop
        null;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

drop table tbl;

--+ server-message off
