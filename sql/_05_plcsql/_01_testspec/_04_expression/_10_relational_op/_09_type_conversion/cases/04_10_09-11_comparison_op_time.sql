--+ server-message on

select 'This test is a normal run case. ( t_null_time )' ;
create or replace procedure t_null_time( tc_comment string ) as 
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
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If null = small_time Then 
        dbms_output.put_line(' null =  small_time true' );
    Else 
        dbms_output.put_line(' null =  small_time false' );
    end if;

    If null <=> small_time Then 
        dbms_output.put_line(' null <=>  small_time true' );
    Else 
        dbms_output.put_line(' null <=>  small_time false' );
    end if;

    If null != small_time Then 
        dbms_output.put_line(' null !=  small_time true' );
    Else 
        dbms_output.put_line(' null !=  small_time false' );
    end if;

    If null <= small_time Then 
        dbms_output.put_line(' null <=  small_time true' );
    Else 
        dbms_output.put_line(' null <=  small_time false' );
    end if;

    If null >= small_time Then 
        dbms_output.put_line(' null >=  small_time true' );
    Else 
        dbms_output.put_line(' null >=  small_time false' );
    end if;

    If null < small_time Then 
        dbms_output.put_line(' null <  small_time true' );
    Else 
        dbms_output.put_line(' null <  small_time false' );
    end if;

    If null > small_time Then 
        dbms_output.put_line(' null >  small_time true' );
    Else 
        dbms_output.put_line(' null >  small_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_time = null Then 
        dbms_output.put_line(' small_time =  null true' );
    Else 
        dbms_output.put_line(' small_time =  null false' );
    end if;

    If small_time <=> null Then 
        dbms_output.put_line(' small_time <=>  null true' );
    Else 
        dbms_output.put_line(' small_time <=>  null false' );
    end if;

    If small_time != null Then 
        dbms_output.put_line(' small_time !=  null true' );
    Else 
        dbms_output.put_line(' small_time !=  null false' );
    end if;

    If small_time <= null Then 
        dbms_output.put_line(' small_time <=  null true' );
    Else 
        dbms_output.put_line(' small_time <=  null false' );
    end if;

    If small_time >= null Then 
        dbms_output.put_line(' small_time >=  null true' );
    Else 
        dbms_output.put_line(' small_time >=  null false' );
    end if;

    If small_time < null Then 
        dbms_output.put_line(' small_time <  null true' );
    Else 
        dbms_output.put_line(' small_time <  null false' );
    end if;

    If small_time > null Then 
        dbms_output.put_line(' small_time >  null true' );
    Else 
        dbms_output.put_line(' small_time >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_null_time('Comparison operation : null, time ' ) ; 

drop procedure t_null_time ; 



select 'This test is a case where an error is output.(not support, not created) ( t_boolean_time ) ' ; 
create or replace procedure t_boolean_time( tc_comment string ) as 
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
    If big_boolean = small_time Then 
        dbms_output.put_line(' big_boolean =  small_time true' );
    Else 
        dbms_output.put_line(' big_boolean =  small_time false' );
    end if;

end; 

select 'This test is a normal run case. ( t_string_time )' ;
create or replace procedure t_string_time( tc_comment string ) as 
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
    dbms_output.put_line('big_string_time = ' || NVL(big_string_time,'NULL') );
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_string_time = small_time Then 
        dbms_output.put_line(' big_string_time =  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time =  small_time false' );
    end if;

    If big_string_time <=> small_time Then 
        dbms_output.put_line(' big_string_time <=>  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time <=>  small_time false' );
    end if;

    If big_string_time != small_time Then 
        dbms_output.put_line(' big_string_time !=  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time !=  small_time false' );
    end if;

    If big_string_time <= small_time Then 
        dbms_output.put_line(' big_string_time <=  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time <=  small_time false' );
    end if;

    If big_string_time >= small_time Then 
        dbms_output.put_line(' big_string_time >=  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time >=  small_time false' );
    end if;

    If big_string_time < small_time Then 
        dbms_output.put_line(' big_string_time <  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time <  small_time false' );
    end if;

    If big_string_time > small_time Then 
        dbms_output.put_line(' big_string_time >  small_time true' );
    Else 
        dbms_output.put_line(' big_string_time >  small_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('big_string_time = ' || NVL(big_string_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_time = big_string_time Then 
        dbms_output.put_line(' small_time =  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time =  big_string_time false' );
    end if;

    If small_time <=> big_string_time Then 
        dbms_output.put_line(' small_time <=>  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time <=>  big_string_time false' );
    end if;

    If small_time != big_string_time Then 
        dbms_output.put_line(' small_time !=  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time !=  big_string_time false' );
    end if;

    If small_time <= big_string_time Then 
        dbms_output.put_line(' small_time <=  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time <=  big_string_time false' );
    end if;

    If small_time >= big_string_time Then 
        dbms_output.put_line(' small_time >=  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time >=  big_string_time false' );
    end if;

    If small_time < big_string_time Then 
        dbms_output.put_line(' small_time <  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time <  big_string_time false' );
    end if;

    If small_time > big_string_time Then 
        dbms_output.put_line(' small_time >  big_string_time true' );
    Else 
        dbms_output.put_line(' small_time >  big_string_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_string_time('Comparison operation : string, time ' ) ; 

drop procedure t_string_time ; 



select 'This test is a normal run case. ( t_short_time )' ;
create or replace procedure t_short_time( tc_comment string ) as 
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
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_short = small_time Then 
        dbms_output.put_line(' big_short =  small_time true' );
    Else 
        dbms_output.put_line(' big_short =  small_time false' );
    end if;

    If big_short <=> small_time Then 
        dbms_output.put_line(' big_short <=>  small_time true' );
    Else 
        dbms_output.put_line(' big_short <=>  small_time false' );
    end if;

    If big_short != small_time Then 
        dbms_output.put_line(' big_short !=  small_time true' );
    Else 
        dbms_output.put_line(' big_short !=  small_time false' );
    end if;

    If big_short <= small_time Then 
        dbms_output.put_line(' big_short <=  small_time true' );
    Else 
        dbms_output.put_line(' big_short <=  small_time false' );
    end if;

    If big_short >= small_time Then 
        dbms_output.put_line(' big_short >=  small_time true' );
    Else 
        dbms_output.put_line(' big_short >=  small_time false' );
    end if;

    If big_short < small_time Then 
        dbms_output.put_line(' big_short <  small_time true' );
    Else 
        dbms_output.put_line(' big_short <  small_time false' );
    end if;

    If big_short > small_time Then 
        dbms_output.put_line(' big_short >  small_time true' );
    Else 
        dbms_output.put_line(' big_short >  small_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_time = big_short Then 
        dbms_output.put_line(' small_time =  big_short true' );
    Else 
        dbms_output.put_line(' small_time =  big_short false' );
    end if;

    If small_time <=> big_short Then 
        dbms_output.put_line(' small_time <=>  big_short true' );
    Else 
        dbms_output.put_line(' small_time <=>  big_short false' );
    end if;

    If small_time != big_short Then 
        dbms_output.put_line(' small_time !=  big_short true' );
    Else 
        dbms_output.put_line(' small_time !=  big_short false' );
    end if;

    If small_time <= big_short Then 
        dbms_output.put_line(' small_time <=  big_short true' );
    Else 
        dbms_output.put_line(' small_time <=  big_short false' );
    end if;

    If small_time >= big_short Then 
        dbms_output.put_line(' small_time >=  big_short true' );
    Else 
        dbms_output.put_line(' small_time >=  big_short false' );
    end if;

    If small_time < big_short Then 
        dbms_output.put_line(' small_time <  big_short true' );
    Else 
        dbms_output.put_line(' small_time <  big_short false' );
    end if;

    If small_time > big_short Then 
        dbms_output.put_line(' small_time >  big_short true' );
    Else 
        dbms_output.put_line(' small_time >  big_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_short_time('Comparison operation : short, time ' ) ; 

drop procedure t_short_time ; 



select 'This test is a normal run case. ( t_int_time )' ;
create or replace procedure t_int_time( tc_comment string ) as 
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
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_int = small_time Then 
        dbms_output.put_line(' big_int =  small_time true' );
    Else 
        dbms_output.put_line(' big_int =  small_time false' );
    end if;

    If big_int <=> small_time Then 
        dbms_output.put_line(' big_int <=>  small_time true' );
    Else 
        dbms_output.put_line(' big_int <=>  small_time false' );
    end if;

    If big_int != small_time Then 
        dbms_output.put_line(' big_int !=  small_time true' );
    Else 
        dbms_output.put_line(' big_int !=  small_time false' );
    end if;

    If big_int <= small_time Then 
        dbms_output.put_line(' big_int <=  small_time true' );
    Else 
        dbms_output.put_line(' big_int <=  small_time false' );
    end if;

    If big_int >= small_time Then 
        dbms_output.put_line(' big_int >=  small_time true' );
    Else 
        dbms_output.put_line(' big_int >=  small_time false' );
    end if;

    If big_int < small_time Then 
        dbms_output.put_line(' big_int <  small_time true' );
    Else 
        dbms_output.put_line(' big_int <  small_time false' );
    end if;

    If big_int > small_time Then 
        dbms_output.put_line(' big_int >  small_time true' );
    Else 
        dbms_output.put_line(' big_int >  small_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_time = big_int Then 
        dbms_output.put_line(' small_time =  big_int true' );
    Else 
        dbms_output.put_line(' small_time =  big_int false' );
    end if;

    If small_time <=> big_int Then 
        dbms_output.put_line(' small_time <=>  big_int true' );
    Else 
        dbms_output.put_line(' small_time <=>  big_int false' );
    end if;

    If small_time != big_int Then 
        dbms_output.put_line(' small_time !=  big_int true' );
    Else 
        dbms_output.put_line(' small_time !=  big_int false' );
    end if;

    If small_time <= big_int Then 
        dbms_output.put_line(' small_time <=  big_int true' );
    Else 
        dbms_output.put_line(' small_time <=  big_int false' );
    end if;

    If small_time >= big_int Then 
        dbms_output.put_line(' small_time >=  big_int true' );
    Else 
        dbms_output.put_line(' small_time >=  big_int false' );
    end if;

    If small_time < big_int Then 
        dbms_output.put_line(' small_time <  big_int true' );
    Else 
        dbms_output.put_line(' small_time <  big_int false' );
    end if;

    If small_time > big_int Then 
        dbms_output.put_line(' small_time >  big_int true' );
    Else 
        dbms_output.put_line(' small_time >  big_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_int_time('Comparison operation : int, time ' ) ; 

drop procedure t_int_time ; 



select 'This test is a normal run case. ( t_bigint_time )' ;
create or replace procedure t_bigint_time( tc_comment string ) as 
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
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_bigint = small_time Then 
        dbms_output.put_line(' big_bigint =  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint =  small_time false' );
    end if;

    If big_bigint <=> small_time Then 
        dbms_output.put_line(' big_bigint <=>  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint <=>  small_time false' );
    end if;

    If big_bigint != small_time Then 
        dbms_output.put_line(' big_bigint !=  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint !=  small_time false' );
    end if;

    If big_bigint <= small_time Then 
        dbms_output.put_line(' big_bigint <=  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint <=  small_time false' );
    end if;

    If big_bigint >= small_time Then 
        dbms_output.put_line(' big_bigint >=  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint >=  small_time false' );
    end if;

    If big_bigint < small_time Then 
        dbms_output.put_line(' big_bigint <  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint <  small_time false' );
    end if;

    If big_bigint > small_time Then 
        dbms_output.put_line(' big_bigint >  small_time true' );
    Else 
        dbms_output.put_line(' big_bigint >  small_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_time = big_bigint Then 
        dbms_output.put_line(' small_time =  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time =  big_bigint false' );
    end if;

    If small_time <=> big_bigint Then 
        dbms_output.put_line(' small_time <=>  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time <=>  big_bigint false' );
    end if;

    If small_time != big_bigint Then 
        dbms_output.put_line(' small_time !=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time !=  big_bigint false' );
    end if;

    If small_time <= big_bigint Then 
        dbms_output.put_line(' small_time <=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time <=  big_bigint false' );
    end if;

    If small_time >= big_bigint Then 
        dbms_output.put_line(' small_time >=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time >=  big_bigint false' );
    end if;

    If small_time < big_bigint Then 
        dbms_output.put_line(' small_time <  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time <  big_bigint false' );
    end if;

    If small_time > big_bigint Then 
        dbms_output.put_line(' small_time >  big_bigint true' );
    Else 
        dbms_output.put_line(' small_time >  big_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_bigint_time('Comparison operation : bigint, time ' ) ; 

drop procedure t_bigint_time ; 



select 'This test is a case where an error is output.(not support, not created) ( t_numeric_time ) ' ; 
create or replace procedure t_numeric_time( tc_comment string ) as 
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
    If big_numeric = small_time Then 
        dbms_output.put_line(' big_numeric =  small_time true' );
    Else 
        dbms_output.put_line(' big_numeric =  small_time false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_float_time ) ' ; 
create or replace procedure t_float_time( tc_comment string ) as 
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
    If big_float = small_time Then 
        dbms_output.put_line(' big_float =  small_time true' );
    Else 
        dbms_output.put_line(' big_float =  small_time false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_double_time ) ' ; 
create or replace procedure t_double_time( tc_comment string ) as 
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
    If big_double = small_time Then 
        dbms_output.put_line(' big_double =  small_time true' );
    Else 
        dbms_output.put_line(' big_double =  small_time false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_date_time ) ' ; 
create or replace procedure t_date_time( tc_comment string ) as 
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
    If big_date = small_time Then 
        dbms_output.put_line(' big_date =  small_time true' );
    Else 
        dbms_output.put_line(' big_date =  small_time false' );
    end if;

end; 

select 'This test is a normal run case. ( t_time_time )' ;
create or replace procedure t_time_time( tc_comment string ) as 
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
    dbms_output.put_line('big_time = ' || NVL(big_time,'NULL') );
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_time = small_time Then 
        dbms_output.put_line(' big_time =  small_time true' );
    Else 
        dbms_output.put_line(' big_time =  small_time false' );
    end if;

    If big_time <=> small_time Then 
        dbms_output.put_line(' big_time <=>  small_time true' );
    Else 
        dbms_output.put_line(' big_time <=>  small_time false' );
    end if;

    If big_time != small_time Then 
        dbms_output.put_line(' big_time !=  small_time true' );
    Else 
        dbms_output.put_line(' big_time !=  small_time false' );
    end if;

    If big_time <= small_time Then 
        dbms_output.put_line(' big_time <=  small_time true' );
    Else 
        dbms_output.put_line(' big_time <=  small_time false' );
    end if;

    If big_time >= small_time Then 
        dbms_output.put_line(' big_time >=  small_time true' );
    Else 
        dbms_output.put_line(' big_time >=  small_time false' );
    end if;

    If big_time < small_time Then 
        dbms_output.put_line(' big_time <  small_time true' );
    Else 
        dbms_output.put_line(' big_time <  small_time false' );
    end if;

    If big_time > small_time Then 
        dbms_output.put_line(' big_time >  small_time true' );
    Else 
        dbms_output.put_line(' big_time >  small_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_time = ' || NVL(small_time,'NULL') );
    dbms_output.put_line('big_time = ' || NVL(big_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_time = big_time Then 
        dbms_output.put_line(' small_time =  big_time true' );
    Else 
        dbms_output.put_line(' small_time =  big_time false' );
    end if;

    If small_time <=> big_time Then 
        dbms_output.put_line(' small_time <=>  big_time true' );
    Else 
        dbms_output.put_line(' small_time <=>  big_time false' );
    end if;

    If small_time != big_time Then 
        dbms_output.put_line(' small_time !=  big_time true' );
    Else 
        dbms_output.put_line(' small_time !=  big_time false' );
    end if;

    If small_time <= big_time Then 
        dbms_output.put_line(' small_time <=  big_time true' );
    Else 
        dbms_output.put_line(' small_time <=  big_time false' );
    end if;

    If small_time >= big_time Then 
        dbms_output.put_line(' small_time >=  big_time true' );
    Else 
        dbms_output.put_line(' small_time >=  big_time false' );
    end if;

    If small_time < big_time Then 
        dbms_output.put_line(' small_time <  big_time true' );
    Else 
        dbms_output.put_line(' small_time <  big_time false' );
    end if;

    If small_time > big_time Then 
        dbms_output.put_line(' small_time >  big_time true' );
    Else 
        dbms_output.put_line(' small_time >  big_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_time_time('Comparison operation : time, time ' ) ; 

drop procedure t_time_time ; 



select 'This test is a case where an error is output.(not support, not created) ( t_datetime_time ) ' ; 
create or replace procedure t_datetime_time( tc_comment string ) as 
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
    If big_datetime = small_time Then 
        dbms_output.put_line(' big_datetime =  small_time true' );
    Else 
        dbms_output.put_line(' big_datetime =  small_time false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_timestamp_time ) ' ; 
create or replace procedure t_timestamp_time( tc_comment string ) as 
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
    If big_timestamp = small_time Then 
        dbms_output.put_line(' big_timestamp =  small_time true' );
    Else 
        dbms_output.put_line(' big_timestamp =  small_time false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_sys_refcursor_time ) ' ; 
create or replace procedure t_sys_refcursor_time( tc_comment string ) as 
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
    If big_sys_refcursor = small_time Then 
        dbms_output.put_line(' big_sys_refcursor =  small_time true' );
    Else 
        dbms_output.put_line(' big_sys_refcursor =  small_time false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_cursor_time ) ' ; 
create or replace procedure t_cursor_time( tc_comment string ) as 
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
    If big_cursor = small_time Then 
        dbms_output.put_line(' big_cursor =  small_time true' );
    Else 
        dbms_output.put_line(' big_cursor =  small_time false' );
    end if;

end; 

--+ server-message off
