--+ server-message on

-- Check for errors when using special characters in procedure names.

create procedure test_prc#1(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create procedure "test_prc#2"(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;


--+ server-message off

