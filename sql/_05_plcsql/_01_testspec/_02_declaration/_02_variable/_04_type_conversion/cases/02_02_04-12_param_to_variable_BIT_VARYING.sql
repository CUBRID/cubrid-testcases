--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIT VARYING. This scenario is a failure.');
create or replace procedure t_DATETIME_BITVARYING(param_type string, variables_type string, param DATETIME ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_BITVARYING('DATETIME', 'BIT VARYING', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_BITVARYING ;


call print_message('t_DATETIMELTZ_BIT VARYING. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_BITVARYING(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_BITVARYING('DATETIMELTZ', 'BIT VARYING', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_BITVARYING ;


call print_message('t_DATETIMETZ_BIT VARYING. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_BITVARYING(param_type string, variables_type string, param DATETIMETZ ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_BITVARYING('DATETIMETZ', 'BIT VARYING', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_BITVARYING ;


call print_message('t_DATE_BIT VARYING. This scenario is a failure.');
create or replace procedure t_DATE_BITVARYING(param_type string, variables_type string, param DATE ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_BITVARYING('DATE', 'BIT VARYING', DATE'2008-10-31' ) ;
drop procedure t_DATE_BITVARYING ;


call print_message('t_TIME_BIT VARYING. This scenario is a failure.');
create or replace procedure t_TIME_BITVARYING(param_type string, variables_type string, param TIME ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_BITVARYING('TIME', 'BIT VARYING', TIME'13:15:45' ) ;
drop procedure t_TIME_BITVARYING ;


call print_message('t_TIMESTAMP_BIT VARYING. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_BITVARYING(param_type string, variables_type string, param TIMESTAMP ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_BITVARYING('TIMESTAMP', 'BIT VARYING', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_BITVARYING ;


call print_message('t_TIMESTAMPLTZ_BIT VARYING. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_BITVARYING(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_BITVARYING('TIMESTAMPLTZ', 'BIT VARYING', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_BITVARYING ;


call print_message('t_TIMESTAMPTZ_BIT VARYING. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_BITVARYING(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_BITVARYING('TIMESTAMPTZ', 'BIT VARYING', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_BITVARYING ;


call print_message('t_DOUBLE_BIT VARYING. This scenario is a failure.');
create or replace procedure t_DOUBLE_BITVARYING(param_type string, variables_type string, param DOUBLE ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_BITVARYING('DOUBLE', 'BIT VARYING', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_BITVARYING ;


call print_message('t_FLOAT_BIT VARYING. This scenario is a failure.');
create or replace procedure t_FLOAT_BITVARYING(param_type string, variables_type string, param FLOAT ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_BITVARYING('FLOAT', 'BIT VARYING', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_BITVARYING ;


call print_message('t_NUMERIC(8,4)_BIT VARYING. This scenario is a failure.');
create or replace procedure t_NUMERIC_BITVARYING(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_BITVARYING('NUMERIC(8,4)', 'BIT VARYING', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_BITVARYING ;


call print_message('t_BIGINT_BIT VARYING. This scenario is a failure.');
create or replace procedure t_BIGINT_BITVARYING(param_type string, variables_type string, param BIGINT ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_BITVARYING('BIGINT', 'BIT VARYING', decode('BIT VARYING', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_BITVARYING ;


call print_message('t_INT_BIT VARYING. This scenario is a failure.');
create or replace procedure t_INT_BITVARYING(param_type string, variables_type string, param INT ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_BITVARYING('INT', 'BIT VARYING', decode('BIT VARYING', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_BITVARYING ;


call print_message('t_SHORT_BIT VARYING. This scenario is a failure.');
create or replace procedure t_SHORT_BITVARYING(param_type string, variables_type string, param SHORT ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_BITVARYING('SHORT', 'BIT VARYING', decode('BIT VARYING', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_BITVARYING ;


call print_message('t_BIT(8)_BIT VARYING. This scenario is a failure.');
create or replace procedure t_BIT_BITVARYING(param_type string, variables_type string, param BIT(8) ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_BITVARYING('BIT(8)', 'BIT VARYING', 0xaa ) ;
drop procedure t_BIT_BITVARYING ;


call print_message('t_BIT VARYING_BIT VARYING. This scenario is a failure.');
create or replace procedure t_BITVARYING_BITVARYING(param_type string, variables_type string, param BIT VARYING ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_BITVARYING('BIT VARYING', 'BIT VARYING', 0xaa ) ;
drop procedure t_BITVARYING_BITVARYING ;


call print_message('t_CHAR_BIT VARYING. This scenario is a failure.');
create or replace procedure t_CHAR_BITVARYING(param_type string, variables_type string, param CHAR ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_BITVARYING('CHAR', 'BIT VARYING', 0xaa ) ;
drop procedure t_CHAR_BITVARYING ;


call print_message('t_VARCHAR_BIT VARYING. This scenario is a failure.');
create or replace procedure t_VARCHAR_BITVARYING(param_type string, variables_type string, param VARCHAR ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_BITVARYING('VARCHAR', 'BIT VARYING', 0xaa ) ;
drop procedure t_VARCHAR_BITVARYING ;


call print_message('t_SET_BIT VARYING. This scenario is a failure.');
create or replace procedure t_SET_BITVARYING(param_type string, variables_type string, param SET ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_BITVARYING('SET', 'BIT VARYING', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_BITVARYING ;


call print_message('t_MULTISET_BIT VARYING. This scenario is a failure.');
create or replace procedure t_MULTISET_BITVARYING(param_type string, variables_type string, param MULTISET ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_BITVARYING('MULTISET', 'BIT VARYING', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_BITVARYING ;


call print_message('t_LIST_BIT VARYING. This scenario is a failure.');
create or replace procedure t_LIST_BITVARYING(param_type string, variables_type string, param LIST ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_BITVARYING('LIST', 'BIT VARYING', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_BITVARYING ;


call print_message('t_ENUM_BIT VARYING. This scenario is a failure.');
create or replace procedure t_ENUM_BITVARYING(param_type string, variables_type string, param ENUM ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_BITVARYING('ENUM', 'BIT VARYING', 'yellow' ) ;
drop procedure t_ENUM_BITVARYING ;


call print_message('t_BLOB_BIT VARYING. This scenario is a failure.');
create or replace procedure t_BLOB_BITVARYING(param_type string, variables_type string, param BLOB ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_BITVARYING('BLOB', 'BIT VARYING', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_BITVARYING ;


call print_message('t_CLOB_BIT VARYING. This scenario is a failure.');
create or replace procedure t_CLOB_BITVARYING(param_type string, variables_type string, param CLOB ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_BITVARYING('CLOB', 'BIT VARYING', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_BITVARYING ;


call print_message('t_JSON_BIT VARYING. This scenario is a failure.');
create or replace procedure t_JSON_BITVARYING(param_type string, variables_type string, param JSON ) as 
VAR BIT VARYING := param ;
VAR1 BIT VARYING  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_BITVARYING('JSON', 'BIT VARYING', '{"a":1}' ) ;
drop procedure t_JSON_BITVARYING ;
drop procedure print_message;

--+ server-message off
