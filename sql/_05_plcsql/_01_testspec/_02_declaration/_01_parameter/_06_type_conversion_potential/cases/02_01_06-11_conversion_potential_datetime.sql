--+ server-message on

select 'An error occurs. ( t_boolean, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('boolean', False ) ; 
drop procedure t_datetime ; 



select 'It is called normally. ( t_string, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('string', cast('2024-03-01 22:15:25' as string) ) ; 
drop procedure t_datetime ; 



select 'An error occurs. ( t_short, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('short', cast(8934 as short) ) ; 
drop procedure t_datetime ; 



select 'An error occurs. ( t_int, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('int', cast(78234 as int) ) ; 
drop procedure t_datetime ; 



select 'An error occurs. ( t_bigint, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('bigint', cast(278234 as bigint) ) ; 
drop procedure t_datetime ; 



select 'An error occurs. ( t_numeric(8,3), datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_datetime ; 



select 'An error occurs. ( t_float, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('float', cast(3677.345 as float) ) ; 
drop procedure t_datetime ; 



select 'An error occurs. ( t_double, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('double', cast(56789.1234 as double) ) ; 
drop procedure t_datetime ; 



select 'It is called normally. ( t_date, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('date', cast('2024-03-05' as date) ) ; 
drop procedure t_datetime ; 


--BUG
select 'An error occurs. ( t_time, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('time', cast('23:59:59' as time) ) ; 
drop procedure t_datetime ; 



select 'It is called normally. ( t_datetime, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_datetime ; 



select 'It is called normally. ( t_timestamp, datetime )' ;
create or replace procedure t_datetime( from_type string, param datetime ) as 
begin 
    dbms_output.put_line(from_type||' to datetime ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_datetime('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_datetime ; 



--+ server-message off
