--+ server-message on

-- A test case that uses functions and calculation formulas to assign variable values. If processed normally.
-- If an error occurs.

create or replace procedure t  as
    a date := to_date('2012-11-28', 'YYYY-MM-DD') + 7 ;
begin
    dbms_output.put_line('a = ' || a );

    a := to_date('1974-12-27', 'YYYY-MM-DD') + 7 ;
    dbms_output.put_line('a = ' || a );
end;
call t();


create or replace procedure t  as
    a string := to_char(to_datetime('2012-11-28 23:59:59', 'YYYY-MM-DD HH24:MI:SS')+1000, 'YYYY-MM-DD HH24:MI:SS' );
begin
    dbms_output.put_line('a =' || a );

    a := to_char(to_datetime('1974-12-27 23:59:59', 'YYYY-MM-DD HH24:MI:SS')+1000, 'YYYY-MM-DD HH24:MI:SS' );
    dbms_output.put_line('a =' || a );
end;
call t();


create or replace procedure t  as
    a varchar := lpad('4', 5, '0');
begin
    dbms_output.put_line('a = ' || a );

    a := repeat('cubrid ', 3);
    dbms_output.put_line('a = ' || a );
end;
call t();


create or replace procedure t  as
    a varchar;
begin
    a := CHARSET('abc');
    dbms_output.put_line('a = ' || a );
end;
call t();


drop procedure t;


--+ server-message off

