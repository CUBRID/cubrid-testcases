--+ server-message on

-- Error writing "begin".
-- Errors in writing "end" cannot be tested.

create procedure t(i int) as 

    dbms_output.put_line('i=' || i);
end;

create procedure t(i int) as 
begin;
    dbms_output.put_line('i=' || i);
end;


--+ server-message off

