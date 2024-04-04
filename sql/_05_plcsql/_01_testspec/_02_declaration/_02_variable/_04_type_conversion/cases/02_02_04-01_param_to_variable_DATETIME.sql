--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIME. This scenario is a success.');
create or replace procedure t_DATETIME_DATETIME(param_type string, variables_type string, param DATETIME ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_DATETIME('DATETIME', 'DATETIME', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_DATETIME ;


call print_message('t_DATETIMELTZ_DATETIME. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DATETIME(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_DATETIME('DATETIMELTZ', 'DATETIME', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_DATETIME ;


call print_message('t_DATETIMETZ_DATETIME. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DATETIME(param_type string, variables_type string, param DATETIMETZ ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_DATETIME('DATETIMETZ', 'DATETIME', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_DATETIME ;


call print_message('t_DATE_DATETIME. This scenario is a success.');
create or replace procedure t_DATE_DATETIME(param_type string, variables_type string, param DATE ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_DATETIME('DATE', 'DATETIME', DATE'2008-10-31' ) ;
drop procedure t_DATE_DATETIME ;


call print_message('t_TIME_DATETIME. This scenario is a failure.');
create or replace procedure t_TIME_DATETIME(param_type string, variables_type string, param TIME ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_DATETIME('TIME', 'DATETIME', TIME'13:15:45' ) ;
drop procedure t_TIME_DATETIME ;


call print_message('t_TIMESTAMP_DATETIME. This scenario is a success.');
create or replace procedure t_TIMESTAMP_DATETIME(param_type string, variables_type string, param TIMESTAMP ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_DATETIME('TIMESTAMP', 'DATETIME', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_DATETIME ;


call print_message('t_TIMESTAMPLTZ_DATETIME. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DATETIME(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_DATETIME('TIMESTAMPLTZ', 'DATETIME', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_DATETIME ;


call print_message('t_TIMESTAMPTZ_DATETIME. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DATETIME(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_DATETIME('TIMESTAMPTZ', 'DATETIME', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_DATETIME ;


call print_message('t_DOUBLE_DATETIME. This scenario is a failure.');
create or replace procedure t_DOUBLE_DATETIME(param_type string, variables_type string, param DOUBLE ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_DATETIME('DOUBLE', 'DATETIME', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_DATETIME ;


call print_message('t_FLOAT_DATETIME. This scenario is a failure.');
create or replace procedure t_FLOAT_DATETIME(param_type string, variables_type string, param FLOAT ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_DATETIME('FLOAT', 'DATETIME', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_DATETIME ;


call print_message('t_NUMERIC(8,4)_DATETIME. This scenario is a failure.');
create or replace procedure t_NUMERIC_DATETIME(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_DATETIME('NUMERIC(8,4)', 'DATETIME', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_DATETIME ;


call print_message('t_BIGINT_DATETIME. This scenario is a failure.');
create or replace procedure t_BIGINT_DATETIME(param_type string, variables_type string, param BIGINT ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_DATETIME('BIGINT', 'DATETIME', decode('DATETIME', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_DATETIME ;


call print_message('t_INT_DATETIME. This scenario is a failure.');
create or replace procedure t_INT_DATETIME(param_type string, variables_type string, param INT ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_DATETIME('INT', 'DATETIME', decode('DATETIME', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_DATETIME ;


call print_message('t_SHORT_DATETIME. This scenario is a failure.');
create or replace procedure t_SHORT_DATETIME(param_type string, variables_type string, param SHORT ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_DATETIME('SHORT', 'DATETIME', decode('DATETIME', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_DATETIME ;


call print_message('t_BIT(8)_DATETIME. This scenario is a failure.');
create or replace procedure t_BIT_DATETIME(param_type string, variables_type string, param BIT(8) ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_DATETIME('BIT(8)', 'DATETIME', 0xaa ) ;
drop procedure t_BIT_DATETIME ;


call print_message('t_BIT VARYING_DATETIME. This scenario is a failure.');
create or replace procedure t_BITVARYING_DATETIME(param_type string, variables_type string, param BIT VARYING ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_DATETIME('BIT VARYING', 'DATETIME', 0xaa ) ;
drop procedure t_BITVARYING_DATETIME ;


call print_message('t_CHAR_DATETIME. This scenario is a success.');
create or replace procedure t_CHAR_DATETIME(param_type string, variables_type string, param CHAR ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_DATETIME('CHAR', 'DATETIME', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_DATETIME ;


call print_message('t_VARCHAR_DATETIME. This scenario is a success.');
create or replace procedure t_VARCHAR_DATETIME(param_type string, variables_type string, param VARCHAR ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_DATETIME('VARCHAR', 'DATETIME', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_DATETIME ;


call print_message('t_SET_DATETIME. This scenario is a failure.');
create or replace procedure t_SET_DATETIME(param_type string, variables_type string, param SET ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_DATETIME('SET', 'DATETIME', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_DATETIME ;


call print_message('t_MULTISET_DATETIME. This scenario is a failure.');
create or replace procedure t_MULTISET_DATETIME(param_type string, variables_type string, param MULTISET ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_DATETIME('MULTISET', 'DATETIME', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_DATETIME ;


call print_message('t_LIST_DATETIME. This scenario is a failure.');
create or replace procedure t_LIST_DATETIME(param_type string, variables_type string, param LIST ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_DATETIME('LIST', 'DATETIME', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_DATETIME ;


call print_message('t_ENUM_DATETIME. This scenario is a failure.');
create or replace procedure t_ENUM_DATETIME(param_type string, variables_type string, param ENUM ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_DATETIME('ENUM', 'DATETIME', 'yellow' ) ;
drop procedure t_ENUM_DATETIME ;


call print_message('t_BLOB_DATETIME. This scenario is a failure.');
create or replace procedure t_BLOB_DATETIME(param_type string, variables_type string, param BLOB ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_DATETIME('BLOB', 'DATETIME', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_DATETIME ;


call print_message('t_CLOB_DATETIME. This scenario is a failure.');
create or replace procedure t_CLOB_DATETIME(param_type string, variables_type string, param CLOB ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_DATETIME('CLOB', 'DATETIME', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_DATETIME ;


call print_message('t_JSON_DATETIME. This scenario is a failure.');
create or replace procedure t_JSON_DATETIME(param_type string, variables_type string, param JSON ) as 
VAR DATETIME := param ;
VAR1 DATETIME  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_DATETIME('JSON', 'DATETIME', '{"a":1}' ) ;
drop procedure t_JSON_DATETIME ;
drop procedure print_message;

--+ server-message off
