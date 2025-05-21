--+ server-message on
-- Verified the CBRD-25681
-- PL/CSQL test to granted user & ungranted user

create user ungranted_user;
create user granted_user;

evaluate 'create plcsql dba.fibonacci';
CREATE OR REPLACE FUNCTION fibonacci(n INTEGER) RETURN INTEGER
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

select fibonacci(3);

evaluate 'grant to granted_user for dba.fibonacci';
grant execute on procedure dba.fibonacci to granted_user;

evaluate 'connect to granted_user';
call login('granted_user', '') on class db_user;

evaluate 'select dba.fibonacci(3) & call dba.fibonacci(3)';
select dba.fibonacci(3);
call dba.fibonacci(3);

evaluate 'connect to ungranted_user';
call login('ungranted_user', '') on class db_user;
evaluate 'ERROR: EXECUTE authorization failure';
select dba.fibonacci(3);


evaluate 'connect to dba & Test done';
CALL login(CLASS db_user, 'dba', '');
DROP FUNCTION fibonacci;
DROP USER granted_user;
DROP USER ungranted_user;

--+ server-message off
