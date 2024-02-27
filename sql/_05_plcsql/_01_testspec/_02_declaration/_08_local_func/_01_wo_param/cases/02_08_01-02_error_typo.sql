--+ server-message on

--Grammar check for local functions. 

creator  FUNCTION choose(m INT, n INT) RETURN INT
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
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

CREATE functions  choose(m INT, n INT) RETURN INT
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
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

CREATE FUNCTION choose(m INT, n INT) RETURN INT
AS
    invalid_argument EXCEPTION;
    FUNCTION factorial(n INT) retorn INT
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
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

CREATE FUNCTION choose(m INT, n INT) RETURN INTS
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
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

CREATE FUNCTION choose(m INT, n INT) RETURN INT
AS
    invalid_argument EXCEPTION;
    FUNCTION factorial(n INT) RETURN INT
    TO
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
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

CREATE FUNCTION choose(m INT, n INT) RETURN INT
AS
    invalid_argument EXCEPTION;
    FUNCTION factorial(n INT) RETURN INT
    AS
    began
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
        RETURN factorial(m) / factorial(n) / factorial(m - n);
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
            retorn  1;
        ELSE
            RETURN n * factorial(n - 1);    -- 재귀 호출
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
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
            RETURN AA;
        ELSE
            RETURN n * factorial(n - 1);    -- 재귀 호출
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
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
    ENDS;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;
end;
end;



--+ server-message off
