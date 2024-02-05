--+ server-message on

--Use the name of the local function the same as the name of the built in function, and check whether an error occurs when calling each function. 

CREATE OR replace FUNCTION choose(m INT, n INT) RETURN VARCHAR
AS
--    invalid_argument EXCEPTION;
    FUNCTION substr(n INT) RETURN VARCHAR
    AS
    BEGIN
        IF n <= 0 THEN
            return '-- end --';
        ELSE
            return 'ping ->';
        END IF;
    END;
    abc varchar;
begin
    IF n > m OR n < 0 THEN
        put_line('error'||abc);
        RETURN 'error';
    ELSE
        abc := substr('abcde',1,3);
        put_line('build in substr function ->'||abc);
        RETURN substr(123);
    END IF;
END;


--+ server-message off
