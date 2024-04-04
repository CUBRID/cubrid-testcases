--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('boolean', False ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_string, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('string', cast('123' as string) ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_short, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('short', cast(8934 as short) ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_int, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('int', cast(78234 as int) ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_bigint, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('bigint', cast(278234 as bigint) ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_numeric(8,3), double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_float, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('float', cast(3677.345 as float) ) ; 
drop procedure t_double ; 



select 'It is called normally. ( t_double, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('double', cast(56789.1234 as double) ) ; 
drop procedure t_double ; 



select 'An error occurs. ( t_date, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('date', cast('2024-03-05' as date) ) ; 
drop procedure t_double ; 



select 'An error occurs. ( t_time, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('time', cast('23:59:59' as time) ) ; 
drop procedure t_double ; 



select 'An error occurs. ( t_datetime, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_double ; 



select 'An error occurs. ( t_timestamp, double )' ;
create or replace procedure t_double( from_type string, param double ) as 
begin 
    dbms_output.put_line(from_type||' to double ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_double('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_double ; 



--+ server-message off
