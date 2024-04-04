--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_CHAR. This scenario is a success.');
create or replace procedure t_DATETIME_CHAR(param_type string, variables_type string, param DATETIME ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_CHAR('DATETIME', 'CHAR', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_CHAR ;


call print_message('t_DATETIMELTZ_CHAR. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_CHAR(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_CHAR('DATETIMELTZ', 'CHAR', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_CHAR ;


call print_message('t_DATETIMETZ_CHAR. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_CHAR(param_type string, variables_type string, param DATETIMETZ ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_CHAR('DATETIMETZ', 'CHAR', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_CHAR ;


call print_message('t_DATE_CHAR. This scenario is a success.');
create or replace procedure t_DATE_CHAR(param_type string, variables_type string, param DATE ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_CHAR('DATE', 'CHAR', DATE'2008-10-31' ) ;
drop procedure t_DATE_CHAR ;


call print_message('t_TIME_CHAR. This scenario is a success.');
create or replace procedure t_TIME_CHAR(param_type string, variables_type string, param TIME ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_CHAR('TIME', 'CHAR', TIME'13:15:45' ) ;
drop procedure t_TIME_CHAR ;


call print_message('t_TIMESTAMP_CHAR. This scenario is a success.');
create or replace procedure t_TIMESTAMP_CHAR(param_type string, variables_type string, param TIMESTAMP ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_CHAR('TIMESTAMP', 'CHAR', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_CHAR ;


call print_message('t_TIMESTAMPLTZ_CHAR. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_CHAR(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_CHAR('TIMESTAMPLTZ', 'CHAR', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_CHAR ;


call print_message('t_TIMESTAMPTZ_CHAR. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_CHAR(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_CHAR('TIMESTAMPTZ', 'CHAR', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_CHAR ;


call print_message('t_DOUBLE_CHAR. This scenario is a success.');
create or replace procedure t_DOUBLE_CHAR(param_type string, variables_type string, param DOUBLE ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_CHAR('DOUBLE', 'CHAR', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_CHAR ;


call print_message('t_FLOAT_CHAR. This scenario is a success.');
create or replace procedure t_FLOAT_CHAR(param_type string, variables_type string, param FLOAT ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_CHAR('FLOAT', 'CHAR', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_CHAR ;


call print_message('t_NUMERIC_CHAR. This scenario is a success.');
create or replace procedure t_NUMERIC_CHAR(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_CHAR('NUMERIC(8,4)', 'CHAR', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_CHAR ;


call print_message('t_BIGINT_CHAR. This scenario is a success.');
create or replace procedure t_BIGINT_CHAR(param_type string, variables_type string, param BIGINT ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_CHAR('BIGINT', 'CHAR', decode('CHAR', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_CHAR ;


call print_message('t_INT_CHAR. This scenario is a success.');
create or replace procedure t_INT_CHAR(param_type string, variables_type string, param INT ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_CHAR('INT', 'CHAR', decode('CHAR', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_CHAR ;


call print_message('t_SHORT_CHAR. This scenario is a success.');
create or replace procedure t_SHORT_CHAR(param_type string, variables_type string, param SHORT ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_CHAR('SHORT', 'CHAR', decode('CHAR', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_CHAR ;


call print_message('t_BIT(8)_CHAR. This scenario is a failure.');
create or replace procedure t_BIT_CHAR(param_type string, variables_type string, param BIT(8) ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_CHAR('BIT(8)', 'CHAR', 0xaa ) ;
drop procedure t_BIT_CHAR ;


call print_message('t_BIT VARYING_CHAR. This scenario is a failure.');
create or replace procedure t_BITVARYING_CHAR(param_type string, variables_type string, param BIT VARYING ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_CHAR('BIT VARYING', 'CHAR', 0xaa ) ;
drop procedure t_BITVARYING_CHAR ;


call print_message('t_CHAR_CHAR. This scenario is a success.');
create or replace procedure t_CHAR_CHAR(param_type string, variables_type string, param CHAR ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_CHAR('CHAR', 'CHAR', 'CHAR CUBRID' ) ;
drop procedure t_CHAR_CHAR ;


call print_message('t_VARCHAR_CHAR. This scenario is a success.');
create or replace procedure t_VARCHAR_CHAR(param_type string, variables_type string, param VARCHAR ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_CHAR('VARCHAR', 'CHAR', 'VARCHAR CUBRID' ) ;
drop procedure t_VARCHAR_CHAR ;


call print_message('t_SET_CHAR. This scenario is a failure.');
create or replace procedure t_SET_CHAR(param_type string, variables_type string, param SET ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_CHAR('SET', 'CHAR', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_CHAR ;


call print_message('t_MULTISET_CHAR. This scenario is a failure.');
create or replace procedure t_MULTISET_CHAR(param_type string, variables_type string, param MULTISET ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_CHAR('MULTISET', 'CHAR', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_CHAR ;


call print_message('t_LIST_CHAR. This scenario is a failure.');
create or replace procedure t_LIST_CHAR(param_type string, variables_type string, param LIST ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_CHAR('LIST', 'CHAR', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_CHAR ;


call print_message('t_ENUM_CHAR. This scenario is a failure.');
create or replace procedure t_ENUM_CHAR(param_type string, variables_type string, param ENUM ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_CHAR('ENUM', 'CHAR', 'yellow' ) ;
drop procedure t_ENUM_CHAR ;


call print_message('t_BLOB_CHAR. This scenario is a failure.');
create or replace procedure t_BLOB_CHAR(param_type string, variables_type string, param BLOB ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_CHAR('BLOB', 'CHAR', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_CHAR ;


call print_message('t_CLOB_CHAR. This scenario is a failure.');
create or replace procedure t_CLOB_CHAR(param_type string, variables_type string, param CLOB ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_CHAR('CLOB', 'CHAR', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_CHAR ;


call print_message('t_JSON_CHAR. This scenario is a failure.');
create or replace procedure t_JSON_CHAR(param_type string, variables_type string, param JSON ) as 
VAR CHAR := param ;
VAR1 CHAR  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_CHAR('JSON', 'CHAR', '{"a":1}' ) ;
drop procedure t_JSON_CHAR ;
drop procedure print_message;

--+ server-message off
