--+ server-message on

select 'An error occurs. ( t_boolean, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('boolean => ' ||  param ) ; 
    END;
begin
    t_local('boolean', a_param );
end;

call t_date('boolean' ) ;
drop procedure t_date;



select 'It is called normally. ( t_string, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param string := '2024-03-05' ; 
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('string => ' ||  param ) ; 
    END;
begin
    t_local('string', a_param );
end;

call t_date('string' ) ;
drop procedure t_date;



select 'An error occurs. ( t_short, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('short => ' ||  param ) ; 
    END;
begin
    t_local('short', a_param );
end;

call t_date('short' ) ;
drop procedure t_date;



select 'An error occurs. ( t_int, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('int => ' ||  param ) ; 
    END;
begin
    t_local('int', a_param );
end;

call t_date('int' ) ;
drop procedure t_date;



select 'An error occurs. ( t_bigint, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('bigint => ' ||  param ) ; 
    END;
begin
    t_local('bigint', a_param );
end;

call t_date('bigint' ) ;
drop procedure t_date;



select 'An error occurs. ( t_numeric(8,3), date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('numeric(8,3) => ' ||  param ) ; 
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_date('numeric(8,3)' ) ;
drop procedure t_date;



select 'An error occurs. ( t_float, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('float => ' ||  param ) ; 
    END;
begin
    t_local('float', a_param );
end;

call t_date('float' ) ;
drop procedure t_date;



select 'An error occurs. ( t_double, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('double => ' ||  param ) ; 
    END;
begin
    t_local('double', a_param );
end;

call t_date('double' ) ;
drop procedure t_date;



select 'It is called normally. ( t_date, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('date => ' ||  param ) ; 
    END;
begin
    t_local('date', a_param );
end;

call t_date('date' ) ;
drop procedure t_date;



select 'An error occurs. ( t_time, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('time => ' ||  param ) ; 
    END;
begin
    t_local('time', a_param );
end;

call t_date('time' ) ;
drop procedure t_date;



select 'It is called normally. ( t_datetime, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('datetime => ' ||  param ) ; 
    END;
begin
    t_local('datetime', a_param );
end;

call t_date('datetime' ) ;
drop procedure t_date;



select 'It is called normally. ( t_timestamp, date )' ;
create or replace procedure t_date( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param date) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to date' ); 
        dbms_output.put_line('timestamp => ' ||  param ) ; 
    END;
begin
    t_local('timestamp', a_param );
end;

call t_date('timestamp' ) ;
drop procedure t_date;



--+ server-message off
