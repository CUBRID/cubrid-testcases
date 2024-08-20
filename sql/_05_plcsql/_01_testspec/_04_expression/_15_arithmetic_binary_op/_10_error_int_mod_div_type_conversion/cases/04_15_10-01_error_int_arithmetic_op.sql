--+ server-message on

select 'This test throws an execution error. ( null mod 0 )' ;
create or replace procedure t_exe_error_null( tc_comment string ) as
begin
    dbms_output.put_line('null mod 0 = '||null mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_null(' Integer Arithmetic operations : null mod 0 ' ) ;
drop procedure t_exe_error_null;


select 'This test throws an execution error. ( variable(null) mod 0 )' ;
create or replace procedure t_exe_error_null( tc_comment string ) as
    left_string                    string        := null;
    left_short                     short         := null;
    left_int                       int           := null;
    left_bigint                    bigint        := null;
    left_numeric                   numeric(8,4)  := null;
    left_float                     float         := null;
    left_double                    double        := null;
begin
    dbms_output.put_line('string(null) mod 0 = '||nvl( left_string mod 0, 'null') ) ;
    
    dbms_output.put_line('short(null) mod 0 = '||nvl( left_short mod 0, 'null') ) ;
    
    dbms_output.put_line('int(null) mod 0 = '||nvl( left_int mod 0, 'null') ) ;
    
    dbms_output.put_line('bigint(null) mod 0 = '||nvl( left_bigint mod 0, 'null') ) ;
    
    dbms_output.put_line('numeric(null) mod 0 = '||nvl( left_numeric mod 0, 'null') ) ;
    
    dbms_output.put_line('float(null) mod 0 = '||nvl( left_float mod 0, 'null') ) ;
    
    dbms_output.put_line('double(null) mod 0 = '||nvl( left_double mod 0, 'null') ) ;
end;

call t_exe_error_null(' Integer Arithmetic operations : variable(null) mod 0 ' ) ;
drop procedure t_exe_error_null;



select 'This test throws an execution error. ( null div 0 )' ;
create or replace procedure t_exe_error_null( tc_comment string ) as
begin
    dbms_output.put_line('***************************************');
    dbms_output.put_line('null = ' ||  NVL(null,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('null div 0 = '||null div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_null(' Integer Arithmetic operations : null div 0 ' ) ;
drop procedure t_exe_error_null;


select 'This test throws an execution error. ( variable(null) div 0 )' ;
create or replace procedure t_exe_error_null( tc_comment string ) as
    left_string                    string        := null;
    left_short                     short         := null;
    left_int                       int           := null;
    left_bigint                    bigint        := null;
    left_numeric                   numeric(8,4)  := null;
    left_float                     float         := null;
    left_double                    double        := null;
begin
    dbms_output.put_line('string(null) div 0 = '||nvl( left_string div 0, 'null') ) ;
    
    dbms_output.put_line('short(null) div 0 = '||nvl( left_short div 0, 'null') ) ;
    
    dbms_output.put_line('int(null) div 0 = '||nvl( left_int div 0, 'null') ) ;
    
    dbms_output.put_line('bigint(null) div 0 = '||nvl( left_bigint div 0, 'null') ) ;
    
    dbms_output.put_line('numeric(null) div 0 = '||nvl( left_numeric div 0, 'null') ) ;
    
    dbms_output.put_line('float(null) div 0 = '||nvl( left_float div 0, 'null') ) ;
    
    dbms_output.put_line('double(null) div 0 = '||nvl( left_double div 0, 'null') ) ;
end;

call t_exe_error_null(' Integer Arithmetic operations : variable(null) div 0 ' ) ;
drop procedure t_exe_error_null;

--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_string mod 0 )' ;
create or replace procedure t_exe_error_string( tc_comment string ) as
begin
    dbms_output.put_line('''123'' mod 0 = '||'123' mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error(' Integer Arithmetic operations : string mod 0 ' ) ;
drop procedure t_exe_error_string;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_string div 0 )' ;
create or replace procedure t_exe_error_string( tc_comment string ) as
    left_string                    string        := '123';
begin

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string = ' ||  NVL(left_string,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string div 0 = '||left_string div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error(' Integer Arithmetic operations : string div 0 ' ) ;
drop procedure t_exe_error_string ;



select 'This test throws an execution error. ( t_short mod 0 )' ;
create or replace procedure t_exe_error_short( tc_comment string ) as
    left_short                     short         := 8934;
begin

    dbms_output.put_line('8934 mod 0 = '||left_short mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_short(' Integer Arithmetic operations : short mod 0 ' ) ;
drop procedure t_exe_error_short;




select 'This test throws an execution error. ( t_short div 0 )' ;
create or replace procedure t_exe_error_short( tc_comment string ) as
    left_short                     short         := 8934;
begin

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_short = ' ||  NVL(left_short,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_short div 0 = '||left_short div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_short(' Integer Arithmetic operations : short, string ' ) ;
drop procedure t_exe_error_short;



select 'This test throws an execution error. ( t_int mod 0 )' ;
create or replace procedure t_exe_error_int( tc_comment string ) as
    left_int                       int           := 78234;
begin

    dbms_output.put_line('78234 mod 0 = '||left_int mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_int(' Integer Arithmetic operations : int mod 0 ' ) ;
drop procedure t_exe_error_int;



select 'This test throws an execution error. ( t_int div 0 )' ;
create or replace procedure t_exe_error_int( tc_comment string ) as
    left_int                       int           := 78234;
begin

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_int = ' ||  NVL(left_int,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_int div 0 = '||left_int div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_int(' Integer Arithmetic operations : int div 0 ' ) ;
drop procedure t_exe_error_int;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_bigint mod 0 )' ;
create or replace procedure t_exe_error_bigint( tc_comment string ) as
    left_bigint                    bigint        := 278234;
begin

    dbms_output.put_line('278234 mod 0 = '||left_bigint mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_bigint(' Integer Arithmetic operations : bigint mod 0 ' ) ;
drop procedure t_exe_error_bigint;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_bigint div 0 )' ;
create or replace procedure t_exe_error_bigint( tc_comment string ) as
    left_bigint                    bigint        := 278234;
begin

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_bigint = ' ||  NVL(left_bigint,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_bigint div 0 = '||left_bigint div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_bigint(' Integer Arithmetic operations : bigint, string ' ) ;
drop procedure t_exe_error_bigint;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_numeric mod 0)' ;
create or replace procedure t_exe_error_numeric( tc_comment string ) as
    left_numeric                   numeric(8,4)  := 5678.123;
begin
    dbms_output.put_line('5678.123 mod 0 = '||left_numeric mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_numeric(' Integer Arithmetic operations : numeric mod 0 ' ) ;
drop procedure t_exe_error_numeric;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_numeric div 0 )' ;
create or replace procedure t_exe_error_numeric( tc_comment string ) as
    left_numeric                   numeric(8,4)  := 5678.123;
begin
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_numeric = ' ||  NVL(left_numeric,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_numeric div 0 = '||left_numeric div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_numeric(' Integer Arithmetic operations : numeric, string ' ) ;
drop procedure t_exe_error_numeric;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_float mod 0 )' ;
create or replace procedure t_exe_error_float( tc_comment string ) as
    left_float                     float         := 3677.345;
begin
    dbms_output.put_line('3677.345 mod 0 = '||left_float mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_float(' Integer Arithmetic operations : float mod 0 ' ) ;
drop procedure t_exe_error_float ;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_float div 0 )' ;
create or replace procedure t_exe_error_float( tc_comment string ) as
    left_float                     float         := 3677.345;
begin

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_float = ' ||  NVL(left_float,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_float div 0 = '||left_float div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_float(' Integer Arithmetic operations : float div 0 ' ) ;
drop procedure t_exe_error_float ;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_double mod 0 )' ;
create or replace procedure t_exe_error_double( tc_comment string ) as
    left_double                    double        := 56789.1234;
begin

    dbms_output.put_line('56789.1234 mod 0 = '||left_double mod 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_double(' Integer Arithmetic operations : double mod 0 ' ) ;
drop procedure t_exe_error_double ;


--BUG ( normal : division by zero, BUG : internal server error )
select 'This test throws an execution error. ( t_double div 0 )' ;
create or replace procedure t_exe_error_double( tc_comment string ) as
    left_double                    double        := 56789.1234;
begin

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_double = ' ||  NVL(left_double,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_double div 0 = '||left_double div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_double(' Integer Arithmetic operations : double div 0 ' ) ;
drop procedure t_exe_error_double ;


--+ server-message off
