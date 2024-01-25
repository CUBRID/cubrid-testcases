--+ server-message on

-- Check whether an error occurs when performing calculations on assigned constant values using functions and calculation expressions.

create or replace procedure t  as
    a constant date := to_date('2012-11-28', 'YYYY-MM-DD') + 7 ;
begin
    a := a - 5;
    dbms_output.put_line('a = ' || a );
end;


create or replace procedure t  as
    a constant string := to_char(to_datetime('2012-11-28 23:59:59', 'YYYY-MM-DD HH24:MI:SS')+1000, 'YYYY-MM-DD HH24:MI:SS' );
begin
    a := a || 'to_datetime function';
    dbms_output.put_line('a =' || a );
end;


create or replace procedure t  as
    a constant varchar := lpad('4', 5, '0');
begin
    a := a|| 'lpad function';
    dbms_output.put_line('a = ' || a );
end;


create or replace procedure t  as
    a constant varchar := USER();
begin
    a := a || 'user function';
    dbms_output.put_line('a = ' || a );
end;


--+ server-message off

