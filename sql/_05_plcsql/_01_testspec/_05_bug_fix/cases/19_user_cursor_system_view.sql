/**
 *  This test case verifies CBRD-25563: a normal user gets an authorization error when a PL/CSQL
 *  cursor selects from db_class, db_vclass or db_attribute
 *
 *  After the fix a cursor over these system views returns the rows that the user may see.
 *  u1 is a normal user, and u2 is a member of the dba group.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  dba.test_sp1 run by dba counts the rows of db_class, db_vclass and db_attribute per owner in cursors
 *    Case 2:  u1.test_sp1 run by u1 counts only the rows that u1 may see, with no authorization error
 *    Case 3:  u2.test_sp1 run by u2, a member of dba, counts the same rows as dba
 *    Case 4:  a cursor of u1.test_sp2 over db_class that calls the Java function dba.hello runs; result = Hello, a
 *    Case 5:  u1 calls u2.test_sp1, owned by a member of dba and granted to u1, and it reads dba.t1; result = z
 */

--+ server-message on

create user u1;
create user u2 groups dba;

evaluate 'Case 1: dba.test_sp1 run by dba counts the rows of db_class, db_vclass and db_attribute per owner in cursors';
drop view if exists dba.v1;
drop table if exists dba.t1;
create table dba.t1(col1 char(1));
create view  dba.v1 as select * from dba.t1;
 
create or replace procedure dba.test_sp1 as
    cursor c1 is select owner_name, count(*) cnt from db_class group by owner_name;        
    cursor c2 is select owner_name, count(*) cnt from db_vclass group by owner_name;       
    cursor c3 is select owner_name, count(*) cnt from db_attribute group by owner_name;    
begin
    DBMS_OUTPUT.put_line('onwer is dba');
    FOR r IN c1 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
    FOR r IN c2 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
    FOR r IN c3 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
end;

create table u1.t1(col1 char(1));
create view  u1.v1 as select * from u1.t1;
 
create or replace procedure u1.test_sp1 as
    cursor c1 is select owner_name, count(*) cnt from db_class group by owner_name;        
    cursor c2 is select owner_name, count(*) cnt from db_vclass group by owner_name;       
    cursor c3 is select owner_name, count(*) cnt from db_attribute group by owner_name;    
begin
    DBMS_OUTPUT.put_line('onwer is u1');
    FOR r IN c1 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
    FOR r IN c2 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
    FOR r IN c3 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
end;

create table u2.t1(col1 char(1));
create view  u2.v1 as select * from u2.t1;
 
create or replace procedure u2.test_sp1 as
    cursor c1 is select owner_name, count(*) cnt from db_class group by owner_name;        
    cursor c2 is select owner_name, count(*) cnt from db_vclass group by owner_name;       
    cursor c3 is select owner_name, count(*) cnt from db_attribute group by owner_name;    
begin
    DBMS_OUTPUT.put_line('onwer is u2');
    FOR r IN c1 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
    FOR r IN c2 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
    FOR r IN c3 LOOP
        DBMS_OUTPUT.put_line(r.owner_name||' '||r.cnt);
    END LOOP;
end;

call dba.test_sp1();
evaluate 'Case 2: u1.test_sp1 run by u1 counts only the rows that u1 may see, with no authorization error';
call login('u1','') on class db_user;
call u1.test_sp1();
evaluate 'Case 3: u2.test_sp1 run by u2, a member of dba, counts the same rows as dba';
call login('u2','') on class db_user;
call u2.test_sp1();

-- back to dba
call login('dba','') on class db_user;

drop procedure dba.test_sp1;
drop procedure u1.test_sp1;
drop procedure u2.test_sp1;

drop view dba.v1, u1.v1, u2.v1;
drop table dba.t1, u1.t1, u2.t1;


evaluate 'Case 4: a cursor of u1.test_sp2 over db_class that calls the Java function dba.hello runs; result = Hello, a';
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

drop function hello;


evaluate 'Case 5: u1 calls u2.test_sp1, owned by a member of dba and granted to u1, and it reads dba.t1; result = z';
create table t1(col1 char(1));
insert t1 values('z');

create or replace procedure u2.test_sp1 as
    cursor c1 is select col1 from dba.t1;
begin
    FOR r IN c1 LOOP
        DBMS_OUTPUT.put_line('dba.t1 value: ' || r.col1);
    END LOOP;
end;

grant execute on procedure u2.test_sp1 to u1;

-- as u1
call login('u1','') on class db_user;

call u2.test_sp1();

-- back to dba
call login('dba','') on class db_user;

drop procedure u2.test_sp1;
drop t1;


drop user u1;
drop user u2;


--+ server-message off
