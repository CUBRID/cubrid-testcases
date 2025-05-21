--+ server-message on
-- verified the CBRD-25563
-- bug fix: normal user has permission error when search to db_class, db_vclass, db_attribute on pl/csql cursor

create user u1;
create user u2 groups dba;

evaluate 'case 1: search to db_class, db_vclass, db_attribute from each users on pl/csql';
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
evaluate 'connect u1';
call login('u1','') on class db_user;
call u1.test_sp1();
evaluate 'connect u2';
call login('u2','') on class db_user;
call u2.test_sp1();

evaluate 'connect dba';
call login('dba','') on class db_user;

drop procedure dba.test_sp1;
drop procedure u1.test_sp1;
drop procedure u2.test_sp1;

drop view dba.v1, u1.v1, u2.v1;
drop table dba.t1, u1.t1, u2.t1;


evaluate 'case 2: u1 is search to db_class with dba function on cursor';
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


evaluate 'u1 is call the u2(=dba group) function then u1 is possible to watch the dba.t1 value';
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

evaluate 'connect u1';
call login('u1','') on class db_user;

call u2.test_sp1();

evaluate 'connect dba';
call login('dba','') on class db_user;

drop procedure u2.test_sp1;
drop t1;



evaluate 'test end';
drop user u1;
drop user u2;


--+ server-message off
