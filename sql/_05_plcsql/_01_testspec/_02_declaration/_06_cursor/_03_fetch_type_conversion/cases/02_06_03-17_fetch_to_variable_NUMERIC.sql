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


call print_message('t_DATETIME_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATETIME_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATETIME FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_DATETIME_NUMERIC('DATETIME', 'NUMERIC(38,15)'  ) ;
drop procedure t_DATETIME_NUMERIC ;



call print_message('t_DATETIMELTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATETIMELTZ FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_DATETIMELTZ_NUMERIC('DATETIMELTZ', 'NUMERIC(38,15)'  ) ;
drop procedure t_DATETIMELTZ_NUMERIC ;



call print_message('t_DATETIMETZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATETIMETZ_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATETIMETZ FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_DATETIMETZ_NUMERIC('DATETIMETZ', 'NUMERIC(38,15)'  ) ;
drop procedure t_DATETIMETZ_NUMERIC ;



call print_message('t_DATE_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATE_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DATE FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_DATE_NUMERIC('DATE', 'NUMERIC(38,15)'  ) ;
drop procedure t_DATE_NUMERIC ;



call print_message('t_TIME_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIME_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIME FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_TIME_NUMERIC('TIME', 'NUMERIC(38,15)'  ) ;
drop procedure t_TIME_NUMERIC ;



call print_message('t_TIMESTAMP_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIMESTAMP_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIMESTAMP FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_TIMESTAMP_NUMERIC('TIMESTAMP', 'NUMERIC(38,15)'  ) ;
drop procedure t_TIMESTAMP_NUMERIC ;



call print_message('t_TIMESTAMPLTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIMESTAMPLTZ FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_TIMESTAMPLTZ_NUMERIC('TIMESTAMPLTZ', 'NUMERIC(38,15)'  ) ;
drop procedure t_TIMESTAMPLTZ_NUMERIC ;



call print_message('t_TIMESTAMPTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_TIMESTAMPTZ FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_TIMESTAMPTZ_NUMERIC('TIMESTAMPTZ', 'NUMERIC(38,15)'  ) ;
drop procedure t_TIMESTAMPTZ_NUMERIC ;



call print_message('t_DOUBLE_NUMERIC. This scenario is a success.');
create or replace procedure t_DOUBLE_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_DOUBLE FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_DOUBLE_NUMERIC('DOUBLE', 'NUMERIC(38,15)'  ) ;
drop procedure t_DOUBLE_NUMERIC ;


--BUG ( normal : -3.402823000000000, BUG : -3.402823448181152 )
--BUG ( normal : 3.402823000000000, BUG : 3.402800083160400 )
call print_message('t_FLOAT_NUMERIC. This scenario is a success.');
create or replace procedure t_FLOAT_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_FLOAT FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_REAL FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
    OPEN my_cursor2 ; 
    LOOP 
        FETCH my_cursor2 INTO VAR;
        EXIT WHEN my_cursor2%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor2;
    
end;
call t_FLOAT_NUMERIC('FLOAT', 'NUMERIC(38,15)'  ) ;
drop procedure t_FLOAT_NUMERIC ;



call print_message('t_NUMERIC_NUMERIC. This scenario is a success.');
create or replace procedure t_NUMERIC_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_NUMERIC FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_DECIMAL FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
    OPEN my_cursor2 ; 
    LOOP 
        FETCH my_cursor2 INTO VAR;
        EXIT WHEN my_cursor2%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor2;
    
end;
call t_NUMERIC_NUMERIC('NUMERIC(8,4)', 'NUMERIC(38,15)'  ) ;
drop procedure t_NUMERIC_NUMERIC ;



call print_message('t_BIGINT_NUMERIC. This scenario is a success.');
create or replace procedure t_BIGINT_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BIGINT FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_BIGINT_NUMERIC('BIGINT', 'NUMERIC(38,15)'  ) ;
drop procedure t_BIGINT_NUMERIC ;



call print_message('t_INT_NUMERIC. This scenario is a success.');
create or replace procedure t_INT_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_INT FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_INTEGER FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
    OPEN my_cursor2 ; 
    LOOP 
        FETCH my_cursor2 INTO VAR;
        EXIT WHEN my_cursor2%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor2;
    
end;
call t_INT_NUMERIC('INT', 'NUMERIC(38,15)'  ) ;
drop procedure t_INT_NUMERIC ;



call print_message('t_SHORT_NUMERIC. This scenario is a success.');
create or replace procedure t_SHORT_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_SHORT FROM plcsql_type_tbl WHERE ID = 1 ;
     CURSOR my_cursor2 IS 
          SELECT T_SMALLINT FROM plcsql_type_tbl WHERE ID = 2 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
    OPEN my_cursor2 ; 
    LOOP 
        FETCH my_cursor2 INTO VAR;
        EXIT WHEN my_cursor2%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor2;
    
end;
call t_SHORT_NUMERIC('SHORT', 'NUMERIC(38,15)'  ) ;
drop procedure t_SHORT_NUMERIC ;



call print_message('t_BIT(8)_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_BIT_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BIT FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_BIT_NUMERIC('BIT(8)', 'NUMERIC(38,15)'  ) ;
drop procedure t_BIT_NUMERIC ;



call print_message('t_BIT VARYING_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_BITVARYING_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BITVARYING FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_BITVARYING_NUMERIC('BIT VARYING', 'NUMERIC(38,15)'  ) ;
drop procedure t_BITVARYING_NUMERIC ;



call print_message('t_CHAR_NUMERIC. This scenario is a success.');
create or replace procedure t_CHAR_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_VARCHAR_NUMBER FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_CHAR_NUMERIC('CHAR', 'NUMERIC(38,15)'  ) ;
drop procedure t_CHAR_NUMERIC ;



call print_message('t_VARCHAR_NUMERIC. This scenario is a success.');
create or replace procedure t_VARCHAR_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_VARCHAR_NUMBER FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_VARCHAR_NUMERIC('VARCHAR', 'NUMERIC(38,15)'  ) ;
drop procedure t_VARCHAR_NUMERIC ;



call print_message('t_SET_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_SET_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_SET FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_SET_NUMERIC('SET', 'NUMERIC(38,15)'  ) ;
drop procedure t_SET_NUMERIC ;



call print_message('t_MULTISET_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_MULTISET_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_MULTISET FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_MULTISET_NUMERIC('MULTISET', 'NUMERIC(38,15)'  ) ;
drop procedure t_MULTISET_NUMERIC ;



call print_message('t_LIST_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_LIST_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_LIST FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_LIST_NUMERIC('LIST', 'NUMERIC(38,15)'  ) ;
drop procedure t_LIST_NUMERIC ;



call print_message('t_ENUM_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_ENUM_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_ENUM FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_ENUM_NUMERIC('ENUM', 'NUMERIC(38,15)'  ) ;
drop procedure t_ENUM_NUMERIC ;



call print_message('t_BLOB_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_BLOB_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_BLOB FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_BLOB_NUMERIC('BLOB', 'NUMERIC(38,15)'  ) ;
drop procedure t_BLOB_NUMERIC ;



call print_message('t_CLOB_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_CLOB_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_CLOB FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_CLOB_NUMERIC('CLOB', 'NUMERIC(38,15)'  ) ;
drop procedure t_CLOB_NUMERIC ;



call print_message('t_JSON_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_JSON_NUMERIC(param_type string, variables_type string ) as 
     CURSOR my_cursor1 IS 
          SELECT T_JSON FROM plcsql_type_tbl WHERE ID = 1 ;

   VAR NUMERIC(38,15)  ;
begin
    OPEN my_cursor1 ; 
    LOOP 
        FETCH my_cursor1 INTO VAR;
        EXIT WHEN my_cursor1%NOTFOUND;
        dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    END LOOP;
    CLOSE my_cursor1;
    
end;
call t_JSON_NUMERIC('JSON', 'NUMERIC(38,15)'  ) ;
drop procedure t_JSON_NUMERIC ;

drop table IF EXISTS plcsql_type_tbl;

drop procedure print_message;

--+ server-message off
