--+ server-message on
-- Verified for CBRD-25352
-- check to pl/csql

evaluate 'create dba.test_proc';
create or replace procedure test_proc as
begin
    for r in (select t.name from db_user t order by t.name) loop
        dbms_output.put_line('user name=' || r.name);
    end loop;
end;

call test_proc();


evaluate 'create public.test_proc';
create or replace procedure public.test_proc as
begin
    for r in (select t.name from db_user t order by t.name) loop
        dbms_output.put_line('user name=' || r.name);
    end loop;
end;

call public.test_proc();


evaluate 'create table athlete & insert procedure & delete procedure';
create table athlete(
    code integer AUTO_INCREMENT(16693, 1) NOT NULL,
    [name] character varying(40) NOT NULL,
    gender character(1),
    nation_code character(3),
    [event] character varying(30)
);

CREATE OR REPLACE PROCEDURE insert_athlete(
    p_name VARCHAR,
    p_gender VARCHAR,
    p_nation_code VARCHAR,
    p_event VARCHAR)
AS
BEGIN
    INSERT INTO athlete (name, gender, nation_code, event)
    VALUES (p_name, p_gender, p_nation_code, p_event);

    COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
END;

CREATE OR REPLACE PROCEDURE delete_athlete(c INTEGER)
AS
    n_deleted INTEGER;
BEGIN
    DELETE FROM athlete WHERE code = c;

    n_deleted := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.put_line(n_deleted || ' rows deleted');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('exception occurred');
END;

evaluate 'select insert_athlete() & call insert_athlete()';
select insert_athlete('a','a','a','a') from dual;
select * from athlete order by code;
		
call insert_athlete('b','b','b','b');
select * from athlete order by code;


evaluate 'select delete_athlete() & call delete_athlete()';
select delete_athlete(16693);
select * from athlete order by code;

call delete_athlete(16694);
select * from athlete order by code;


evaluate 'create function dba.fibonacci';
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

evaluate 'ERROR: Stored procedure execute error';
select fibonacci('a');

evaluate 'ERROR: Parameter count is invalid';
select fibonacci('aaa',2);


evaluate 'create user u1 & connect to u1';
create user u1;
call login('u1','') on class db_user;


evaluate 'create function public.fibonacci, ERROR: DBA, members of DBA group, and owner can perform CREATE PROCEDURE/FUNCTION';
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
        RETURN public.fibonacci(n-1) + public.fibonacci(n-2);
    END IF;
EXCEPTION
    WHEN invalid_input THEN
        DBMS_OUTPUT.put_line('invalid input: ' || n);
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('unknown exception');
        RETURN -1;
END;


evaluate 'connect to public & create function public.fibonacci2';
call login('public','') on class db_user;

CREATE OR REPLACE FUNCTION public.fibonacci2(n INTEGER) RETURN INTEGER
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

evaluate 'select public.fibonacci2';
select public.fibonacci2(3);


evaluate 'connect to dba & create function public.fibonacci';
call login('dba','') on class db_user;

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
        RETURN public.fibonacci(n-1) + public.fibonacci(n-2);
    END IF;
EXCEPTION
    WHEN invalid_input THEN
        DBMS_OUTPUT.put_line('invalid input: ' || n);
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('unknown exception');
        RETURN -1;
END;

evaluate 'select public.fibonacci() from dual';
select public.fibonacci(3) from dual;


evaluate 'create function dba.fibonacci2';
CREATE OR REPLACE FUNCTION fibonacci2(n INTEGER) RETURN INTEGER
IS
    invalid_input EXCEPTION;
BEGIN
    IF n <= 0 THEN
        RAISE invalid_input;
    END IF;

    IF n = 1 OR n = 2 THEN
        RETURN 1;
    ELSE
        RETURN public.fibonacci(n-1) + public.fibonacci(n-2);
    END IF;
EXCEPTION
    WHEN invalid_input THEN
        DBMS_OUTPUT.put_line('invalid input: ' || n);
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('unknown exception');
        RETURN -1;
END;

evaluate 'select fibonacci2() from dual';
select fibonacci2(3) from dual;


evaluate 'Test done';
DROP PROCEDURE test_proc;
DROP PROCEDURE public.test_proc;
DROP PROCEDURE insert_athlete;
DROP PROCEDURE delete_athlete;
DROP FUNCTION fibonacci;
DROP FUNCTION fibonacci2;
DROP FUNCTION public.fibonacci;
DROP FUNCTION public.fibonacci2;
drop user u1;
drop table athlete;

--+ server-message off
