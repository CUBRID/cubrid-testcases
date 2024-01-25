--+ server-message on

-- Check if an error occurs by declaring with the same parameter name.

create procedure t( i int, I varchar ) as
begin
    dbms_output.put_line('i=' || i);
end;

--+ server-message off
