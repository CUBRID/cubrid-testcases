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


call print_message('t_DATETIME_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIME_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_DATETIME INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATETIME INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATETIME_DOUBLE('DATETIME', 'DOUBLE'  ) ;
drop procedure t_DATETIME_DOUBLE ;



call print_message('t_DATETIMELTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_DATETIMELTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATETIMELTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATETIMELTZ_DOUBLE('DATETIMELTZ', 'DOUBLE'  ) ;
drop procedure t_DATETIMELTZ_DOUBLE ;



call print_message('t_DATETIMETZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_DATETIMETZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATETIMETZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATETIMETZ_DOUBLE('DATETIMETZ', 'DOUBLE'  ) ;
drop procedure t_DATETIMETZ_DOUBLE ;



call print_message('t_DATE_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATE_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_DATE INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATE INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATE_DOUBLE('DATE', 'DOUBLE'  ) ;
drop procedure t_DATE_DOUBLE ;



call print_message('t_TIME_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIME_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_TIME INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIME INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIME_DOUBLE('TIME', 'DOUBLE'  ) ;
drop procedure t_TIME_DOUBLE ;



call print_message('t_TIMESTAMP_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_TIMESTAMP INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIMESTAMP INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIMESTAMP_DOUBLE('TIMESTAMP', 'DOUBLE'  ) ;
drop procedure t_TIMESTAMP_DOUBLE ;



call print_message('t_TIMESTAMPLTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_TIMESTAMPLTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIMESTAMPLTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIMESTAMPLTZ_DOUBLE('TIMESTAMPLTZ', 'DOUBLE'  ) ;
drop procedure t_TIMESTAMPLTZ_DOUBLE ;



call print_message('t_TIMESTAMPTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_TIMESTAMPTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIMESTAMPTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIMESTAMPTZ_DOUBLE('TIMESTAMPTZ', 'DOUBLE'  ) ;
drop procedure t_TIMESTAMPTZ_DOUBLE ;



call print_message('t_DOUBLE_DOUBLE. This scenario is a success.');
create or replace procedure t_DOUBLE_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_DOUBLE INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DOUBLE INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DOUBLE_DOUBLE('DOUBLE', 'DOUBLE'  ) ;
drop procedure t_DOUBLE_DOUBLE ;



call print_message('t_FLOAT_DOUBLE. This scenario is a success.');
create or replace procedure t_FLOAT_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_FLOAT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_FLOAT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


    SELECT  T_REAL INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT T_REAL INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
end;
call t_FLOAT_DOUBLE('FLOAT', 'DOUBLE'  ) ;
drop procedure t_FLOAT_DOUBLE ;

call print_message('t_NUMERIC_DOUBLE. This scenario is a success.');
create or replace procedure t_NUMERIC_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_NUMERIC INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_NUMERIC INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


    SELECT  T_DECIMAL INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT T_DECIMAL INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
end;
call t_NUMERIC_DOUBLE('NUMERIC(8,4)', 'DOUBLE'  ) ;
drop procedure t_NUMERIC_DOUBLE ;



call print_message('t_BIGINT_DOUBLE. This scenario is a success.');
create or replace procedure t_BIGINT_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_BIGINT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BIGINT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BIGINT_DOUBLE('BIGINT', 'DOUBLE'  ) ;
drop procedure t_BIGINT_DOUBLE ;



call print_message('t_INT_DOUBLE. This scenario is a success.');
create or replace procedure t_INT_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_INT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_INT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


    SELECT  T_INTEGER INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT T_INTEGER INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
end;
call t_INT_DOUBLE('INT', 'DOUBLE'  ) ;
drop procedure t_INT_DOUBLE ;



call print_message('t_SHORT_DOUBLE. This scenario is a success.');
create or replace procedure t_SHORT_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_SHORT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_SHORT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


    SELECT  T_SMALLINT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT T_SMALLINT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
end;
call t_SHORT_DOUBLE('SHORT', 'DOUBLE'  ) ;
drop procedure t_SHORT_DOUBLE ;



call print_message('t_BIT(8)_DOUBLE. This scenario is a failure.');
create or replace procedure t_BIT_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_BIT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BIT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BIT_DOUBLE('BIT(8)', 'DOUBLE'  ) ;
drop procedure t_BIT_DOUBLE ;



call print_message('t_BIT VARYING_DOUBLE. This scenario is a failure.');
create or replace procedure t_BITVARYING_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_BITVARYING INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BITVARYING INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BITVARYING_DOUBLE('BIT VARYING', 'DOUBLE'  ) ;
drop procedure t_BITVARYING_DOUBLE ;



call print_message('t_CHAR_DOUBLE. This scenario is a success.');
create or replace procedure t_CHAR_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_CHAR_DOUBLE('CHAR', 'DOUBLE'  ) ;
drop procedure t_CHAR_DOUBLE ;



call print_message('t_VARCHAR_DOUBLE. This scenario is a success.');
create or replace procedure t_VARCHAR_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_VARCHAR_DOUBLE('VARCHAR', 'DOUBLE'  ) ;
drop procedure t_VARCHAR_DOUBLE ;



call print_message('t_SET_DOUBLE. This scenario is a failure.');
create or replace procedure t_SET_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_SET INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_SET INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_SET_DOUBLE('SET', 'DOUBLE'  ) ;
drop procedure t_SET_DOUBLE ;



call print_message('t_MULTISET_DOUBLE. This scenario is a failure.');
create or replace procedure t_MULTISET_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_MULTISET INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_MULTISET INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_MULTISET_DOUBLE('MULTISET', 'DOUBLE'  ) ;
drop procedure t_MULTISET_DOUBLE ;



call print_message('t_LIST_DOUBLE. This scenario is a failure.');
create or replace procedure t_LIST_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_LIST INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_LIST INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_LIST_DOUBLE('LIST', 'DOUBLE'  ) ;
drop procedure t_LIST_DOUBLE ;



call print_message('t_ENUM_DOUBLE. This scenario is a failure.');
create or replace procedure t_ENUM_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_ENUM INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_ENUM INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_ENUM_DOUBLE('ENUM', 'DOUBLE'  ) ;
drop procedure t_ENUM_DOUBLE ;



call print_message('t_BLOB_DOUBLE. This scenario is a failure.');
create or replace procedure t_BLOB_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_BLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BLOB_DOUBLE('BLOB', 'DOUBLE'  ) ;
drop procedure t_BLOB_DOUBLE ;



call print_message('t_CLOB_DOUBLE. This scenario is a failure.');
create or replace procedure t_CLOB_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_CLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_CLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_CLOB_DOUBLE('CLOB', 'DOUBLE'  ) ;
drop procedure t_CLOB_DOUBLE ;



call print_message('t_JSON_DOUBLE. This scenario is a failure.');
create or replace procedure t_JSON_DOUBLE(param_type string, variables_type string ) as 
VAR DOUBLE  ;
begin
    SELECT T_JSON INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_JSON INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_JSON_DOUBLE('JSON', 'DOUBLE'  ) ;
drop procedure t_JSON_DOUBLE ;

drop table IF EXISTS plcsql_type_tbl;

drop procedure print_message;

--+ server-message off
