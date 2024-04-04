--+ server-message on

select 'An error occurs. ( t_boolean, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('boolean => ' ||  param ) ; 
    END;
begin
    t_local('boolean', a_param );
end;

call t_string('boolean' ) ;
drop procedure t_string;



select 'It is called normally. ( t_string, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param string := '123' ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('string => ' ||  param ) ; 
    END;
begin
    t_local('string', a_param );
end;

call t_string('string' ) ;
drop procedure t_string;



select 'It is called normally. ( t_short, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('short => ' ||  param ) ; 
    END;
begin
    t_local('short', a_param );
end;

call t_string('short' ) ;
drop procedure t_string;



select 'It is called normally. ( t_int, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('int => ' ||  param ) ; 
    END;
begin
    t_local('int', a_param );
end;

call t_string('int' ) ;
drop procedure t_string;



select 'It is called normally. ( t_bigint, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('bigint => ' ||  param ) ; 
    END;
begin
    t_local('bigint', a_param );
end;

call t_string('bigint' ) ;
drop procedure t_string;



select 'It is called normally. ( t_numeric(8,3), string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('numeric(8,3) => ' ||  param ) ; 
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_string('numeric(8,3)' ) ;
drop procedure t_string;



select 'It is called normally. ( t_float, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('float => ' ||  param ) ; 
    END;
begin
    t_local('float', a_param );
end;

call t_string('float' ) ;
drop procedure t_string;



select 'It is called normally. ( t_double, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('double => ' ||  param ) ; 
    END;
begin
    t_local('double', a_param );
end;

call t_string('double' ) ;
drop procedure t_string;



select 'It is called normally. ( t_date, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('date => ' ||  param ) ; 
    END;
begin
    t_local('date', a_param );
end;

call t_string('date' ) ;
drop procedure t_string;



select 'It is called normally. ( t_time, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('time => ' ||  param ) ; 
    END;
begin
    t_local('time', a_param );
end;

call t_string('time' ) ;
drop procedure t_string;



select 'It is called normally. ( t_datetime, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('datetime => ' ||  param ) ; 
    END;
begin
    t_local('datetime', a_param );
end;

call t_string('datetime' ) ;
drop procedure t_string;



select 'It is called normally. ( t_timestamp, string )' ;
create or replace procedure t_string( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param string) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to string' ); 
        dbms_output.put_line('timestamp => ' ||  param ) ; 
    END;
begin
    t_local('timestamp', a_param );
end;

call t_string('timestamp' ) ;
drop procedure t_string;



--+ server-message off
