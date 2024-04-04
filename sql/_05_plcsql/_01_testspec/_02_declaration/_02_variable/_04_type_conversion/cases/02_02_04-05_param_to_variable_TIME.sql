--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIME. This scenario is a success.');
create or replace procedure t_DATETIME_TIME(param_type string, variables_type string, param DATETIME ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_TIME('DATETIME', 'TIME', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_TIME ;


call print_message('t_DATETIMELTZ_TIME. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_TIME(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_TIME('DATETIMELTZ', 'TIME', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_TIME ;


call print_message('t_DATETIMETZ_TIME. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_TIME(param_type string, variables_type string, param DATETIMETZ ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_TIME('DATETIMETZ', 'TIME', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_TIME ;


call print_message('t_DATE_TIME. This scenario is a failure.');
create or replace procedure t_DATE_TIME(param_type string, variables_type string, param DATE ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_TIME('DATE', 'TIME', DATE'2008-10-31' ) ;
drop procedure t_DATE_TIME ;


call print_message('t_TIME_TIME. This scenario is a success.');
create or replace procedure t_TIME_TIME(param_type string, variables_type string, param TIME ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_TIME('TIME', 'TIME', TIME'13:15:45' ) ;
drop procedure t_TIME_TIME ;


call print_message('t_TIMESTAMP_TIME. This scenario is a success.');
create or replace procedure t_TIMESTAMP_TIME(param_type string, variables_type string, param TIMESTAMP ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_TIME('TIMESTAMP', 'TIME', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_TIME ;


call print_message('t_TIMESTAMPLTZ_TIME. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_TIME(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_TIME('TIMESTAMPLTZ', 'TIME', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_TIME ;


call print_message('t_TIMESTAMPTZ_TIME. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_TIME(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_TIME('TIMESTAMPTZ', 'TIME', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_TIME ;


call print_message('t_DOUBLE_TIME. This scenario is a success.');
create or replace procedure t_DOUBLE_TIME(param_type string, variables_type string, param DOUBLE ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_TIME('DOUBLE', 'TIME', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_TIME ;


call print_message('t_FLOAT_TIME. This scenario is a success.');
create or replace procedure t_FLOAT_TIME(param_type string, variables_type string, param FLOAT ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_TIME('FLOAT', 'TIME', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_TIME ;


call print_message('t_NUMERIC(8,4)_TIME. This scenario is a failure.');
create or replace procedure t_NUMERIC_TIME(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_TIME('NUMERIC(8,4)', 'TIME', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_TIME ;


call print_message('t_BIGINT_TIME. This scenario is a success.');
create or replace procedure t_BIGINT_TIME(param_type string, variables_type string, param BIGINT ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_TIME('BIGINT', 'TIME', decode('TIME', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_TIME ;


call print_message('t_INT_TIME. This scenario is a success.');
create or replace procedure t_INT_TIME(param_type string, variables_type string, param INT ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_TIME('INT', 'TIME', decode('TIME', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_TIME ;


call print_message('t_SHORT_TIME. This scenario is a success.');
create or replace procedure t_SHORT_TIME(param_type string, variables_type string, param SHORT ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_TIME('SHORT', 'TIME', decode('TIME', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_TIME ;


call print_message('t_BIT(8)_TIME. This scenario is a failure.');
create or replace procedure t_BIT_TIME(param_type string, variables_type string, param BIT(8) ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_TIME('BIT(8)', 'TIME', 0xaa ) ;
drop procedure t_BIT_TIME ;


call print_message('t_BIT VARYING_TIME. This scenario is a failure.');
create or replace procedure t_BITVARYING_TIME(param_type string, variables_type string, param BIT VARYING ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_TIME('BIT VARYING', 'TIME', 0xaa ) ;
drop procedure t_BITVARYING_TIME ;


call print_message('t_CHAR_TIME. This scenario is a success.');
create or replace procedure t_CHAR_TIME(param_type string, variables_type string, param CHAR ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_TIME('CHAR', 'TIME', cast( '05:05:05 pm' as char(11) ) ) ;
drop procedure t_CHAR_TIME ;


call print_message('t_VARCHAR_TIME. This scenario is a success.');
create or replace procedure t_VARCHAR_TIME(param_type string, variables_type string, param VARCHAR ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_TIME('VARCHAR', 'TIME', cast( '09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_TIME ;


call print_message('t_SET_TIME. This scenario is a failure.');
create or replace procedure t_SET_TIME(param_type string, variables_type string, param SET ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_TIME('SET', 'TIME', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_TIME ;


call print_message('t_MULTISET_TIME. This scenario is a failure.');
create or replace procedure t_MULTISET_TIME(param_type string, variables_type string, param MULTISET ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_TIME('MULTISET', 'TIME', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_TIME ;


call print_message('t_LIST_TIME. This scenario is a failure.');
create or replace procedure t_LIST_TIME(param_type string, variables_type string, param LIST ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_TIME('LIST', 'TIME', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_TIME ;


call print_message('t_ENUM_TIME. This scenario is a failure.');
create or replace procedure t_ENUM_TIME(param_type string, variables_type string, param ENUM ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_TIME('ENUM', 'TIME', 'yellow' ) ;
drop procedure t_ENUM_TIME ;


call print_message('t_BLOB_TIME. This scenario is a failure.');
create or replace procedure t_BLOB_TIME(param_type string, variables_type string, param BLOB ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_TIME('BLOB', 'TIME', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_TIME ;


call print_message('t_CLOB_TIME. This scenario is a failure.');
create or replace procedure t_CLOB_TIME(param_type string, variables_type string, param CLOB ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_TIME('CLOB', 'TIME', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_TIME ;


call print_message('t_JSON_TIME. This scenario is a failure.');
create or replace procedure t_JSON_TIME(param_type string, variables_type string, param JSON ) as 
VAR TIME := param ;
VAR1 TIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_TIME('JSON', 'TIME', '{"a":1}' ) ;
drop procedure t_JSON_TIME ;
drop procedure print_message;

--+ server-message off
