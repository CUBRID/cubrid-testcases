--+ server-message on
-- verified the CBRD-25506

CREATE OR REPLACE FUNCTION dba.fibonacci(n INTEGER) RETURN INTEGER
IS
    invalid_input EXCEPTION;
BEGIN
    IF n <= 0 THEN
        RAISE invalid_input;
    END IF;

    IF n = 1 OR n = 2 THEN
        RETURN 1;
    ELSE
        RETURN fibonacci(n-1) + fibonacci(n-2);
    END IF;
EXCEPTION
    WHEN invalid_input THEN
        DBMS_OUTPUT.put_line('invalid input: ' || n);
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('unknown exception');
        RETURN -1;
END;

CREATE OR REPLACE FUNCTION public.fibonacci(n INTEGER) RETURN INTEGER
IS
    invalid_input EXCEPTION;
BEGIN
    IF n <= 0 THEN
        RAISE invalid_input;
    END IF;

    IF n = 1 OR n = 2 THEN
        RETURN 1;
    ELSE
        RETURN dba.fibonacci(n-1) + dba.fibonacci(n-2);
    END IF;
EXCEPTION
    WHEN invalid_input THEN
        DBMS_OUTPUT.put_line('invalid input: ' || n);
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('unknown exception');
        RETURN -1;
END;

-- check onwer & source
SELECT unique_name, sp_name, owner.name FROM _db_stored_procedure WHERE is_system_generated = 0 order by owner.name;
SELECT 'Func_FIBONACCI' as "name", owner.name, scode, substr(scode,0,6) FROM _db_stored_procedure_code order by owner.name;

-- return: 2
select fibonacci(3) as "dba fibonacci: succ" from dual;

-- return: -1, because unknown exception
select public.fibonacci(3) as "public fibonacci: fail" from dual;

GRANT EXECUTE ON PROCEDURE dba.fibonacci TO public;
-- return: 2
select public.fibonacci(3) as "public fibonacci: succ" from dual;

REVOKE EXECUTE ON PROCEDURE dba.fibonacci FROM public;
-- return: -1, because unknown exception
select public.fibonacci(3) as "public fibonacci: fail" from dual;


drop FUNCTION dba.fibonacci;
drop FUNCTION public.fibonacci;

--+ server-message off
