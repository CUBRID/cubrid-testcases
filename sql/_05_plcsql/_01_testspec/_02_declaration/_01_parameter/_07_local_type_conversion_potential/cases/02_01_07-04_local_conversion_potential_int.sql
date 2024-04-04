--+ server-message on

select 'An error occurs. ( t_boolean, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('boolean => ' ||  param ) ; 
    END;
begin
    t_local('boolean', a_param );
end;

call t_int('boolean' ) ;
drop procedure t_int;



select 'It is called normally. ( t_string, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param string := '123' ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('string => ' ||  param ) ; 
    END;
begin
    t_local('string', a_param );
end;

call t_int('string' ) ;
drop procedure t_int;



select 'It is called normally. ( t_short, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('short => ' ||  param ) ; 
    END;
begin
    t_local('short', a_param );
end;

call t_int('short' ) ;
drop procedure t_int;



select 'It is called normally. ( t_int, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('int => ' ||  param ) ; 
    END;
begin
    t_local('int', a_param );
end;

call t_int('int' ) ;
drop procedure t_int;



select 'It is called normally. ( t_bigint, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('bigint => ' ||  param ) ; 
    END;
begin
    t_local('bigint', a_param );
end;

call t_int('bigint' ) ;
drop procedure t_int;



select 'It is called normally. ( t_numeric(8,3), int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('numeric(8,3) => ' ||  param ) ; 
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_int('numeric(8,3)' ) ;
drop procedure t_int;



select 'It is called normally. ( t_float, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('float => ' ||  param ) ; 
    END;
begin
    t_local('float', a_param );
end;

call t_int('float' ) ;
drop procedure t_int;



select 'It is called normally. ( t_double, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('double => ' ||  param ) ; 
    END;
begin
    t_local('double', a_param );
end;

call t_int('double' ) ;
drop procedure t_int;



select 'An error occurs. ( t_date, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('date => ' ||  param ) ; 
    END;
begin
    t_local('date', a_param );
end;

call t_int('date' ) ;
drop procedure t_int;



select 'An error occurs. ( t_time, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('time => ' ||  param ) ; 
    END;
begin
    t_local('time', a_param );
end;

call t_int('time' ) ;
drop procedure t_int;



select 'An error occurs. ( t_datetime, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('datetime => ' ||  param ) ; 
    END;
begin
    t_local('datetime', a_param );
end;

call t_int('datetime' ) ;
drop procedure t_int;



select 'An error occurs. ( t_timestamp, int )' ;
create or replace procedure t_int( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param int) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to int' ); 
        dbms_output.put_line('timestamp => ' ||  param ) ; 
    END;
begin
    t_local('timestamp', a_param );
end;

call t_int('timestamp' ) ;
drop procedure t_int;



--+ server-message off
