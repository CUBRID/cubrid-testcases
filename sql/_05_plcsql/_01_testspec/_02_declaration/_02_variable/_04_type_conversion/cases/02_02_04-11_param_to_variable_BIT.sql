--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIT. This scenario is a failure.');
create or replace procedure t_DATETIME_BIT(param_type string, variables_type string, param DATETIME ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_BIT('DATETIME', 'BIT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_BIT ;


call print_message('t_DATETIMELTZ_BIT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_BIT(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_BIT('DATETIMELTZ', 'BIT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_BIT ;


call print_message('t_DATETIMETZ_BIT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_BIT(param_type string, variables_type string, param DATETIMETZ ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_BIT('DATETIMETZ', 'BIT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_BIT ;


call print_message('t_DATE_BIT. This scenario is a failure.');
create or replace procedure t_DATE_BIT(param_type string, variables_type string, param DATE ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_BIT('DATE', 'BIT', DATE'2008-10-31' ) ;
drop procedure t_DATE_BIT ;


call print_message('t_TIME_BIT. This scenario is a failure.');
create or replace procedure t_TIME_BIT(param_type string, variables_type string, param TIME ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_BIT('TIME', 'BIT', TIME'13:15:45' ) ;
drop procedure t_TIME_BIT ;


call print_message('t_TIMESTAMP_BIT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_BIT(param_type string, variables_type string, param TIMESTAMP ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_BIT('TIMESTAMP', 'BIT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_BIT ;


call print_message('t_TIMESTAMPLTZ_BIT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_BIT(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_BIT('TIMESTAMPLTZ', 'BIT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_BIT ;


call print_message('t_TIMESTAMPTZ_BIT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_BIT(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_BIT('TIMESTAMPTZ', 'BIT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_BIT ;


call print_message('t_DOUBLE_BIT. This scenario is a failure.');
create or replace procedure t_DOUBLE_BIT(param_type string, variables_type string, param DOUBLE ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_BIT('DOUBLE', 'BIT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_BIT ;


call print_message('t_FLOAT_BIT. This scenario is a failure.');
create or replace procedure t_FLOAT_BIT(param_type string, variables_type string, param FLOAT ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_BIT('FLOAT', 'BIT', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_BIT ;


call print_message('t_NUMERIC(8,4)_BIT. This scenario is a failure.');
create or replace procedure t_NUMERIC_BIT(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_BIT('NUMERIC(8,4)', 'BIT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_BIT ;


call print_message('t_BIGINT_BIT. This scenario is a failure.');
create or replace procedure t_BIGINT_BIT(param_type string, variables_type string, param BIGINT ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_BIT('BIGINT', 'BIT', decode('BIT', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_BIT ;


call print_message('t_INT_BIT. This scenario is a failure.');
create or replace procedure t_INT_BIT(param_type string, variables_type string, param INT ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_BIT('INT', 'BIT', decode('BIT', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_BIT ;


call print_message('t_SHORT_BIT. This scenario is a failure.');
create or replace procedure t_SHORT_BIT(param_type string, variables_type string, param SHORT ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_BIT('SHORT', 'BIT', decode('BIT', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_BIT ;


call print_message('t_BIT(8)_BIT. This scenario is a failure.');
create or replace procedure t_BIT_BIT(param_type string, variables_type string, param BIT(8) ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_BIT('BIT(8)', 'BIT', 0xaa ) ;
drop procedure t_BIT_BIT ;


call print_message('t_BIT VARYING_BIT. This scenario is a failure.');
create or replace procedure t_BITVARYING_BIT(param_type string, variables_type string, param BIT VARYING ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_BIT('BIT VARYING', 'BIT', 0xaa ) ;
drop procedure t_BITVARYING_BIT ;


call print_message('t_CHAR_BIT. This scenario is a failure.');
create or replace procedure t_CHAR_BIT(param_type string, variables_type string, param CHAR ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_BIT('CHAR', 'BIT', 'CHAR CUBRID' ) ;
drop procedure t_CHAR_BIT ;


call print_message('t_VARCHAR_BIT. This scenario is a failure.');
create or replace procedure t_VARCHAR_BIT(param_type string, variables_type string, param VARCHAR ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_BIT('VARCHAR', 'BIT', 'VARCHAR CUBRID' ) ;
drop procedure t_VARCHAR_BIT ;


call print_message('t_SET_BIT. This scenario is a failure.');
create or replace procedure t_SET_BIT(param_type string, variables_type string, param SET ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_BIT('SET', 'BIT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_BIT ;


call print_message('t_MULTISET_BIT. This scenario is a failure.');
create or replace procedure t_MULTISET_BIT(param_type string, variables_type string, param MULTISET ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_BIT('MULTISET', 'BIT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_BIT ;


call print_message('t_LIST_BIT. This scenario is a failure.');
create or replace procedure t_LIST_BIT(param_type string, variables_type string, param LIST ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_BIT('LIST', 'BIT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_BIT ;


call print_message('t_ENUM_BIT. This scenario is a failure.');
create or replace procedure t_ENUM_BIT(param_type string, variables_type string, param ENUM ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_BIT('ENUM', 'BIT', 'yellow' ) ;
drop procedure t_ENUM_BIT ;


call print_message('t_BLOB_BIT. This scenario is a failure.');
create or replace procedure t_BLOB_BIT(param_type string, variables_type string, param BLOB ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_BIT('BLOB', 'BIT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_BIT ;


call print_message('t_CLOB_BIT. This scenario is a failure.');
create or replace procedure t_CLOB_BIT(param_type string, variables_type string, param CLOB ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_BIT('CLOB', 'BIT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_BIT ;


call print_message('t_JSON_BIT. This scenario is a failure.');
create or replace procedure t_JSON_BIT(param_type string, variables_type string, param JSON ) as 
VAR BIT := param ;
VAR1 BIT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_BIT('JSON', 'BIT', '{"a":1}' ) ;
drop procedure t_JSON_BIT ;
drop procedure print_message;

--+ server-message off
