--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_LIST. This scenario is a failure.');
create or replace procedure t_DATETIME_LIST(param_type string, variables_type string, param DATETIME ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_LIST('DATETIME', 'LIST', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_LIST ;


call print_message('t_DATETIMELTZ_LIST. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_LIST(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_LIST('DATETIMELTZ', 'LIST', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_LIST ;


call print_message('t_DATETIMETZ_LIST. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_LIST(param_type string, variables_type string, param DATETIMETZ ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_LIST('DATETIMETZ', 'LIST', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_LIST ;


call print_message('t_DATE_LIST. This scenario is a failure.');
create or replace procedure t_DATE_LIST(param_type string, variables_type string, param DATE ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_LIST('DATE', 'LIST', DATE'2008-10-31' ) ;
drop procedure t_DATE_LIST ;


call print_message('t_TIME_LIST. This scenario is a failure.');
create or replace procedure t_TIME_LIST(param_type string, variables_type string, param TIME ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_LIST('TIME', 'LIST', TIME'13:15:45' ) ;
drop procedure t_TIME_LIST ;


call print_message('t_TIMESTAMP_LIST. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_LIST(param_type string, variables_type string, param TIMESTAMP ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_LIST('TIMESTAMP', 'LIST', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_LIST ;


call print_message('t_TIMESTAMPLTZ_LIST. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_LIST(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_LIST('TIMESTAMPLTZ', 'LIST', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_LIST ;


call print_message('t_TIMESTAMPTZ_LIST. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_LIST(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_LIST('TIMESTAMPTZ', 'LIST', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_LIST ;


call print_message('t_DOUBLE_LIST. This scenario is a failure.');
create or replace procedure t_DOUBLE_LIST(param_type string, variables_type string, param DOUBLE ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_LIST('DOUBLE', 'LIST', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_LIST ;


call print_message('t_FLOAT_LIST. This scenario is a failure.');
create or replace procedure t_FLOAT_LIST(param_type string, variables_type string, param FLOAT ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_LIST('FLOAT', 'LIST', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_LIST ;


call print_message('t_NUMERIC(8,4)_LIST. This scenario is a failure.');
create or replace procedure t_NUMERIC_LIST(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_LIST('NUMERIC(8,4)', 'LIST', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_LIST ;


call print_message('t_BIGINT_LIST. This scenario is a failure.');
create or replace procedure t_BIGINT_LIST(param_type string, variables_type string, param BIGINT ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_LIST('BIGINT', 'LIST', decode('LIST', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_LIST ;


call print_message('t_INT_LIST. This scenario is a failure.');
create or replace procedure t_INT_LIST(param_type string, variables_type string, param INT ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_LIST('INT', 'LIST', decode('LIST', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_LIST ;


call print_message('t_SHORT_LIST. This scenario is a failure.');
create or replace procedure t_SHORT_LIST(param_type string, variables_type string, param SHORT ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_LIST('SHORT', 'LIST', decode('LIST', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_LIST ;


call print_message('t_BIT(8)_LIST. This scenario is a failure.');
create or replace procedure t_BIT_LIST(param_type string, variables_type string, param BIT(8) ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_LIST('BIT(8)', 'LIST', 0xaa ) ;
drop procedure t_BIT_LIST ;


call print_message('t_BIT VARYING_LIST. This scenario is a failure.');
create or replace procedure t_BITVARYING_LIST(param_type string, variables_type string, param BIT VARYING ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_LIST('BIT VARYING', 'LIST', 0xaa ) ;
drop procedure t_BITVARYING_LIST ;


call print_message('t_CHAR_LIST. This scenario is a failure.');
create or replace procedure t_CHAR_LIST(param_type string, variables_type string, param CHAR ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_LIST('CHAR', 'LIST', {'c','c','c','b','b','a'} ) ;
drop procedure t_CHAR_LIST ;


call print_message('t_VARCHAR_LIST. This scenario is a failure.');
create or replace procedure t_VARCHAR_LIST(param_type string, variables_type string, param VARCHAR ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_LIST('VARCHAR', 'LIST', {'c','c','c','b','b','a'} ) ;
drop procedure t_VARCHAR_LIST ;


call print_message('t_SET_LIST. This scenario is a failure.');
create or replace procedure t_SET_LIST(param_type string, variables_type string, param SET ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_LIST('SET', 'LIST', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_LIST ;


call print_message('t_MULTISET_LIST. This scenario is a failure.');
create or replace procedure t_MULTISET_LIST(param_type string, variables_type string, param MULTISET ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_LIST('MULTISET', 'LIST', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_LIST ;


call print_message('t_LIST_LIST. This scenario is a failure.');
create or replace procedure t_LIST_LIST(param_type string, variables_type string, param LIST ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_LIST('LIST', 'LIST', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_LIST ;


call print_message('t_ENUM_LIST. This scenario is a failure.');
create or replace procedure t_ENUM_LIST(param_type string, variables_type string, param ENUM ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_LIST('ENUM', 'LIST', 'yellow' ) ;
drop procedure t_ENUM_LIST ;


call print_message('t_BLOB_LIST. This scenario is a failure.');
create or replace procedure t_BLOB_LIST(param_type string, variables_type string, param BLOB ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_LIST('BLOB', 'LIST', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_LIST ;


call print_message('t_CLOB_LIST. This scenario is a failure.');
create or replace procedure t_CLOB_LIST(param_type string, variables_type string, param CLOB ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_LIST('CLOB', 'LIST', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_LIST ;


call print_message('t_JSON_LIST. This scenario is a failure.');
create or replace procedure t_JSON_LIST(param_type string, variables_type string, param JSON ) as 
VAR LIST := param ;
VAR1 LIST  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_LIST('JSON', 'LIST', '{"a":1}' ) ;
drop procedure t_JSON_LIST ;
drop procedure print_message;

--+ server-message off
