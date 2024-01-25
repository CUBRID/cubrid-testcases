--+ server-message on

-- Check for syntax errors in local procedures.

create or replace procedure t(cnt int) 
as 
    PROCEDUREE ping(n INT)
    AS
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
begin    
    ping(cnt);
end;

create or replace procedure t(cnt int) 
as 
    PROCEDURE ping(n INT)
    TO
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
begin    
    ping(cnt);
end;

create or replace procedure t(cnt int) 
as 
    PROCEDURE ping(n INT)
    AS
    BEGAN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
begin    
    ping(cnt);
end;

create or replace procedure t(cnt int) 
as 
    PROCEDURE ping(n INT)
    AS
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    ENDS;
begin    
    ping(cnt);
end;
end;
end;




--+ server-message off
