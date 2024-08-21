--+ server-message on

select 'This test is a normal run case. ( t_null_timestamp )' ;
create or replace procedure t_null_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If null = small_timestamp Then 
        dbms_output.put_line(' null =  small_timestamp true' );
    Else 
        dbms_output.put_line(' null =  small_timestamp false' );
    end if;

    If null <=> small_timestamp Then 
        dbms_output.put_line(' null <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' null <=>  small_timestamp false' );
    end if;

    If null != small_timestamp Then 
        dbms_output.put_line(' null !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' null !=  small_timestamp false' );
    end if;

    If null <= small_timestamp Then 
        dbms_output.put_line(' null <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' null <=  small_timestamp false' );
    end if;

    If null >= small_timestamp Then 
        dbms_output.put_line(' null >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' null >=  small_timestamp false' );
    end if;

    If null < small_timestamp Then 
        dbms_output.put_line(' null <  small_timestamp true' );
    Else 
        dbms_output.put_line(' null <  small_timestamp false' );
    end if;

    If null > small_timestamp Then 
        dbms_output.put_line(' null >  small_timestamp true' );
    Else 
        dbms_output.put_line(' null >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = null Then 
        dbms_output.put_line(' small_timestamp =  null true' );
    Else 
        dbms_output.put_line(' small_timestamp =  null false' );
    end if;

    If small_timestamp <=> null Then 
        dbms_output.put_line(' small_timestamp <=>  null true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  null false' );
    end if;

    If small_timestamp != null Then 
        dbms_output.put_line(' small_timestamp !=  null true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  null false' );
    end if;

    If small_timestamp <= null Then 
        dbms_output.put_line(' small_timestamp <=  null true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  null false' );
    end if;

    If small_timestamp >= null Then 
        dbms_output.put_line(' small_timestamp >=  null true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  null false' );
    end if;

    If small_timestamp < null Then 
        dbms_output.put_line(' small_timestamp <  null true' );
    Else 
        dbms_output.put_line(' small_timestamp <  null false' );
    end if;

    If small_timestamp > null Then 
        dbms_output.put_line(' small_timestamp >  null true' );
    Else 
        dbms_output.put_line(' small_timestamp >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_null_timestamp('Comparison operation : null, timestamp ' ) ; 

drop procedure t_null_timestamp ; 



select 'This test is a case where an error is output.(not support, not created) ( t_boolean_timestamp ) ' ; 
create or replace procedure t_boolean_timestamp( tc_comment string ) as 
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
    If big_boolean = small_timestamp Then 
        dbms_output.put_line(' big_boolean =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_boolean =  small_timestamp false' );
    end if;

end; 

select 'This test is a normal run case. ( t_string_timestamp )' ;
create or replace procedure t_string_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('big_string_timestamp = ' || NVL(big_string_timestamp,'NULL') );
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_string_timestamp = small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp =  small_timestamp false' );
    end if;

    If big_string_timestamp <=> small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp <=>  small_timestamp false' );
    end if;

    If big_string_timestamp != small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp !=  small_timestamp false' );
    end if;

    If big_string_timestamp <= small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp <=  small_timestamp false' );
    end if;

    If big_string_timestamp >= small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp >=  small_timestamp false' );
    end if;

    If big_string_timestamp < small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp <  small_timestamp false' );
    end if;

    If big_string_timestamp > small_timestamp Then 
        dbms_output.put_line(' big_string_timestamp >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_string_timestamp >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_string_timestamp = ' || NVL(big_string_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp =  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_string_timestamp false' );
    end if;

    If small_timestamp <=> big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp <=>  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_string_timestamp false' );
    end if;

    If small_timestamp != big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp !=  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_string_timestamp false' );
    end if;

    If small_timestamp <= big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp <=  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_string_timestamp false' );
    end if;

    If small_timestamp >= big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp >=  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_string_timestamp false' );
    end if;

    If small_timestamp < big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp <  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_string_timestamp false' );
    end if;

    If small_timestamp > big_string_timestamp Then 
        dbms_output.put_line(' small_timestamp >  big_string_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_string_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_string_timestamp('Comparison operation : string, timestamp ' ) ; 

drop procedure t_string_timestamp ; 



select 'This test is a normal run case. ( t_short_timestamp )' ;
create or replace procedure t_short_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_short = small_timestamp Then 
        dbms_output.put_line(' big_short =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short =  small_timestamp false' );
    end if;

    If big_short <=> small_timestamp Then 
        dbms_output.put_line(' big_short <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short <=>  small_timestamp false' );
    end if;

    If big_short != small_timestamp Then 
        dbms_output.put_line(' big_short !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short !=  small_timestamp false' );
    end if;

    If big_short <= small_timestamp Then 
        dbms_output.put_line(' big_short <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short <=  small_timestamp false' );
    end if;

    If big_short >= small_timestamp Then 
        dbms_output.put_line(' big_short >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short >=  small_timestamp false' );
    end if;

    If big_short < small_timestamp Then 
        dbms_output.put_line(' big_short <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short <  small_timestamp false' );
    end if;

    If big_short > small_timestamp Then 
        dbms_output.put_line(' big_short >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_short >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_short Then 
        dbms_output.put_line(' small_timestamp =  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_short false' );
    end if;

    If small_timestamp <=> big_short Then 
        dbms_output.put_line(' small_timestamp <=>  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_short false' );
    end if;

    If small_timestamp != big_short Then 
        dbms_output.put_line(' small_timestamp !=  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_short false' );
    end if;

    If small_timestamp <= big_short Then 
        dbms_output.put_line(' small_timestamp <=  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_short false' );
    end if;

    If small_timestamp >= big_short Then 
        dbms_output.put_line(' small_timestamp >=  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_short false' );
    end if;

    If small_timestamp < big_short Then 
        dbms_output.put_line(' small_timestamp <  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_short false' );
    end if;

    If small_timestamp > big_short Then 
        dbms_output.put_line(' small_timestamp >  big_short true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_short_timestamp('Comparison operation : short, timestamp ' ) ; 

drop procedure t_short_timestamp ; 



select 'This test is a normal run case. ( t_int_timestamp )' ;
create or replace procedure t_int_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_int = small_timestamp Then 
        dbms_output.put_line(' big_int =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int =  small_timestamp false' );
    end if;

    If big_int <=> small_timestamp Then 
        dbms_output.put_line(' big_int <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int <=>  small_timestamp false' );
    end if;

    If big_int != small_timestamp Then 
        dbms_output.put_line(' big_int !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int !=  small_timestamp false' );
    end if;

    If big_int <= small_timestamp Then 
        dbms_output.put_line(' big_int <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int <=  small_timestamp false' );
    end if;

    If big_int >= small_timestamp Then 
        dbms_output.put_line(' big_int >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int >=  small_timestamp false' );
    end if;

    If big_int < small_timestamp Then 
        dbms_output.put_line(' big_int <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int <  small_timestamp false' );
    end if;

    If big_int > small_timestamp Then 
        dbms_output.put_line(' big_int >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_int >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_int Then 
        dbms_output.put_line(' small_timestamp =  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_int false' );
    end if;

    If small_timestamp <=> big_int Then 
        dbms_output.put_line(' small_timestamp <=>  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_int false' );
    end if;

    If small_timestamp != big_int Then 
        dbms_output.put_line(' small_timestamp !=  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_int false' );
    end if;

    If small_timestamp <= big_int Then 
        dbms_output.put_line(' small_timestamp <=  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_int false' );
    end if;

    If small_timestamp >= big_int Then 
        dbms_output.put_line(' small_timestamp >=  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_int false' );
    end if;

    If small_timestamp < big_int Then 
        dbms_output.put_line(' small_timestamp <  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_int false' );
    end if;

    If small_timestamp > big_int Then 
        dbms_output.put_line(' small_timestamp >  big_int true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_int_timestamp('Comparison operation : int, timestamp ' ) ; 

drop procedure t_int_timestamp ; 



select 'This test is a normal run case. ( t_bigint_timestamp )' ;
create or replace procedure t_bigint_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_bigint = small_timestamp Then 
        dbms_output.put_line(' big_bigint =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint =  small_timestamp false' );
    end if;

    If big_bigint <=> small_timestamp Then 
        dbms_output.put_line(' big_bigint <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint <=>  small_timestamp false' );
    end if;

    If big_bigint != small_timestamp Then 
        dbms_output.put_line(' big_bigint !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint !=  small_timestamp false' );
    end if;

    If big_bigint <= small_timestamp Then 
        dbms_output.put_line(' big_bigint <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint <=  small_timestamp false' );
    end if;

    If big_bigint >= small_timestamp Then 
        dbms_output.put_line(' big_bigint >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint >=  small_timestamp false' );
    end if;

    If big_bigint < small_timestamp Then 
        dbms_output.put_line(' big_bigint <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint <  small_timestamp false' );
    end if;

    If big_bigint > small_timestamp Then 
        dbms_output.put_line(' big_bigint >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_bigint >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_bigint Then 
        dbms_output.put_line(' small_timestamp =  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_bigint false' );
    end if;

    If small_timestamp <=> big_bigint Then 
        dbms_output.put_line(' small_timestamp <=>  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_bigint false' );
    end if;

    If small_timestamp != big_bigint Then 
        dbms_output.put_line(' small_timestamp !=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_bigint false' );
    end if;

    If small_timestamp <= big_bigint Then 
        dbms_output.put_line(' small_timestamp <=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_bigint false' );
    end if;

    If small_timestamp >= big_bigint Then 
        dbms_output.put_line(' small_timestamp >=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_bigint false' );
    end if;

    If small_timestamp < big_bigint Then 
        dbms_output.put_line(' small_timestamp <  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_bigint false' );
    end if;

    If small_timestamp > big_bigint Then 
        dbms_output.put_line(' small_timestamp >  big_bigint true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_bigint_timestamp('Comparison operation : bigint, timestamp ' ) ; 

drop procedure t_bigint_timestamp ; 



select 'This test is a case where an error is output.(not support, not created) ( t_numeric_timestamp ) ' ; 
create or replace procedure t_numeric_timestamp( tc_comment string ) as 
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
    If big_numeric = small_timestamp Then 
        dbms_output.put_line(' big_numeric =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_numeric =  small_timestamp false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_float_timestamp ) ' ; 
create or replace procedure t_float_timestamp( tc_comment string ) as 
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
    If big_float = small_timestamp Then 
        dbms_output.put_line(' big_float =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_float =  small_timestamp false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_double_timestamp ) ' ; 
create or replace procedure t_double_timestamp( tc_comment string ) as 
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
    If big_double = small_timestamp Then 
        dbms_output.put_line(' big_double =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_double =  small_timestamp false' );
    end if;

end; 

select 'This test is a normal run case. ( t_date_timestamp )' ;
create or replace procedure t_date_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_date = small_timestamp Then 
        dbms_output.put_line(' big_date =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date =  small_timestamp false' );
    end if;

    If big_date <=> small_timestamp Then 
        dbms_output.put_line(' big_date <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date <=>  small_timestamp false' );
    end if;

    If big_date != small_timestamp Then 
        dbms_output.put_line(' big_date !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date !=  small_timestamp false' );
    end if;

    If big_date <= small_timestamp Then 
        dbms_output.put_line(' big_date <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date <=  small_timestamp false' );
    end if;

    If big_date >= small_timestamp Then 
        dbms_output.put_line(' big_date >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date >=  small_timestamp false' );
    end if;

    If big_date < small_timestamp Then 
        dbms_output.put_line(' big_date <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date <  small_timestamp false' );
    end if;

    If big_date > small_timestamp Then 
        dbms_output.put_line(' big_date >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_date >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_date = ' || NVL(big_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_date Then 
        dbms_output.put_line(' small_timestamp =  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_date false' );
    end if;

    If small_timestamp <=> big_date Then 
        dbms_output.put_line(' small_timestamp <=>  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_date false' );
    end if;

    If small_timestamp != big_date Then 
        dbms_output.put_line(' small_timestamp !=  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_date false' );
    end if;

    If small_timestamp <= big_date Then 
        dbms_output.put_line(' small_timestamp <=  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_date false' );
    end if;

    If small_timestamp >= big_date Then 
        dbms_output.put_line(' small_timestamp >=  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_date false' );
    end if;

    If small_timestamp < big_date Then 
        dbms_output.put_line(' small_timestamp <  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_date false' );
    end if;

    If small_timestamp > big_date Then 
        dbms_output.put_line(' small_timestamp >  big_date true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_date_timestamp('Comparison operation : date, timestamp ' ) ; 

drop procedure t_date_timestamp ; 



select 'This test is a case where an error is output.(not support, not created) ( t_time_timestamp ) ' ; 
create or replace procedure t_time_timestamp( tc_comment string ) as 
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
    If big_time = small_timestamp Then 
        dbms_output.put_line(' big_time =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_time =  small_timestamp false' );
    end if;

end; 

select 'This test is a normal run case. ( t_datetime_timestamp )' ;
create or replace procedure t_datetime_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_datetime = small_timestamp Then 
        dbms_output.put_line(' big_datetime =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime =  small_timestamp false' );
    end if;

    If big_datetime <=> small_timestamp Then 
        dbms_output.put_line(' big_datetime <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime <=>  small_timestamp false' );
    end if;

    If big_datetime != small_timestamp Then 
        dbms_output.put_line(' big_datetime !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime !=  small_timestamp false' );
    end if;

    If big_datetime <= small_timestamp Then 
        dbms_output.put_line(' big_datetime <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime <=  small_timestamp false' );
    end if;

    If big_datetime >= small_timestamp Then 
        dbms_output.put_line(' big_datetime >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime >=  small_timestamp false' );
    end if;

    If big_datetime < small_timestamp Then 
        dbms_output.put_line(' big_datetime <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime <  small_timestamp false' );
    end if;

    If big_datetime > small_timestamp Then 
        dbms_output.put_line(' big_datetime >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_datetime >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_datetime = ' || NVL(big_datetime,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_datetime Then 
        dbms_output.put_line(' small_timestamp =  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_datetime false' );
    end if;

    If small_timestamp <=> big_datetime Then 
        dbms_output.put_line(' small_timestamp <=>  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_datetime false' );
    end if;

    If small_timestamp != big_datetime Then 
        dbms_output.put_line(' small_timestamp !=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_datetime false' );
    end if;

    If small_timestamp <= big_datetime Then 
        dbms_output.put_line(' small_timestamp <=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_datetime false' );
    end if;

    If small_timestamp >= big_datetime Then 
        dbms_output.put_line(' small_timestamp >=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_datetime false' );
    end if;

    If small_timestamp < big_datetime Then 
        dbms_output.put_line(' small_timestamp <  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_datetime false' );
    end if;

    If small_timestamp > big_datetime Then 
        dbms_output.put_line(' small_timestamp >  big_datetime true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_datetime false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_datetime_timestamp('Comparison operation : datetime, timestamp ' ) ; 

drop procedure t_datetime_timestamp ; 



select 'This test is a normal run case. ( t_timestamp_timestamp )' ;
create or replace procedure t_timestamp_timestamp( tc_comment string ) as 
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
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_timestamp = small_timestamp Then 
        dbms_output.put_line(' big_timestamp =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp =  small_timestamp false' );
    end if;

    If big_timestamp <=> small_timestamp Then 
        dbms_output.put_line(' big_timestamp <=>  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <=>  small_timestamp false' );
    end if;

    If big_timestamp != small_timestamp Then 
        dbms_output.put_line(' big_timestamp !=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp !=  small_timestamp false' );
    end if;

    If big_timestamp <= small_timestamp Then 
        dbms_output.put_line(' big_timestamp <=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <=  small_timestamp false' );
    end if;

    If big_timestamp >= small_timestamp Then 
        dbms_output.put_line(' big_timestamp >=  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp >=  small_timestamp false' );
    end if;

    If big_timestamp < small_timestamp Then 
        dbms_output.put_line(' big_timestamp <  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <  small_timestamp false' );
    end if;

    If big_timestamp > small_timestamp Then 
        dbms_output.put_line(' big_timestamp >  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp >  small_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_timestamp = ' || NVL(small_timestamp,'NULL') );
    dbms_output.put_line('big_timestamp = ' || NVL(big_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_timestamp = big_timestamp Then 
        dbms_output.put_line(' small_timestamp =  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp =  big_timestamp false' );
    end if;

    If small_timestamp <=> big_timestamp Then 
        dbms_output.put_line(' small_timestamp <=>  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp <=>  big_timestamp false' );
    end if;

    If small_timestamp != big_timestamp Then 
        dbms_output.put_line(' small_timestamp !=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp !=  big_timestamp false' );
    end if;

    If small_timestamp <= big_timestamp Then 
        dbms_output.put_line(' small_timestamp <=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp <=  big_timestamp false' );
    end if;

    If small_timestamp >= big_timestamp Then 
        dbms_output.put_line(' small_timestamp >=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp >=  big_timestamp false' );
    end if;

    If small_timestamp < big_timestamp Then 
        dbms_output.put_line(' small_timestamp <  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp <  big_timestamp false' );
    end if;

    If small_timestamp > big_timestamp Then 
        dbms_output.put_line(' small_timestamp >  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_timestamp >  big_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_timestamp_timestamp('Comparison operation : timestamp, timestamp ' ) ; 

drop procedure t_timestamp_timestamp ; 



select 'This test is a case where an error is output.(not support, not created) ( t_sys_refcursor_timestamp ) ' ; 
create or replace procedure t_sys_refcursor_timestamp( tc_comment string ) as 
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
    If big_sys_refcursor = small_timestamp Then 
        dbms_output.put_line(' big_sys_refcursor =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_sys_refcursor =  small_timestamp false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_cursor_timestamp ) ' ; 
create or replace procedure t_cursor_timestamp( tc_comment string ) as 
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
    If big_cursor = small_timestamp Then 
        dbms_output.put_line(' big_cursor =  small_timestamp true' );
    Else 
        dbms_output.put_line(' big_cursor =  small_timestamp false' );
    end if;

end; 

--+ server-message off
