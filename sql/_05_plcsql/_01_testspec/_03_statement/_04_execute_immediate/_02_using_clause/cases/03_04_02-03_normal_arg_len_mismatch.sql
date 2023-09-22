--+ server-message on

-- normal: if the number of host variables (?'s) and the length of using values do not match, then SQL_ERROR is raised


create or replace procedure poo(a int, b IN int, c IN OUT int, d INOUT int, e OUT int) as
begin
    null;
end;

create or replace procedure t(i int) as
    a int := 1;
    b int := 2;
    c int := 3;
    d int := 4;
    e int := 5;
begin
    execute immediate 'call poo(?, ?, ?, ?, ?)' using IN b, IN OUT c, INOUT d, OUT e;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;
drop procedure poo;


