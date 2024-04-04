--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_FLOAT. This scenario is a failure.');
create or replace procedure t_DATETIME_FLOAT(param_type string, variables_type string, param DATETIME ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_FLOAT('DATETIME', 'FLOAT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_FLOAT ;


call print_message('t_DATETIMELTZ_FLOAT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_FLOAT(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_FLOAT('DATETIMELTZ', 'FLOAT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_FLOAT ;


call print_message('t_DATETIMETZ_FLOAT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_FLOAT(param_type string, variables_type string, param DATETIMETZ ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_FLOAT('DATETIMETZ', 'FLOAT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_FLOAT ;


call print_message('t_DATE_FLOAT. This scenario is a failure.');
create or replace procedure t_DATE_FLOAT(param_type string, variables_type string, param DATE ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_FLOAT('DATE', 'FLOAT', DATE'2008-10-31' ) ;
drop procedure t_DATE_FLOAT ;


call print_message('t_TIME_FLOAT. This scenario is a failure.');
create or replace procedure t_TIME_FLOAT(param_type string, variables_type string, param TIME ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_FLOAT('TIME', 'FLOAT', TIME'13:15:45' ) ;
drop procedure t_TIME_FLOAT ;


call print_message('t_TIMESTAMP_FLOAT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_FLOAT(param_type string, variables_type string, param TIMESTAMP ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_FLOAT('TIMESTAMP', 'FLOAT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_FLOAT ;


call print_message('t_TIMESTAMPLTZ_FLOAT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_FLOAT(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_FLOAT('TIMESTAMPLTZ', 'FLOAT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_FLOAT ;


call print_message('t_TIMESTAMPTZ_FLOAT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_FLOAT(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_FLOAT('TIMESTAMPTZ', 'FLOAT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_FLOAT ;


call print_message('t_DOUBLE_FLOAT. This scenario is a success.');
create or replace procedure t_DOUBLE_FLOAT(param_type string, variables_type string, param DOUBLE ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_FLOAT('DOUBLE', 'FLOAT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_FLOAT ;


call print_message('t_FLOAT_FLOAT. This scenario is a success.');
create or replace procedure t_FLOAT_FLOAT(param_type string, variables_type string, param FLOAT ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_FLOAT('FLOAT', 'FLOAT', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_FLOAT ;


call print_message('t_NUMERIC_FLOAT. This scenario is a success.');
create or replace procedure t_NUMERIC_FLOAT(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_FLOAT('NUMERIC(8,4)', 'FLOAT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_FLOAT ;


call print_message('t_BIGINT_FLOAT. This scenario is a success.');
create or replace procedure t_BIGINT_FLOAT(param_type string, variables_type string, param BIGINT ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_FLOAT('BIGINT', 'FLOAT', decode('FLOAT', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_FLOAT ;


call print_message('t_INT_FLOAT. This scenario is a success.');
create or replace procedure t_INT_FLOAT(param_type string, variables_type string, param INT ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_FLOAT('INT', 'FLOAT', decode('FLOAT', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_FLOAT ;


call print_message('t_SHORT_FLOAT. This scenario is a success.');
create or replace procedure t_SHORT_FLOAT(param_type string, variables_type string, param SHORT ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_FLOAT('SHORT', 'FLOAT', decode('FLOAT', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_FLOAT ;


call print_message('t_BIT(8)_FLOAT. This scenario is a failure.');
create or replace procedure t_BIT_FLOAT(param_type string, variables_type string, param BIT(8) ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_FLOAT('BIT(8)', 'FLOAT', 0xaa ) ;
drop procedure t_BIT_FLOAT ;


call print_message('t_BIT VARYING_FLOAT. This scenario is a failure.');
create or replace procedure t_BITVARYING_FLOAT(param_type string, variables_type string, param BIT VARYING ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_FLOAT('BIT VARYING', 'FLOAT', 0xaa ) ;
drop procedure t_BITVARYING_FLOAT ;


call print_message('t_CHAR_FLOAT. This scenario is a success.');
create or replace procedure t_CHAR_FLOAT(param_type string, variables_type string, param CHAR ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_FLOAT('CHAR', 'FLOAT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_FLOAT ;


call print_message('t_VARCHAR_FLOAT. This scenario is a success.');
create or replace procedure t_VARCHAR_FLOAT(param_type string, variables_type string, param VARCHAR ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_FLOAT('VARCHAR', 'FLOAT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_FLOAT ;


call print_message('t_SET_FLOAT. This scenario is a failure.');
create or replace procedure t_SET_FLOAT(param_type string, variables_type string, param SET ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_FLOAT('SET', 'FLOAT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_FLOAT ;


call print_message('t_MULTISET_FLOAT. This scenario is a failure.');
create or replace procedure t_MULTISET_FLOAT(param_type string, variables_type string, param MULTISET ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_FLOAT('MULTISET', 'FLOAT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_FLOAT ;


call print_message('t_LIST_FLOAT. This scenario is a failure.');
create or replace procedure t_LIST_FLOAT(param_type string, variables_type string, param LIST ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_FLOAT('LIST', 'FLOAT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_FLOAT ;


call print_message('t_ENUM_FLOAT. This scenario is a failure.');
create or replace procedure t_ENUM_FLOAT(param_type string, variables_type string, param ENUM ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_FLOAT('ENUM', 'FLOAT', 'yellow' ) ;
drop procedure t_ENUM_FLOAT ;


call print_message('t_BLOB_FLOAT. This scenario is a failure.');
create or replace procedure t_BLOB_FLOAT(param_type string, variables_type string, param BLOB ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_FLOAT('BLOB', 'FLOAT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_FLOAT ;


call print_message('t_CLOB_FLOAT. This scenario is a failure.');
create or replace procedure t_CLOB_FLOAT(param_type string, variables_type string, param CLOB ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_FLOAT('CLOB', 'FLOAT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_FLOAT ;


call print_message('t_JSON_FLOAT. This scenario is a failure.');
create or replace procedure t_JSON_FLOAT(param_type string, variables_type string, param JSON ) as 
VAR FLOAT := param ;
VAR1 FLOAT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_FLOAT('JSON', 'FLOAT', '{"a":1}' ) ;
drop procedure t_JSON_FLOAT ;
drop procedure print_message;

--+ server-message off
