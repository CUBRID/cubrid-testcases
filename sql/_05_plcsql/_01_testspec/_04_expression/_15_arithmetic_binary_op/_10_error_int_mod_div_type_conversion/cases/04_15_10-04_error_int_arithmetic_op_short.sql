--+ server-message on

select 'This test throws an execution error. ( t_null, short )' ;
create or replace procedure t_exe_error_null_short( tc_comment string ) as 
begin 

    dbms_output.put_line('null mod 0 = '||null mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_null_short(' Integer Arithmetic operations : null, short ' ) ; 
drop procedure t_exe_error_null_short ; 



select 'This test throws an execution error. ( t_null, short )' ;
create or replace procedure t_exe_error_null_short( tc_comment string ) as 
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
    dbms_output.put_line('null = ' ||  NVL(null,'NULL') ); 
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('null div 0 = '||null div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_null_short(' Integer Arithmetic operations : null, short ' ) ; 
drop procedure t_exe_error_null_short ; 



select 'This test throws an execution error. ( t_string, short )' ;
create or replace procedure t_exe_error_string_short( tc_comment string ) as 
begin 

    dbms_output.put_line('''123'' mod 0 = '||'123' mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_string_short(' Integer Arithmetic operations : string, short ' ) ; 
drop procedure t_exe_error_string_short ; 



select 'This test throws an execution error. ( t_string, short )' ;
create or replace procedure t_exe_error_string_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string div 0 = '||left_string div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_string_short(' Integer Arithmetic operations : string, short ' ) ; 
drop procedure t_exe_error_string_short ; 



select 'This test throws an execution error. ( t_short, short )' ;
create or replace procedure t_exe_error_short_short( tc_comment string ) as 
begin 

    dbms_output.put_line('8934 mod 0 = '||8934 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_short_short(' Integer Arithmetic operations : short, short ' ) ; 
drop procedure t_exe_error_short_short ; 



select 'This test throws an execution error. ( t_short, short )' ;
create or replace procedure t_exe_error_short_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_short div 0 = '||left_short div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_short_short(' Integer Arithmetic operations : short, short ' ) ; 
drop procedure t_exe_error_short_short ; 



select 'This test throws an execution error. ( t_int, short )' ;
create or replace procedure t_exe_error_int_short( tc_comment string ) as 
begin 

    dbms_output.put_line('78234 mod 0 = '||78234 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_int_short(' Integer Arithmetic operations : int, short ' ) ; 
drop procedure t_exe_error_int_short ; 



select 'This test throws an execution error. ( t_int, short )' ;
create or replace procedure t_exe_error_int_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_int div 0 = '||left_int div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_int_short(' Integer Arithmetic operations : int, short ' ) ; 
drop procedure t_exe_error_int_short ; 



select 'This test throws an execution error. ( t_bigint, short )' ;
create or replace procedure t_exe_error_bigint_short( tc_comment string ) as 
begin 

    dbms_output.put_line('278234 mod 0 = '||278234 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_bigint_short(' Integer Arithmetic operations : bigint, short ' ) ; 
drop procedure t_exe_error_bigint_short ; 



select 'This test throws an execution error. ( t_bigint, short )' ;
create or replace procedure t_exe_error_bigint_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_bigint div 0 = '||left_bigint div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_bigint_short(' Integer Arithmetic operations : bigint, short ' ) ; 
drop procedure t_exe_error_bigint_short ; 



select 'This test throws an execution error. ( t_numeric, short )' ;
create or replace procedure t_exe_error_numeric_short( tc_comment string ) as 
begin 

    dbms_output.put_line('5678.123 mod 0 = '||5678.123 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_numeric_short(' Integer Arithmetic operations : numeric, short ' ) ; 
drop procedure t_exe_error_numeric_short ; 



select 'This test throws an execution error. ( t_numeric, short )' ;
create or replace procedure t_exe_error_numeric_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_numeric div 0 = '||left_numeric div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_numeric_short(' Integer Arithmetic operations : numeric, short ' ) ; 
drop procedure t_exe_error_numeric_short ; 



select 'This test throws an execution error. ( t_float, short )' ;
create or replace procedure t_exe_error_float_short( tc_comment string ) as 
begin 

    dbms_output.put_line('3677.345 mod 0 = '||3677.345 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_float_short(' Integer Arithmetic operations : float, short ' ) ; 
drop procedure t_exe_error_float_short ; 



select 'This test throws an execution error. ( t_float, short )' ;
create or replace procedure t_exe_error_float_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_float div 0 = '||left_float div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_float_short(' Integer Arithmetic operations : float, short ' ) ; 
drop procedure t_exe_error_float_short ; 



select 'This test throws an execution error. ( t_double, short )' ;
create or replace procedure t_exe_error_double_short( tc_comment string ) as 
begin 

    dbms_output.put_line('56789.1234 mod 0 = '||56789.1234 mod 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_double_short(' Integer Arithmetic operations : double, short ' ) ; 
drop procedure t_exe_error_double_short ; 



select 'This test throws an execution error. ( t_double, short )' ;
create or replace procedure t_exe_error_double_short( tc_comment string ) as 
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
    dbms_output.put_line('right_short = ' ||NVL(right_short,'NULL') ); 
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_double div 0 = '||left_double div 0 ) ; 
    dbms_output.put_line('');
end;

call t_exe_error_double_short(' Integer Arithmetic operations : double, short ' ) ; 
drop procedure t_exe_error_double_short ; 



--+ server-message off
