--+ server-message on
--BUG
select 'An error occurs. ( t_boolean, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('boolean', False ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_string, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('string', cast('123' as string) ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_short, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('short', cast(8934 as short) ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_int, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('int', cast(78234 as int) ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_bigint, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('bigint', cast(278234 as bigint) ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_numeric(8,3), bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('numeric(8,3)', cast(5678.123 as numeric(8,3)) ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_float, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('float', cast(3677.345 as float) ) ; 
drop procedure t_bigint ; 



select 'It is called normally. ( t_double, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('double', cast(56789.1234 as double) ) ; 
drop procedure t_bigint ; 



select 'An error occurs. ( t_date, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('date', cast('2024-03-05' as date) ) ; 
drop procedure t_bigint ; 



select 'An error occurs. ( t_time, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('time', cast('23:59:59' as time) ) ; 
drop procedure t_bigint ; 



select 'An error occurs. ( t_datetime, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('datetime', cast('2024-03-01 22:15:25' as datetime) ) ; 
drop procedure t_bigint ; 



select 'An error occurs. ( t_timestamp, bigint )' ;
create or replace procedure t_bigint( from_type string, param bigint ) as 
begin 
    dbms_output.put_line(from_type||' to bigint ' ) ;
    dbms_output.put_line('param value = '|| param );
end;

call t_bigint('timestamp', cast('2024-05-05 23:30:45' as timestamp) ) ; 
drop procedure t_bigint ; 



--+ server-message off
