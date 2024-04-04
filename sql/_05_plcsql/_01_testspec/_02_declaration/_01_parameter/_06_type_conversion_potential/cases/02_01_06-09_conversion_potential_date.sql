--+ server-message on

select 'An error occurs. ( t_boolean, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('boolean', False ) ; 
drop procedure t_date ; 



select 'It is called normally. ( t_string, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('string', cast('2024-03-05' as string) ) ; 
drop procedure t_date ; 



select 'An error occurs. ( t_short, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('short', cast(8934 as short) ) ; 
drop procedure t_date ; 



select 'An error occurs. ( t_int, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('int', cast(78234 as int) ) ; 
drop procedure t_date ; 



select 'An error occurs. ( t_bigint, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('bigint', cast(278234 as bigint) ) ; 
drop procedure t_date ; 



select 'An error occurs. ( t_numeric(8,3), date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_date ; 



select 'An error occurs. ( t_float, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('float', cast(3677.345 as float) ) ; 
drop procedure t_date ; 



select 'An error occurs. ( t_double, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('double', cast(56789.1234 as double) ) ; 
drop procedure t_date ; 



select 'It is called normally. ( t_date, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('date', cast('2024-03-05' as date) ) ; 
drop procedure t_date ; 


--BUG
select 'An error occurs. ( t_time, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('time', cast('23:59:59' as time) ) ; 
drop procedure t_date ; 



select 'It is called normally. ( t_datetime, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_date ; 



select 'It is called normally. ( t_timestamp, date )' ;
create or replace procedure t_date( from_type string, param date ) as 
begin 
    dbms_output.put_line(from_type||' to date ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_date('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_date ; 



--+ server-message off
