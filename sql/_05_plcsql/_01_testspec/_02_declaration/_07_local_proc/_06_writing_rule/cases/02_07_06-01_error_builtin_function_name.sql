--+ server-message on

-- Check if an error occurs if the local procedure name is declared as an internal function name.

-- In the case of Oracle, when a local procedure with the same name as the built in function name is created, an error occurs when the built in function is called.
-- It is being processed normally in CUBRID. This is a bug.

create or replace procedure t(cnt int)
as
    PROCEDURE substr(n INT)
    AS
    BEGIN
        IF n <= 0 THEN
            put_line('-- end --');
        ELSE
            put_line('ping ->');
        END IF;
    END;
    abc varchar;
begin
    substr(cnt);
    abc := substr('abcde',1,3);
    put_line('build in substr function ->'||abc);
end;
call t(3);
 

--+ server-message off
