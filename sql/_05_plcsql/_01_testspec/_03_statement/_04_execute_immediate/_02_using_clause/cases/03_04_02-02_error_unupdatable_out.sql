--+ server-message on

-- error: using unupdatable identifier for (in)out arguments

create or replace procedure poo(c IN OUT int, d INOUT int, e OUT int) as
begin
    null;
end;

create or replace procedure t(a int, b int) as
    c constant int := 3;
begin
    execute immediate 'call poo(?, ?, ?)' using IN OUT a, INOUT b, OUT c;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

drop procedure poo;


