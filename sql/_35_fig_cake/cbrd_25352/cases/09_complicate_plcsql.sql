/**
 *  This test case verifies CBRD-25352: PL/CSQL stored procedures and functions of dba and of
 *  other owners, created, called and dropped.
 *  Revised for CBRD-26470: a direct call checks EXECUTE when the caller is compiled, so
 *  public.fibonacci2, which calls dba.fibonacci without EXECUTE, fails to compile.
 *
 *  Coverage:
 *    Case 1:  dba.test_proc with a FOR loop over a query is created and runs
 *    Case 2:  public.test_proc created by dba is created and runs
 *    Case 3:  table athlete and the procedures insert_athlete and delete_athlete are created
 *    Case 4:  each call of insert_athlete inserts a row
 *    Case 5:  each call of delete_athlete deletes a row and prints the count
 *    Case 6:  the recursive function dba.fibonacci is created and runs
 *    Case 7:  dba.fibonacci with a string argument fails with a stored procedure execute error
 *    Case 8:  dba.fibonacci with two arguments fails with an invalid parameter count
 *    Case 9:  u1 creating public.fibonacci is refused (DBA, members of DBA group, and owner only)
 *    Case 10: public creating public.fibonacci2 that calls dba.fibonacci without EXECUTE fails to
 *             compile with EXECUTE authorization failure
 *    Case 11: dba creates public.fibonacci
 *    Case 12: public.fibonacci runs recursively
 *    Case 13: dba.fibonacci2 calling public.fibonacci is created
 *    Case 14: dba.fibonacci2 runs
 */

--+ server-message on

evaluate 'Case 1: dba.test_proc is created and runs';
create or replace procedure test_proc as
begin
    for r in (select t.name from db_user t order by t.name) loop
        dbms_output.put_line('user name=' || r.name);
    end loop;
end;

call test_proc();


evaluate 'Case 2: public.test_proc is created by dba and runs';
create or replace procedure public.test_proc as
begin
    for r in (select t.name from db_user t order by t.name) loop
        dbms_output.put_line('user name=' || r.name);
    end loop;
end;

call public.test_proc();


evaluate 'Case 3: table athlete and the procedures insert_athlete and delete_athlete are created';
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

evaluate 'Case 4: each call of insert_athlete inserts a row';
call insert_athlete('a','a','a','a');
select * from athlete order by code;
		
call insert_athlete('b','b','b','b');
select * from athlete order by code;


evaluate 'Case 5: each call of delete_athlete deletes a row';
call delete_athlete(16693);
select * from athlete order by code;

call delete_athlete(16694);
select * from athlete order by code;


evaluate 'Case 6: the recursive function dba.fibonacci is created and runs';
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

evaluate 'Case 7: a string argument fails with a stored procedure execute error';
select fibonacci('a');

evaluate 'Case 8: two arguments fail with an invalid parameter count';
select fibonacci('aaa',2);


evaluate 'Case 9: u1 creating public.fibonacci is refused: DBA, members of DBA group, and owner can perform CREATE PROCEDURE/FUNCTION';
create user u1;
call login('u1','') on class db_user;

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


evaluate 'Case 10: public creating public.fibonacci2 that calls dba.fibonacci without EXECUTE fails: EXECUTE authorization failure';
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


evaluate 'Case 11: dba creates public.fibonacci';
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

evaluate 'Case 12: public.fibonacci runs recursively';
select public.fibonacci(3) from dual;


evaluate 'Case 13: dba.fibonacci2 calling public.fibonacci is created';
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

evaluate 'Case 14: dba.fibonacci2 runs';
select fibonacci2(3) from dual;


DROP PROCEDURE test_proc;
DROP PROCEDURE public.test_proc;
DROP PROCEDURE insert_athlete;
DROP PROCEDURE delete_athlete;
DROP FUNCTION fibonacci;
DROP FUNCTION fibonacci2;
DROP FUNCTION public.fibonacci;
drop user u1;
drop table athlete;

--+ server-message off
