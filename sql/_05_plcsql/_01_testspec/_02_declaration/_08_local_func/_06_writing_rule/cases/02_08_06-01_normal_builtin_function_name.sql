--+ server-message on

--Use the name of the local function the same as the built in function name and call the local function. 

CREATE OR replace FUNCTION choose(m INT, n INT) RETURN VARCHAR
AS
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
        RETURN substr(123);
    END IF;
END;

call choose(7, 5);

drop function choose;

--+ server-message off
