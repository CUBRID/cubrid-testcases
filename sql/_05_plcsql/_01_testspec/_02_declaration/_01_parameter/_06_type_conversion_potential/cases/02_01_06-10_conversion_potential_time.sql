--+ server-message on

select 'An error occurs. ( t_boolean, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('boolean', False ) ; 
drop procedure t_time ; 



select 'It is called normally. ( t_string, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('string', cast('23:59:59' as string) ) ; 
drop procedure t_time ; 


--BUG
select 'It is called normally. ( t_short, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('short', cast(8934 as short) ) ; 
drop procedure t_time ; 


--BUG
select 'It is called normally. ( t_int, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('int', cast(78234 as int) ) ; 
drop procedure t_time ; 


--BUG
select 'It is called normally. ( t_bigint, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('bigint', cast(278234 as bigint) ) ; 
drop procedure t_time ; 



select 'An error occurs. ( t_numeric(8,3), time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_time ; 


--BUG
select 'It is called normally. ( t_float, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('float', cast(3677.345 as float) ) ; 
drop procedure t_time ; 


--BUG
select 'It is called normally. ( t_double, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('double', cast(56789.1234 as double) ) ; 
drop procedure t_time ; 


--BUG
select 'An error occurs. ( t_date, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('date', cast('2024-03-05' as date) ) ; 
drop procedure t_time ; 



select 'It is called normally. ( t_time, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('time', cast('23:59:59' as time) ) ; 
drop procedure t_time ; 



select 'It is called normally. ( t_datetime, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_time ; 



select 'It is called normally. ( t_timestamp, time )' ;
create or replace procedure t_time( from_type string, param time ) as 
begin 
    dbms_output.put_line(from_type||' to time ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_time('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_time ; 



--+ server-message off
