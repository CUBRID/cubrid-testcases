--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('boolean', False ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_string, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('string', cast('123' as string) ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_short, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('short', cast(8934 as short) ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_int, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('int', cast(78234 as int) ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_bigint, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('bigint', cast(278234 as bigint) ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_numeric(8,3), short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_float, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('float', cast(3677.345 as float) ) ; 
drop procedure t_short ; 



select 'It is called normally. ( t_double, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('double', cast(56789.1234 as double) ) ; 
drop procedure t_short ; 



select 'An error occurs. ( t_date, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('date', cast('2024-03-05' as date) ) ; 
drop procedure t_short ; 



select 'An error occurs. ( t_time, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('time', cast('23:59:59' as time) ) ; 
drop procedure t_short ; 



select 'An error occurs. ( t_datetime, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_short ; 



select 'An error occurs. ( t_timestamp, short )' ;
create or replace procedure t_short( from_type string, param short ) as 
begin 
    dbms_output.put_line(from_type||' to short ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_short('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_short ; 



--+ server-message off
