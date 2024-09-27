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


call print_message('t_DATETIME_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIME_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_DATETIME INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATETIME INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATETIME_SHORT('DATETIME', 'SHORT'  ) ;
drop procedure t_DATETIME_SHORT ;



call print_message('t_DATETIMELTZ_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_DATETIMELTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATETIMELTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATETIMELTZ_SHORT('DATETIMELTZ', 'SHORT'  ) ;
drop procedure t_DATETIMELTZ_SHORT ;



call print_message('t_DATETIMETZ_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_DATETIMETZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATETIMETZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATETIMETZ_SHORT('DATETIMETZ', 'SHORT'  ) ;
drop procedure t_DATETIMETZ_SHORT ;



call print_message('t_DATE_SHORT. This scenario is a failure.');
create or replace procedure t_DATE_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_DATE INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DATE INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DATE_SHORT('DATE', 'SHORT'  ) ;
drop procedure t_DATE_SHORT ;



call print_message('t_TIME_SHORT. This scenario is a failure.');
create or replace procedure t_TIME_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_TIME INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIME INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIME_SHORT('TIME', 'SHORT'  ) ;
drop procedure t_TIME_SHORT ;



call print_message('t_TIMESTAMP_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_TIMESTAMP INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIMESTAMP INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIMESTAMP_SHORT('TIMESTAMP', 'SHORT'  ) ;
drop procedure t_TIMESTAMP_SHORT ;



call print_message('t_TIMESTAMPLTZ_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_TIMESTAMPLTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIMESTAMPLTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIMESTAMPLTZ_SHORT('TIMESTAMPLTZ', 'SHORT'  ) ;
drop procedure t_TIMESTAMPLTZ_SHORT ;



call print_message('t_TIMESTAMPTZ_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_TIMESTAMPTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_TIMESTAMPTZ INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_TIMESTAMPTZ_SHORT('TIMESTAMPTZ', 'SHORT'  ) ;
drop procedure t_TIMESTAMPTZ_SHORT ;



call print_message('t_DOUBLE_SHORT. This scenario is a success.');
create or replace procedure t_DOUBLE_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_DOUBLE INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_DOUBLE INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_DOUBLE_SHORT('DOUBLE', 'SHORT'  ) ;
drop procedure t_DOUBLE_SHORT ;



call print_message('t_FLOAT_SHORT. This scenario is a success.');
create or replace procedure t_FLOAT_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
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
call t_FLOAT_SHORT('FLOAT', 'SHORT'  ) ;
drop procedure t_FLOAT_SHORT ;

call print_message('t_NUMERIC_SHORT. This scenario is a success.');
create or replace procedure t_NUMERIC_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
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
call t_NUMERIC_SHORT('NUMERIC(8,4)', 'SHORT'  ) ;
drop procedure t_NUMERIC_SHORT ;



call print_message('t_BIGINT_SHORT. This scenario is a success.');
create or replace procedure t_BIGINT_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_BIGINT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BIGINT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BIGINT_SHORT('BIGINT', 'SHORT'  ) ;
drop procedure t_BIGINT_SHORT ;



call print_message('t_INT_SHORT. This scenario is a success.');
create or replace procedure t_INT_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
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
call t_INT_SHORT('INT', 'SHORT'  ) ;
drop procedure t_INT_SHORT ;



call print_message('t_SHORT_SHORT. This scenario is a success.');
create or replace procedure t_SHORT_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
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
call t_SHORT_SHORT('SHORT', 'SHORT'  ) ;
drop procedure t_SHORT_SHORT ;



call print_message('t_BIT(8)_SHORT. This scenario is a failure.');
create or replace procedure t_BIT_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_BIT INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BIT INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BIT_SHORT('BIT(8)', 'SHORT'  ) ;
drop procedure t_BIT_SHORT ;



call print_message('t_BIT VARYING_SHORT. This scenario is a failure.');
create or replace procedure t_BITVARYING_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_BITVARYING INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BITVARYING INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BITVARYING_SHORT('BIT VARYING', 'SHORT'  ) ;
drop procedure t_BITVARYING_SHORT ;



call print_message('t_CHAR_SHORT. This scenario is a success.');
create or replace procedure t_CHAR_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_CHAR_SHORT('CHAR', 'SHORT'  ) ;
drop procedure t_CHAR_SHORT ;



call print_message('t_VARCHAR_SHORT. This scenario is a success.');
create or replace procedure t_VARCHAR_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_VARCHAR_NUMBER INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_VARCHAR_SHORT('VARCHAR', 'SHORT'  ) ;
drop procedure t_VARCHAR_SHORT ;



call print_message('t_SET_SHORT. This scenario is a failure.');
create or replace procedure t_SET_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_SET INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_SET INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_SET_SHORT('SET', 'SHORT'  ) ;
drop procedure t_SET_SHORT ;



call print_message('t_MULTISET_SHORT. This scenario is a failure.');
create or replace procedure t_MULTISET_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_MULTISET INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_MULTISET INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_MULTISET_SHORT('MULTISET', 'SHORT'  ) ;
drop procedure t_MULTISET_SHORT ;



call print_message('t_LIST_SHORT. This scenario is a failure.');
create or replace procedure t_LIST_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_LIST INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_LIST INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_LIST_SHORT('LIST', 'SHORT'  ) ;
drop procedure t_LIST_SHORT ;



call print_message('t_ENUM_SHORT. This scenario is a failure.');
create or replace procedure t_ENUM_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_ENUM INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_ENUM INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_ENUM_SHORT('ENUM', 'SHORT'  ) ;
drop procedure t_ENUM_SHORT ;



call print_message('t_BLOB_SHORT. This scenario is a failure.');
create or replace procedure t_BLOB_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_BLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_BLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_BLOB_SHORT('BLOB', 'SHORT'  ) ;
drop procedure t_BLOB_SHORT ;



call print_message('t_CLOB_SHORT. This scenario is a failure.');
create or replace procedure t_CLOB_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_CLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_CLOB INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_CLOB_SHORT('CLOB', 'SHORT'  ) ;
drop procedure t_CLOB_SHORT ;



call print_message('t_JSON_SHORT. This scenario is a failure.');
create or replace procedure t_JSON_SHORT(param_type string, variables_type string ) as 
VAR SHORT  ;
begin
    SELECT T_JSON INTO VAR FROM plcsql_type_tbl WHERE ID = 1 ;
    dbms_output.put_line('select_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 
    SELECT  T_JSON INTO VAR FROM plcsql_type_tbl WHERE ID = 2 ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', SELECT column=>INTO variables = '|| VAR ); 


end;
call t_JSON_SHORT('JSON', 'SHORT'  ) ;
drop procedure t_JSON_SHORT ;

drop table IF EXISTS plcsql_type_tbl;

drop procedure print_message;

--+ server-message off
