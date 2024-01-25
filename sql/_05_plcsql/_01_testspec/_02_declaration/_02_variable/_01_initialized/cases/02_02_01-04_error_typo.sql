
--+ server-message on

-- Test for typo errors when assigning variable values.

create or replace procedure t  as
   a INT NOT NOLL := 3;
begin
    dbms_output.put_line('a =' || a );
end;

create or replace procedure t  as
   a INT NUT NULL := 3;
begin
    dbms_output.put_line('a =' || a );
end;


create or replace procedure t  as
   a INT  DEFAULTS 3;
begin
    dbms_output.put_line('a =' || a );
end;

create or replace procedure t  as
   a INT 3 DEFAULTS ;
begin
    dbms_output.put_line('a =' || a );
end;


drop procedure t;


--+ server-message off


