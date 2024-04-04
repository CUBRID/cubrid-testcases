--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('boolean', False ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_string, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('string', cast('123' as string) ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_short, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('short', cast(8934 as short) ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_int, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('int', cast(78234 as int) ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_bigint, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('bigint', cast(278234 as bigint) ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_numeric(8,3), int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_float, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('float', cast(3677.345 as float) ) ; 
drop procedure t_int ; 



select 'It is called normally. ( t_double, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('double', cast(56789.1234 as double) ) ; 
drop procedure t_int ; 



select 'An error occurs. ( t_date, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('date', cast('2024-03-05' as date) ) ; 
drop procedure t_int ; 



select 'An error occurs. ( t_time, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('time', cast('23:59:59' as time) ) ; 
drop procedure t_int ; 



select 'An error occurs. ( t_datetime, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_int ; 



select 'An error occurs. ( t_timestamp, int )' ;
create or replace procedure t_int( from_type string, param int ) as 
begin 
    dbms_output.put_line(from_type||' to int ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_int('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_int ; 



--+ server-message off
