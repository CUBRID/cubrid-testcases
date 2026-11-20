/**
 *  This test case verifies CBRD-25097: a PL/CSQL procedure can call itself recursively,
 *  and CBRD-25907: an endless recursion fails with a stack overflow error.
 *
 *  Since CBRD-26470, a routine calls another routine directly, not through the server, so an
 *  endless recursion of direct calls ends with a stack overflow. A recursion through a SQL
 *  statement goes through the server on every call and ends with the limit of nested calls.
 *
 *  Coverage:
 *    Case 1:  a recursive procedure is created and prints i=5 down to i=0
 *    Case 2:  a procedure without parameters that calls itself fails with a stack overflow
 *    Case 3:  a procedure with parameters that calls itself fails with a stack overflow
 *    Case 4:  a procedure with a default parameter value that calls itself fails with a stack overflow
 *    Case 5:  two procedures that call each other fail with a stack overflow
 *    Case 6:  a function that calls itself through a SELECT statement fails with too many nested
 *             stored procedure calls
 */

--+ server-message on

evaluate 'Case 1: a recursive procedure is created and prints i=5 down to i=0';
create or replace procedure t(i int) as
begin
    if i <= 0 then
        dbms_output.put_line('i=' || i);
        return;
    else
        dbms_output.put_line('i=' || i);
        t(i - 1);
    end if;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(5);

evaluate 'Case 2: a procedure without parameters that calls itself fails with a stack overflow; result = Error:-889';
create or replace procedure t() as
begin
    t();
end;

call t();

evaluate 'Case 3: a procedure with parameters that calls itself fails with a stack overflow; result = Error:-889';
create or replace procedure t(i int, j int) as
begin
    t(i,j);
end;

call t(1,2);


evaluate 'Case 4: a procedure with a default parameter value that calls itself fails with a stack overflow; result = Error:-889';
create or replace procedure t(i int, j int := 20) as
begin
    t(i,j);
end;

call t(1);


-- u is created first so that t can call it, and then replaced to call t
evaluate 'Case 5: two procedures that call each other fail with a stack overflow; result = Error:-889';
create or replace procedure u() as
begin
    -- Placeholder; will be updated later
    null;
end;

create or replace procedure t() as
begin
    u();
end;

create or replace procedure u() as
begin
    t();
end;

call t(); 

drop procedure u;
drop procedure t;


-- f_sql is created first so that its SELECT statement can call it, and then replaced
evaluate 'Case 6: a function that calls itself through a SELECT statement fails with too many nested stored procedure calls; result = Error:-889';
create or replace function f_sql(i int) return int as
begin
    return 0;
end;

create or replace function f_sql(i int) return int as
    r int;
begin
    select f_sql(i + 1) into r from dual;
    return r;
end;

select f_sql(1) from dual;

drop function f_sql;



--+ server-message off
