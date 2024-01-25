--+ server-message on

-- Check whether an error occurs when executing a typographical statement.

creator or replace procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedeur t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i int) to 
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i int) as 
began
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
ends;

create or replaces procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create and replace procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i int) as return integer begin
    dbms_output.put_line('i=' || i);
end;


--+ server-message off

