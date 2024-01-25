--+ server-message on

-- A test case that uses functions and calculation formulas to assign constant values. 
-- If processed normally.

create or replace procedure t  as
    a constant date := to_date('2012-11-28', 'YYYY-MM-DD') + 7 ;
begin
    dbms_output.put_line('a = ' || a );
end;
call t();


create or replace procedure t  as
    a constant string := to_char(to_datetime('2012-11-28 23:59:59', 'YYYY-MM-DD HH24:MI:SS')+1000, 'YYYY-MM-DD HH24:MI:SS' );
begin
    dbms_output.put_line('a =' || a );
end;
call t();


create or replace procedure t  as
    a constant varchar := lpad('4', 5, '0');
begin
    dbms_output.put_line('a = ' || a );
end;
call t();


create or replace procedure t  as
    a constant varchar := USER();
begin
    dbms_output.put_line('a = ' || a );
end;
call t();


drop procedure t;


--+ server-message off

