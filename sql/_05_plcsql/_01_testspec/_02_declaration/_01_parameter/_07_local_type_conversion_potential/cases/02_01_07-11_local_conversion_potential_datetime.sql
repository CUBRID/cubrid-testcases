--+ server-message on

select 'An error occurs. ( t_boolean, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('boolean => ' ||  param ) ; 
    END;
begin
    t_local('boolean', a_param );
end;

call t_datetime('boolean' ) ;
drop procedure t_datetime;



select 'It is called normally. ( t_string, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param string := '2024-03-01 22:15:25' ; 
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('string => ' ||  param ) ; 
    END;
begin
    t_local('string', a_param );
end;

call t_datetime('string' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_short, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('short => ' ||  param ) ; 
    END;
begin
    t_local('short', a_param );
end;

call t_datetime('short' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_int, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('int => ' ||  param ) ; 
    END;
begin
    t_local('int', a_param );
end;

call t_datetime('int' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_bigint, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('bigint => ' ||  param ) ; 
    END;
begin
    t_local('bigint', a_param );
end;

call t_datetime('bigint' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_numeric(8,3), datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('numeric(8,3) => ' ||  param ) ; 
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_datetime('numeric(8,3)' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_float, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('float => ' ||  param ) ; 
    END;
begin
    t_local('float', a_param );
end;

call t_datetime('float' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_double, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('double => ' ||  param ) ; 
    END;
begin
    t_local('double', a_param );
end;

call t_datetime('double' ) ;
drop procedure t_datetime;



select 'It is called normally. ( t_date, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('date => ' ||  param ) ; 
    END;
begin
    t_local('date', a_param );
end;

call t_datetime('date' ) ;
drop procedure t_datetime;



select 'An error occurs. ( t_time, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('time => ' ||  param ) ; 
    END;
begin
    t_local('time', a_param );
end;

call t_datetime('time' ) ;
drop procedure t_datetime;



select 'It is called normally. ( t_datetime, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('datetime => ' ||  param ) ; 
    END;
begin
    t_local('datetime', a_param );
end;

call t_datetime('datetime' ) ;
drop procedure t_datetime;



select 'It is called normally. ( t_timestamp, datetime )' ;
create or replace procedure t_datetime( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param datetime) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to datetime' ); 
        dbms_output.put_line('timestamp => ' ||  param ) ; 
    END;
begin
    t_local('timestamp', a_param );
end;

call t_datetime('timestamp' ) ;
drop procedure t_datetime;



--+ server-message off
