--+ server-message on

-- error: When using constant-related grammar, check if an error occurs by making a typo.


create or replace procedure t  as
   CONSTANTS a INT := 3;
begin
    dbms_output.put_line('a =' || a );
end;


create or replace procedure t  as
   CONSTANT a INT NOT NOLL := 3;
begin
    dbms_output.put_line('a =' || a );
end;

create or replace procedure t  as
   CONSTANT a INT NUT NULL := 3;
begin
    dbms_output.put_line('a =' || a );
end;


create or replace procedure t  as
   CONSTANT a INT  DEFAULTS 3;
begin
    dbms_output.put_line('a =' || a );
end;

create or replace procedure t  as
   CONSTANT a INT 3 DEFAULTS ;
begin
    dbms_output.put_line('a =' || a );
end;

--+ server-message on
