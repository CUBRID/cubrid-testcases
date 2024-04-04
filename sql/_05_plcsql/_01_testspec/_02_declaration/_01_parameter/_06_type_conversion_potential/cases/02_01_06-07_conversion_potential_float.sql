--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('boolean', False ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_string, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('string', cast('123' as string) ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_short, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('short', cast(8934 as short) ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_int, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('int', cast(78234 as int) ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_bigint, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('bigint', cast(278234 as bigint) ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_numeric(8,3), float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_float, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('float', cast(3677.345 as float) ) ; 
drop procedure t_float ; 



select 'It is called normally. ( t_double, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('double', cast(56789.1234 as double) ) ; 
drop procedure t_float ; 



select 'An error occurs. ( t_date, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('date', cast('2024-03-05' as date) ) ; 
drop procedure t_float ; 



select 'An error occurs. ( t_time, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('time', cast('23:59:59' as time) ) ; 
drop procedure t_float ; 



select 'An error occurs. ( t_datetime, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_float ; 



select 'An error occurs. ( t_timestamp, float )' ;
create or replace procedure t_float( from_type string, param float ) as 
begin 
    dbms_output.put_line(from_type||' to float ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_float('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_float ; 



--+ server-message off
