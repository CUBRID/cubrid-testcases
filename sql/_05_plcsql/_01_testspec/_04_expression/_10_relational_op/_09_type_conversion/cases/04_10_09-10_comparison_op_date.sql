--+ server-message on

select 'This test is a normal run case. ( t_null_date )' ;
create or replace procedure t_null_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    dbms_output.put_line('*****   '||tc_comment ||'   ***' );
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If null = small_date Then 
        dbms_output.put_line(' null =  small_date true' );
    Else 
        dbms_output.put_line(' null =  small_date false' );
    end if;

    If null <=> small_date Then 
        dbms_output.put_line(' null <=>  small_date true' );
    Else 
        dbms_output.put_line(' null <=>  small_date false' );
    end if;

    If null != small_date Then 
        dbms_output.put_line(' null !=  small_date true' );
    Else 
        dbms_output.put_line(' null !=  small_date false' );
    end if;

    If null <= small_date Then 
        dbms_output.put_line(' null <=  small_date true' );
    Else 
        dbms_output.put_line(' null <=  small_date false' );
    end if;

    If null >= small_date Then 
        dbms_output.put_line(' null >=  small_date true' );
    Else 
        dbms_output.put_line(' null >=  small_date false' );
    end if;

    If null < small_date Then 
        dbms_output.put_line(' null <  small_date true' );
    Else 
        dbms_output.put_line(' null <  small_date false' );
    end if;

    If null > small_date Then 
        dbms_output.put_line(' null >  small_date true' );
    Else 
        dbms_output.put_line(' null >  small_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_date = null Then 
        dbms_output.put_line(' small_date =  null true' );
    Else 
        dbms_output.put_line(' small_date =  null false' );
    end if;

    If small_date <=> null Then 
        dbms_output.put_line(' small_date <=>  null true' );
    Else 
        dbms_output.put_line(' small_date <=>  null false' );
    end if;

    If small_date != null Then 
        dbms_output.put_line(' small_date !=  null true' );
    Else 
        dbms_output.put_line(' small_date !=  null false' );
    end if;

    If small_date <= null Then 
        dbms_output.put_line(' small_date <=  null true' );
    Else 
        dbms_output.put_line(' small_date <=  null false' );
    end if;

    If small_date >= null Then 
        dbms_output.put_line(' small_date >=  null true' );
    Else 
        dbms_output.put_line(' small_date >=  null false' );
    end if;

    If small_date < null Then 
        dbms_output.put_line(' small_date <  null true' );
    Else 
        dbms_output.put_line(' small_date <  null false' );
    end if;

    If small_date > null Then 
        dbms_output.put_line(' small_date >  null true' );
    Else 
        dbms_output.put_line(' small_date >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_null_date('Comparison operation : null, date ' ) ; 

drop procedure t_null_date ; 



select 'This test is a case where an error is output.(not support, not created) ( t_boolean_date ) ' ; 
create or replace procedure t_boolean_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_boolean = small_date Then 
        dbms_output.put_line(' big_boolean =  small_date true' );
    Else 
        dbms_output.put_line(' big_boolean =  small_date false' );
    end if;

end; 

select 'This test is a normal run case. ( t_string_date )' ;
create or replace procedure t_string_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    dbms_output.put_line('*****   '||tc_comment ||'   ***' );
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_string_date = ' || NVL(big_string_date,'NULL') );
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_string_date = small_date Then 
        dbms_output.put_line(' big_string_date =  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date =  small_date false' );
    end if;

    If big_string_date <=> small_date Then 
        dbms_output.put_line(' big_string_date <=>  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date <=>  small_date false' );
    end if;

    If big_string_date != small_date Then 
        dbms_output.put_line(' big_string_date !=  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date !=  small_date false' );
    end if;

    If big_string_date <= small_date Then 
        dbms_output.put_line(' big_string_date <=  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date <=  small_date false' );
    end if;

    If big_string_date >= small_date Then 
        dbms_output.put_line(' big_string_date >=  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date >=  small_date false' );
    end if;

    If big_string_date < small_date Then 
        dbms_output.put_line(' big_string_date <  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date <  small_date false' );
    end if;

    If big_string_date > small_date Then 
        dbms_output.put_line(' big_string_date >  small_date true' );
    Else 
        dbms_output.put_line(' big_string_date >  small_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('big_string_date = ' || NVL(big_string_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_date = big_string_date Then 
        dbms_output.put_line(' small_date =  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date =  big_string_date false' );
    end if;

    If small_date <=> big_string_date Then 
        dbms_output.put_line(' small_date <=>  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date <=>  big_string_date false' );
    end if;

    If small_date != big_string_date Then 
        dbms_output.put_line(' small_date !=  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date !=  big_string_date false' );
    end if;

    If small_date <= big_string_date Then 
        dbms_output.put_line(' small_date <=  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date <=  big_string_date false' );
    end if;

    If small_date >= big_string_date Then 
        dbms_output.put_line(' small_date >=  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date >=  big_string_date false' );
    end if;

    If small_date < big_string_date Then 
        dbms_output.put_line(' small_date <  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date <  big_string_date false' );
    end if;

    If small_date > big_string_date Then 
        dbms_output.put_line(' small_date >  big_string_date true' );
    Else 
        dbms_output.put_line(' small_date >  big_string_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_string_date('Comparison operation : string, date ' ) ; 

drop procedure t_string_date ; 



select 'This test is a case where an error is output.(not support, not created) ( t_short_date ) ' ; 
create or replace procedure t_short_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_short = small_date Then 
        dbms_output.put_line(' big_short =  small_date true' );
    Else 
        dbms_output.put_line(' big_short =  small_date false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_int_date ) ' ; 
create or replace procedure t_int_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_int = small_date Then 
        dbms_output.put_line(' big_int =  small_date true' );
    Else 
        dbms_output.put_line(' big_int =  small_date false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_bigint_date ) ' ; 
create or replace procedure t_bigint_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_bigint = small_date Then 
        dbms_output.put_line(' big_bigint =  small_date true' );
    Else 
        dbms_output.put_line(' big_bigint =  small_date false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_numeric_date ) ' ; 
create or replace procedure t_numeric_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_numeric = small_date Then 
        dbms_output.put_line(' big_numeric =  small_date true' );
    Else 
        dbms_output.put_line(' big_numeric =  small_date false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_float_date ) ' ; 
create or replace procedure t_float_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_float = small_date Then 
        dbms_output.put_line(' big_float =  small_date true' );
    Else 
        dbms_output.put_line(' big_float =  small_date false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_double_date ) ' ; 
create or replace procedure t_double_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_double = small_date Then 
        dbms_output.put_line(' big_double =  small_date true' );
    Else 
        dbms_output.put_line(' big_double =  small_date false' );
    end if;

end; 

select 'This test is a normal run case. ( t_date_date )' ;
create or replace procedure t_date_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    dbms_output.put_line('*****   '||tc_comment ||'   ***' );
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_date = ' || NVL(big_date,'NULL') );
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_date = small_date Then 
        dbms_output.put_line(' big_date =  small_date true' );
    Else 
        dbms_output.put_line(' big_date =  small_date false' );
    end if;

    If big_date <=> small_date Then 
        dbms_output.put_line(' big_date <=>  small_date true' );
    Else 
        dbms_output.put_line(' big_date <=>  small_date false' );
    end if;

    If big_date != small_date Then 
        dbms_output.put_line(' big_date !=  small_date true' );
    Else 
        dbms_output.put_line(' big_date !=  small_date false' );
    end if;

    If big_date <= small_date Then 
        dbms_output.put_line(' big_date <=  small_date true' );
    Else 
        dbms_output.put_line(' big_date <=  small_date false' );
    end if;

    If big_date >= small_date Then 
        dbms_output.put_line(' big_date >=  small_date true' );
    Else 
        dbms_output.put_line(' big_date >=  small_date false' );
    end if;

    If big_date < small_date Then 
        dbms_output.put_line(' big_date <  small_date true' );
    Else 
        dbms_output.put_line(' big_date <  small_date false' );
    end if;

    If big_date > small_date Then 
        dbms_output.put_line(' big_date >  small_date true' );
    Else 
        dbms_output.put_line(' big_date >  small_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('big_date = ' || NVL(big_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_date = big_date Then 
        dbms_output.put_line(' small_date =  big_date true' );
    Else 
        dbms_output.put_line(' small_date =  big_date false' );
    end if;

    If small_date <=> big_date Then 
        dbms_output.put_line(' small_date <=>  big_date true' );
    Else 
        dbms_output.put_line(' small_date <=>  big_date false' );
    end if;

    If small_date != big_date Then 
        dbms_output.put_line(' small_date !=  big_date true' );
    Else 
        dbms_output.put_line(' small_date !=  big_date false' );
    end if;

    If small_date <= big_date Then 
        dbms_output.put_line(' small_date <=  big_date true' );
    Else 
        dbms_output.put_line(' small_date <=  big_date false' );
    end if;

    If small_date >= big_date Then 
        dbms_output.put_line(' small_date >=  big_date true' );
    Else 
        dbms_output.put_line(' small_date >=  big_date false' );
    end if;

    If small_date < big_date Then 
        dbms_output.put_line(' small_date <  big_date true' );
    Else 
        dbms_output.put_line(' small_date <  big_date false' );
    end if;

    If small_date > big_date Then 
        dbms_output.put_line(' small_date >  big_date true' );
    Else 
        dbms_output.put_line(' small_date >  big_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_date_date('Comparison operation : date, date ' ) ; 

drop procedure t_date_date ; 



select 'This test is a case where an error is output.(not support, not created) ( t_time_date ) ' ; 
create or replace procedure t_time_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_time = small_date Then 
        dbms_output.put_line(' big_time =  small_date true' );
    Else 
        dbms_output.put_line(' big_time =  small_date false' );
    end if;

end; 

select 'This test is a normal run case. ( t_datetime_date )' ;
create or replace procedure t_datetime_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    dbms_output.put_line('*****   '||tc_comment ||'   ***' );
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_datetime = ' || NVL(big_datetime,'NULL') );
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_datetime = small_date Then 
        dbms_output.put_line(' big_datetime =  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime =  small_date false' );
    end if;

    If big_datetime <=> small_date Then 
        dbms_output.put_line(' big_datetime <=>  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime <=>  small_date false' );
    end if;

    If big_datetime != small_date Then 
        dbms_output.put_line(' big_datetime !=  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime !=  small_date false' );
    end if;

    If big_datetime <= small_date Then 
        dbms_output.put_line(' big_datetime <=  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime <=  small_date false' );
    end if;

    If big_datetime >= small_date Then 
        dbms_output.put_line(' big_datetime >=  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime >=  small_date false' );
    end if;

    If big_datetime < small_date Then 
        dbms_output.put_line(' big_datetime <  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime <  small_date false' );
    end if;

    If big_datetime > small_date Then 
        dbms_output.put_line(' big_datetime >  small_date true' );
    Else 
        dbms_output.put_line(' big_datetime >  small_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('big_datetime = ' || NVL(big_datetime,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_date = big_datetime Then 
        dbms_output.put_line(' small_date =  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date =  big_datetime false' );
    end if;

    If small_date <=> big_datetime Then 
        dbms_output.put_line(' small_date <=>  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date <=>  big_datetime false' );
    end if;

    If small_date != big_datetime Then 
        dbms_output.put_line(' small_date !=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date !=  big_datetime false' );
    end if;

    If small_date <= big_datetime Then 
        dbms_output.put_line(' small_date <=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date <=  big_datetime false' );
    end if;

    If small_date >= big_datetime Then 
        dbms_output.put_line(' small_date >=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date >=  big_datetime false' );
    end if;

    If small_date < big_datetime Then 
        dbms_output.put_line(' small_date <  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date <  big_datetime false' );
    end if;

    If small_date > big_datetime Then 
        dbms_output.put_line(' small_date >  big_datetime true' );
    Else 
        dbms_output.put_line(' small_date >  big_datetime false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_datetime_date('Comparison operation : datetime, date ' ) ; 

drop procedure t_datetime_date ; 



select 'This test is a normal run case. ( t_timestamp_date )' ;
create or replace procedure t_timestamp_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    dbms_output.put_line('*****   '||tc_comment ||'   ***' );
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_timestamp = ' || NVL(big_timestamp,'NULL') );
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_timestamp = small_date Then 
        dbms_output.put_line(' big_timestamp =  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp =  small_date false' );
    end if;

    If big_timestamp <=> small_date Then 
        dbms_output.put_line(' big_timestamp <=>  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp <=>  small_date false' );
    end if;

    If big_timestamp != small_date Then 
        dbms_output.put_line(' big_timestamp !=  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp !=  small_date false' );
    end if;

    If big_timestamp <= small_date Then 
        dbms_output.put_line(' big_timestamp <=  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp <=  small_date false' );
    end if;

    If big_timestamp >= small_date Then 
        dbms_output.put_line(' big_timestamp >=  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp >=  small_date false' );
    end if;

    If big_timestamp < small_date Then 
        dbms_output.put_line(' big_timestamp <  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp <  small_date false' );
    end if;

    If big_timestamp > small_date Then 
        dbms_output.put_line(' big_timestamp >  small_date true' );
    Else 
        dbms_output.put_line(' big_timestamp >  small_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_date = ' || NVL(small_date,'NULL') );
    dbms_output.put_line('big_timestamp = ' || NVL(big_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_date = big_timestamp Then 
        dbms_output.put_line(' small_date =  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date =  big_timestamp false' );
    end if;

    If small_date <=> big_timestamp Then 
        dbms_output.put_line(' small_date <=>  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date <=>  big_timestamp false' );
    end if;

    If small_date != big_timestamp Then 
        dbms_output.put_line(' small_date !=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date !=  big_timestamp false' );
    end if;

    If small_date <= big_timestamp Then 
        dbms_output.put_line(' small_date <=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date <=  big_timestamp false' );
    end if;

    If small_date >= big_timestamp Then 
        dbms_output.put_line(' small_date >=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date >=  big_timestamp false' );
    end if;

    If small_date < big_timestamp Then 
        dbms_output.put_line(' small_date <  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date <  big_timestamp false' );
    end if;

    If small_date > big_timestamp Then 
        dbms_output.put_line(' small_date >  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_date >  big_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_timestamp_date('Comparison operation : timestamp, date ' ) ; 

drop procedure t_timestamp_date ; 



select 'This test is a case where an error is output.(not support, not created) ( t_sys_refcursor_date ) ' ; 
create or replace procedure t_sys_refcursor_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_sys_refcursor = small_date Then 
        dbms_output.put_line(' big_sys_refcursor =  small_date true' );
    Else 
        dbms_output.put_line(' big_sys_refcursor =  small_date false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_cursor_date ) ' ; 
create or replace procedure t_cursor_date( tc_comment string ) as 
    big_boolean                   boolean       := TRUE;
    big_string                    string        := 'AAA_string';
    big_string_null               string        := NULL;
    big_string_boolean         string        := 'TRUE';
    big_string_short              string        := '8934';                             
    big_string_int                string        := '78234';                            
    big_string_bigint             string        := '278234';                           
    big_string_numeric            string        := '5678.123';                         
    big_string_float              string        := '3677.345';                        
    big_string_double             string        := '56789.1234';                       
    big_string_date               string        := '2024-03-05';                 
    big_string_time               string        := '23:59:59';                   
    big_string_datetime           string        := '2024-03-01 22:15:25'; 
    big_string_timestamp          string        := '2024-05-05 23:30:45';
    big_short                     short         := 8934;
    big_int                       int           := 78234;
    big_bigint                    bigint        := 278234;
    big_numeric                   numeric(8,4)  := 5678.123;
    big_float                     float         := 3677.345;
    big_double                    double        := 56789.1234;
    big_date                      date          := DATE'2024-03-05';
    big_time                      time          := TIME'23:59:59';
    big_datetime                  datetime      := DATETIME'2024-03-01 22:15:25';
    big_timestamp                 timestamp     := TIMESTAMP'2024-05-05 23:30:45';
    big_sys_refcursor             sys_refcursor ;
    cursor  big_cursor is select * from dual ;
    
    small_boolean                 boolean       := FALSE;
    small_string                  string        := 'ZZZ_string';
    small_string_null             string        := NULL; 
    small_string_boolean        string        := 'FALSE'; 
    small_string_short            string        := '34';                               
    small_string_int              string        := '234';                              
    small_string_bigint           string        := '1234';                             
    small_string_numeric          string        := '1234.567';                         
    small_string_float            string        := '432.321';                        
    small_string_double           string        := '1234.56789';                 
    small_string_date             string        := '2002-03-05';                 
    small_string_time             string        := '03:59:59';               
    small_string_datetime         string        := '2002-02-02 02:22:22';
    small_string_timestamp        string        := '2002-01-01 01:01:01';
    small_short                   short         := 34;
    small_int                     int           := 234;
    small_bigint                  bigint        := 1234;
    small_numeric                 numeric(8,4)  := 1234.567;
    small_float                   float         := 432.321;
    small_double                  double        := 1234.56789;
    small_date                    date          := DATE'2002-03-05';
    small_time                    time          := TIME'03:59:59';
    small_datetime                datetime      := DATETIME'2002-02-02 02:22:22';
    small_timestamp               timestamp     := TIMESTAMP'2002-01-01 01:01:01';
    small_sys_refcursor           sys_refcursor ;
    cursor  small_cursor is select * from dual ;

begin 
    If big_cursor = small_date Then 
        dbms_output.put_line(' big_cursor =  small_date true' );
    Else 
        dbms_output.put_line(' big_cursor =  small_date false' );
    end if;

end; 

--+ server-message off
