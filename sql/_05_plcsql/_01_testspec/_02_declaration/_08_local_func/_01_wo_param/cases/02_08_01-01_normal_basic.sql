--+ server-message on

-- normal: local function without parameters


create or replace procedure t(i int) as
    function poo return int as
    begin
        return 1;
    end;

    function boo() return int as
    begin
        return 2;
    end;
begin
    dbms_output.put_line('poo()=' || poo());
    dbms_output.put_line('boo()=' || boo());
    dbms_output.put_line('poo=' || poo);
    dbms_output.put_line('boo=' || boo);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

