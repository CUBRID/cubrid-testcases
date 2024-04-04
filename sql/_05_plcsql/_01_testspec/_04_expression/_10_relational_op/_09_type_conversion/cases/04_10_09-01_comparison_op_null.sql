--+ server-message on

select 'This test is a normal run case. ( t_null_null )' ;
create or replace procedure t_null_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If null = null Then 
        dbms_output.put_line(' null =  null true' );
    Else 
        dbms_output.put_line(' null =  null false' );
    end if;

    If null <=> null Then 
        dbms_output.put_line(' null <=>  null true' );
    Else 
        dbms_output.put_line(' null <=>  null false' );
    end if;

    If null != null Then 
        dbms_output.put_line(' null !=  null true' );
    Else 
        dbms_output.put_line(' null !=  null false' );
    end if;

    If null <= null Then 
        dbms_output.put_line(' null <=  null true' );
    Else 
        dbms_output.put_line(' null <=  null false' );
    end if;

    If null >= null Then 
        dbms_output.put_line(' null >=  null true' );
    Else 
        dbms_output.put_line(' null >=  null false' );
    end if;

    If null < null Then 
        dbms_output.put_line(' null <  null true' );
    Else 
        dbms_output.put_line(' null <  null false' );
    end if;

    If null > null Then 
        dbms_output.put_line(' null >  null true' );
    Else 
        dbms_output.put_line(' null >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = null Then 
        dbms_output.put_line(' null =  null true' );
    Else 
        dbms_output.put_line(' null =  null false' );
    end if;

    If null <=> null Then 
        dbms_output.put_line(' null <=>  null true' );
    Else 
        dbms_output.put_line(' null <=>  null false' );
    end if;

    If null != null Then 
        dbms_output.put_line(' null !=  null true' );
    Else 
        dbms_output.put_line(' null !=  null false' );
    end if;

    If null <= null Then 
        dbms_output.put_line(' null <=  null true' );
    Else 
        dbms_output.put_line(' null <=  null false' );
    end if;

    If null >= null Then 
        dbms_output.put_line(' null >=  null true' );
    Else 
        dbms_output.put_line(' null >=  null false' );
    end if;

    If null < null Then 
        dbms_output.put_line(' null <  null true' );
    Else 
        dbms_output.put_line(' null <  null false' );
    end if;

    If null > null Then 
        dbms_output.put_line(' null >  null true' );
    Else 
        dbms_output.put_line(' null >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = null Then 
        dbms_output.put_line(' null =  null true' );
    Else 
        dbms_output.put_line(' null =  null false' );
    end if;

    If null <=> null Then 
        dbms_output.put_line(' null <=>  null true' );
    Else 
        dbms_output.put_line(' null <=>  null false' );
    end if;

    If null != null Then 
        dbms_output.put_line(' null !=  null true' );
    Else 
        dbms_output.put_line(' null !=  null false' );
    end if;

    If null <= null Then 
        dbms_output.put_line(' null <=  null true' );
    Else 
        dbms_output.put_line(' null <=  null false' );
    end if;

    If null >= null Then 
        dbms_output.put_line(' null >=  null true' );
    Else 
        dbms_output.put_line(' null >=  null false' );
    end if;

    If null < null Then 
        dbms_output.put_line(' null <  null true' );
    Else 
        dbms_output.put_line(' null <  null false' );
    end if;

    If null > null Then 
        dbms_output.put_line(' null >  null true' );
    Else 
        dbms_output.put_line(' null >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_null_null('Comparison operation : null, null ' ) ; 

drop procedure t_null_null ; 



select 'This test is a normal run case. ( t_boolean_null )' ;
create or replace procedure t_boolean_null( tc_comment string ) as 
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
    dbms_output.put_line('big_boolean = ' || 'TRUE' );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_boolean = null Then 
        dbms_output.put_line(' big_boolean =  null true' );
    Else 
        dbms_output.put_line(' big_boolean =  null false' );
    end if;

    If big_boolean <=> null Then 
        dbms_output.put_line(' big_boolean <=>  null true' );
    Else 
        dbms_output.put_line(' big_boolean <=>  null false' );
    end if;

    If big_boolean != null Then 
        dbms_output.put_line(' big_boolean !=  null true' );
    Else 
        dbms_output.put_line(' big_boolean !=  null false' );
    end if;

    If big_boolean <= null Then 
        dbms_output.put_line(' big_boolean <=  null true' );
    Else 
        dbms_output.put_line(' big_boolean <=  null false' );
    end if;

    If big_boolean >= null Then 
        dbms_output.put_line(' big_boolean >=  null true' );
    Else 
        dbms_output.put_line(' big_boolean >=  null false' );
    end if;

    If big_boolean < null Then 
        dbms_output.put_line(' big_boolean <  null true' );
    Else 
        dbms_output.put_line(' big_boolean <  null false' );
    end if;

    If big_boolean > null Then 
        dbms_output.put_line(' big_boolean >  null true' );
    Else 
        dbms_output.put_line(' big_boolean >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_boolean = ' || 'TRUE' );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_boolean Then 
        dbms_output.put_line(' null =  big_boolean true' );
    Else 
        dbms_output.put_line(' null =  big_boolean false' );
    end if;

    If null <=> big_boolean Then 
        dbms_output.put_line(' null <=>  big_boolean true' );
    Else 
        dbms_output.put_line(' null <=>  big_boolean false' );
    end if;

    If null != big_boolean Then 
        dbms_output.put_line(' null !=  big_boolean true' );
    Else 
        dbms_output.put_line(' null !=  big_boolean false' );
    end if;

    If null <= big_boolean Then 
        dbms_output.put_line(' null <=  big_boolean true' );
    Else 
        dbms_output.put_line(' null <=  big_boolean false' );
    end if;

    If null >= big_boolean Then 
        dbms_output.put_line(' null >=  big_boolean true' );
    Else 
        dbms_output.put_line(' null >=  big_boolean false' );
    end if;

    If null < big_boolean Then 
        dbms_output.put_line(' null <  big_boolean true' );
    Else 
        dbms_output.put_line(' null <  big_boolean false' );
    end if;

    If null > big_boolean Then 
        dbms_output.put_line(' null >  big_boolean true' );
    Else 
        dbms_output.put_line(' null >  big_boolean false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_boolean = ' || 'TRUE' );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_boolean = big_boolean Then 
        dbms_output.put_line(' big_boolean =  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean =  big_boolean false' );
    end if;

    If big_boolean <=> big_boolean Then 
        dbms_output.put_line(' big_boolean <=>  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean <=>  big_boolean false' );
    end if;

    If big_boolean != big_boolean Then 
        dbms_output.put_line(' big_boolean !=  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean !=  big_boolean false' );
    end if;

    If big_boolean <= big_boolean Then 
        dbms_output.put_line(' big_boolean <=  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean <=  big_boolean false' );
    end if;

    If big_boolean >= big_boolean Then 
        dbms_output.put_line(' big_boolean >=  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean >=  big_boolean false' );
    end if;

    If big_boolean < big_boolean Then 
        dbms_output.put_line(' big_boolean <  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean <  big_boolean false' );
    end if;

    If big_boolean > big_boolean Then 
        dbms_output.put_line(' big_boolean >  big_boolean true' );
    Else 
        dbms_output.put_line(' big_boolean >  big_boolean false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_boolean_null('Comparison operation : boolean, null ' ) ; 

drop procedure t_boolean_null ; 



select 'This test is a normal run case. ( t_string_null )' ;
create or replace procedure t_string_null( tc_comment string ) as 
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
    dbms_output.put_line('big_string_null = ' || NVL(big_string_null,'NULL') );
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_string = null Then 
        dbms_output.put_line(' big_string =  null true' );
    Else 
        dbms_output.put_line(' big_string =  null false' );
    end if;

    If big_string <=> null Then 
        dbms_output.put_line(' big_string <=>  null true' );
    Else 
        dbms_output.put_line(' big_string <=>  null false' );
    end if;

    If big_string != null Then 
        dbms_output.put_line(' big_string !=  null true' );
    Else 
        dbms_output.put_line(' big_string !=  null false' );
    end if;

    If big_string <= null Then 
        dbms_output.put_line(' big_string <=  null true' );
    Else 
        dbms_output.put_line(' big_string <=  null false' );
    end if;

    If big_string >= null Then 
        dbms_output.put_line(' big_string >=  null true' );
    Else 
        dbms_output.put_line(' big_string >=  null false' );
    end if;

    If big_string < null Then 
        dbms_output.put_line(' big_string <  null true' );
    Else 
        dbms_output.put_line(' big_string <  null false' );
    end if;

    If big_string > null Then 
        dbms_output.put_line(' big_string >  null true' );
    Else 
        dbms_output.put_line(' big_string >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_string_null = ' || NVL(big_string_null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_string Then 
        dbms_output.put_line(' null =  big_string true' );
    Else 
        dbms_output.put_line(' null =  big_string false' );
    end if;

    If null <=> big_string Then 
        dbms_output.put_line(' null <=>  big_string true' );
    Else 
        dbms_output.put_line(' null <=>  big_string false' );
    end if;

    If null != big_string Then 
        dbms_output.put_line(' null !=  big_string true' );
    Else 
        dbms_output.put_line(' null !=  big_string false' );
    end if;

    If null <= big_string Then 
        dbms_output.put_line(' null <=  big_string true' );
    Else 
        dbms_output.put_line(' null <=  big_string false' );
    end if;

    If null >= big_string Then 
        dbms_output.put_line(' null >=  big_string true' );
    Else 
        dbms_output.put_line(' null >=  big_string false' );
    end if;

    If null < big_string Then 
        dbms_output.put_line(' null <  big_string true' );
    Else 
        dbms_output.put_line(' null <  big_string false' );
    end if;

    If null > big_string Then 
        dbms_output.put_line(' null >  big_string true' );
    Else 
        dbms_output.put_line(' null >  big_string false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_string_null = ' || NVL(big_string_null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_string = big_string Then 
        dbms_output.put_line(' big_string =  big_string true' );
    Else 
        dbms_output.put_line(' big_string =  big_string false' );
    end if;

    If big_string <=> big_string Then 
        dbms_output.put_line(' big_string <=>  big_string true' );
    Else 
        dbms_output.put_line(' big_string <=>  big_string false' );
    end if;

    If big_string != big_string Then 
        dbms_output.put_line(' big_string !=  big_string true' );
    Else 
        dbms_output.put_line(' big_string !=  big_string false' );
    end if;

    If big_string <= big_string Then 
        dbms_output.put_line(' big_string <=  big_string true' );
    Else 
        dbms_output.put_line(' big_string <=  big_string false' );
    end if;

    If big_string >= big_string Then 
        dbms_output.put_line(' big_string >=  big_string true' );
    Else 
        dbms_output.put_line(' big_string >=  big_string false' );
    end if;

    If big_string < big_string Then 
        dbms_output.put_line(' big_string <  big_string true' );
    Else 
        dbms_output.put_line(' big_string <  big_string false' );
    end if;

    If big_string > big_string Then 
        dbms_output.put_line(' big_string >  big_string true' );
    Else 
        dbms_output.put_line(' big_string >  big_string false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_string_null('Comparison operation : string, null ' ) ; 

drop procedure t_string_null ; 



select 'This test is a normal run case. ( t_short_null )' ;
create or replace procedure t_short_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_short = null Then 
        dbms_output.put_line(' big_short =  null true' );
    Else 
        dbms_output.put_line(' big_short =  null false' );
    end if;

    If big_short <=> null Then 
        dbms_output.put_line(' big_short <=>  null true' );
    Else 
        dbms_output.put_line(' big_short <=>  null false' );
    end if;

    If big_short != null Then 
        dbms_output.put_line(' big_short !=  null true' );
    Else 
        dbms_output.put_line(' big_short !=  null false' );
    end if;

    If big_short <= null Then 
        dbms_output.put_line(' big_short <=  null true' );
    Else 
        dbms_output.put_line(' big_short <=  null false' );
    end if;

    If big_short >= null Then 
        dbms_output.put_line(' big_short >=  null true' );
    Else 
        dbms_output.put_line(' big_short >=  null false' );
    end if;

    If big_short < null Then 
        dbms_output.put_line(' big_short <  null true' );
    Else 
        dbms_output.put_line(' big_short <  null false' );
    end if;

    If big_short > null Then 
        dbms_output.put_line(' big_short >  null true' );
    Else 
        dbms_output.put_line(' big_short >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_short Then 
        dbms_output.put_line(' null =  big_short true' );
    Else 
        dbms_output.put_line(' null =  big_short false' );
    end if;

    If null <=> big_short Then 
        dbms_output.put_line(' null <=>  big_short true' );
    Else 
        dbms_output.put_line(' null <=>  big_short false' );
    end if;

    If null != big_short Then 
        dbms_output.put_line(' null !=  big_short true' );
    Else 
        dbms_output.put_line(' null !=  big_short false' );
    end if;

    If null <= big_short Then 
        dbms_output.put_line(' null <=  big_short true' );
    Else 
        dbms_output.put_line(' null <=  big_short false' );
    end if;

    If null >= big_short Then 
        dbms_output.put_line(' null >=  big_short true' );
    Else 
        dbms_output.put_line(' null >=  big_short false' );
    end if;

    If null < big_short Then 
        dbms_output.put_line(' null <  big_short true' );
    Else 
        dbms_output.put_line(' null <  big_short false' );
    end if;

    If null > big_short Then 
        dbms_output.put_line(' null >  big_short true' );
    Else 
        dbms_output.put_line(' null >  big_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_short = ' || NVL(big_short,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_short = big_short Then 
        dbms_output.put_line(' big_short =  big_short true' );
    Else 
        dbms_output.put_line(' big_short =  big_short false' );
    end if;

    If big_short <=> big_short Then 
        dbms_output.put_line(' big_short <=>  big_short true' );
    Else 
        dbms_output.put_line(' big_short <=>  big_short false' );
    end if;

    If big_short != big_short Then 
        dbms_output.put_line(' big_short !=  big_short true' );
    Else 
        dbms_output.put_line(' big_short !=  big_short false' );
    end if;

    If big_short <= big_short Then 
        dbms_output.put_line(' big_short <=  big_short true' );
    Else 
        dbms_output.put_line(' big_short <=  big_short false' );
    end if;

    If big_short >= big_short Then 
        dbms_output.put_line(' big_short >=  big_short true' );
    Else 
        dbms_output.put_line(' big_short >=  big_short false' );
    end if;

    If big_short < big_short Then 
        dbms_output.put_line(' big_short <  big_short true' );
    Else 
        dbms_output.put_line(' big_short <  big_short false' );
    end if;

    If big_short > big_short Then 
        dbms_output.put_line(' big_short >  big_short true' );
    Else 
        dbms_output.put_line(' big_short >  big_short false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_short_null('Comparison operation : short, null ' ) ; 

drop procedure t_short_null ; 



select 'This test is a normal run case. ( t_int_null )' ;
create or replace procedure t_int_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_int = null Then 
        dbms_output.put_line(' big_int =  null true' );
    Else 
        dbms_output.put_line(' big_int =  null false' );
    end if;

    If big_int <=> null Then 
        dbms_output.put_line(' big_int <=>  null true' );
    Else 
        dbms_output.put_line(' big_int <=>  null false' );
    end if;

    If big_int != null Then 
        dbms_output.put_line(' big_int !=  null true' );
    Else 
        dbms_output.put_line(' big_int !=  null false' );
    end if;

    If big_int <= null Then 
        dbms_output.put_line(' big_int <=  null true' );
    Else 
        dbms_output.put_line(' big_int <=  null false' );
    end if;

    If big_int >= null Then 
        dbms_output.put_line(' big_int >=  null true' );
    Else 
        dbms_output.put_line(' big_int >=  null false' );
    end if;

    If big_int < null Then 
        dbms_output.put_line(' big_int <  null true' );
    Else 
        dbms_output.put_line(' big_int <  null false' );
    end if;

    If big_int > null Then 
        dbms_output.put_line(' big_int >  null true' );
    Else 
        dbms_output.put_line(' big_int >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_int Then 
        dbms_output.put_line(' null =  big_int true' );
    Else 
        dbms_output.put_line(' null =  big_int false' );
    end if;

    If null <=> big_int Then 
        dbms_output.put_line(' null <=>  big_int true' );
    Else 
        dbms_output.put_line(' null <=>  big_int false' );
    end if;

    If null != big_int Then 
        dbms_output.put_line(' null !=  big_int true' );
    Else 
        dbms_output.put_line(' null !=  big_int false' );
    end if;

    If null <= big_int Then 
        dbms_output.put_line(' null <=  big_int true' );
    Else 
        dbms_output.put_line(' null <=  big_int false' );
    end if;

    If null >= big_int Then 
        dbms_output.put_line(' null >=  big_int true' );
    Else 
        dbms_output.put_line(' null >=  big_int false' );
    end if;

    If null < big_int Then 
        dbms_output.put_line(' null <  big_int true' );
    Else 
        dbms_output.put_line(' null <  big_int false' );
    end if;

    If null > big_int Then 
        dbms_output.put_line(' null >  big_int true' );
    Else 
        dbms_output.put_line(' null >  big_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_int = ' || NVL(big_int,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_int = big_int Then 
        dbms_output.put_line(' big_int =  big_int true' );
    Else 
        dbms_output.put_line(' big_int =  big_int false' );
    end if;

    If big_int <=> big_int Then 
        dbms_output.put_line(' big_int <=>  big_int true' );
    Else 
        dbms_output.put_line(' big_int <=>  big_int false' );
    end if;

    If big_int != big_int Then 
        dbms_output.put_line(' big_int !=  big_int true' );
    Else 
        dbms_output.put_line(' big_int !=  big_int false' );
    end if;

    If big_int <= big_int Then 
        dbms_output.put_line(' big_int <=  big_int true' );
    Else 
        dbms_output.put_line(' big_int <=  big_int false' );
    end if;

    If big_int >= big_int Then 
        dbms_output.put_line(' big_int >=  big_int true' );
    Else 
        dbms_output.put_line(' big_int >=  big_int false' );
    end if;

    If big_int < big_int Then 
        dbms_output.put_line(' big_int <  big_int true' );
    Else 
        dbms_output.put_line(' big_int <  big_int false' );
    end if;

    If big_int > big_int Then 
        dbms_output.put_line(' big_int >  big_int true' );
    Else 
        dbms_output.put_line(' big_int >  big_int false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_int_null('Comparison operation : int, null ' ) ; 

drop procedure t_int_null ; 



select 'This test is a normal run case. ( t_bigint_null )' ;
create or replace procedure t_bigint_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_bigint = null Then 
        dbms_output.put_line(' big_bigint =  null true' );
    Else 
        dbms_output.put_line(' big_bigint =  null false' );
    end if;

    If big_bigint <=> null Then 
        dbms_output.put_line(' big_bigint <=>  null true' );
    Else 
        dbms_output.put_line(' big_bigint <=>  null false' );
    end if;

    If big_bigint != null Then 
        dbms_output.put_line(' big_bigint !=  null true' );
    Else 
        dbms_output.put_line(' big_bigint !=  null false' );
    end if;

    If big_bigint <= null Then 
        dbms_output.put_line(' big_bigint <=  null true' );
    Else 
        dbms_output.put_line(' big_bigint <=  null false' );
    end if;

    If big_bigint >= null Then 
        dbms_output.put_line(' big_bigint >=  null true' );
    Else 
        dbms_output.put_line(' big_bigint >=  null false' );
    end if;

    If big_bigint < null Then 
        dbms_output.put_line(' big_bigint <  null true' );
    Else 
        dbms_output.put_line(' big_bigint <  null false' );
    end if;

    If big_bigint > null Then 
        dbms_output.put_line(' big_bigint >  null true' );
    Else 
        dbms_output.put_line(' big_bigint >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_bigint Then 
        dbms_output.put_line(' null =  big_bigint true' );
    Else 
        dbms_output.put_line(' null =  big_bigint false' );
    end if;

    If null <=> big_bigint Then 
        dbms_output.put_line(' null <=>  big_bigint true' );
    Else 
        dbms_output.put_line(' null <=>  big_bigint false' );
    end if;

    If null != big_bigint Then 
        dbms_output.put_line(' null !=  big_bigint true' );
    Else 
        dbms_output.put_line(' null !=  big_bigint false' );
    end if;

    If null <= big_bigint Then 
        dbms_output.put_line(' null <=  big_bigint true' );
    Else 
        dbms_output.put_line(' null <=  big_bigint false' );
    end if;

    If null >= big_bigint Then 
        dbms_output.put_line(' null >=  big_bigint true' );
    Else 
        dbms_output.put_line(' null >=  big_bigint false' );
    end if;

    If null < big_bigint Then 
        dbms_output.put_line(' null <  big_bigint true' );
    Else 
        dbms_output.put_line(' null <  big_bigint false' );
    end if;

    If null > big_bigint Then 
        dbms_output.put_line(' null >  big_bigint true' );
    Else 
        dbms_output.put_line(' null >  big_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_bigint = ' || NVL(big_bigint,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_bigint = big_bigint Then 
        dbms_output.put_line(' big_bigint =  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint =  big_bigint false' );
    end if;

    If big_bigint <=> big_bigint Then 
        dbms_output.put_line(' big_bigint <=>  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint <=>  big_bigint false' );
    end if;

    If big_bigint != big_bigint Then 
        dbms_output.put_line(' big_bigint !=  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint !=  big_bigint false' );
    end if;

    If big_bigint <= big_bigint Then 
        dbms_output.put_line(' big_bigint <=  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint <=  big_bigint false' );
    end if;

    If big_bigint >= big_bigint Then 
        dbms_output.put_line(' big_bigint >=  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint >=  big_bigint false' );
    end if;

    If big_bigint < big_bigint Then 
        dbms_output.put_line(' big_bigint <  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint <  big_bigint false' );
    end if;

    If big_bigint > big_bigint Then 
        dbms_output.put_line(' big_bigint >  big_bigint true' );
    Else 
        dbms_output.put_line(' big_bigint >  big_bigint false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_bigint_null('Comparison operation : bigint, null ' ) ; 

drop procedure t_bigint_null ; 



select 'This test is a normal run case. ( t_numeric_null )' ;
create or replace procedure t_numeric_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_numeric = null Then 
        dbms_output.put_line(' big_numeric =  null true' );
    Else 
        dbms_output.put_line(' big_numeric =  null false' );
    end if;

    If big_numeric <=> null Then 
        dbms_output.put_line(' big_numeric <=>  null true' );
    Else 
        dbms_output.put_line(' big_numeric <=>  null false' );
    end if;

    If big_numeric != null Then 
        dbms_output.put_line(' big_numeric !=  null true' );
    Else 
        dbms_output.put_line(' big_numeric !=  null false' );
    end if;

    If big_numeric <= null Then 
        dbms_output.put_line(' big_numeric <=  null true' );
    Else 
        dbms_output.put_line(' big_numeric <=  null false' );
    end if;

    If big_numeric >= null Then 
        dbms_output.put_line(' big_numeric >=  null true' );
    Else 
        dbms_output.put_line(' big_numeric >=  null false' );
    end if;

    If big_numeric < null Then 
        dbms_output.put_line(' big_numeric <  null true' );
    Else 
        dbms_output.put_line(' big_numeric <  null false' );
    end if;

    If big_numeric > null Then 
        dbms_output.put_line(' big_numeric >  null true' );
    Else 
        dbms_output.put_line(' big_numeric >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_numeric = ' || NVL(big_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_numeric Then 
        dbms_output.put_line(' null =  big_numeric true' );
    Else 
        dbms_output.put_line(' null =  big_numeric false' );
    end if;

    If null <=> big_numeric Then 
        dbms_output.put_line(' null <=>  big_numeric true' );
    Else 
        dbms_output.put_line(' null <=>  big_numeric false' );
    end if;

    If null != big_numeric Then 
        dbms_output.put_line(' null !=  big_numeric true' );
    Else 
        dbms_output.put_line(' null !=  big_numeric false' );
    end if;

    If null <= big_numeric Then 
        dbms_output.put_line(' null <=  big_numeric true' );
    Else 
        dbms_output.put_line(' null <=  big_numeric false' );
    end if;

    If null >= big_numeric Then 
        dbms_output.put_line(' null >=  big_numeric true' );
    Else 
        dbms_output.put_line(' null >=  big_numeric false' );
    end if;

    If null < big_numeric Then 
        dbms_output.put_line(' null <  big_numeric true' );
    Else 
        dbms_output.put_line(' null <  big_numeric false' );
    end if;

    If null > big_numeric Then 
        dbms_output.put_line(' null >  big_numeric true' );
    Else 
        dbms_output.put_line(' null >  big_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_numeric = ' || NVL(big_numeric,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_numeric = big_numeric Then 
        dbms_output.put_line(' big_numeric =  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric =  big_numeric false' );
    end if;

    If big_numeric <=> big_numeric Then 
        dbms_output.put_line(' big_numeric <=>  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <=>  big_numeric false' );
    end if;

    If big_numeric != big_numeric Then 
        dbms_output.put_line(' big_numeric !=  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric !=  big_numeric false' );
    end if;

    If big_numeric <= big_numeric Then 
        dbms_output.put_line(' big_numeric <=  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <=  big_numeric false' );
    end if;

    If big_numeric >= big_numeric Then 
        dbms_output.put_line(' big_numeric >=  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric >=  big_numeric false' );
    end if;

    If big_numeric < big_numeric Then 
        dbms_output.put_line(' big_numeric <  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric <  big_numeric false' );
    end if;

    If big_numeric > big_numeric Then 
        dbms_output.put_line(' big_numeric >  big_numeric true' );
    Else 
        dbms_output.put_line(' big_numeric >  big_numeric false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_numeric_null('Comparison operation : numeric, null ' ) ; 

drop procedure t_numeric_null ; 



select 'This test is a normal run case. ( t_float_null )' ;
create or replace procedure t_float_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_float = null Then 
        dbms_output.put_line(' big_float =  null true' );
    Else 
        dbms_output.put_line(' big_float =  null false' );
    end if;

    If big_float <=> null Then 
        dbms_output.put_line(' big_float <=>  null true' );
    Else 
        dbms_output.put_line(' big_float <=>  null false' );
    end if;

    If big_float != null Then 
        dbms_output.put_line(' big_float !=  null true' );
    Else 
        dbms_output.put_line(' big_float !=  null false' );
    end if;

    If big_float <= null Then 
        dbms_output.put_line(' big_float <=  null true' );
    Else 
        dbms_output.put_line(' big_float <=  null false' );
    end if;

    If big_float >= null Then 
        dbms_output.put_line(' big_float >=  null true' );
    Else 
        dbms_output.put_line(' big_float >=  null false' );
    end if;

    If big_float < null Then 
        dbms_output.put_line(' big_float <  null true' );
    Else 
        dbms_output.put_line(' big_float <  null false' );
    end if;

    If big_float > null Then 
        dbms_output.put_line(' big_float >  null true' );
    Else 
        dbms_output.put_line(' big_float >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_float = ' || NVL(big_float,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_float Then 
        dbms_output.put_line(' null =  big_float true' );
    Else 
        dbms_output.put_line(' null =  big_float false' );
    end if;

    If null <=> big_float Then 
        dbms_output.put_line(' null <=>  big_float true' );
    Else 
        dbms_output.put_line(' null <=>  big_float false' );
    end if;

    If null != big_float Then 
        dbms_output.put_line(' null !=  big_float true' );
    Else 
        dbms_output.put_line(' null !=  big_float false' );
    end if;

    If null <= big_float Then 
        dbms_output.put_line(' null <=  big_float true' );
    Else 
        dbms_output.put_line(' null <=  big_float false' );
    end if;

    If null >= big_float Then 
        dbms_output.put_line(' null >=  big_float true' );
    Else 
        dbms_output.put_line(' null >=  big_float false' );
    end if;

    If null < big_float Then 
        dbms_output.put_line(' null <  big_float true' );
    Else 
        dbms_output.put_line(' null <  big_float false' );
    end if;

    If null > big_float Then 
        dbms_output.put_line(' null >  big_float true' );
    Else 
        dbms_output.put_line(' null >  big_float false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_float = ' || NVL(big_float,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_float = big_float Then 
        dbms_output.put_line(' big_float =  big_float true' );
    Else 
        dbms_output.put_line(' big_float =  big_float false' );
    end if;

    If big_float <=> big_float Then 
        dbms_output.put_line(' big_float <=>  big_float true' );
    Else 
        dbms_output.put_line(' big_float <=>  big_float false' );
    end if;

    If big_float != big_float Then 
        dbms_output.put_line(' big_float !=  big_float true' );
    Else 
        dbms_output.put_line(' big_float !=  big_float false' );
    end if;

    If big_float <= big_float Then 
        dbms_output.put_line(' big_float <=  big_float true' );
    Else 
        dbms_output.put_line(' big_float <=  big_float false' );
    end if;

    If big_float >= big_float Then 
        dbms_output.put_line(' big_float >=  big_float true' );
    Else 
        dbms_output.put_line(' big_float >=  big_float false' );
    end if;

    If big_float < big_float Then 
        dbms_output.put_line(' big_float <  big_float true' );
    Else 
        dbms_output.put_line(' big_float <  big_float false' );
    end if;

    If big_float > big_float Then 
        dbms_output.put_line(' big_float >  big_float true' );
    Else 
        dbms_output.put_line(' big_float >  big_float false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_float_null('Comparison operation : float, null ' ) ; 

drop procedure t_float_null ; 



select 'This test is a normal run case. ( t_double_null )' ;
create or replace procedure t_double_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_double = null Then 
        dbms_output.put_line(' big_double =  null true' );
    Else 
        dbms_output.put_line(' big_double =  null false' );
    end if;

    If big_double <=> null Then 
        dbms_output.put_line(' big_double <=>  null true' );
    Else 
        dbms_output.put_line(' big_double <=>  null false' );
    end if;

    If big_double != null Then 
        dbms_output.put_line(' big_double !=  null true' );
    Else 
        dbms_output.put_line(' big_double !=  null false' );
    end if;

    If big_double <= null Then 
        dbms_output.put_line(' big_double <=  null true' );
    Else 
        dbms_output.put_line(' big_double <=  null false' );
    end if;

    If big_double >= null Then 
        dbms_output.put_line(' big_double >=  null true' );
    Else 
        dbms_output.put_line(' big_double >=  null false' );
    end if;

    If big_double < null Then 
        dbms_output.put_line(' big_double <  null true' );
    Else 
        dbms_output.put_line(' big_double <  null false' );
    end if;

    If big_double > null Then 
        dbms_output.put_line(' big_double >  null true' );
    Else 
        dbms_output.put_line(' big_double >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_double = ' || NVL(big_double,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_double Then 
        dbms_output.put_line(' null =  big_double true' );
    Else 
        dbms_output.put_line(' null =  big_double false' );
    end if;

    If null <=> big_double Then 
        dbms_output.put_line(' null <=>  big_double true' );
    Else 
        dbms_output.put_line(' null <=>  big_double false' );
    end if;

    If null != big_double Then 
        dbms_output.put_line(' null !=  big_double true' );
    Else 
        dbms_output.put_line(' null !=  big_double false' );
    end if;

    If null <= big_double Then 
        dbms_output.put_line(' null <=  big_double true' );
    Else 
        dbms_output.put_line(' null <=  big_double false' );
    end if;

    If null >= big_double Then 
        dbms_output.put_line(' null >=  big_double true' );
    Else 
        dbms_output.put_line(' null >=  big_double false' );
    end if;

    If null < big_double Then 
        dbms_output.put_line(' null <  big_double true' );
    Else 
        dbms_output.put_line(' null <  big_double false' );
    end if;

    If null > big_double Then 
        dbms_output.put_line(' null >  big_double true' );
    Else 
        dbms_output.put_line(' null >  big_double false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_double = ' || NVL(big_double,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_double = big_double Then 
        dbms_output.put_line(' big_double =  big_double true' );
    Else 
        dbms_output.put_line(' big_double =  big_double false' );
    end if;

    If big_double <=> big_double Then 
        dbms_output.put_line(' big_double <=>  big_double true' );
    Else 
        dbms_output.put_line(' big_double <=>  big_double false' );
    end if;

    If big_double != big_double Then 
        dbms_output.put_line(' big_double !=  big_double true' );
    Else 
        dbms_output.put_line(' big_double !=  big_double false' );
    end if;

    If big_double <= big_double Then 
        dbms_output.put_line(' big_double <=  big_double true' );
    Else 
        dbms_output.put_line(' big_double <=  big_double false' );
    end if;

    If big_double >= big_double Then 
        dbms_output.put_line(' big_double >=  big_double true' );
    Else 
        dbms_output.put_line(' big_double >=  big_double false' );
    end if;

    If big_double < big_double Then 
        dbms_output.put_line(' big_double <  big_double true' );
    Else 
        dbms_output.put_line(' big_double <  big_double false' );
    end if;

    If big_double > big_double Then 
        dbms_output.put_line(' big_double >  big_double true' );
    Else 
        dbms_output.put_line(' big_double >  big_double false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_double_null('Comparison operation : double, null ' ) ; 

drop procedure t_double_null ; 



select 'This test is a normal run case. ( t_date_null )' ;
create or replace procedure t_date_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_date = null Then 
        dbms_output.put_line(' big_date =  null true' );
    Else 
        dbms_output.put_line(' big_date =  null false' );
    end if;

    If big_date <=> null Then 
        dbms_output.put_line(' big_date <=>  null true' );
    Else 
        dbms_output.put_line(' big_date <=>  null false' );
    end if;

    If big_date != null Then 
        dbms_output.put_line(' big_date !=  null true' );
    Else 
        dbms_output.put_line(' big_date !=  null false' );
    end if;

    If big_date <= null Then 
        dbms_output.put_line(' big_date <=  null true' );
    Else 
        dbms_output.put_line(' big_date <=  null false' );
    end if;

    If big_date >= null Then 
        dbms_output.put_line(' big_date >=  null true' );
    Else 
        dbms_output.put_line(' big_date >=  null false' );
    end if;

    If big_date < null Then 
        dbms_output.put_line(' big_date <  null true' );
    Else 
        dbms_output.put_line(' big_date <  null false' );
    end if;

    If big_date > null Then 
        dbms_output.put_line(' big_date >  null true' );
    Else 
        dbms_output.put_line(' big_date >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_date = ' || NVL(big_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_date Then 
        dbms_output.put_line(' null =  big_date true' );
    Else 
        dbms_output.put_line(' null =  big_date false' );
    end if;

    If null <=> big_date Then 
        dbms_output.put_line(' null <=>  big_date true' );
    Else 
        dbms_output.put_line(' null <=>  big_date false' );
    end if;

    If null != big_date Then 
        dbms_output.put_line(' null !=  big_date true' );
    Else 
        dbms_output.put_line(' null !=  big_date false' );
    end if;

    If null <= big_date Then 
        dbms_output.put_line(' null <=  big_date true' );
    Else 
        dbms_output.put_line(' null <=  big_date false' );
    end if;

    If null >= big_date Then 
        dbms_output.put_line(' null >=  big_date true' );
    Else 
        dbms_output.put_line(' null >=  big_date false' );
    end if;

    If null < big_date Then 
        dbms_output.put_line(' null <  big_date true' );
    Else 
        dbms_output.put_line(' null <  big_date false' );
    end if;

    If null > big_date Then 
        dbms_output.put_line(' null >  big_date true' );
    Else 
        dbms_output.put_line(' null >  big_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_date = ' || NVL(big_date,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_date = big_date Then 
        dbms_output.put_line(' big_date =  big_date true' );
    Else 
        dbms_output.put_line(' big_date =  big_date false' );
    end if;

    If big_date <=> big_date Then 
        dbms_output.put_line(' big_date <=>  big_date true' );
    Else 
        dbms_output.put_line(' big_date <=>  big_date false' );
    end if;

    If big_date != big_date Then 
        dbms_output.put_line(' big_date !=  big_date true' );
    Else 
        dbms_output.put_line(' big_date !=  big_date false' );
    end if;

    If big_date <= big_date Then 
        dbms_output.put_line(' big_date <=  big_date true' );
    Else 
        dbms_output.put_line(' big_date <=  big_date false' );
    end if;

    If big_date >= big_date Then 
        dbms_output.put_line(' big_date >=  big_date true' );
    Else 
        dbms_output.put_line(' big_date >=  big_date false' );
    end if;

    If big_date < big_date Then 
        dbms_output.put_line(' big_date <  big_date true' );
    Else 
        dbms_output.put_line(' big_date <  big_date false' );
    end if;

    If big_date > big_date Then 
        dbms_output.put_line(' big_date >  big_date true' );
    Else 
        dbms_output.put_line(' big_date >  big_date false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_date_null('Comparison operation : date, null ' ) ; 

drop procedure t_date_null ; 



select 'This test is a normal run case. ( t_time_null )' ;
create or replace procedure t_time_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_time = null Then 
        dbms_output.put_line(' big_time =  null true' );
    Else 
        dbms_output.put_line(' big_time =  null false' );
    end if;

    If big_time <=> null Then 
        dbms_output.put_line(' big_time <=>  null true' );
    Else 
        dbms_output.put_line(' big_time <=>  null false' );
    end if;

    If big_time != null Then 
        dbms_output.put_line(' big_time !=  null true' );
    Else 
        dbms_output.put_line(' big_time !=  null false' );
    end if;

    If big_time <= null Then 
        dbms_output.put_line(' big_time <=  null true' );
    Else 
        dbms_output.put_line(' big_time <=  null false' );
    end if;

    If big_time >= null Then 
        dbms_output.put_line(' big_time >=  null true' );
    Else 
        dbms_output.put_line(' big_time >=  null false' );
    end if;

    If big_time < null Then 
        dbms_output.put_line(' big_time <  null true' );
    Else 
        dbms_output.put_line(' big_time <  null false' );
    end if;

    If big_time > null Then 
        dbms_output.put_line(' big_time >  null true' );
    Else 
        dbms_output.put_line(' big_time >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_time = ' || NVL(big_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_time Then 
        dbms_output.put_line(' null =  big_time true' );
    Else 
        dbms_output.put_line(' null =  big_time false' );
    end if;

    If null <=> big_time Then 
        dbms_output.put_line(' null <=>  big_time true' );
    Else 
        dbms_output.put_line(' null <=>  big_time false' );
    end if;

    If null != big_time Then 
        dbms_output.put_line(' null !=  big_time true' );
    Else 
        dbms_output.put_line(' null !=  big_time false' );
    end if;

    If null <= big_time Then 
        dbms_output.put_line(' null <=  big_time true' );
    Else 
        dbms_output.put_line(' null <=  big_time false' );
    end if;

    If null >= big_time Then 
        dbms_output.put_line(' null >=  big_time true' );
    Else 
        dbms_output.put_line(' null >=  big_time false' );
    end if;

    If null < big_time Then 
        dbms_output.put_line(' null <  big_time true' );
    Else 
        dbms_output.put_line(' null <  big_time false' );
    end if;

    If null > big_time Then 
        dbms_output.put_line(' null >  big_time true' );
    Else 
        dbms_output.put_line(' null >  big_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_time = ' || NVL(big_time,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_time = big_time Then 
        dbms_output.put_line(' big_time =  big_time true' );
    Else 
        dbms_output.put_line(' big_time =  big_time false' );
    end if;

    If big_time <=> big_time Then 
        dbms_output.put_line(' big_time <=>  big_time true' );
    Else 
        dbms_output.put_line(' big_time <=>  big_time false' );
    end if;

    If big_time != big_time Then 
        dbms_output.put_line(' big_time !=  big_time true' );
    Else 
        dbms_output.put_line(' big_time !=  big_time false' );
    end if;

    If big_time <= big_time Then 
        dbms_output.put_line(' big_time <=  big_time true' );
    Else 
        dbms_output.put_line(' big_time <=  big_time false' );
    end if;

    If big_time >= big_time Then 
        dbms_output.put_line(' big_time >=  big_time true' );
    Else 
        dbms_output.put_line(' big_time >=  big_time false' );
    end if;

    If big_time < big_time Then 
        dbms_output.put_line(' big_time <  big_time true' );
    Else 
        dbms_output.put_line(' big_time <  big_time false' );
    end if;

    If big_time > big_time Then 
        dbms_output.put_line(' big_time >  big_time true' );
    Else 
        dbms_output.put_line(' big_time >  big_time false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_time_null('Comparison operation : time, null ' ) ; 

drop procedure t_time_null ; 



select 'This test is a normal run case. ( t_datetime_null )' ;
create or replace procedure t_datetime_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_datetime = null Then 
        dbms_output.put_line(' big_datetime =  null true' );
    Else 
        dbms_output.put_line(' big_datetime =  null false' );
    end if;

    If big_datetime <=> null Then 
        dbms_output.put_line(' big_datetime <=>  null true' );
    Else 
        dbms_output.put_line(' big_datetime <=>  null false' );
    end if;

    If big_datetime != null Then 
        dbms_output.put_line(' big_datetime !=  null true' );
    Else 
        dbms_output.put_line(' big_datetime !=  null false' );
    end if;

    If big_datetime <= null Then 
        dbms_output.put_line(' big_datetime <=  null true' );
    Else 
        dbms_output.put_line(' big_datetime <=  null false' );
    end if;

    If big_datetime >= null Then 
        dbms_output.put_line(' big_datetime >=  null true' );
    Else 
        dbms_output.put_line(' big_datetime >=  null false' );
    end if;

    If big_datetime < null Then 
        dbms_output.put_line(' big_datetime <  null true' );
    Else 
        dbms_output.put_line(' big_datetime <  null false' );
    end if;

    If big_datetime > null Then 
        dbms_output.put_line(' big_datetime >  null true' );
    Else 
        dbms_output.put_line(' big_datetime >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_datetime = ' || NVL(big_datetime,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_datetime Then 
        dbms_output.put_line(' null =  big_datetime true' );
    Else 
        dbms_output.put_line(' null =  big_datetime false' );
    end if;

    If null <=> big_datetime Then 
        dbms_output.put_line(' null <=>  big_datetime true' );
    Else 
        dbms_output.put_line(' null <=>  big_datetime false' );
    end if;

    If null != big_datetime Then 
        dbms_output.put_line(' null !=  big_datetime true' );
    Else 
        dbms_output.put_line(' null !=  big_datetime false' );
    end if;

    If null <= big_datetime Then 
        dbms_output.put_line(' null <=  big_datetime true' );
    Else 
        dbms_output.put_line(' null <=  big_datetime false' );
    end if;

    If null >= big_datetime Then 
        dbms_output.put_line(' null >=  big_datetime true' );
    Else 
        dbms_output.put_line(' null >=  big_datetime false' );
    end if;

    If null < big_datetime Then 
        dbms_output.put_line(' null <  big_datetime true' );
    Else 
        dbms_output.put_line(' null <  big_datetime false' );
    end if;

    If null > big_datetime Then 
        dbms_output.put_line(' null >  big_datetime true' );
    Else 
        dbms_output.put_line(' null >  big_datetime false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_datetime = ' || NVL(big_datetime,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_datetime = big_datetime Then 
        dbms_output.put_line(' big_datetime =  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime =  big_datetime false' );
    end if;

    If big_datetime <=> big_datetime Then 
        dbms_output.put_line(' big_datetime <=>  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime <=>  big_datetime false' );
    end if;

    If big_datetime != big_datetime Then 
        dbms_output.put_line(' big_datetime !=  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime !=  big_datetime false' );
    end if;

    If big_datetime <= big_datetime Then 
        dbms_output.put_line(' big_datetime <=  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime <=  big_datetime false' );
    end if;

    If big_datetime >= big_datetime Then 
        dbms_output.put_line(' big_datetime >=  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime >=  big_datetime false' );
    end if;

    If big_datetime < big_datetime Then 
        dbms_output.put_line(' big_datetime <  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime <  big_datetime false' );
    end if;

    If big_datetime > big_datetime Then 
        dbms_output.put_line(' big_datetime >  big_datetime true' );
    Else 
        dbms_output.put_line(' big_datetime >  big_datetime false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_datetime_null('Comparison operation : datetime, null ' ) ; 

drop procedure t_datetime_null ; 



select 'This test is a normal run case. ( t_timestamp_null )' ;
create or replace procedure t_timestamp_null( tc_comment string ) as 
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
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');

    If big_timestamp = null Then 
        dbms_output.put_line(' big_timestamp =  null true' );
    Else 
        dbms_output.put_line(' big_timestamp =  null false' );
    end if;

    If big_timestamp <=> null Then 
        dbms_output.put_line(' big_timestamp <=>  null true' );
    Else 
        dbms_output.put_line(' big_timestamp <=>  null false' );
    end if;

    If big_timestamp != null Then 
        dbms_output.put_line(' big_timestamp !=  null true' );
    Else 
        dbms_output.put_line(' big_timestamp !=  null false' );
    end if;

    If big_timestamp <= null Then 
        dbms_output.put_line(' big_timestamp <=  null true' );
    Else 
        dbms_output.put_line(' big_timestamp <=  null false' );
    end if;

    If big_timestamp >= null Then 
        dbms_output.put_line(' big_timestamp >=  null true' );
    Else 
        dbms_output.put_line(' big_timestamp >=  null false' );
    end if;

    If big_timestamp < null Then 
        dbms_output.put_line(' big_timestamp <  null true' );
    Else 
        dbms_output.put_line(' big_timestamp <  null false' );
    end if;

    If big_timestamp > null Then 
        dbms_output.put_line(' big_timestamp >  null true' );
    Else 
        dbms_output.put_line(' big_timestamp >  null false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('null = ' || NVL(null,'NULL') );
    dbms_output.put_line('big_timestamp = ' || NVL(big_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If null = big_timestamp Then 
        dbms_output.put_line(' null =  big_timestamp true' );
    Else 
        dbms_output.put_line(' null =  big_timestamp false' );
    end if;

    If null <=> big_timestamp Then 
        dbms_output.put_line(' null <=>  big_timestamp true' );
    Else 
        dbms_output.put_line(' null <=>  big_timestamp false' );
    end if;

    If null != big_timestamp Then 
        dbms_output.put_line(' null !=  big_timestamp true' );
    Else 
        dbms_output.put_line(' null !=  big_timestamp false' );
    end if;

    If null <= big_timestamp Then 
        dbms_output.put_line(' null <=  big_timestamp true' );
    Else 
        dbms_output.put_line(' null <=  big_timestamp false' );
    end if;

    If null >= big_timestamp Then 
        dbms_output.put_line(' null >=  big_timestamp true' );
    Else 
        dbms_output.put_line(' null >=  big_timestamp false' );
    end if;

    If null < big_timestamp Then 
        dbms_output.put_line(' null <  big_timestamp true' );
    Else 
        dbms_output.put_line(' null <  big_timestamp false' );
    end if;

    If null > big_timestamp Then 
        dbms_output.put_line(' null >  big_timestamp true' );
    Else 
        dbms_output.put_line(' null >  big_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('********************************');
    dbms_output.put_line('big_timestamp = ' || NVL(big_timestamp,'NULL') );
    dbms_output.put_line('********************************');
    dbms_output.put_line('');
    If big_timestamp = big_timestamp Then 
        dbms_output.put_line(' big_timestamp =  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp =  big_timestamp false' );
    end if;

    If big_timestamp <=> big_timestamp Then 
        dbms_output.put_line(' big_timestamp <=>  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <=>  big_timestamp false' );
    end if;

    If big_timestamp != big_timestamp Then 
        dbms_output.put_line(' big_timestamp !=  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp !=  big_timestamp false' );
    end if;

    If big_timestamp <= big_timestamp Then 
        dbms_output.put_line(' big_timestamp <=  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <=  big_timestamp false' );
    end if;

    If big_timestamp >= big_timestamp Then 
        dbms_output.put_line(' big_timestamp >=  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp >=  big_timestamp false' );
    end if;

    If big_timestamp < big_timestamp Then 
        dbms_output.put_line(' big_timestamp <  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp <  big_timestamp false' );
    end if;

    If big_timestamp > big_timestamp Then 
        dbms_output.put_line(' big_timestamp >  big_timestamp true' );
    Else 
        dbms_output.put_line(' big_timestamp >  big_timestamp false' );
    end if;

    dbms_output.put_line('');
    dbms_output.put_line('');
end; 

call t_timestamp_null('Comparison operation : timestamp, null ' ) ; 

drop procedure t_timestamp_null ; 



select 'This test is a case where an error is output.(not support, not created) ( t_sys_refcursor_null ) ' ; 
create or replace procedure t_sys_refcursor_null( tc_comment string ) as 
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
    If big_sys_refcursor = null Then 
        dbms_output.put_line(' big_sys_refcursor =  null true' );
    Else 
        dbms_output.put_line(' big_sys_refcursor =  null false' );
    end if;

end; 

select 'This test is a case where an error is output.(not support, not created) ( t_cursor_null ) ' ; 
create or replace procedure t_cursor_null( tc_comment string ) as 
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
    If big_cursor = null Then 
        dbms_output.put_line(' big_cursor =  null true' );
    Else 
        dbms_output.put_line(' big_cursor =  null false' );
    end if;

end; 

--+ server-message off
