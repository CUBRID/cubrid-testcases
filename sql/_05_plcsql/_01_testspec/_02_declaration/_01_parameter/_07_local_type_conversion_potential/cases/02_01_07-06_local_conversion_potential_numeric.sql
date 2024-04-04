--+ server-message on

select 'An error occurs. ( t_boolean, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param boolean := False ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('boolean => ' ||  param ) ; 
    END;
begin
    t_local('boolean', a_param );
end;

call t_numeric('boolean' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_string, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param string := '123' ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('string => ' ||  param ) ; 
    END;
begin
    t_local('string', a_param );
end;

call t_numeric('string' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_short, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param short := 8934 ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('short => ' ||  param ) ; 
    END;
begin
    t_local('short', a_param );
end;

call t_numeric('short' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_int, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param int := 8234 ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('int => ' ||  param ) ; 
    END;
begin
    t_local('int', a_param );
end;

call t_numeric('int' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_bigint, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param bigint := 278 ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('bigint => ' ||  param ) ; 
    END;
begin
    t_local('bigint', a_param );
end;

call t_numeric('bigint' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_numeric(8,3), numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param numeric(8,3) := 5678.123 ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('numeric(8,3) => ' ||  param ) ; 
    END;
begin
    t_local('numeric(8,3)', a_param );
end;

call t_numeric('numeric(8,3)' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_float, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param float := 3677.345 ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('float => ' ||  param ) ; 
    END;
begin
    t_local('float', a_param );
end;

call t_numeric('float' ) ;
drop procedure t_numeric ;



select 'It is called normally. ( t_double, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param double := 789.1234 ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('double => ' ||  param ) ; 
    END;
begin
    t_local('double', a_param );
end;

call t_numeric('double' ) ;
drop procedure t_numeric ;



select 'An error occurs. ( t_date, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param date := '2024-03-05' ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('date => ' ||  param ) ; 
    END;
begin
    t_local('date', a_param );
end;

call t_numeric('date' ) ;
drop procedure t_numeric ;



select 'An error occurs. ( t_time, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param time := '23:59:59' ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('time => ' ||  param ) ; 
    END;
begin
    t_local('time', a_param );
end;

call t_numeric('time' ) ;
drop procedure t_numeric ;



select 'An error occurs. ( t_datetime, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param datetime := '2024-03-01 22:15:25' ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('datetime => ' ||  param ) ; 
    END;
begin
    t_local('datetime', a_param );
end;

call t_numeric('datetime' ) ;
drop procedure t_numeric ;



select 'An error occurs. ( t_timestamp, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string ) as 
    a_param timestamp := '2024-05-05 23:30:45' ;
    procedure t_local(from_type string, param numeric(8,3)) 
    AS 
    begin 
        dbms_output.put_line(from_type||' to numeric(8,3)' ); 
        dbms_output.put_line('timestamp => ' ||  param ) ; 
    END;
begin
    t_local('timestamp', a_param );
end;

call t_numeric('timestamp' ) ;
drop procedure t_numeric ;



--+ server-message off
