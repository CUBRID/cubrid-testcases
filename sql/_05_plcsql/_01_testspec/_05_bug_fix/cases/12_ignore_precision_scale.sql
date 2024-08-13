--+ server-message on
-- verified for CBRD-25083

create or replace procedure p0(n numeric) as 
begin
    dbms_output.put_line('in p0');
    null;
end;
create or replace procedure p_test0 as
begin
    p0(7);
    dbms_output.put_line('after p0');
end;
call p_test0();
drop procedure p_test0;
drop procedure p0;


create or replace procedure p1(n char) as 
begin
    dbms_output.put_line('in p1');
    null;
end;
create or replace procedure p_test1 as
begin
    p1(7);
    dbms_output.put_line('after p1');
end;
call p_test1();
drop procedure p_test1;
drop procedure p1;


create or replace procedure p2(n varchar) as 
begin
    dbms_output.put_line('in p2');
    null;
end;
create or replace procedure p_test2 as
begin
    p2(7);
    dbms_output.put_line('after p2');
end;
call p_test2();
drop procedure p_test2;
drop procedure p2;



create or replace function f0 return numeric as
begin
    dbms_output.put_line('in f0');
    return null;
end;
create or replace procedure f_test0 as
    n numeric;
begin
    n := f0;
    dbms_output.put_line(n);
    dbms_output.put_line('after f0');
end;
call f_test0();
drop procedure f_test0;
drop function f0;


create or replace function f1 return char as
begin
    dbms_output.put_line('in f1');
    return null;
end;
create or replace procedure f_test1 as
    n numeric;
begin
    n := f1;
    dbms_output.put_line(n);
    dbms_output.put_line('after f1');
end;
call f_test1();
drop procedure f_test1;
drop function f1;


create or replace function f2 return varchar as
begin
    dbms_output.put_line('in f2');
    return null;
end;
create or replace procedure f_test2 as
    n numeric;
begin
    n := f2;
    dbms_output.put_line(n);
    dbms_output.put_line('after f2');
end;
call f_test2();
drop procedure f_test2;
drop function f2;


--+ server-message off
