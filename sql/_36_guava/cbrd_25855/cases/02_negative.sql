/**
 *  This test case verifies CBRD-25855: PL/CSQL OPEN FOR with dynamic SQL and a USING clause,
 *  negative scenarios.
 *
 *  A non-string SQL and unsupported USING types are compile errors. DML in OPEN FOR, a
 *  missing object, a bind count mismatch and an empty or NULL SQL string are run time errors.
 *  The whole file runs under server-message, so each error prints its message.
 *
 *  Coverage:
 *    Case 1:  a non-string SQL expression in OPEN FOR is a compile error
 *    Case 2:  a USING value of type SYS_REFCURSOR is a compile error
 *    Case 3:  a USING value of type BOOLEAN is a compile error
 *    Case 4:  a USING value of type CURSOR is a compile error
 *    Case 5:  a USING value of a RECORD type (ROWTYPE) is a compile error
 *    Case 6:  a DML statement given to OPEN FOR fails at run time, only SELECT is allowed
 *    Case 7:  a missing table in the dynamic SQL compiles and fails only at CALL
 *    Case 8:  fewer USING values than placeholders fail at run time
 *    Case 9:  more USING values than placeholders fail at run time with another error than Case 8
 *    Case 10: an empty dynamic SQL string in OPEN FOR fails at run time
 *    Case 11: a NULL dynamic SQL string in OPEN FOR fails at run time
 */

--+ server-message on

drop table if exists emp;
create table emp (id int primary key, name varchar(20), dept int);
insert into emp values (1,'a',10),(2,'b',10),(3,'c',20);

evaluate 'Case 1: a non-string SQL expression in OPEN FOR is a compile error';
create or replace procedure p_neg1 as
    c sys_refcursor;
    n int := 5;
begin
    open c for n;
end;

evaluate 'Case 2: a USING value of type SYS_REFCURSOR is a compile error';
create or replace procedure p_neg2 as
    c sys_refcursor;
    c2 sys_refcursor;
begin
    open c for 'select id from emp where id = ?' using c2;
end;

evaluate 'Case 3: a USING value of type BOOLEAN is a compile error';
create or replace procedure p_neg3 as
    c sys_refcursor;
    b boolean := true;
begin
    open c for 'select id from emp where id = ?' using b;
end;

evaluate 'Case 4: a USING value of type CURSOR is a compile error';
create or replace procedure p_neg4 as
    cursor cur is select id from emp;
    c sys_refcursor;
begin
    open c for 'select id from emp where id = ?' using cur;
end;

-- Cases 2 to 5 cover the unsupported USING types of the issue: sys_refcursor, boolean, cursor and record
evaluate 'Case 5: a USING value of a RECORD type (%ROWTYPE) is a compile error';
create or replace procedure p_neg5 as
    c sys_refcursor;
    r emp%rowtype;
begin
    open c for 'select id from emp where id = ?' using r;
end;

-- INSERT, UPDATE and DELETE raise the same error, so INSERT stands for them
evaluate 'Case 6: a DML statement given to OPEN FOR fails at run time, only SELECT is allowed';
create or replace procedure p_run(p_sql varchar) as
    c sys_refcursor;
    v_id int;
begin
    open c for p_sql;
    fetch c into v_id;
    close c;
end;
call p_run('insert into emp(id,dept) values (9,30)');

-- OPEN FOR does not check the dynamic SQL at compile time
evaluate 'Case 7: a missing table in the dynamic SQL compiles and fails only at CALL (Unknown class)';
create or replace procedure p_badsql as
    c sys_refcursor;
    v int;
begin
    open c for 'select id from no_such_table where id = 1';
    fetch c into v;
    close c;
end;
call p_badsql();

evaluate 'Case 8: fewer USING values than placeholders fail at run time';
create or replace procedure p_mis(p_a int) as
    c sys_refcursor;
begin
    open c for 'select id from emp where id >= ? and id <= ?' using p_a;
    close c;
end;
call p_mis(1);

evaluate 'Case 9: more USING values than placeholders fail at run time with another error than Case 8';
create or replace procedure p_more(p_a int, p_b int) as
    c sys_refcursor;
begin
    open c for 'select id from emp where id = ?' using p_a, p_b;
    close c;
end;
call p_more(1, 2);

evaluate 'Case 10: an empty dynamic SQL string in OPEN FOR fails at run time';
call p_run('');

evaluate 'Case 11: a NULL dynamic SQL string in OPEN FOR fails at run time';
call p_run(null);

-- The procedures of Cases 1 to 5 fail to compile, so their drops fail too. The drops stay
-- so that a procedure that compiles after a change of the engine does not stay in the database.
drop procedure p_neg1;
drop procedure p_neg2;
drop procedure p_neg3;
drop procedure p_neg4;
drop procedure p_neg5;
drop procedure p_run;
drop procedure p_badsql;
drop procedure p_mis;
drop procedure p_more;
drop table if exists emp;

--+ server-message off
