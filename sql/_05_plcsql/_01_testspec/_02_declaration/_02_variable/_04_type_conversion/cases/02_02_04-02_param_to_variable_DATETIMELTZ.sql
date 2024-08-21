--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATETIME_DATETIMELTZ(param_type string, variables_type string, param DATETIME ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_DATETIMELTZ('DATETIME', 'DATETIMELTZ', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_DATETIMELTZ ;


call print_message('t_DATETIMELTZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DATETIMELTZ(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_DATETIMELTZ('DATETIMELTZ', 'DATETIMELTZ', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_DATETIMELTZ ;


call print_message('t_DATETIMETZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DATETIMELTZ(param_type string, variables_type string, param DATETIMETZ ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_DATETIMELTZ('DATETIMETZ', 'DATETIMELTZ', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_DATETIMELTZ ;


call print_message('t_DATE_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DATE_DATETIMELTZ(param_type string, variables_type string, param DATE ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_DATETIMELTZ('DATE', 'DATETIMELTZ', DATE'2008-10-31' ) ;
drop procedure t_DATE_DATETIMELTZ ;


call print_message('t_TIME_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIME_DATETIMELTZ(param_type string, variables_type string, param TIME ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_DATETIMELTZ('TIME', 'DATETIMELTZ', TIME'13:15:45' ) ;
drop procedure t_TIME_DATETIMELTZ ;


call print_message('t_TIMESTAMP_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_DATETIMELTZ(param_type string, variables_type string, param TIMESTAMP ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_DATETIMELTZ('TIMESTAMP', 'DATETIMELTZ', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_DATETIMELTZ ;


call print_message('t_TIMESTAMPLTZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DATETIMELTZ(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_DATETIMELTZ('TIMESTAMPLTZ', 'DATETIMELTZ', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_DATETIMELTZ ;


call print_message('t_TIMESTAMPTZ_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DATETIMELTZ(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_DATETIMELTZ('TIMESTAMPTZ', 'DATETIMELTZ', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_DATETIMELTZ ;


call print_message('t_DOUBLE_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_DOUBLE_DATETIMELTZ(param_type string, variables_type string, param DOUBLE ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_DATETIMELTZ('DOUBLE', 'DATETIMELTZ', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_DATETIMELTZ ;


call print_message('t_FLOAT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_FLOAT_DATETIMELTZ(param_type string, variables_type string, param FLOAT ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_DATETIMELTZ('FLOAT', 'DATETIMELTZ', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_DATETIMELTZ ;


call print_message('t_NUMERIC(8,4)_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_NUMERIC_DATETIMELTZ(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_DATETIMELTZ('NUMERIC(8,4)', 'DATETIMELTZ', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_DATETIMELTZ ;


call print_message('t_BIGINT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BIGINT_DATETIMELTZ(param_type string, variables_type string, param BIGINT ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_DATETIMELTZ('BIGINT', 'DATETIMELTZ', decode('DATETIMELTZ', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_DATETIMELTZ ;


call print_message('t_INT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_INT_DATETIMELTZ(param_type string, variables_type string, param INT ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_DATETIMELTZ('INT', 'DATETIMELTZ', decode('DATETIMELTZ', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_DATETIMELTZ ;


call print_message('t_SHORT_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_SHORT_DATETIMELTZ(param_type string, variables_type string, param SHORT ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_DATETIMELTZ('SHORT', 'DATETIMELTZ', decode('DATETIMELTZ', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_DATETIMELTZ ;


call print_message('t_BIT(8)_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BIT_DATETIMELTZ(param_type string, variables_type string, param BIT(8) ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_DATETIMELTZ('BIT(8)', 'DATETIMELTZ', 0xaa ) ;
drop procedure t_BIT_DATETIMELTZ ;


call print_message('t_BIT VARYING_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BITVARYING_DATETIMELTZ(param_type string, variables_type string, param BIT VARYING ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_DATETIMELTZ('BIT VARYING', 'DATETIMELTZ', 0xaa ) ;
drop procedure t_BITVARYING_DATETIMELTZ ;


call print_message('t_CHAR_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_CHAR_DATETIMELTZ(param_type string, variables_type string, param CHAR ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_DATETIMELTZ('CHAR', 'DATETIMELTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_DATETIMELTZ ;


call print_message('t_VARCHAR_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_VARCHAR_DATETIMELTZ(param_type string, variables_type string, param VARCHAR ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_DATETIMELTZ('VARCHAR', 'DATETIMELTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_DATETIMELTZ ;


call print_message('t_SET_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_SET_DATETIMELTZ(param_type string, variables_type string, param SET ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_DATETIMELTZ('SET', 'DATETIMELTZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_DATETIMELTZ ;


call print_message('t_MULTISET_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_MULTISET_DATETIMELTZ(param_type string, variables_type string, param MULTISET ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_DATETIMELTZ('MULTISET', 'DATETIMELTZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_DATETIMELTZ ;


call print_message('t_LIST_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_LIST_DATETIMELTZ(param_type string, variables_type string, param LIST ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_DATETIMELTZ('LIST', 'DATETIMELTZ', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_DATETIMELTZ ;


call print_message('t_ENUM_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_ENUM_DATETIMELTZ(param_type string, variables_type string, param ENUM ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_DATETIMELTZ('ENUM', 'DATETIMELTZ', 'yellow' ) ;
drop procedure t_ENUM_DATETIMELTZ ;


call print_message('t_BLOB_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_BLOB_DATETIMELTZ(param_type string, variables_type string, param BLOB ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_DATETIMELTZ('BLOB', 'DATETIMELTZ', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_DATETIMELTZ ;


call print_message('t_CLOB_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_CLOB_DATETIMELTZ(param_type string, variables_type string, param CLOB ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_DATETIMELTZ('CLOB', 'DATETIMELTZ', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_DATETIMELTZ ;


call print_message('t_JSON_DATETIMELTZ. This scenario is a failure.');
create or replace procedure t_JSON_DATETIMELTZ(param_type string, variables_type string, param JSON ) as 
VAR DATETIMELTZ := param ;
VAR1 DATETIMELTZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_DATETIMELTZ('JSON', 'DATETIMELTZ', '{"a":1}' ) ;
drop procedure t_JSON_DATETIMELTZ ;
drop procedure print_message;

--+ server-message off
