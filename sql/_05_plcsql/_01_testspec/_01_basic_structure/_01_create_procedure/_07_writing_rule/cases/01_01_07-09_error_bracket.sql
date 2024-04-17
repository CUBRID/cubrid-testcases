
--+ server-message on

-- 


create procedure t(i int as
begin
    dbms_output.put_line('i=' || i);
end;

create procedure t  i int) as
begin
    dbms_output.put_line('i=' || i);
end;

create procedure t((i int) as
begin
    dbms_output.put_line('i=' || i);
end;

create procedure t  (i int)) as
begin
    dbms_output.put_line('i=' || i);
end;



--+ server-message off

