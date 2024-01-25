--+ server-message on

-- A test case that uses functions and calculation formulas to assign variable values. 
-- If an error occurs.

--create OK. run error.
create or replace procedure t  as
    a date := to_date('2012-13-28', 'YYYY-MM-DD') + 7 ;
begin
    dbms_output.put_line('a = ' || a );
end; 
call t();


--create OK. run error.
create or replace procedure t  as
    a date ;
begin
    a := to_date('1974-12-34', 'YYYY-MM-DD') + 7 ;
    dbms_output.put_line('a = ' || a );
end; 
call t();


--create OK. run error.
create or replace procedure t  as
    a string := to_char(to_datetime('2012-11-28 23:59:61', 'YYYY-MM-DD HH24:MI:SS')+1000, 'YYYY-MM-DD HH24:MI:SS' );
begin
    dbms_output.put_line('a =' || a );
end;
call t();


--create OK. run error.
create or replace procedure t  as
    a string ;
begin
    a := to_char(to_datetime('1974-12-27 23:59:61', 'YYYY-MM-DD HH24:MI:SS')+1000, 'YYYY-MM-DD HH24:MI:SS' );
    dbms_output.put_line('a =' || a );
end;
call t();

-- run error.
create or replace procedure t  as
    a varchar := lpad('4', 5, '0','abc');
begin
    dbms_output.put_line('a = ' || a );
end;


-- run error.
create or replace procedure t  as
    a varchar;
begin
    a := repeat('cubrid ', 3, 'def');
    dbms_output.put_line('a = ' || a );
end;


-- run error.
create or replace procedure t  as
    a varchar := USER_A();
begin
    dbms_output.put_line('a = ' || a );
end;


--create OK. run error.
create or replace procedure t  as
    a varchar;
begin
    a := CHARSET(123);
    dbms_output.put_line('a = ' || a );
end;
call t();



drop procedure t;


--+ server-message off

