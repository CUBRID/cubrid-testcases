--+ server-message on
-- verified the CBRD-25563

create user u1;

evaluate 'case 1: search to db_class, db_vclass, db_attribute on cursor on u1';
create or replace procedure u1.test_sp1 as
    cursor c1 is select 'db_class test' as sp from db_class limit 1;
    cursor c2 is select 'db_vclass test' as sp from db_vclass limit 1;
    cursor c3 is select 'db_attribute test' as sp from db_attribute limit 1;
begin
    FOR r IN c1 LOOP
        DBMS_OUTPUT.put_line(r.sp);
    END LOOP;
    FOR r IN c2 LOOP
        DBMS_OUTPUT.put_line(r.sp);
    END LOOP;
    FOR r IN c3 LOOP
        DBMS_OUTPUT.put_line(r.sp);
    END LOOP;
end;

call u1.test_sp1();

drop procedure u1.test_sp1;


evaluate 'case 2: search to db_class with dba function on cursor';
CREATE or replace FUNCTION hello(i String) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(java.lang.String) return java.lang.String';

grant execute on procedure dba.hello to u1;

create or replace procedure u1.test_sp2 as
    cursor c1 is select dba.hello('a') as sp from db_class limit 1;
begin
    FOR r IN c1 LOOP
        DBMS_OUTPUT.put_line(r.sp);
    END LOOP;
end;

call u1.test_sp2();

drop procedure u1.test_sp2;

drop user u1;
drop function hello;


--+ server-message off
