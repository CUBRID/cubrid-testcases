--+ server-message on

-- error: static sql is not a select statement

create table tbl(i int);

create or replace procedure t(i int) as
begin
    for r in (insert into tbl values (7)) loop
        null;
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

drop table tbl;
