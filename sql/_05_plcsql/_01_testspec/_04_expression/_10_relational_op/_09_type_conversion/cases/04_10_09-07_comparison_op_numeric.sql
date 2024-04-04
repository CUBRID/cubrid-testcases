--+ server-message on

select 'This test is a normal run case. ( t_null_numeric )' ;
create or replace procedure t_null_numeric( tc_comment string ) as 
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
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If null = small_numeric Then 
        dbms_output.put_line(' null =  small_numeric true' );
    Else 
        dbms_output.put_line(' null =  small_numeric false' );
    end if;

    If null <=> small_numeric Then 
        dbms_output.put_line(' null <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' null <=>  small_numeric false' );
    end if;

    If null != small_numeric Then 
        dbms_output.put_line(' null !=  small_numeric true' );
    Else 
        dbms_output.put_line(' null !=  small_numeric false' );
    end if;

    If null <= small_numeric Then 
        dbms_output.put_line(' null <=  small_numeric true' );
    Else 
        dbms_output.put_line(' null <=  small_numeric false' );
    end if;

    If null >= small_numeric Then 
        dbms_output.put_line(' null >=  small_numeric true' );
    Else 
        dbms_output.put_line(' null >=  small_numeric false' );
    end if;

    If null < small_numeric Then 
        dbms_output.put_line(' null <  small_numeric true' );
    Else 
        dbms_output.put_line(' null <  small_numeric false' );
    end if;

    If null > small_numeric Then 
        dbms_output.put_line(' null >  small_numeric true' );
    Else 
        dbms_output.put_line(' null >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = null Then 
        dbms_output.put_line(' small_numeric =  null true' );
    Else 
        dbms_output.put_line(' small_numeric =  null false' );
    end if;

    If small_numeric <=> null Then 
        dbms_output.put_line(' small_numeric <=>  null true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  null false' );
    end if;

    If small_numeric != null Then 
        dbms_output.put_line(' small_numeric !=  null true' );
    Else 
        dbms_output.put_line(' small_numeric !=  null false' );
    end if;

    If small_numeric <= null Then 
        dbms_output.put_line(' small_numeric <=  null true' );
    Else 
        dbms_output.put_line(' small_numeric <=  null false' );
    end if;

    If small_numeric >= null Then 
        dbms_output.put_line(' small_numeric >=  null true' );
    Else 
        dbms_output.put_line(' small_numeric >=  null false' );
    end if;

    If small_numeric < null Then 
        dbms_output.put_line(' small_numeric <  null true' );
    Else 
        dbms_output.put_line(' small_numeric <  null false' );
    end if;

    If small_numeric > null Then 
        dbms_output.put_line(' small_numeric >  null true' );
    Else 
        dbms_output.put_line(' small_numeric >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_null_numeric('Comparison operation : null, numeric ' ) ; 

drop procedure t_null_numeric ; 



select 'This test is a case where an error is output.(not support, not created) ( t_boolean_numeric ) ' ; 
create or replace procedure t_boolean_numeric( tc_comment string ) as 
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
    If big_boolean = small_numeric Then 
        dbms_output.put_line(' big_boolean =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_boolean =  small_numeric false' );
    end if;

end; 

select 'This test is a normal run case. ( t_string_numeric )' ;
create or replace procedure t_string_numeric( tc_comment string ) as 
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
    dbms_output.put_line('big_string_numeric = ' || NVL(big_string_numeric,'NULL') );
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_string_numeric = small_numeric Then 
        dbms_output.put_line(' big_string_numeric =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric =  small_numeric false' );
    end if;

    If big_string_numeric <=> small_numeric Then 
        dbms_output.put_line(' big_string_numeric <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric <=>  small_numeric false' );
    end if;

    If big_string_numeric != small_numeric Then 
        dbms_output.put_line(' big_string_numeric !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric !=  small_numeric false' );
    end if;

    If big_string_numeric <= small_numeric Then 
        dbms_output.put_line(' big_string_numeric <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric <=  small_numeric false' );
    end if;

    If big_string_numeric >= small_numeric Then 
        dbms_output.put_line(' big_string_numeric >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric >=  small_numeric false' );
    end if;

    If big_string_numeric < small_numeric Then 
        dbms_output.put_line(' big_string_numeric <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric <  small_numeric false' );
    end if;

    If big_string_numeric > small_numeric Then 
        dbms_output.put_line(' big_string_numeric >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_string_numeric >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_string_numeric = ' || NVL(big_string_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_string_numeric Then 
        dbms_output.put_line(' small_numeric =  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_string_numeric false' );
    end if;

    If small_numeric <=> big_string_numeric Then 
        dbms_output.put_line(' small_numeric <=>  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_string_numeric false' );
    end if;

    If small_numeric != big_string_numeric Then 
        dbms_output.put_line(' small_numeric !=  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_string_numeric false' );
    end if;

    If small_numeric <= big_string_numeric Then 
        dbms_output.put_line(' small_numeric <=  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_string_numeric false' );
    end if;

    If small_numeric >= big_string_numeric Then 
        dbms_output.put_line(' small_numeric >=  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_string_numeric false' );
    end if;

    If small_numeric < big_string_numeric Then 
        dbms_output.put_line(' small_numeric <  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_string_numeric false' );
    end if;

    If small_numeric > big_string_numeric Then 
        dbms_output.put_line(' small_numeric >  big_string_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_string_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_string_numeric('Comparison operation : string, numeric ' ) ; 

drop procedure t_string_numeric ; 



select 'This test is a normal run case. ( t_short_numeric )' ;
create or replace procedure t_short_numeric( tc_comment string ) as 
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
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_short = small_numeric Then 
        dbms_output.put_line(' big_short =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short =  small_numeric false' );
    end if;

    If big_short <=> small_numeric Then 
        dbms_output.put_line(' big_short <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short <=>  small_numeric false' );
    end if;

    If big_short != small_numeric Then 
        dbms_output.put_line(' big_short !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short !=  small_numeric false' );
    end if;

    If big_short <= small_numeric Then 
        dbms_output.put_line(' big_short <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short <=  small_numeric false' );
    end if;

    If big_short >= small_numeric Then 
        dbms_output.put_line(' big_short >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short >=  small_numeric false' );
    end if;

    If big_short < small_numeric Then 
        dbms_output.put_line(' big_short <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short <  small_numeric false' );
    end if;

    If big_short > small_numeric Then 
        dbms_output.put_line(' big_short >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_short >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_short Then 
        dbms_output.put_line(' small_numeric =  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_short false' );
    end if;

    If small_numeric <=> big_short Then 
        dbms_output.put_line(' small_numeric <=>  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_short false' );
    end if;

    If small_numeric != big_short Then 
        dbms_output.put_line(' small_numeric !=  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_short false' );
    end if;

    If small_numeric <= big_short Then 
        dbms_output.put_line(' small_numeric <=  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_short false' );
    end if;

    If small_numeric >= big_short Then 
        dbms_output.put_line(' small_numeric >=  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_short false' );
    end if;

    If small_numeric < big_short Then 
        dbms_output.put_line(' small_numeric <  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_short false' );
    end if;

    If small_numeric > big_short Then 
        dbms_output.put_line(' small_numeric >  big_short true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_short_numeric('Comparison operation : short, numeric ' ) ; 

drop procedure t_short_numeric ; 



select 'This test is a normal run case. ( t_int_numeric )' ;
create or replace procedure t_int_numeric( tc_comment string ) as 
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
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_int = small_numeric Then 
        dbms_output.put_line(' big_int =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int =  small_numeric false' );
    end if;

    If big_int <=> small_numeric Then 
        dbms_output.put_line(' big_int <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int <=>  small_numeric false' );
    end if;

    If big_int != small_numeric Then 
        dbms_output.put_line(' big_int !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int !=  small_numeric false' );
    end if;

    If big_int <= small_numeric Then 
        dbms_output.put_line(' big_int <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int <=  small_numeric false' );
    end if;

    If big_int >= small_numeric Then 
        dbms_output.put_line(' big_int >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int >=  small_numeric false' );
    end if;

    If big_int < small_numeric Then 
        dbms_output.put_line(' big_int <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int <  small_numeric false' );
    end if;

    If big_int > small_numeric Then 
        dbms_output.put_line(' big_int >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_int >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_int Then 
        dbms_output.put_line(' small_numeric =  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_int false' );
    end if;

    If small_numeric <=> big_int Then 
        dbms_output.put_line(' small_numeric <=>  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_int false' );
    end if;

    If small_numeric != big_int Then 
        dbms_output.put_line(' small_numeric !=  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_int false' );
    end if;

    If small_numeric <= big_int Then 
        dbms_output.put_line(' small_numeric <=  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_int false' );
    end if;

    If small_numeric >= big_int Then 
        dbms_output.put_line(' small_numeric >=  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_int false' );
    end if;

    If small_numeric < big_int Then 
        dbms_output.put_line(' small_numeric <  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_int false' );
    end if;

    If small_numeric > big_int Then 
        dbms_output.put_line(' small_numeric >  big_int true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_int_numeric('Comparison operation : int, numeric ' ) ; 

drop procedure t_int_numeric ; 



select 'This test is a normal run case. ( t_bigint_numeric )' ;
create or replace procedure t_bigint_numeric( tc_comment string ) as 
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
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_bigint = small_numeric Then 
        dbms_output.put_line(' big_bigint =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint =  small_numeric false' );
    end if;

    If big_bigint <=> small_numeric Then 
        dbms_output.put_line(' big_bigint <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint <=>  small_numeric false' );
    end if;

    If big_bigint != small_numeric Then 
        dbms_output.put_line(' big_bigint !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint !=  small_numeric false' );
    end if;

    If big_bigint <= small_numeric Then 
        dbms_output.put_line(' big_bigint <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint <=  small_numeric false' );
    end if;

    If big_bigint >= small_numeric Then 
        dbms_output.put_line(' big_bigint >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint >=  small_numeric false' );
    end if;

    If big_bigint < small_numeric Then 
        dbms_output.put_line(' big_bigint <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint <  small_numeric false' );
    end if;

    If big_bigint > small_numeric Then 
        dbms_output.put_line(' big_bigint >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_bigint >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_bigint Then 
        dbms_output.put_line(' small_numeric =  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_bigint false' );
    end if;

    If small_numeric <=> big_bigint Then 
        dbms_output.put_line(' small_numeric <=>  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_bigint false' );
    end if;

    If small_numeric != big_bigint Then 
        dbms_output.put_line(' small_numeric !=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_bigint false' );
    end if;

    If small_numeric <= big_bigint Then 
        dbms_output.put_line(' small_numeric <=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_bigint false' );
    end if;

    If small_numeric >= big_bigint Then 
        dbms_output.put_line(' small_numeric >=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_bigint false' );
    end if;

    If small_numeric < big_bigint Then 
        dbms_output.put_line(' small_numeric <  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_bigint false' );
    end if;

    If small_numeric > big_bigint Then 
        dbms_output.put_line(' small_numeric >  big_bigint true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_bigint_numeric('Comparison operation : bigint, numeric ' ) ; 

drop procedure t_bigint_numeric ; 



select 'This test is a normal run case. ( t_numeric_numeric )' ;
create or replace procedure t_numeric_numeric( tc_comment string ) as 
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
    dbms_output.put_line('big_numeric = ' || NVL(big_numeric,'NULL') );
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_numeric = small_numeric Then 
        dbms_output.put_line(' big_numeric =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric =  small_numeric false' );
    end if;

    If big_numeric <=> small_numeric Then 
        dbms_output.put_line(' big_numeric <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <=>  small_numeric false' );
    end if;

    If big_numeric != small_numeric Then 
        dbms_output.put_line(' big_numeric !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric !=  small_numeric false' );
    end if;

    If big_numeric <= small_numeric Then 
        dbms_output.put_line(' big_numeric <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <=  small_numeric false' );
    end if;

    If big_numeric >= small_numeric Then 
        dbms_output.put_line(' big_numeric >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric >=  small_numeric false' );
    end if;

    If big_numeric < small_numeric Then 
        dbms_output.put_line(' big_numeric <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <  small_numeric false' );
    end if;

    If big_numeric > small_numeric Then 
        dbms_output.put_line(' big_numeric >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_numeric = ' || NVL(big_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_numeric Then 
        dbms_output.put_line(' small_numeric =  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_numeric false' );
    end if;

    If small_numeric <=> big_numeric Then 
        dbms_output.put_line(' small_numeric <=>  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_numeric false' );
    end if;

    If small_numeric != big_numeric Then 
        dbms_output.put_line(' small_numeric !=  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_numeric false' );
    end if;

    If small_numeric <= big_numeric Then 
        dbms_output.put_line(' small_numeric <=  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_numeric false' );
    end if;

    If small_numeric >= big_numeric Then 
        dbms_output.put_line(' small_numeric >=  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_numeric false' );
    end if;

    If small_numeric < big_numeric Then 
        dbms_output.put_line(' small_numeric <  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_numeric false' );
    end if;

    If small_numeric > big_numeric Then 
        dbms_output.put_line(' small_numeric >  big_numeric true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_numeric_numeric('Comparison operation : numeric, numeric ' ) ; 

drop procedure t_numeric_numeric ; 



select 'This test is a normal run case. ( t_float_numeric )' ;
create or replace procedure t_float_numeric( tc_comment string ) as 
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
    dbms_output.put_line('big_float = ' || NVL(big_float,'NULL') );
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_float = small_numeric Then 
        dbms_output.put_line(' big_float =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float =  small_numeric false' );
    end if;

    If big_float <=> small_numeric Then 
        dbms_output.put_line(' big_float <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float <=>  small_numeric false' );
    end if;

    If big_float != small_numeric Then 
        dbms_output.put_line(' big_float !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float !=  small_numeric false' );
    end if;

    If big_float <= small_numeric Then 
        dbms_output.put_line(' big_float <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float <=  small_numeric false' );
    end if;

    If big_float >= small_numeric Then 
        dbms_output.put_line(' big_float >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float >=  small_numeric false' );
    end if;

    If big_float < small_numeric Then 
        dbms_output.put_line(' big_float <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float <  small_numeric false' );
    end if;

    If big_float > small_numeric Then 
        dbms_output.put_line(' big_float >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_float >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_float = ' || NVL(big_float,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_float Then 
        dbms_output.put_line(' small_numeric =  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_float false' );
    end if;

    If small_numeric <=> big_float Then 
        dbms_output.put_line(' small_numeric <=>  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_float false' );
    end if;

    If small_numeric != big_float Then 
        dbms_output.put_line(' small_numeric !=  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_float false' );
    end if;

    If small_numeric <= big_float Then 
        dbms_output.put_line(' small_numeric <=  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_float false' );
    end if;

    If small_numeric >= big_float Then 
        dbms_output.put_line(' small_numeric >=  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_float false' );
    end if;

    If small_numeric < big_float Then 
        dbms_output.put_line(' small_numeric <  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_float false' );
    end if;

    If small_numeric > big_float Then 
        dbms_output.put_line(' small_numeric >  big_float true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_float false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_float_numeric('Comparison operation : float, numeric ' ) ; 

drop procedure t_float_numeric ; 



select 'This test is a normal run case. ( t_double_numeric )' ;
create or replace procedure t_double_numeric( tc_comment string ) as 
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
    dbms_output.put_line('big_double = ' || NVL(big_double,'NULL') );
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_double = small_numeric Then 
        dbms_output.put_line(' big_double =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double =  small_numeric false' );
    end if;

    If big_double <=> small_numeric Then 
        dbms_output.put_line(' big_double <=>  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double <=>  small_numeric false' );
    end if;

    If big_double != small_numeric Then 
        dbms_output.put_line(' big_double !=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double !=  small_numeric false' );
    end if;

    If big_double <= small_numeric Then 
        dbms_output.put_line(' big_double <=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double <=  small_numeric false' );
    end if;

    If big_double >= small_numeric Then 
        dbms_output.put_line(' big_double >=  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double >=  small_numeric false' );
    end if;

    If big_double < small_numeric Then 
        dbms_output.put_line(' big_double <  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double <  small_numeric false' );
    end if;

    If big_double > small_numeric Then 
        dbms_output.put_line(' big_double >  small_numeric true' );
    Else 
        dbms_output.put_line(' big_double >  small_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_numeric = ' || NVL(small_numeric,'NULL') );
    dbms_output.put_line('big_double = ' || NVL(big_double,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_numeric = big_double Then 
        dbms_output.put_line(' small_numeric =  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric =  big_double false' );
    end if;

    If small_numeric <=> big_double Then 
        dbms_output.put_line(' small_numeric <=>  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric <=>  big_double false' );
    end if;

    If small_numeric != big_double Then 
        dbms_output.put_line(' small_numeric !=  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric !=  big_double false' );
    end if;

    If small_numeric <= big_double Then 
        dbms_output.put_line(' small_numeric <=  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric <=  big_double false' );
    end if;

    If small_numeric >= big_double Then 
        dbms_output.put_line(' small_numeric >=  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric >=  big_double false' );
    end if;

    If small_numeric < big_double Then 
        dbms_output.put_line(' small_numeric <  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric <  big_double false' );
    end if;

    If small_numeric > big_double Then 
        dbms_output.put_line(' small_numeric >  big_double true' );
    Else 
        dbms_output.put_line(' small_numeric >  big_double false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_double_numeric('Comparison operation : double, numeric ' ) ; 

drop procedure t_double_numeric ; 



select 'This test is a case where an error is output.(not support, not created) ( t_date_numeric ) ' ; 
create or replace procedure t_date_numeric( tc_comment string ) as 
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
    If big_date = small_numeric Then 
        dbms_output.put_line(' big_date =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_date =  small_numeric false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_time_numeric ) ' ; 
create or replace procedure t_time_numeric( tc_comment string ) as 
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
    If big_time = small_numeric Then 
        dbms_output.put_line(' big_time =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_time =  small_numeric false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_datetime_numeric ) ' ; 
create or replace procedure t_datetime_numeric( tc_comment string ) as 
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
    If big_datetime = small_numeric Then 
        dbms_output.put_line(' big_datetime =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_datetime =  small_numeric false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_timestamp_numeric ) ' ; 
create or replace procedure t_timestamp_numeric( tc_comment string ) as 
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
    If big_timestamp = small_numeric Then 
        dbms_output.put_line(' big_timestamp =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_timestamp =  small_numeric false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_sys_refcursor_numeric ) ' ; 
create or replace procedure t_sys_refcursor_numeric( tc_comment string ) as 
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
    If big_sys_refcursor = small_numeric Then 
        dbms_output.put_line(' big_sys_refcursor =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_sys_refcursor =  small_numeric false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_cursor_numeric ) ' ; 
create or replace procedure t_cursor_numeric( tc_comment string ) as 
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
    If big_cursor = small_numeric Then 
        dbms_output.put_line(' big_cursor =  small_numeric true' );
    Else 
        dbms_output.put_line(' big_cursor =  small_numeric false' );
    end if;

end; 

--+ server-message off
