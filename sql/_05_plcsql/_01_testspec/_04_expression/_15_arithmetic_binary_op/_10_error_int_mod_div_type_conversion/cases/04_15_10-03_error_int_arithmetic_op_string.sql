--+ server-message on

select 'This test throws an execution error. ( t_string, string )' ;
create or replace procedure t_exe_error_string_string( tc_comment string ) as 
begin 

    dbms_output.put_line('''123'' mod 0 = '||'123' mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_string_string(' Integer Arithmetic operations : string, string ' ) ; 
drop procedure t_exe_error_string_string ; 



select 'This test throws an execution error. ( t_string, string )' ;
create or replace procedure t_exe_error_string_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string = ' ||  NVL(left_string,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string div 0 = '||left_string div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_string_string(' Integer Arithmetic operations : string, string ' ) ; 
drop procedure t_exe_error_string_string ; 



select 'This test throws an execution error. ( t_short, string )' ;
create or replace procedure t_exe_error_short_string( tc_comment string ) as 
begin 

    dbms_output.put_line('8934 mod 0 = '||8934 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_short_string(' Integer Arithmetic operations : short, string ' ) ; 
drop procedure t_exe_error_short_string ; 



select 'This test throws an execution error. ( t_short, string )' ;
create or replace procedure t_exe_error_short_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_short = ' ||  NVL(left_short,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_short div 0 = '||left_short div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_short_string(' Integer Arithmetic operations : short, string ' ) ; 
drop procedure t_exe_error_short_string ; 



select 'This test throws an execution error. ( t_int, string )' ;
create or replace procedure t_exe_error_int_string( tc_comment string ) as 
begin 

    dbms_output.put_line('78234 mod 0 = '||78234 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_int_string(' Integer Arithmetic operations : int, string ' ) ; 
drop procedure t_exe_error_int_string ; 



select 'This test throws an execution error. ( t_int, string )' ;
create or replace procedure t_exe_error_int_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_int = ' ||  NVL(left_int,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_int div 0 = '||left_int div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_int_string(' Integer Arithmetic operations : int, string ' ) ; 
drop procedure t_exe_error_int_string ; 



select 'This test throws an execution error. ( t_bigint, string )' ;
create or replace procedure t_exe_error_bigint_string( tc_comment string ) as 
begin 

    dbms_output.put_line('278234 mod 0 = '||278234 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_bigint_string(' Integer Arithmetic operations : bigint, string ' ) ; 
drop procedure t_exe_error_bigint_string ; 



select 'This test throws an execution error. ( t_bigint, string )' ;
create or replace procedure t_exe_error_bigint_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_bigint = ' ||  NVL(left_bigint,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_bigint div 0 = '||left_bigint div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_bigint_string(' Integer Arithmetic operations : bigint, string ' ) ; 
drop procedure t_exe_error_bigint_string ; 



select 'This test throws an execution error. ( t_numeric, string )' ;
create or replace procedure t_exe_error_numeric_string( tc_comment string ) as 
begin 

    dbms_output.put_line('5678.123 mod 0 = '||5678.123 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_numeric_string(' Integer Arithmetic operations : numeric, string ' ) ; 
drop procedure t_exe_error_numeric_string ; 



select 'This test throws an execution error. ( t_numeric, string )' ;
create or replace procedure t_exe_error_numeric_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_numeric = ' ||  NVL(left_numeric,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_numeric div 0 = '||left_numeric div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_numeric_string(' Integer Arithmetic operations : numeric, string ' ) ; 
drop procedure t_exe_error_numeric_string ; 



select 'This test throws an execution error. ( t_float, string )' ;
create or replace procedure t_exe_error_float_string( tc_comment string ) as 
begin 

    dbms_output.put_line('3677.345 mod 0 = '||3677.345 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_float_string(' Integer Arithmetic operations : float, string ' ) ; 
drop procedure t_exe_error_float_string ; 



select 'This test throws an execution error. ( t_float, string )' ;
create or replace procedure t_exe_error_float_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_float = ' ||  NVL(left_float,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_float div 0 = '||left_float div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_float_string(' Integer Arithmetic operations : float, string ' ) ; 
drop procedure t_exe_error_float_string ; 



select 'This test throws an execution error. ( t_double, string )' ;
create or replace procedure t_exe_error_double_string( tc_comment string ) as 
begin 

    dbms_output.put_line('56789.1234 mod 0 = '||56789.1234 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_double_string(' Integer Arithmetic operations : double, string ' ) ; 
drop procedure t_exe_error_double_string ; 



select 'This test throws an execution error. ( t_double, string )' ;
create or replace procedure t_exe_error_double_string( tc_comment string ) as 
    left_boolean                   boolean       := TRUE;
    left_string                    string        := '123';
    left_string_null               string        := NULL;
    left_string_boolean         string        := 'TRUE';
    left_string_short              string        := '8934';                             
    left_string_int                string        := '78234';                            
    left_string_bigint             string        := '278234';                           
    left_string_numeric            string        := '5678.123';                         
    left_string_float              string        := '3677.345';                        
    left_string_double             string        := '56789.1234';                       
    left_string_date               string        := '2024-03-05';                 
    left_string_time               string        := '23:59:59';                   
    left_string_datetime           string        := '2024-03-01 22:15:25'; 
    left_string_timestamp          string        := '2024-05-05 23:30:45';
    left_short                     short         := 8934;
    left_int                       int           := 78234;
    left_bigint                    bigint        := 278234;
    left_numeric                   numeric(8,4)  := 5678.123;
    left_float                     float         := 3677.345;
    left_double                    double        := 56789.1234;
    left_date                      date          := DATE'2024-03-05';
    left_time                      time          := TIME'23:59:59';
    left_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    left_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    left_sys_refcursor             sys_refcursor ;
    cursor  left_cursor is select * from dual ;
    
    right_boolean                 boolean       := FALSE;
    right_string                  string        := '999';
    right_string_null             string        := NULL; 
    right_string_boolean        string        := 'FALSE'; 
    right_string_short            string        := '34';                               
    right_string_int              string        := '234';                              
    right_string_bigint           string        := '1234';                             
    right_string_numeric          string        := '1234.567';                         
    right_string_float            string        := '432.321';                        
    right_string_double           string        := '1234.56789';                 
    right_string_date             string        := '2002-03-05';                 
    right_string_time             string        := '03:59:59';               
    right_string_datetime         string        := '2002-02-02 02:22:22';
    right_string_timestamp        string        := '2002-01-01 01:01:01';
    right_short                   short         := 34;
    right_int                     int           := 234;
    right_bigint                  bigint        := 1234;
    right_numeric                 numeric(8,4)  := 1234.567;
    right_float                   float         := 432.321;
    right_double                  double        := 1234.56789;
    right_date                    date          := DATE'2002-03-05';
    right_time                    time          := TIME'03:59:59';
    right_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    right_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    right_sys_refcursor           sys_refcursor ;
    cursor  right_cursor is select * from dual ;
begin 

    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_double = ' ||  NVL(left_double,'NULL') ); 
    dbms_output.put_line('right_string = ' ||NVL(right_string,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_double div 0 = '||left_double div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_double_string(' Integer Arithmetic operations : double, string ' ) ; 
drop procedure t_exe_error_double_string ; 



--+ server-message off
