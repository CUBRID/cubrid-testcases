--+ server-message on

-- normal: mutual recursion


create or replace procedure t(i int)
as
    j int;
    function ping(n int) return int
    as
    begin
        if n <= 0 then
            dbms_output.put_line('-- end --');
        else
            dbms_output.put_line('      <- ping');
            pong(n - 1);     -- mutual recursion
        end if;

        return 0;
    end;

    procedure pong(n int)
    as
        i int;
    begin
        if n <= 0 then
            dbms_output.put_line('-- end --');
        else
            dbms_output.put_line('pong ->');
            i := ping(n - 1);     -- mutual recursion
        end if;
    end;

begin
    dbms_output.put_line('ping returned ' || ping(i));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off
