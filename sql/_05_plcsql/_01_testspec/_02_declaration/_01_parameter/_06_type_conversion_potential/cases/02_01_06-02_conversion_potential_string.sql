--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('boolean', False ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_string, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('string', cast('123' as string) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_short, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('short', cast(8934 as short) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_int, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('int', cast(78234 as int) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_bigint, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('bigint', cast(278234 as bigint) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_numeric(8,3), string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_float, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('float', cast(3677.345 as float) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_double, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('double', cast(56789.1234 as double) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_date, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('date', cast('2024-03-05' as date) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_time, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('time', cast('23:59:59' as time) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_datetime, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_string ; 



select 'It is called normally. ( t_timestamp, string )' ;
create or replace procedure t_string( from_type string, param string ) as 
begin 
    dbms_output.put_line(from_type||' to string ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_string('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_string ; 



--+ server-message off
