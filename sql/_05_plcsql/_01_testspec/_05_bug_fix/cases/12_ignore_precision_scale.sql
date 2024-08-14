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

create or replace procedure p3(n numeric(2,1)) as 
begin
    dbms_output.put_line('in p3');
    null;
end;
create or replace procedure p_test3 as
begin
    p3(7);
    dbms_output.put_line('after p3');
end;
call p_test3();
drop procedure p_test3;
drop procedure p3;


create or replace procedure p4(n char(1)) as 
begin
    dbms_output.put_line('in p4');
    null;
end;
create or replace procedure p_test4 as
begin
    p4(7);
    dbms_output.put_line('after p4');
end;
call p_test4();
drop procedure p_test4;
drop procedure p4;


create or replace procedure p5(n varchar(1)) as 
begin
    dbms_output.put_line('in p5');
    null;
end;
create or replace procedure p_test5 as
begin
    p5(7);
    dbms_output.put_line('after p5');
end;
call p_test5();
drop procedure p_test5;
drop procedure p5;



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


create or replace function f3 return numeric as
begin
    dbms_output.put_line('in f3');
    return null;
end;
create or replace procedure f_test3 as
    n numeric;
begin
    n := f3();
    dbms_output.put_line(n);
    dbms_output.put_line('after f3');
end;
call f_test3();
drop procedure f_test3;
drop function f3;


create or replace function f4 return char as
begin
    dbms_output.put_line('in f4');
    return null;
end;
create or replace procedure f_test4 as
    n numeric;
begin
    n := f4();
    dbms_output.put_line(n);
    dbms_output.put_line('after f4');
end;
call f_test4();
drop procedure f_test4;
drop function f4;


create or replace function f5 return varchar(1) as
begin
    dbms_output.put_line('in f5');
    return null;
end;
create or replace procedure f_test5 as
    n numeric;
begin
    n := f5();
    dbms_output.put_line(n);
    dbms_output.put_line('after f5');
end;
call f_test5();
drop procedure f_test5;
drop function f5;


create or replace function rf6 return numeric as
begin
    dbms_output.put_line('in rf6');
    return 1.2;
end;
create or replace procedure rf_test6 as
    n numeric(2,1);
begin
    n := rf6();
    dbms_output.put_line(n);
    dbms_output.put_line('after rf6');
end;
call rf_test6();
drop procedure rf_test6;
drop function rf6;


create or replace function rf7 return char as
begin
    dbms_output.put_line('in rf7');
    return 'char';
end;
create or replace procedure rf_test7 as
    n char(4);
begin
    n := rf7();
    dbms_output.put_line(n);
    dbms_output.put_line('after rf7');
end;
call rf_test7();
drop procedure rf_test7;
drop function rf7;


create or replace function rf8 return varchar as
begin
    dbms_output.put_line('in rf8');
    return 'varchar';
end;
create or replace procedure rf_test8 as
    n varchar;
begin
    n := rf8();
    dbms_output.put_line(n);
    dbms_output.put_line('after rf8');
end;
call rf_test8();
drop procedure rf_test8;
drop function rf8;


--+ server-message off
