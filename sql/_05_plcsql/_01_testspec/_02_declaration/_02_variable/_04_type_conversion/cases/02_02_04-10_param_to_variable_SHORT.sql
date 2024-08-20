--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIME_SHORT(param_type string, variables_type string, param DATETIME ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_SHORT('DATETIME', 'SHORT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_SHORT ;


call print_message('t_DATETIMELTZ_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_SHORT(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_SHORT('DATETIMELTZ', 'SHORT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_SHORT ;


call print_message('t_DATETIMETZ_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_SHORT(param_type string, variables_type string, param DATETIMETZ ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_SHORT('DATETIMETZ', 'SHORT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_SHORT ;


call print_message('t_DATE_SHORT. This scenario is a failure.');
create or replace procedure t_DATE_SHORT(param_type string, variables_type string, param DATE ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_SHORT('DATE', 'SHORT', DATE'2008-10-31' ) ;
drop procedure t_DATE_SHORT ;


call print_message('t_TIME_SHORT. This scenario is a failure.');
create or replace procedure t_TIME_SHORT(param_type string, variables_type string, param TIME ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_SHORT('TIME', 'SHORT', TIME'13:15:45' ) ;
drop procedure t_TIME_SHORT ;


call print_message('t_TIMESTAMP_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_SHORT(param_type string, variables_type string, param TIMESTAMP ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_SHORT('TIMESTAMP', 'SHORT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_SHORT ;


call print_message('t_TIMESTAMPLTZ_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_SHORT(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_SHORT('TIMESTAMPLTZ', 'SHORT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_SHORT ;


call print_message('t_TIMESTAMPTZ_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_SHORT(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_SHORT('TIMESTAMPTZ', 'SHORT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_SHORT ;


call print_message('t_DOUBLE_SHORT. This scenario is a success.');
create or replace procedure t_DOUBLE_SHORT(param_type string, variables_type string, param DOUBLE ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_SHORT('DOUBLE', 'SHORT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_SHORT ;


call print_message('t_FLOAT_SHORT. This scenario is a success.');
create or replace procedure t_FLOAT_SHORT(param_type string, variables_type string, param FLOAT ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_SHORT('FLOAT', 'SHORT', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_SHORT ;


call print_message('t_NUMERIC_SHORT. This scenario is a success.');
create or replace procedure t_NUMERIC_SHORT(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_SHORT('NUMERIC(4,4)', 'SHORT', cast( 0.123456789 as numeric(4,4) ) ) ;
call t_NUMERIC_SHORT('NUMERIC(8,4)', 'SHORT', cast( 0.123456789 as numeric(8,4) ) ) ;
drop procedure t_NUMERIC_SHORT ;


call print_message('t_BIGINT_SHORT. This scenario is a success.');
create or replace procedure t_BIGINT_SHORT(param_type string, variables_type string, param BIGINT ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_SHORT('BIGINT', 'SHORT', decode('SHORT', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_SHORT ;


call print_message('t_INT_SHORT. This scenario is a success.');
create or replace procedure t_INT_SHORT(param_type string, variables_type string, param INT ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_SHORT('INT', 'SHORT', decode('SHORT', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_SHORT ;


call print_message('t_SHORT_SHORT. This scenario is a success.');
create or replace procedure t_SHORT_SHORT(param_type string, variables_type string, param SHORT ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_SHORT('SHORT', 'SHORT', decode('SHORT', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_SHORT ;


call print_message('t_BIT(8)_SHORT. This scenario is a failure.');
create or replace procedure t_BIT_SHORT(param_type string, variables_type string, param BIT(8) ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_SHORT('BIT(8)', 'SHORT', 0xaa ) ;
drop procedure t_BIT_SHORT ;


call print_message('t_BIT VARYING_SHORT. This scenario is a failure.');
create or replace procedure t_BITVARYING_SHORT(param_type string, variables_type string, param BIT VARYING ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_SHORT('BIT VARYING', 'SHORT', 0xaa ) ;
drop procedure t_BITVARYING_SHORT ;


call print_message('t_CHAR_SHORT. This scenario is a success.');
create or replace procedure t_CHAR_SHORT(param_type string, variables_type string, param CHAR ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_SHORT('CHAR', 'SHORT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_SHORT ;


call print_message('t_VARCHAR_SHORT. This scenario is a success.');
create or replace procedure t_VARCHAR_SHORT(param_type string, variables_type string, param VARCHAR ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_SHORT('VARCHAR', 'SHORT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_SHORT ;


call print_message('t_SET_SHORT. This scenario is a failure.');
create or replace procedure t_SET_SHORT(param_type string, variables_type string, param SET ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_SHORT('SET', 'SHORT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_SHORT ;


call print_message('t_MULTISET_SHORT. This scenario is a failure.');
create or replace procedure t_MULTISET_SHORT(param_type string, variables_type string, param MULTISET ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_SHORT('MULTISET', 'SHORT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_SHORT ;


call print_message('t_LIST_SHORT. This scenario is a failure.');
create or replace procedure t_LIST_SHORT(param_type string, variables_type string, param LIST ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_SHORT('LIST', 'SHORT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_SHORT ;


call print_message('t_ENUM_SHORT. This scenario is a failure.');
create or replace procedure t_ENUM_SHORT(param_type string, variables_type string, param ENUM ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_SHORT('ENUM', 'SHORT', 'yellow' ) ;
drop procedure t_ENUM_SHORT ;


call print_message('t_BLOB_SHORT. This scenario is a failure.');
create or replace procedure t_BLOB_SHORT(param_type string, variables_type string, param BLOB ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_SHORT('BLOB', 'SHORT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_SHORT ;


call print_message('t_CLOB_SHORT. This scenario is a failure.');
create or replace procedure t_CLOB_SHORT(param_type string, variables_type string, param CLOB ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_SHORT('CLOB', 'SHORT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_SHORT ;


call print_message('t_JSON_SHORT. This scenario is a failure.');
create or replace procedure t_JSON_SHORT(param_type string, variables_type string, param JSON ) as 
VAR SHORT := param ;
VAR1 SHORT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_SHORT('JSON', 'SHORT', '{"a":1}' ) ;
drop procedure t_JSON_SHORT ;
drop procedure print_message;

--+ server-message off
