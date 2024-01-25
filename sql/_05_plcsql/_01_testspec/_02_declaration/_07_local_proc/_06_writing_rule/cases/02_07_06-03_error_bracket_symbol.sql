--+ server-message on

--Check for errors if parentheses are abnormal when calling the created local procedure.

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
    ping(cnt ;
end;

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
    ping cnt );
end;

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
    ping cnt ;
end;


--+ server-message off
