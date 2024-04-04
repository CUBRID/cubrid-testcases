--+ server-message on

select 'An error occurs. ( t_boolean, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('boolean', False ) ; 
drop procedure t_timestamp ; 



select 'It is called normally. ( t_string, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('string', cast('2024-03-01 22:15:25' as string) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'It is called normally. ( t_short, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('short', cast(8934 as short) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'It is called normally. ( t_int, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('int', cast(78234 as int) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'It is called normally. ( t_bigint, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('bigint', cast(278234 as bigint) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'It is called normally. ( t_numeric(8,3), timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'It is called normally. ( t_float, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('float', cast(3677.345 as float) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'It is called normally. ( t_double, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('double', cast(56789.1234 as double) ) ; 
drop procedure t_timestamp ; 



select 'It is called normally. ( t_date, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('date', cast('2024-03-05' as date) ) ; 
drop procedure t_timestamp ; 


--BUG
select 'An error occurs. ( t_time, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('time', cast('23:59:59' as time) ) ; 
drop procedure t_timestamp ; 



select 'It is called normally. ( t_datetime, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_timestamp ; 



select 'It is called normally. ( t_timestamp, timestamp )' ;
create or replace procedure t_timestamp( from_type string, param timestamp ) as 
begin 
    dbms_output.put_line(from_type||' to timestamp ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_timestamp('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_timestamp ; 



--+ server-message off
