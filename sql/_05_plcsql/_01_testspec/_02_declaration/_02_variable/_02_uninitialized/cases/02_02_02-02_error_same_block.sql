--+ server-message on

-- Verified for CBRD-25017
-- a default value expression of a variable or constant cannot contain a variable/constant declared later in the same declaration block.

create or replace procedure poo as
    i int := 3;

    procedure p as
        j int := i;
        --  NOTE: OK without the line below.
        i int; 
    begin
        null;
    end;
begin
    null;
end;


create or replace procedure t(i int) as
    procedure poo as
        --  NOTE: OK without the line below. 
        i int := i;
    begin
        dbms_output.put_line('i=' || i);
    end;
begin
    poo;
    dbms_output.put_line('OK');
end;


create or replace procedure poo(i int) as
    procedure inner as
        procedure p as
            procedure pp as
            begin
                -- illegal forward reference of i
                dbms_output.put_line(i); 
            end;
        begin
            null;
        end;        

        i int;
    begin
        null;
    end;
begin
    null;
end;


create or replace procedure poo(i int) as
    procedure inner as
        procedure p as
            -- illegal forward reference of i
            cursor c is select * from dual where dummy = i;
        begin
            null;
        end;        
        
        i int;
    begin
        null;
    end;
begin
    null;
end;



--+ server-message off
