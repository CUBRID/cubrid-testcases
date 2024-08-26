--+ server-message on
-- verified for CBRD-25083

create or replace procedure p0(n numeric) as 
begin
    dbms_output.put_line('in p0');
    dbms_output.put_line(n);
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
    dbms_output.put_line(n);
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
    dbms_output.put_line(n);
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
    n := f0();
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
    n := f1();
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
    n := f2();
    dbms_output.put_line(n);
    dbms_output.put_line('after f2');
end;
call f_test2();
drop procedure f_test2;
drop function f2;


create or replace function rf3 return numeric as
begin
    dbms_output.put_line('in rf3');
    return 1.2;
end;
create or replace procedure rf_test3 as
    n numeric(2,1);
begin
    n := rf3();
    dbms_output.put_line(n);
    dbms_output.put_line('after rf3');
end;
call rf_test3();
drop procedure rf_test3;
drop function rf3;


create or replace function rf4 return char as
begin
    dbms_output.put_line('in rf4');
    return 'char';
end;
create or replace procedure rf_test4 as
    n char(4);
begin
    n := rf4();
    dbms_output.put_line(n);
    dbms_output.put_line('after rf4');
end;
call rf_test4();
drop procedure rf_test4;
drop function rf4;


create or replace function rf5 return varchar as
begin
    dbms_output.put_line('in rf5');
    return 'varchar';
end;
create or replace procedure rf_test5 as
    n varchar;
begin
    n := rf5();
    dbms_output.put_line(n);
    dbms_output.put_line('after rf5');
end;
call rf_test5();
drop procedure rf_test5;
drop function rf5;


--+ server-message off
