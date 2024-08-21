--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_DATETIME_DATETIMETZ(param_type string, variables_type string, param DATETIME ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_DATETIMETZ('DATETIME', 'DATETIMETZ', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_DATETIMETZ ;


call print_message('t_DATETIMELTZ_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DATETIMETZ(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_DATETIMETZ('DATETIMELTZ', 'DATETIMETZ', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_DATETIMETZ ;


call print_message('t_DATETIMETZ_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DATETIMETZ(param_type string, variables_type string, param DATETIMETZ ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_DATETIMETZ('DATETIMETZ', 'DATETIMETZ', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_DATETIMETZ ;


call print_message('t_DATE_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_DATE_DATETIMETZ(param_type string, variables_type string, param DATE ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_DATETIMETZ('DATE', 'DATETIMETZ', DATE'2008-10-31' ) ;
drop procedure t_DATE_DATETIMETZ ;


call print_message('t_TIME_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_TIME_DATETIMETZ(param_type string, variables_type string, param TIME ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_DATETIMETZ('TIME', 'DATETIMETZ', TIME'13:15:45' ) ;
drop procedure t_TIME_DATETIMETZ ;


call print_message('t_TIMESTAMP_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_DATETIMETZ(param_type string, variables_type string, param TIMESTAMP ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_DATETIMETZ('TIMESTAMP', 'DATETIMETZ', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_DATETIMETZ ;


call print_message('t_TIMESTAMPLTZ_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DATETIMETZ(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_DATETIMETZ('TIMESTAMPLTZ', 'DATETIMETZ', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_DATETIMETZ ;


call print_message('t_TIMESTAMPTZ_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DATETIMETZ(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_DATETIMETZ('TIMESTAMPTZ', 'DATETIMETZ', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_DATETIMETZ ;


call print_message('t_DOUBLE_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_DOUBLE_DATETIMETZ(param_type string, variables_type string, param DOUBLE ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_DATETIMETZ('DOUBLE', 'DATETIMETZ', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_DATETIMETZ ;


call print_message('t_FLOAT_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_FLOAT_DATETIMETZ(param_type string, variables_type string, param FLOAT ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_DATETIMETZ('FLOAT', 'DATETIMETZ', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_DATETIMETZ ;


call print_message('t_NUMERIC(8,4)_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_NUMERIC_DATETIMETZ(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_DATETIMETZ('NUMERIC(8,4)', 'DATETIMETZ', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_DATETIMETZ ;


call print_message('t_BIGINT_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_BIGINT_DATETIMETZ(param_type string, variables_type string, param BIGINT ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_DATETIMETZ('BIGINT', 'DATETIMETZ', decode('DATETIMETZ', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_DATETIMETZ ;


call print_message('t_INT_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_INT_DATETIMETZ(param_type string, variables_type string, param INT ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_DATETIMETZ('INT', 'DATETIMETZ', decode('DATETIMETZ', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_DATETIMETZ ;


call print_message('t_SHORT_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_SHORT_DATETIMETZ(param_type string, variables_type string, param SHORT ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_DATETIMETZ('SHORT', 'DATETIMETZ', decode('DATETIMETZ', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_DATETIMETZ ;


call print_message('t_BIT(8)_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_BIT_DATETIMETZ(param_type string, variables_type string, param BIT(8) ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_DATETIMETZ('BIT(8)', 'DATETIMETZ', 0xaa ) ;
drop procedure t_BIT_DATETIMETZ ;


call print_message('t_BIT VARYING_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_BITVARYING_DATETIMETZ(param_type string, variables_type string, param BIT VARYING ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_DATETIMETZ('BIT VARYING', 'DATETIMETZ', 0xaa ) ;
drop procedure t_BITVARYING_DATETIMETZ ;


call print_message('t_CHAR_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_CHAR_DATETIMETZ(param_type string, variables_type string, param CHAR ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_DATETIMETZ('CHAR', 'DATETIMETZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_DATETIMETZ ;


call print_message('t_VARCHAR_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_VARCHAR_DATETIMETZ(param_type string, variables_type string, param VARCHAR ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_DATETIMETZ('VARCHAR', 'DATETIMETZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_DATETIMETZ ;


call print_message('t_SET_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_SET_DATETIMETZ(param_type string, variables_type string, param SET ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_DATETIMETZ('SET', 'DATETIMETZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_DATETIMETZ ;


call print_message('t_MULTISET_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_MULTISET_DATETIMETZ(param_type string, variables_type string, param MULTISET ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_DATETIMETZ('MULTISET', 'DATETIMETZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_DATETIMETZ ;


call print_message('t_LIST_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_LIST_DATETIMETZ(param_type string, variables_type string, param LIST ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_DATETIMETZ('LIST', 'DATETIMETZ', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_DATETIMETZ ;


call print_message('t_ENUM_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_ENUM_DATETIMETZ(param_type string, variables_type string, param ENUM ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_DATETIMETZ('ENUM', 'DATETIMETZ', 'yellow' ) ;
drop procedure t_ENUM_DATETIMETZ ;


call print_message('t_BLOB_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_BLOB_DATETIMETZ(param_type string, variables_type string, param BLOB ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_DATETIMETZ('BLOB', 'DATETIMETZ', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_DATETIMETZ ;


call print_message('t_CLOB_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_CLOB_DATETIMETZ(param_type string, variables_type string, param CLOB ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_DATETIMETZ('CLOB', 'DATETIMETZ', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_DATETIMETZ ;


call print_message('t_JSON_DATETIMETZ. This scenario is a failure.');
create or replace procedure t_JSON_DATETIMETZ(param_type string, variables_type string, param JSON ) as 
VAR DATETIMETZ := param ;
VAR1 DATETIMETZ  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_DATETIMETZ('JSON', 'DATETIMETZ', '{"a":1}' ) ;
drop procedure t_JSON_DATETIMETZ ;
drop procedure print_message;

--+ server-message off
