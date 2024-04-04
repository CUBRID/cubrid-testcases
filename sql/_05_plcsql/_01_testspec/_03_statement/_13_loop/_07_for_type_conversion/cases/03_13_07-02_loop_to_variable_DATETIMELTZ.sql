--+ server-message on

drop table IF EXISTS plcsql_type_tbl ;

create table plcsql_type_tbl (
ID INT,
T_SHORT SHORT,
T_SMALLINT SMALLINT,
T_INTEGER INTEGER,
T_INT INT,
T_BIGINT BIGINT,
T_NUMERIC NUMERIC(38,15),
T_DECIMAL DECIMAL,
T_FLOAT FLOAT,
T_REAL REAL,
T_DOUBLE DOUBLE,
T_DATE DATE,
T_TIME TIME,
T_TIMESTAMP TIMESTAMP,
T_DATETIME DATETIME,
T_CHAR CHAR(32),
T_VARCHAR VARCHAR(32),
T_VARCHAR_DATE VARCHAR(32),
T_VARCHAR_TIME VARCHAR(32),
T_VARCHAR_DATETIME VARCHAR(32),
T_VARCHAR_NUMBER VARCHAR(32),
T_BIT BIT(8) default B'1',
T_BITVARYING BIT VARYING(64) default 0xaa,
T_TIMESTAMPLTZ TIMESTAMPLTZ,
T_TIMESTAMPTZ TIMESTAMPTZ,
T_DATETIMELTZ DATETIMELTZ,
T_DATETIMETZ DATETIMETZ,
T_ENUM ENUM('x-small', 'small', 'medium', 'large', 'x-large'),
T_BLOB BLOB,
T_CLOB CLOB,
T_SET SET default {'c','c','c','b','b','a'},
T_MULTISET MULTISET default {'c','c','c','b','b','a'},
T_SEQUENCE SEQUENCE default {'c','c','c','b','b','a'},
T_LIST LIST default {'c','c','c','b','b','a'},
T_JSON JSON
);

insert into plcsql_type_tbl
(ID, T_SHORT, T_SMALLINT, T_INTEGER, T_INT, T_BIGINT, T_NUMERIC, T_DECIMAL, T_FLOAT, T_REAL, T_DOUBLE, 
T_DATE, T_TIME, T_TIMESTAMP, T_DATETIME, 
T_CHAR, T_VARCHAR, 
T_VARCHAR_DATE, T_VARCHAR_TIME, T_VARCHAR_DATETIME, T_VARCHAR_NUMBER,
T_BIT, T_BITVARYING, T_TIMESTAMPLTZ, T_TIMESTAMPTZ, 
T_DATETIMELTZ, T_DATETIMETZ, 
T_ENUM, T_BLOB, T_CLOB, 
T_SET, T_MULTISET, T_SEQUENCE, T_LIST, T_JSON
)
values
(1, -32767,-32767,-21474, -2147, -9223, 0.1, 0.1, -3.4028234, -3.402823, -1.7976931348623,
'0001-01-01', TIME'00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef', 
'09/01/2005', '05:05:05 pm', '09/01/2005 05:05:05 pm', '123',
B'1',0xcf,timestampltz'1970-01-01 09:00:01', timestamptz'1970-01-01 09:00:01',
datetimeltz'0001-01-01 09:00:01.000', datetimetz'0001-01-01 09:00:01.000', 
'x-small', BIT_TO_BLOB(X'000100'), CHAR_TO_CLOB('This is a Cat'), 
{'c','c','c','b','b','a'}, {'c','c','c','b','b','a'}, {'c','c','c','b','b','a'}, {'c','c','c','b','b','a'}, '{"key1": "value1", "key2": "value2"}' );

