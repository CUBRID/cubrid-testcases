--+ server-message on
-- verified the CBRD-25513

create or replace function test_return() return varchar
as
begin
    return 't';
end;

create or replace procedure test_cursor1()
as
    cursor c is select dba.test_return() as col from dual;
begin
    for r in c loop
        dbms_output.put_line(r.col);
    end loop;
end;

select test_cursor1() from dual;

-- in user t1
create user t1 groups dba;
grant execute on procedure test_cursor1 to t1;

evaluate 'connect user t1';
call login('t1','') on class db_user;
select dba.test_cursor1() from dual;

-- in user dba
evaluate 'connect user dba';
call login('dba','') on class db_user;
drop user t1;

drop procedure test_cursor1;

create or replace procedure test_cursor2()
as
    test_type dual.dummy%type;
    cursor c is select dba.test_return() as col from db_class limit 3;
begin
    for r in c loop
        test_type := r.col;
        dbms_output.put_line(test_type);
    end loop;
end;

select test_cursor2() from dual;

drop procedure test_cursor2;
drop function test_return;

--+ server-message off
