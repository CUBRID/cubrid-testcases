-- ============================================
-- CBRD-25855: PL/CSQL OPEN FOR with dynamic SQL and USING clause
-- Negative scenarios (N1-N8)
--   - non-string SQL and unsupported USING types -> compile errors
--   - DML in OPEN FOR, non-existent object, bind-count mismatch -> run-time errors
-- ============================================

--+ server-message on

drop table if exists emp;
create table emp (id int primary key, name varchar(20), dept int);
insert into emp values (1,'a',10),(2,'b',10),(3,'c',20);

-- N1: dynamic SQL expression is not a string type (compile error)
evaluate 'N1: non-string SQL in OPEN FOR';
create or replace procedure p_neg1 as
    c sys_refcursor;
    n int := 5;
begin
    open c for n;
end;

-- N2: USING value of type SYS_REFCURSOR is rejected (compile error)
evaluate 'N2: USING sys_refcursor';
create or replace procedure p_neg2 as
    c sys_refcursor;
    c2 sys_refcursor;
begin
    open c for 'select id from emp where id = ?' using c2;
end;

-- N3: USING value of type BOOLEAN is rejected (compile error)
evaluate 'N3: USING boolean';
create or replace procedure p_neg3 as
    c sys_refcursor;
    b boolean := true;
begin
    open c for 'select id from emp where id = ?' using b;
end;

-- N4: USING value of type CURSOR is rejected (compile error)
evaluate 'N4: USING cursor';
create or replace procedure p_neg4 as
    cursor cur is select id from emp;
    c sys_refcursor;
begin
    open c for 'select id from emp where id = ?' using cur;
end;

-- N5: USING a RECORD type (%ROWTYPE) is rejected (compile error) -- completes the
--     AC's unsupported USING type list (record / cursor / boolean / sys_refcursor)
evaluate 'N5: USING record (%ROWTYPE)';
create or replace procedure p_neg5 as
    c sys_refcursor;
    r emp%rowtype;
begin
    open c for 'select id from emp where id = ?' using r;
end;

-- N6: a DML query given to OPEN FOR is rejected at run time (only SELECT allowed).
--     INSERT/UPDATE/DELETE all raise the same error, so INSERT is representative.
create or replace procedure p_run(p_sql varchar) as
    c sys_refcursor;
    v_id int;
begin
    open c for p_sql;
    fetch c into v_id;
    close c;
end;
evaluate 'N6: DML given to OPEN FOR -> must be a SELECT statement (run time)';
call p_run('insert into emp(id,dept) values (9,30)');

-- N7: OPEN FOR runs the dynamic SQL without compile-time checks -- referencing a
--     non-existent table compiles fine (N7-compile) but fails only at CALL (N7-run)
evaluate 'N7-compile: non-existent table -> procedure still compiles';
create or replace procedure p_badsql as
    c sys_refcursor;
    v int;
begin
    open c for 'select id from no_such_table where id = 1';
    fetch c into v;
    close c;
end;
evaluate 'N7-run: fails only at CALL time (Unknown class)';
call p_badsql();

-- N8: fewer USING values than '?' placeholders is rejected at run time
create or replace procedure p_mis(p_a int) as
    c sys_refcursor;
begin
    open c for 'select id from emp where id >= ? and id <= ?' using p_a;
    close c;
end;
evaluate 'N8: fewer USING values than placeholders (run time)';
call p_mis(1);

-- N9: more USING values than '?' placeholders is rejected at run time
--     (a different error than N8's "not all the parameters are binded")
create or replace procedure p_more(p_a int, p_b int) as
    c sys_refcursor;
begin
    open c for 'select id from emp where id = ?' using p_a, p_b;
    close c;
end;
evaluate 'N9: more USING values than placeholders (run time)';
call p_more(1, 2);

drop procedure p_run;
drop procedure p_badsql;
drop procedure p_mis;
drop procedure p_more;
drop table if exists emp;

--+ server-message off