insert into plcsql_type_tbl
(ID, T_SHORT, T_SMALLINT, T_INTEGER, T_INT, T_BIGINT, T_NUMERIC, T_DECIMAL, T_FLOAT, T_REAL, T_DOUBLE, 
T_DATE, T_TIME, T_TIMESTAMP, T_DATETIME, 
T_CHAR, T_VARCHAR,
T_VARCHAR_DATE, T_VARCHAR_TIME, T_VARCHAR_DATETIME, T_VARCHAR_NUMBER,
T_BIT, T_BITVARYING, T_TIMESTAMPLTZ, T_TIMESTAMPTZ, 
T_DATETIMELTZ, T_DATETIMETZ, 
T_ENUM, T_BLOB, T_CLOB, 
T_SET, T_MULTISET, T_SEQUENCE, T_LIST, T_JSON
)
values
(2,32767, 32767, 21474, 2147, 9223, 987.432, 5432, 3.4028, 3.402823466, 3.402823,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999', 
'1234567890abcdef','1234567890abcdef',
'09/01/2019', '09:09:09 pm', '09/01/2019 09:09:09 pm', '567',
B'1',0xcf,timestampltz'1970-01-01 09:00:01', timestamptz'1970-01-01 09:00:01',
datetimeltz'0001-01-01 09:00:01.000', datetimetz'0001-01-01 09:00:01.000', 
'x-small', BIT_TO_BLOB(X'000100'), CHAR_TO_CLOB('This is a Cat'), 
{'c','c','c','b','b','a'}, {'c','c','c','b','b','a'}, {'c','c','c','b','b','a'}, {'c','c','c','b','b','a'}, '{"key1": "value1", "key2": "value2"}'  );

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATETIME_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATETIME as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_DATETIME_DATETIMELTZ('DATETIME', 'DATETIMELTZ'  ) ;
drop procedure t_DATETIME_DATETIMELTZ ;



