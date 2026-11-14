/**
 *  This test case verifies CBRD-25097: a typo in a function with a local function fails.
 *
 *  After some of the typos, CTP runs the rest of the body as other statements, which fail too.
 *
 *  Coverage:
 *    Case 1:  creator instead of create fails with a syntax error
 *    Case 2:  functions instead of function fails with a syntax error
 *    Case 3:  retorn instead of return in a local function header fails to compile
 *    Case 4:  the unknown return type INTS fails
 *    Case 5:  TO instead of AS in a local function fails to compile
 *    Case 6:  began instead of begin in a local function fails with a syntax error
 *    Case 7:  retorn instead of return in a local function body fails to compile
 *    Case 8:  an undeclared identifier AA in a local function fails to compile
 *    Case 9:  ENDS instead of END in a local function fails with a syntax error
 */

--+ server-message on

evaluate 'Case 1: creator instead of create fails with a syntax error; result = Error:-493';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 2: functions instead of function fails with a syntax error; result = Error:-493';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 3: retorn instead of return in a local function header fails to compile; result = Error:-1360';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 4: the unknown return type INTS fails; result = Error:-494';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 5: TO instead of AS in a local function fails to compile; result = Error:-1360';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 6: began instead of begin in a local function fails with a syntax error; result = Error:-493';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 7: retorn instead of return in a local function body fails to compile; result = Error:-1360';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

evaluate 'Case 8: an undeclared identifier AA in a local function fails to compile; result = Error:-1360';
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
            RETURN n * factorial(n - 1);    -- recursive call
        END IF;
    END;
begin    
    IF n > m OR n < 0 THEN
        RAISE invalid_argument;
    ELSE
        RETURN factorial(m) / factorial(n) / factorial(m - n);
    END IF;
END;

-- ENDS does not close the local function, so the end lines after this create belong to its statement
evaluate 'Case 9: ENDS instead of END in a local function fails with a syntax error; result = Error:-493';
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
            RETURN n * factorial(n - 1);    -- recursive call
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
