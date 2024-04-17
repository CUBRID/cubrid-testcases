--+ server-message on

-- Check if an error occurs if the local procedure name is declared as an internal function name.

create or replace procedure t(cnt int) 
as 
    PROCEDURE CLOB_TO_CHAR(n INT)
    AS
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
begin    
    CLOB_TO_CHAR(cnt);
end;
call t(3);

create or replace procedure t(cnt int) 
as 
    PROCEDURE JSON_REPLACE(n INT)
    AS
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
begin    
    JSON_REPLACE(cnt);
end;
call t(3);

create or replace procedure t(cnt int)
as
    PROCEDURE decode(n INT)
    AS
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
begin
    decode(cnt);
end;
call t(3);
 

--+ server-message off
