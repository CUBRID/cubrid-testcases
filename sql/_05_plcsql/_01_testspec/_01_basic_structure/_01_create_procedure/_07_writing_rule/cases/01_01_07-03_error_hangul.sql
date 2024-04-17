--+ server-message on

-- Check for errors when using spaces in procedure names

create procedure 프로시 져(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;


--+ server-message off

