--+ server-message on

--Check for errors if the number of parameters in the created local procedure is different from the number of parameters when called. 

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
    ping(cnt, 2);
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
    ping();
end;


--+ server-message off
