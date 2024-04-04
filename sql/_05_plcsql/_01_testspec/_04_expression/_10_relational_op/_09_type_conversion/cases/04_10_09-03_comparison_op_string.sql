--+ server-message on

select 'This test is a normal run case. ( t_null_string )' ;
create or replace procedure t_null_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_null = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If null = small_string Then 
        dbms_output.put_line(' null =  small_string true' );
    Else 
        dbms_output.put_line(' null =  small_string false' );
    end if;

    If null <=> small_string Then 
        dbms_output.put_line(' null <=>  small_string true' );
    Else 
        dbms_output.put_line(' null <=>  small_string false' );
    end if;

    If null != small_string Then 
        dbms_output.put_line(' null !=  small_string true' );
    Else 
        dbms_output.put_line(' null !=  small_string false' );
    end if;

    If null <= small_string Then 
        dbms_output.put_line(' null <=  small_string true' );
    Else 
        dbms_output.put_line(' null <=  small_string false' );
    end if;

    If null >= small_string Then 
        dbms_output.put_line(' null >=  small_string true' );
    Else 
        dbms_output.put_line(' null >=  small_string false' );
    end if;

    If null < small_string Then 
        dbms_output.put_line(' null <  small_string true' );
    Else 
        dbms_output.put_line(' null <  small_string false' );
    end if;

    If null > small_string Then 
        dbms_output.put_line(' null >  small_string true' );
    Else 
        dbms_output.put_line(' null >  small_string false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_null = ' || NVL(small_string_null,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string = null Then 
        dbms_output.put_line(' small_string =  null true' );
    Else 
        dbms_output.put_line(' small_string =  null false' );
    end if;

    If small_string <=> null Then 
        dbms_output.put_line(' small_string <=>  null true' );
    Else 
        dbms_output.put_line(' small_string <=>  null false' );
    end if;

    If small_string != null Then 
        dbms_output.put_line(' small_string !=  null true' );
    Else 
        dbms_output.put_line(' small_string !=  null false' );
    end if;

    If small_string <= null Then 
        dbms_output.put_line(' small_string <=  null true' );
    Else 
        dbms_output.put_line(' small_string <=  null false' );
    end if;

    If small_string >= null Then 
        dbms_output.put_line(' small_string >=  null true' );
    Else 
        dbms_output.put_line(' small_string >=  null false' );
    end if;

    If small_string < null Then 
        dbms_output.put_line(' small_string <  null true' );
    Else 
        dbms_output.put_line(' small_string <  null false' );
    end if;

    If small_string > null Then 
        dbms_output.put_line(' small_string >  null true' );
    Else 
        dbms_output.put_line(' small_string >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_null_string('Comparison operation : null, string ' ) ; 

drop procedure t_null_string ; 



select 'This test is a case where an error is output.(not support, not created) ( t_boolean_string ) ' ; 
create or replace procedure t_boolean_string( tc_comment string ) as 
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
    If big_boolean = small_string_boolean Then 
        dbms_output.put_line(' big_boolean =  small_string_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean =  small_string_boolean false' );
    end if;

end; 

select 'This test is a normal run case. ( t_string_string )' ;
create or replace procedure t_string_string( tc_comment string ) as 
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
    dbms_output.put_line('big_string = ' || NVL(big_string,'NULL') );
    dbms_output.put_line('small_string = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_string = small_string Then 
        dbms_output.put_line(' big_string =  small_string true' );
    Else 
        dbms_output.put_line(' big_string =  small_string false' );
    end if;

    If big_string <=> small_string Then 
        dbms_output.put_line(' big_string <=>  small_string true' );
    Else 
        dbms_output.put_line(' big_string <=>  small_string false' );
    end if;

    If big_string != small_string Then 
        dbms_output.put_line(' big_string !=  small_string true' );
    Else 
        dbms_output.put_line(' big_string !=  small_string false' );
    end if;

    If big_string <= small_string Then 
        dbms_output.put_line(' big_string <=  small_string true' );
    Else 
        dbms_output.put_line(' big_string <=  small_string false' );
    end if;

    If big_string >= small_string Then 
        dbms_output.put_line(' big_string >=  small_string true' );
    Else 
        dbms_output.put_line(' big_string >=  small_string false' );
    end if;

    If big_string < small_string Then 
        dbms_output.put_line(' big_string <  small_string true' );
    Else 
        dbms_output.put_line(' big_string <  small_string false' );
    end if;

    If big_string > small_string Then 
        dbms_output.put_line(' big_string >  small_string true' );
    Else 
        dbms_output.put_line(' big_string >  small_string false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('big_string = ' || NVL(big_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string = big_string Then 
        dbms_output.put_line(' small_string =  big_string true' );
    Else 
        dbms_output.put_line(' small_string =  big_string false' );
    end if;

    If small_string <=> big_string Then 
        dbms_output.put_line(' small_string <=>  big_string true' );
    Else 
        dbms_output.put_line(' small_string <=>  big_string false' );
    end if;

    If small_string != big_string Then 
        dbms_output.put_line(' small_string !=  big_string true' );
    Else 
        dbms_output.put_line(' small_string !=  big_string false' );
    end if;

    If small_string <= big_string Then 
        dbms_output.put_line(' small_string <=  big_string true' );
    Else 
        dbms_output.put_line(' small_string <=  big_string false' );
    end if;

    If small_string >= big_string Then 
        dbms_output.put_line(' small_string >=  big_string true' );
    Else 
        dbms_output.put_line(' small_string >=  big_string false' );
    end if;

    If small_string < big_string Then 
        dbms_output.put_line(' small_string <  big_string true' );
    Else 
        dbms_output.put_line(' small_string <  big_string false' );
    end if;

    If small_string > big_string Then 
        dbms_output.put_line(' small_string >  big_string true' );
    Else 
        dbms_output.put_line(' small_string >  big_string false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_string_string('Comparison operation : string, string ' ) ; 

drop procedure t_string_string ; 



select 'This test is a normal run case. ( t_short_string )' ;
create or replace procedure t_short_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_short = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_short = small_string_short Then 
        dbms_output.put_line(' big_short =  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short =  small_string_short false' );
    end if;

    If big_short <=> small_string_short Then 
        dbms_output.put_line(' big_short <=>  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short <=>  small_string_short false' );
    end if;

    If big_short != small_string_short Then 
        dbms_output.put_line(' big_short !=  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short !=  small_string_short false' );
    end if;

    If big_short <= small_string_short Then 
        dbms_output.put_line(' big_short <=  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short <=  small_string_short false' );
    end if;

    If big_short >= small_string_short Then 
        dbms_output.put_line(' big_short >=  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short >=  small_string_short false' );
    end if;

    If big_short < small_string_short Then 
        dbms_output.put_line(' big_short <  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short <  small_string_short false' );
    end if;

    If big_short > small_string_short Then 
        dbms_output.put_line(' big_short >  small_string_short true' );
    Else 
        dbms_output.put_line(' big_short >  small_string_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_short = ' || NVL(small_string_short,'NULL') );
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_short = big_short Then 
        dbms_output.put_line(' small_string_short =  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short =  big_short false' );
    end if;

    If small_string_short <=> big_short Then 
        dbms_output.put_line(' small_string_short <=>  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short <=>  big_short false' );
    end if;

    If small_string_short != big_short Then 
        dbms_output.put_line(' small_string_short !=  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short !=  big_short false' );
    end if;

    If small_string_short <= big_short Then 
        dbms_output.put_line(' small_string_short <=  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short <=  big_short false' );
    end if;

    If small_string_short >= big_short Then 
        dbms_output.put_line(' small_string_short >=  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short >=  big_short false' );
    end if;

    If small_string_short < big_short Then 
        dbms_output.put_line(' small_string_short <  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short <  big_short false' );
    end if;

    If small_string_short > big_short Then 
        dbms_output.put_line(' small_string_short >  big_short true' );
    Else 
        dbms_output.put_line(' small_string_short >  big_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_short_string('Comparison operation : short, string ' ) ; 

drop procedure t_short_string ; 



select 'This test is a normal run case. ( t_int_string )' ;
create or replace procedure t_int_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_int = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_int = small_string_int Then 
        dbms_output.put_line(' big_int =  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int =  small_string_int false' );
    end if;

    If big_int <=> small_string_int Then 
        dbms_output.put_line(' big_int <=>  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int <=>  small_string_int false' );
    end if;

    If big_int != small_string_int Then 
        dbms_output.put_line(' big_int !=  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int !=  small_string_int false' );
    end if;

    If big_int <= small_string_int Then 
        dbms_output.put_line(' big_int <=  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int <=  small_string_int false' );
    end if;

    If big_int >= small_string_int Then 
        dbms_output.put_line(' big_int >=  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int >=  small_string_int false' );
    end if;

    If big_int < small_string_int Then 
        dbms_output.put_line(' big_int <  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int <  small_string_int false' );
    end if;

    If big_int > small_string_int Then 
        dbms_output.put_line(' big_int >  small_string_int true' );
    Else 
        dbms_output.put_line(' big_int >  small_string_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_int = ' || NVL(small_string_int,'NULL') );
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_int = big_int Then 
        dbms_output.put_line(' small_string_int =  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int =  big_int false' );
    end if;

    If small_string_int <=> big_int Then 
        dbms_output.put_line(' small_string_int <=>  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int <=>  big_int false' );
    end if;

    If small_string_int != big_int Then 
        dbms_output.put_line(' small_string_int !=  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int !=  big_int false' );
    end if;

    If small_string_int <= big_int Then 
        dbms_output.put_line(' small_string_int <=  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int <=  big_int false' );
    end if;

    If small_string_int >= big_int Then 
        dbms_output.put_line(' small_string_int >=  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int >=  big_int false' );
    end if;

    If small_string_int < big_int Then 
        dbms_output.put_line(' small_string_int <  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int <  big_int false' );
    end if;

    If small_string_int > big_int Then 
        dbms_output.put_line(' small_string_int >  big_int true' );
    Else 
        dbms_output.put_line(' small_string_int >  big_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_int_string('Comparison operation : int, string ' ) ; 

drop procedure t_int_string ; 



select 'This test is a normal run case. ( t_bigint_string )' ;
create or replace procedure t_bigint_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_bigint = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_bigint = small_string_bigint Then 
        dbms_output.put_line(' big_bigint =  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint =  small_string_bigint false' );
    end if;

    If big_bigint <=> small_string_bigint Then 
        dbms_output.put_line(' big_bigint <=>  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint <=>  small_string_bigint false' );
    end if;

    If big_bigint != small_string_bigint Then 
        dbms_output.put_line(' big_bigint !=  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint !=  small_string_bigint false' );
    end if;

    If big_bigint <= small_string_bigint Then 
        dbms_output.put_line(' big_bigint <=  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint <=  small_string_bigint false' );
    end if;

    If big_bigint >= small_string_bigint Then 
        dbms_output.put_line(' big_bigint >=  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint >=  small_string_bigint false' );
    end if;

    If big_bigint < small_string_bigint Then 
        dbms_output.put_line(' big_bigint <  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint <  small_string_bigint false' );
    end if;

    If big_bigint > small_string_bigint Then 
        dbms_output.put_line(' big_bigint >  small_string_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint >  small_string_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_bigint = ' || NVL(small_string_bigint,'NULL') );
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_bigint = big_bigint Then 
        dbms_output.put_line(' small_string_bigint =  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint =  big_bigint false' );
    end if;

    If small_string_bigint <=> big_bigint Then 
        dbms_output.put_line(' small_string_bigint <=>  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint <=>  big_bigint false' );
    end if;

    If small_string_bigint != big_bigint Then 
        dbms_output.put_line(' small_string_bigint !=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint !=  big_bigint false' );
    end if;

    If small_string_bigint <= big_bigint Then 
        dbms_output.put_line(' small_string_bigint <=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint <=  big_bigint false' );
    end if;

    If small_string_bigint >= big_bigint Then 
        dbms_output.put_line(' small_string_bigint >=  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint >=  big_bigint false' );
    end if;

    If small_string_bigint < big_bigint Then 
        dbms_output.put_line(' small_string_bigint <  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint <  big_bigint false' );
    end if;

    If small_string_bigint > big_bigint Then 
        dbms_output.put_line(' small_string_bigint >  big_bigint true' );
    Else 
        dbms_output.put_line(' small_string_bigint >  big_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_bigint_string('Comparison operation : bigint, string ' ) ; 

drop procedure t_bigint_string ; 



select 'This test is a normal run case. ( t_numeric_string )' ;
create or replace procedure t_numeric_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_numeric = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_numeric = small_string_numeric Then 
        dbms_output.put_line(' big_numeric =  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric =  small_string_numeric false' );
    end if;

    If big_numeric <=> small_string_numeric Then 
        dbms_output.put_line(' big_numeric <=>  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <=>  small_string_numeric false' );
    end if;

    If big_numeric != small_string_numeric Then 
        dbms_output.put_line(' big_numeric !=  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric !=  small_string_numeric false' );
    end if;

    If big_numeric <= small_string_numeric Then 
        dbms_output.put_line(' big_numeric <=  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <=  small_string_numeric false' );
    end if;

    If big_numeric >= small_string_numeric Then 
        dbms_output.put_line(' big_numeric >=  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric >=  small_string_numeric false' );
    end if;

    If big_numeric < small_string_numeric Then 
        dbms_output.put_line(' big_numeric <  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <  small_string_numeric false' );
    end if;

    If big_numeric > small_string_numeric Then 
        dbms_output.put_line(' big_numeric >  small_string_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric >  small_string_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_numeric = ' || NVL(small_string_numeric,'NULL') );
    dbms_output.put_line('big_numeric = ' || NVL(big_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_numeric = big_numeric Then 
        dbms_output.put_line(' small_string_numeric =  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric =  big_numeric false' );
    end if;

    If small_string_numeric <=> big_numeric Then 
        dbms_output.put_line(' small_string_numeric <=>  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric <=>  big_numeric false' );
    end if;

    If small_string_numeric != big_numeric Then 
        dbms_output.put_line(' small_string_numeric !=  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric !=  big_numeric false' );
    end if;

    If small_string_numeric <= big_numeric Then 
        dbms_output.put_line(' small_string_numeric <=  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric <=  big_numeric false' );
    end if;

    If small_string_numeric >= big_numeric Then 
        dbms_output.put_line(' small_string_numeric >=  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric >=  big_numeric false' );
    end if;

    If small_string_numeric < big_numeric Then 
        dbms_output.put_line(' small_string_numeric <  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric <  big_numeric false' );
    end if;

    If small_string_numeric > big_numeric Then 
        dbms_output.put_line(' small_string_numeric >  big_numeric true' );
    Else 
        dbms_output.put_line(' small_string_numeric >  big_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_numeric_string('Comparison operation : numeric, string ' ) ; 

drop procedure t_numeric_string ; 



select 'This test is a normal run case. ( t_float_string )' ;
create or replace procedure t_float_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_float = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_float = small_string_float Then 
        dbms_output.put_line(' big_float =  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float =  small_string_float false' );
    end if;

    If big_float <=> small_string_float Then 
        dbms_output.put_line(' big_float <=>  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float <=>  small_string_float false' );
    end if;

    If big_float != small_string_float Then 
        dbms_output.put_line(' big_float !=  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float !=  small_string_float false' );
    end if;

    If big_float <= small_string_float Then 
        dbms_output.put_line(' big_float <=  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float <=  small_string_float false' );
    end if;

    If big_float >= small_string_float Then 
        dbms_output.put_line(' big_float >=  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float >=  small_string_float false' );
    end if;

    If big_float < small_string_float Then 
        dbms_output.put_line(' big_float <  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float <  small_string_float false' );
    end if;

    If big_float > small_string_float Then 
        dbms_output.put_line(' big_float >  small_string_float true' );
    Else 
        dbms_output.put_line(' big_float >  small_string_float false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_float = ' || NVL(small_string_float,'NULL') );
    dbms_output.put_line('big_float = ' || NVL(big_float,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_float = big_float Then 
        dbms_output.put_line(' small_string_float =  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float =  big_float false' );
    end if;

    If small_string_float <=> big_float Then 
        dbms_output.put_line(' small_string_float <=>  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float <=>  big_float false' );
    end if;

    If small_string_float != big_float Then 
        dbms_output.put_line(' small_string_float !=  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float !=  big_float false' );
    end if;

    If small_string_float <= big_float Then 
        dbms_output.put_line(' small_string_float <=  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float <=  big_float false' );
    end if;

    If small_string_float >= big_float Then 
        dbms_output.put_line(' small_string_float >=  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float >=  big_float false' );
    end if;

    If small_string_float < big_float Then 
        dbms_output.put_line(' small_string_float <  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float <  big_float false' );
    end if;

    If small_string_float > big_float Then 
        dbms_output.put_line(' small_string_float >  big_float true' );
    Else 
        dbms_output.put_line(' small_string_float >  big_float false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_float_string('Comparison operation : float, string ' ) ; 

drop procedure t_float_string ; 



select 'This test is a normal run case. ( t_double_string )' ;
create or replace procedure t_double_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_double = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_double = small_string_double Then 
        dbms_output.put_line(' big_double =  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double =  small_string_double false' );
    end if;

    If big_double <=> small_string_double Then 
        dbms_output.put_line(' big_double <=>  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double <=>  small_string_double false' );
    end if;

    If big_double != small_string_double Then 
        dbms_output.put_line(' big_double !=  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double !=  small_string_double false' );
    end if;

    If big_double <= small_string_double Then 
        dbms_output.put_line(' big_double <=  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double <=  small_string_double false' );
    end if;

    If big_double >= small_string_double Then 
        dbms_output.put_line(' big_double >=  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double >=  small_string_double false' );
    end if;

    If big_double < small_string_double Then 
        dbms_output.put_line(' big_double <  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double <  small_string_double false' );
    end if;

    If big_double > small_string_double Then 
        dbms_output.put_line(' big_double >  small_string_double true' );
    Else 
        dbms_output.put_line(' big_double >  small_string_double false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_double = ' || NVL(small_string_double,'NULL') );
    dbms_output.put_line('big_double = ' || NVL(big_double,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_double = big_double Then 
        dbms_output.put_line(' small_string_double =  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double =  big_double false' );
    end if;

    If small_string_double <=> big_double Then 
        dbms_output.put_line(' small_string_double <=>  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double <=>  big_double false' );
    end if;

    If small_string_double != big_double Then 
        dbms_output.put_line(' small_string_double !=  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double !=  big_double false' );
    end if;

    If small_string_double <= big_double Then 
        dbms_output.put_line(' small_string_double <=  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double <=  big_double false' );
    end if;

    If small_string_double >= big_double Then 
        dbms_output.put_line(' small_string_double >=  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double >=  big_double false' );
    end if;

    If small_string_double < big_double Then 
        dbms_output.put_line(' small_string_double <  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double <  big_double false' );
    end if;

    If small_string_double > big_double Then 
        dbms_output.put_line(' small_string_double >  big_double true' );
    Else 
        dbms_output.put_line(' small_string_double >  big_double false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_double_string('Comparison operation : double, string ' ) ; 

drop procedure t_double_string ; 



select 'This test is a normal run case. ( t_date_string )' ;
create or replace procedure t_date_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_date = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_date = small_string_date Then 
        dbms_output.put_line(' big_date =  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date =  small_string_date false' );
    end if;

    If big_date <=> small_string_date Then 
        dbms_output.put_line(' big_date <=>  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date <=>  small_string_date false' );
    end if;

    If big_date != small_string_date Then 
        dbms_output.put_line(' big_date !=  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date !=  small_string_date false' );
    end if;

    If big_date <= small_string_date Then 
        dbms_output.put_line(' big_date <=  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date <=  small_string_date false' );
    end if;

    If big_date >= small_string_date Then 
        dbms_output.put_line(' big_date >=  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date >=  small_string_date false' );
    end if;

    If big_date < small_string_date Then 
        dbms_output.put_line(' big_date <  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date <  small_string_date false' );
    end if;

    If big_date > small_string_date Then 
        dbms_output.put_line(' big_date >  small_string_date true' );
    Else 
        dbms_output.put_line(' big_date >  small_string_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_date = ' || NVL(small_string_date,'NULL') );
    dbms_output.put_line('big_date = ' || NVL(big_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_date = big_date Then 
        dbms_output.put_line(' small_string_date =  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date =  big_date false' );
    end if;

    If small_string_date <=> big_date Then 
        dbms_output.put_line(' small_string_date <=>  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date <=>  big_date false' );
    end if;

    If small_string_date != big_date Then 
        dbms_output.put_line(' small_string_date !=  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date !=  big_date false' );
    end if;

    If small_string_date <= big_date Then 
        dbms_output.put_line(' small_string_date <=  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date <=  big_date false' );
    end if;

    If small_string_date >= big_date Then 
        dbms_output.put_line(' small_string_date >=  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date >=  big_date false' );
    end if;

    If small_string_date < big_date Then 
        dbms_output.put_line(' small_string_date <  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date <  big_date false' );
    end if;

    If small_string_date > big_date Then 
        dbms_output.put_line(' small_string_date >  big_date true' );
    Else 
        dbms_output.put_line(' small_string_date >  big_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_date_string('Comparison operation : date, string ' ) ; 

drop procedure t_date_string ; 



select 'This test is a normal run case. ( t_time_string )' ;
create or replace procedure t_time_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_time = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_time = small_string_time Then 
        dbms_output.put_line(' big_time =  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time =  small_string_time false' );
    end if;

    If big_time <=> small_string_time Then 
        dbms_output.put_line(' big_time <=>  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time <=>  small_string_time false' );
    end if;

    If big_time != small_string_time Then 
        dbms_output.put_line(' big_time !=  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time !=  small_string_time false' );
    end if;

    If big_time <= small_string_time Then 
        dbms_output.put_line(' big_time <=  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time <=  small_string_time false' );
    end if;

    If big_time >= small_string_time Then 
        dbms_output.put_line(' big_time >=  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time >=  small_string_time false' );
    end if;

    If big_time < small_string_time Then 
        dbms_output.put_line(' big_time <  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time <  small_string_time false' );
    end if;

    If big_time > small_string_time Then 
        dbms_output.put_line(' big_time >  small_string_time true' );
    Else 
        dbms_output.put_line(' big_time >  small_string_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_time = ' || NVL(small_string_time,'NULL') );
    dbms_output.put_line('big_time = ' || NVL(big_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_time = big_time Then 
        dbms_output.put_line(' small_string_time =  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time =  big_time false' );
    end if;

    If small_string_time <=> big_time Then 
        dbms_output.put_line(' small_string_time <=>  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time <=>  big_time false' );
    end if;

    If small_string_time != big_time Then 
        dbms_output.put_line(' small_string_time !=  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time !=  big_time false' );
    end if;

    If small_string_time <= big_time Then 
        dbms_output.put_line(' small_string_time <=  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time <=  big_time false' );
    end if;

    If small_string_time >= big_time Then 
        dbms_output.put_line(' small_string_time >=  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time >=  big_time false' );
    end if;

    If small_string_time < big_time Then 
        dbms_output.put_line(' small_string_time <  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time <  big_time false' );
    end if;

    If small_string_time > big_time Then 
        dbms_output.put_line(' small_string_time >  big_time true' );
    Else 
        dbms_output.put_line(' small_string_time >  big_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_time_string('Comparison operation : time, string ' ) ; 

drop procedure t_time_string ; 



select 'This test is a normal run case. ( t_datetime_string )' ;
create or replace procedure t_datetime_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_datetime = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_datetime = small_string_datetime Then 
        dbms_output.put_line(' big_datetime =  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime =  small_string_datetime false' );
    end if;

    If big_datetime <=> small_string_datetime Then 
        dbms_output.put_line(' big_datetime <=>  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime <=>  small_string_datetime false' );
    end if;

    If big_datetime != small_string_datetime Then 
        dbms_output.put_line(' big_datetime !=  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime !=  small_string_datetime false' );
    end if;

    If big_datetime <= small_string_datetime Then 
        dbms_output.put_line(' big_datetime <=  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime <=  small_string_datetime false' );
    end if;

    If big_datetime >= small_string_datetime Then 
        dbms_output.put_line(' big_datetime >=  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime >=  small_string_datetime false' );
    end if;

    If big_datetime < small_string_datetime Then 
        dbms_output.put_line(' big_datetime <  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime <  small_string_datetime false' );
    end if;

    If big_datetime > small_string_datetime Then 
        dbms_output.put_line(' big_datetime >  small_string_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime >  small_string_datetime false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_datetime = ' || NVL(small_string_datetime,'NULL') );
    dbms_output.put_line('big_datetime = ' || NVL(big_datetime,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_datetime = big_datetime Then 
        dbms_output.put_line(' small_string_datetime =  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime =  big_datetime false' );
    end if;

    If small_string_datetime <=> big_datetime Then 
        dbms_output.put_line(' small_string_datetime <=>  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime <=>  big_datetime false' );
    end if;

    If small_string_datetime != big_datetime Then 
        dbms_output.put_line(' small_string_datetime !=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime !=  big_datetime false' );
    end if;

    If small_string_datetime <= big_datetime Then 
        dbms_output.put_line(' small_string_datetime <=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime <=  big_datetime false' );
    end if;

    If small_string_datetime >= big_datetime Then 
        dbms_output.put_line(' small_string_datetime >=  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime >=  big_datetime false' );
    end if;

    If small_string_datetime < big_datetime Then 
        dbms_output.put_line(' small_string_datetime <  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime <  big_datetime false' );
    end if;

    If small_string_datetime > big_datetime Then 
        dbms_output.put_line(' small_string_datetime >  big_datetime true' );
    Else 
        dbms_output.put_line(' small_string_datetime >  big_datetime false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_datetime_string('Comparison operation : datetime, string ' ) ; 

drop procedure t_datetime_string ; 



select 'This test is a normal run case. ( t_timestamp_string )' ;
create or replace procedure t_timestamp_string( tc_comment string ) as 
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
    dbms_output.put_line('small_string_timestamp = ' || NVL(small_string,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_timestamp = small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp =  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp =  small_string_timestamp false' );
    end if;

    If big_timestamp <=> small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp <=>  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <=>  small_string_timestamp false' );
    end if;

    If big_timestamp != small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp !=  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp !=  small_string_timestamp false' );
    end if;

    If big_timestamp <= small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp <=  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <=  small_string_timestamp false' );
    end if;

    If big_timestamp >= small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp >=  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp >=  small_string_timestamp false' );
    end if;

    If big_timestamp < small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp <  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <  small_string_timestamp false' );
    end if;

    If big_timestamp > small_string_timestamp Then 
        dbms_output.put_line(' big_timestamp >  small_string_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp >  small_string_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('small_string_timestamp = ' || NVL(small_string_timestamp,'NULL') );
    dbms_output.put_line('big_timestamp = ' || NVL(big_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If small_string_timestamp = big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp =  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp =  big_timestamp false' );
    end if;

    If small_string_timestamp <=> big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp <=>  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp <=>  big_timestamp false' );
    end if;

    If small_string_timestamp != big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp !=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp !=  big_timestamp false' );
    end if;

    If small_string_timestamp <= big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp <=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp <=  big_timestamp false' );
    end if;

    If small_string_timestamp >= big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp >=  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp >=  big_timestamp false' );
    end if;

    If small_string_timestamp < big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp <  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp <  big_timestamp false' );
    end if;

    If small_string_timestamp > big_timestamp Then 
        dbms_output.put_line(' small_string_timestamp >  big_timestamp true' );
    Else 
        dbms_output.put_line(' small_string_timestamp >  big_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_timestamp_string('Comparison operation : timestamp, string ' ) ; 

drop procedure t_timestamp_string ; 



select 'This test is a case where an error is output.(not support, not created) ( t_sys_refcursor_string ) ' ; 
create or replace procedure t_sys_refcursor_string( tc_comment string ) as 
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
    If big_sys_refcursor = small_string Then 
        dbms_output.put_line(' big_sys_refcursor =  small_string true' );
    Else 
        dbms_output.put_line(' big_sys_refcursor =  small_string false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_cursor_string ) ' ; 
create or replace procedure t_cursor_string( tc_comment string ) as 
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
    If big_cursor = small_string Then 
        dbms_output.put_line(' big_cursor =  small_string true' );
    Else 
        dbms_output.put_line(' big_cursor =  small_string false' );
    end if;

end; 

--+ server-message off
