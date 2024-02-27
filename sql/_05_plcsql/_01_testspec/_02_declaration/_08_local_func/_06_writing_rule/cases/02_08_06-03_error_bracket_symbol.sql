--+ server-message on

--When calling a local function, check if an error occurs if the parentheses are abnormal.

CREATE FUNCTION choose(m INT, n INT) RETURN INT
AS
    invalid_argument EXCEPTION;
    FUNCTION factorial(n INT) RETURN INT
    AS
    BEGIN
        IF n < 0 THEN
            RAISE invalid_argument;
        ELSIF n <= 1 THEN
            RETURN 1;
        ELSE
            RETURN n * factorial(n - 1);    -- 재귀 호출
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m ;
    END IF;
END;

CREATE FUNCTION choose(m INT, n INT) RETURN INT
AS
    invalid_argument EXCEPTION;
    FUNCTION factorial(n INT) RETURN INT
    AS
    BEGIN
        IF n < 0 THEN
            RAISE invalid_argument;
        ELSIF n <= 1 THEN
            RETURN 1;
        ELSE
            RETURN n * factorial(n - 1);    -- 재귀 호출
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial m) ;
    END IF;
END;

CREATE FUNCTION choose(m INT, n INT) RETURN INT
AS
    invalid_argument EXCEPTION;
    FUNCTION factorial(n INT) RETURN INT
    AS
    BEGIN
        IF n < 0 THEN
            RAISE invalid_argument;
        ELSIF n <= 1 THEN
            RETURN 1;
        ELSE
            RETURN n * factorial(n - 1);    -- 재귀 호출
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial m ;
    END IF;
END;


--+ server-message off
