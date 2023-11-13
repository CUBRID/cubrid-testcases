--+ server-message on

-- normal: local procedure can call a local function defined in the same declaration area


create or replace procedure t(i int)
as
    procedure ping(n int)
    as
        i int;
    begin
        if n <= 0 then
            dbms_output.put_line('-- end --');
        else
            dbms_output.put_line('ping ->');
            i := pong(n - 1);     -- mutual recursion
        end if;
    end;

    function pong(n int) return int
    as
    begin
        if n <= 0 then
            dbms_output.put_line('-- end --');
        else
            dbms_output.put_line('      <- pong');
            ping(n - 1);     -- mutual recursion
        end if;

        return 0;
    end;
begin
    ping(i);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off
