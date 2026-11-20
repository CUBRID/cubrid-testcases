/**
 *  This test case verifies CBRD-25506: EXECUTE authorization of a recursive stored function
 *  called from a function of another owner.
 *  Revised for CBRD-26470: a direct call checks EXECUTE when the caller is compiled, so the
 *  first creation of public.fibonacci, before the grant, fails, and the check is made again
 *  at run time after the revoke.
 *
 *  Coverage:
 *    Case 1: dba.fibonacci is created, and public.fibonacci calling it without EXECUTE fails to
 *            compile with EXECUTE authorization failure
 *    Case 2: the owner and the source of dba.fibonacci in the catalog, no row of public.fibonacci
 *    Case 3: dba.fibonacci runs recursively
 *    Case 4: after GRANT EXECUTE to public, public.fibonacci is created and runs
 *    Case 5: after REVOKE, public.fibonacci fails at run time and its WHEN OTHERS handler runs
 */

--+ server-message on

evaluate 'Case 1: public.fibonacci calling dba.fibonacci without EXECUTE fails to compile';
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

evaluate 'Case 2: the owner and the source of the created function in the catalog';
SELECT unique_name, sp_name, owner.name FROM _db_stored_procedure WHERE is_system_generated = 0 order by owner.name;
SELECT 'Func_FIBONACCI' as "name", owner.name, scode, substr(scode,0,6) FROM _db_stored_procedure_code order by owner.name;

evaluate 'Case 3: dba.fibonacci runs recursively; result = 2';
select fibonacci(3) as "dba fibonacci: succ" from dual;

evaluate 'Case 4: after the grant, public.fibonacci is created and runs; result = 2';
GRANT EXECUTE ON PROCEDURE dba.fibonacci TO public;

-- the same function as in Case 1, created again after the grant
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

select public.fibonacci(3) as "public fibonacci: succ" from dual;

evaluate 'Case 5: after the revoke, the run-time check fails and WHEN OTHERS runs; result = -1 and unknown exception';
REVOKE EXECUTE ON PROCEDURE dba.fibonacci FROM public;

select public.fibonacci(3) as "public fibonacci: fail" from dual;


drop FUNCTION dba.fibonacci;
drop FUNCTION public.fibonacci;

--+ server-message off
