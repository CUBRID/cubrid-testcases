/**
 *  This test case verifies CBRD-25097: a typo in the declaration of a local procedure fails.
 *
 *  After a failed declaration, CTP runs the rest of the body as other statements, which fail too.
 *
 *  Coverage:
 *    Case 1:  PROCEDUREE instead of PROCEDURE fails to compile
 *    Case 2:  TO instead of AS fails to compile
 *    Case 3:  BEGAN instead of BEGIN fails with a syntax error
 *    Case 4:  ENDS instead of END fails with a syntax error
 */

--+ server-message on

evaluate 'Case 1: PROCEDUREE instead of PROCEDURE fails to compile; result = Error:-1360';
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

evaluate 'Case 2: TO instead of AS fails to compile; result = Error:-1360';
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

evaluate 'Case 3: BEGAN instead of BEGIN fails with a syntax error; result = Error:-493';
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

-- ENDS does not close the local procedure, so the end lines after this create belong to its statement
evaluate 'Case 4: ENDS instead of END fails with a syntax error; result = Error:-493';
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
