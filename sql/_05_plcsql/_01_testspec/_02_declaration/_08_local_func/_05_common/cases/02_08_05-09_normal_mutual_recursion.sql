--+ server-message on

-- normal: mutual recursion


create or replace procedure t(i int)
as
    function ping(n int) return int
    as
    begin
        if n <= 0 then
            dbms_output.put_line('-- end --');
        else
            dbms_output.put_line('ping ->');
            dbms_output.put_line('pong returned ' || pong(n - 1));     -- mutual recursion
        end if;
        return n;
    end;

    function pong(n int) return int
    as
    begin
        if n <= 0 then
            dbms_output.put_line('-- end --');
        else
            dbms_output.put_line('      <- pong');
            dbms_output.put_line('ping returned ' || ping(n - 1));     -- mutual recursion
        end if;
        return n;
    end;
begin
    dbms_output.put_line('ping returned ' || ping(i));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


