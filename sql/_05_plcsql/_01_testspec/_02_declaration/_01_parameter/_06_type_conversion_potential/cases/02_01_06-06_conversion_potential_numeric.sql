--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('boolean', False ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_string, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('string', cast('123' as string) ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_short, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('short', cast(8934 as short) ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_int, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('int', cast(78234 as int) ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_bigint, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('bigint', cast(278234 as bigint) ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_numeric(8,3), numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_float, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('float', cast(3677.345 as float) ) ; 
drop procedure t_numeric ; 



select 'It is called normally. ( t_double, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('double', cast(56789.1234 as double) ) ; 
drop procedure t_numeric ; 



select 'An error occurs. ( t_date, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('date', cast('2024-03-05' as date) ) ; 
drop procedure t_numeric ; 



select 'An error occurs. ( t_time, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('time', cast('23:59:59' as time) ) ; 
drop procedure t_numeric ; 



select 'An error occurs. ( t_datetime, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_numeric ; 



select 'An error occurs. ( t_timestamp, numeric(8,3) )' ;
create or replace procedure t_numeric( from_type string, param numeric(8,3) ) as 
begin 
    dbms_output.put_line(from_type||' to numeric(8,3) ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_numeric('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_numeric ; 



--+ server-message off
