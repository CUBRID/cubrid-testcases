--+ server-message on

select 'An error occurs. ( t_boolean, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('boolean => ' ||  param ) ; 
    END;
begin
    t_local('boolean', a_param );
end;

call t_timestamp('boolean' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_string, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param string := '2024-03-01 22:15:25' ; 
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('string => ' ||  param ) ; 
    END;
begin
    t_local('string', a_param );
end;

call t_timestamp('string' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_short, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('short => ' ||  param ) ; 
    END;
begin
    t_local('short', a_param );
end;

call t_timestamp('short' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_int, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('int => ' ||  param ) ; 
    END;
begin
    t_local('int', a_param );
end;

call t_timestamp('int' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_bigint, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('bigint => ' ||  param ) ; 
    END;
begin
    t_local('bigint', a_param );
end;

call t_timestamp('bigint' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_numeric(8,3), timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('numeric(8,3) => ' ||  param ) ; 
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_timestamp('numeric(8,3)' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_float, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('float => ' ||  param ) ; 
    END;
begin
    t_local('float', a_param );
end;

call t_timestamp('float' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_double, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('double => ' ||  param ) ; 
    END;
begin
    t_local('double', a_param );
end;

call t_timestamp('double' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_date, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('date => ' ||  param ) ; 
    END;
begin
    t_local('date', a_param );
end;

call t_timestamp('date' ) ;
drop procedure t_timestamp;



select 'An error occurs. ( t_time, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('time => ' ||  param ) ; 
    END;
begin
    t_local('time', a_param );
end;

call t_timestamp('time' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_datetime, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('datetime => ' ||  param ) ; 
    END;
begin
    t_local('datetime', a_param );
end;

call t_timestamp('datetime' ) ;
drop procedure t_timestamp;



select 'It is called normally. ( t_timestamp, timestamp )' ;
create or replace procedure t_timestamp( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param timestamp) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to timestamp' ); 
        dbms_output.put_line('timestamp => ' ||  param ) ; 
    END;
begin
    t_local('timestamp', a_param );
end;

call t_timestamp('timestamp' ) ;
drop procedure t_timestamp;



--+ server-message off