call print_message('t_DATETIMELTZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATETIMELTZ as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_DATETIMELTZ_DATETIMELTZ('DATETIMELTZ', 'DATETIMELTZ'  ) ;
drop procedure t_DATETIMELTZ_DATETIMELTZ ;



call print_message('t_DATETIMETZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATETIMETZ as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_DATETIMETZ_DATETIMELTZ('DATETIMETZ', 'DATETIMELTZ'  ) ;
drop procedure t_DATETIMETZ_DATETIMELTZ ;



call print_message('t_DATE_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATE_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATE as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_DATE_DATETIMELTZ('DATE', 'DATETIMELTZ'  ) ;
drop procedure t_DATE_DATETIMELTZ ;



call print_message('t_TIME_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIME_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIME as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_TIME_DATETIMELTZ('TIME', 'DATETIMELTZ'  ) ;
drop procedure t_TIME_DATETIMELTZ ;



call print_message('t_TIMESTAMP_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIMESTAMP as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_TIMESTAMP_DATETIMELTZ('TIMESTAMP', 'DATETIMELTZ'  ) ;
drop procedure t_TIMESTAMP_DATETIMELTZ ;



call print_message('t_TIMESTAMPLTZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIMESTAMPLTZ as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_TIMESTAMPLTZ_DATETIMELTZ('TIMESTAMPLTZ', 'DATETIMELTZ'  ) ;
drop procedure t_TIMESTAMPLTZ_DATETIMELTZ ;



call print_message('t_TIMESTAMPTZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIMESTAMPTZ as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_TIMESTAMPTZ_DATETIMELTZ('TIMESTAMPTZ', 'DATETIMELTZ'  ) ;
drop procedure t_TIMESTAMPTZ_DATETIMELTZ ;



call print_message('t_DOUBLE_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DOUBLE_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DOUBLE as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_DOUBLE_DATETIMELTZ('DOUBLE', 'DATETIMELTZ'  ) ;
drop procedure t_DOUBLE_DATETIMELTZ ;



call print_message('t_FLOAT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_FLOAT_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_FLOAT as col_val FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_REAL as col_val FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
    FOR r IN my_cursor2 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
end;
call t_FLOAT_DATETIMELTZ('FLOAT', 'DATETIMELTZ'  ) ;
drop procedure t_FLOAT_DATETIMELTZ ;



call print_message('t_NUMERIC(8,4)_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_NUMERIC_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_NUMERIC as col_val FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_DECIMAL as col_val FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
    FOR r IN my_cursor2 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
end;
call t_NUMERIC_DATETIMELTZ('NUMERIC(8,4)', 'DATETIMELTZ'  ) ;
drop procedure t_NUMERIC_DATETIMELTZ ;



call print_message('t_BIGINT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BIGINT_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BIGINT as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_BIGINT_DATETIMELTZ('BIGINT', 'DATETIMELTZ'  ) ;
drop procedure t_BIGINT_DATETIMELTZ ;



call print_message('t_INT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_INT_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_INT as col_val FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_INTEGER as col_val FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
    FOR r IN my_cursor2 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
end;
call t_INT_DATETIMELTZ('INT', 'DATETIMELTZ'  ) ;
drop procedure t_INT_DATETIMELTZ ;



call print_message('t_SHORT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_SHORT_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_SHORT as col_val FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_SMALLINT as col_val FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
    FOR r IN my_cursor2 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
end;
call t_SHORT_DATETIMELTZ('SHORT', 'DATETIMELTZ'  ) ;
drop procedure t_SHORT_DATETIMELTZ ;



call print_message('t_BIT(8)_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BIT_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BIT as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_BIT_DATETIMELTZ('BIT(8)', 'DATETIMELTZ'  ) ;
drop procedure t_BIT_DATETIMELTZ ;



call print_message('t_BIT VARYING_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BITVARYING_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BITVARYING as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_BITVARYING_DATETIMELTZ('BIT VARYING', 'DATETIMELTZ'  ) ;
drop procedure t_BITVARYING_DATETIMELTZ ;



call print_message('t_CHAR_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_CHAR_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_VARCHAR_DATETIME as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_CHAR_DATETIMELTZ('CHAR', 'DATETIMELTZ'  ) ;
drop procedure t_CHAR_DATETIMELTZ ;



call print_message('t_VARCHAR_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_VARCHAR_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_VARCHAR_DATETIME as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_VARCHAR_DATETIMELTZ('VARCHAR', 'DATETIMELTZ'  ) ;
drop procedure t_VARCHAR_DATETIMELTZ ;



call print_message('t_SET_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_SET_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_SET as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_SET_DATETIMELTZ('SET', 'DATETIMELTZ'  ) ;
drop procedure t_SET_DATETIMELTZ ;



call print_message('t_MULTISET_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_MULTISET_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_MULTISET as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_MULTISET_DATETIMELTZ('MULTISET', 'DATETIMELTZ'  ) ;
drop procedure t_MULTISET_DATETIMELTZ ;



call print_message('t_LIST_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_LIST_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_LIST as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_LIST_DATETIMELTZ('LIST', 'DATETIMELTZ'  ) ;
drop procedure t_LIST_DATETIMELTZ ;



call print_message('t_ENUM_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_ENUM_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_ENUM as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_ENUM_DATETIMELTZ('ENUM', 'DATETIMELTZ'  ) ;
drop procedure t_ENUM_DATETIMELTZ ;



call print_message('t_BLOB_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BLOB_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BLOB as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_BLOB_DATETIMELTZ('BLOB', 'DATETIMELTZ'  ) ;
drop procedure t_BLOB_DATETIMELTZ ;



call print_message('t_CLOB_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_CLOB_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_CLOB as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_CLOB_DATETIMELTZ('CLOB', 'DATETIMELTZ'  ) ;
drop procedure t_CLOB_DATETIMELTZ ;



call print_message('t_JSON_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_JSON_DATETIMELTZ(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_JSON as col_val FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR DATETIMELTZ  ;
begin
    FOR r IN my_cursor1 LOOP  
        VAR := r.col_val ;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    
end;
call t_JSON_DATETIMELTZ('JSON', 'DATETIMELTZ'  ) ;
drop procedure t_JSON_DATETIMELTZ ;

drop table IF EXISTS plcsql_type_tbl;

drop procedure print_message;

--+ server-message off
