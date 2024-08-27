--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_CLOB. This scenario is a failure.');
create or replace procedure t_DATETIME_CLOB(param_type string, variables_type string, param DATETIME ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_CLOB('DATETIME', 'CLOB', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_CLOB ;


call print_message('t_DATETIMELTZ_CLOB. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_CLOB(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_CLOB('DATETIMELTZ', 'CLOB', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_CLOB ;


call print_message('t_DATETIMETZ_CLOB. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_CLOB(param_type string, variables_type string, param DATETIMETZ ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_CLOB('DATETIMETZ', 'CLOB', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_CLOB ;


call print_message('t_DATE_CLOB. This scenario is a failure.');
create or replace procedure t_DATE_CLOB(param_type string, variables_type string, param DATE ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_CLOB('DATE', 'CLOB', DATE'2008-10-31' ) ;
drop procedure t_DATE_CLOB ;


call print_message('t_TIME_CLOB. This scenario is a failure.');
create or replace procedure t_TIME_CLOB(param_type string, variables_type string, param TIME ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_CLOB('TIME', 'CLOB', TIME'13:15:45' ) ;
drop procedure t_TIME_CLOB ;


call print_message('t_TIMESTAMP_CLOB. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_CLOB(param_type string, variables_type string, param TIMESTAMP ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_CLOB('TIMESTAMP', 'CLOB', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_CLOB ;


call print_message('t_TIMESTAMPLTZ_CLOB. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_CLOB(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_CLOB('TIMESTAMPLTZ', 'CLOB', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_CLOB ;


call print_message('t_TIMESTAMPTZ_CLOB. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_CLOB(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_CLOB('TIMESTAMPTZ', 'CLOB', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_CLOB ;


call print_message('t_DOUBLE_CLOB. This scenario is a failure.');
create or replace procedure t_DOUBLE_CLOB(param_type string, variables_type string, param DOUBLE ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_CLOB('DOUBLE', 'CLOB', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_CLOB ;


call print_message('t_FLOAT_CLOB. This scenario is a failure.');
create or replace procedure t_FLOAT_CLOB(param_type string, variables_type string, param FLOAT ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_CLOB('FLOAT', 'CLOB', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_CLOB ;


call print_message('t_NUMERIC(8,4)_CLOB. This scenario is a failure.');
create or replace procedure t_NUMERIC_CLOB(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_CLOB('NUMERIC(8,4)', 'CLOB', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_CLOB ;


call print_message('t_BIGINT_CLOB. This scenario is a failure.');
create or replace procedure t_BIGINT_CLOB(param_type string, variables_type string, param BIGINT ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_CLOB('BIGINT', 'CLOB', decode('CLOB', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_CLOB ;


call print_message('t_INT_CLOB. This scenario is a failure.');
create or replace procedure t_INT_CLOB(param_type string, variables_type string, param INT ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_CLOB('INT', 'CLOB', decode('CLOB', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_CLOB ;


call print_message('t_SHORT_CLOB. This scenario is a failure.');
create or replace procedure t_SHORT_CLOB(param_type string, variables_type string, param SHORT ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_CLOB('SHORT', 'CLOB', decode('CLOB', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_CLOB ;


call print_message('t_BIT(8)_CLOB. This scenario is a failure.');
create or replace procedure t_BIT_CLOB(param_type string, variables_type string, param BIT(8) ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_CLOB('BIT(8)', 'CLOB', 0xaa ) ;
drop procedure t_BIT_CLOB ;


call print_message('t_BIT VARYING_CLOB. This scenario is a failure.');
create or replace procedure t_BITVARYING_CLOB(param_type string, variables_type string, param BIT VARYING ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_CLOB('BIT VARYING', 'CLOB', 0xaa ) ;
drop procedure t_BITVARYING_CLOB ;


call print_message('t_CHAR_CLOB. This scenario is a failure.');
create or replace procedure t_CHAR_CLOB(param_type string, variables_type string, param CHAR ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_CLOB('CHAR', 'CLOB', 'CHAR CUBRID' ) ;
drop procedure t_CHAR_CLOB ;


call print_message('t_VARCHAR_CLOB. This scenario is a failure.');
create or replace procedure t_VARCHAR_CLOB(param_type string, variables_type string, param VARCHAR ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_CLOB('VARCHAR', 'CLOB', 'VARCHAR CUBRID' ) ;
drop procedure t_VARCHAR_CLOB ;


call print_message('t_SET_CLOB. This scenario is a failure.');
create or replace procedure t_SET_CLOB(param_type string, variables_type string, param SET ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_CLOB('SET', 'CLOB', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_CLOB ;


call print_message('t_MULTISET_CLOB. This scenario is a failure.');
create or replace procedure t_MULTISET_CLOB(param_type string, variables_type string, param MULTISET ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_CLOB('MULTISET', 'CLOB', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_CLOB ;


call print_message('t_LIST_CLOB. This scenario is a failure.');
create or replace procedure t_LIST_CLOB(param_type string, variables_type string, param LIST ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_CLOB('LIST', 'CLOB', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_CLOB ;


call print_message('t_ENUM_CLOB. This scenario is a failure.');
create or replace procedure t_ENUM_CLOB(param_type string, variables_type string, param ENUM ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_CLOB('ENUM', 'CLOB', 'yellow' ) ;
drop procedure t_ENUM_CLOB ;


call print_message('t_BLOB_CLOB. This scenario is a failure.');
create or replace procedure t_BLOB_CLOB(param_type string, variables_type string, param BLOB ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_CLOB('BLOB', 'CLOB', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_CLOB ;


call print_message('t_CLOB_CLOB. This scenario is a failure.');
create or replace procedure t_CLOB_CLOB(param_type string, variables_type string, param CLOB ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_CLOB('CLOB', 'CLOB', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_CLOB ;


call print_message('t_JSON_CLOB. This scenario is a failure.');
create or replace procedure t_JSON_CLOB(param_type string, variables_type string, param JSON ) as 
VAR CLOB := param ;
VAR1 CLOB  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_CLOB('JSON', 'CLOB', '{"a":1}' ) ;
drop procedure t_JSON_CLOB ;
drop procedure print_message;

--+ server-message off
