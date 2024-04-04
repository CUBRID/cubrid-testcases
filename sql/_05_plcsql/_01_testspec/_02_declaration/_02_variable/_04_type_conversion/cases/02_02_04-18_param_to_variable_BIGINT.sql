--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIGINT. This scenario is a failure.');
create or replace procedure t_DATETIME_BIGINT(param_type string, variables_type string, param DATETIME ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_BIGINT('DATETIME', 'BIGINT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_BIGINT ;


call print_message('t_DATETIMELTZ_BIGINT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_BIGINT(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_BIGINT('DATETIMELTZ', 'BIGINT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_BIGINT ;


call print_message('t_DATETIMETZ_BIGINT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_BIGINT(param_type string, variables_type string, param DATETIMETZ ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_BIGINT('DATETIMETZ', 'BIGINT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_BIGINT ;


call print_message('t_DATE_BIGINT. This scenario is a failure.');
create or replace procedure t_DATE_BIGINT(param_type string, variables_type string, param DATE ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_BIGINT('DATE', 'BIGINT', DATE'2008-10-31' ) ;
drop procedure t_DATE_BIGINT ;


call print_message('t_TIME_BIGINT. This scenario is a failure.');
create or replace procedure t_TIME_BIGINT(param_type string, variables_type string, param TIME ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_BIGINT('TIME', 'BIGINT', TIME'13:15:45' ) ;
drop procedure t_TIME_BIGINT ;


call print_message('t_TIMESTAMP_BIGINT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_BIGINT(param_type string, variables_type string, param TIMESTAMP ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_BIGINT('TIMESTAMP', 'BIGINT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_BIGINT ;


call print_message('t_TIMESTAMPLTZ_BIGINT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_BIGINT(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_BIGINT('TIMESTAMPLTZ', 'BIGINT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_BIGINT ;


call print_message('t_TIMESTAMPTZ_BIGINT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_BIGINT(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_BIGINT('TIMESTAMPTZ', 'BIGINT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_BIGINT ;


call print_message('t_DOUBLE_BIGINT. This scenario is a success.');
create or replace procedure t_DOUBLE_BIGINT(param_type string, variables_type string, param DOUBLE ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_BIGINT('DOUBLE', 'BIGINT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_BIGINT ;


call print_message('t_FLOAT_BIGINT. This scenario is a success.');
create or replace procedure t_FLOAT_BIGINT(param_type string, variables_type string, param FLOAT ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_BIGINT('FLOAT', 'BIGINT', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_BIGINT ;


call print_message('t_NUMERIC_BIGINT. This scenario is a success.');
create or replace procedure t_NUMERIC_BIGINT(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_BIGINT('NUMERIC(8,4)', 'BIGINT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_BIGINT ;


call print_message('t_BIGINT_BIGINT. This scenario is a success.');
create or replace procedure t_BIGINT_BIGINT(param_type string, variables_type string, param BIGINT ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_BIGINT('BIGINT', 'BIGINT', decode('BIGINT', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_BIGINT ;


call print_message('t_INT_BIGINT. This scenario is a success.');
create or replace procedure t_INT_BIGINT(param_type string, variables_type string, param INT ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_BIGINT('INT', 'BIGINT', decode('BIGINT', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_BIGINT ;


call print_message('t_SHORT_BIGINT. This scenario is a success.');
create or replace procedure t_SHORT_BIGINT(param_type string, variables_type string, param SHORT ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_BIGINT('SHORT', 'BIGINT', decode('BIGINT', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_BIGINT ;


call print_message('t_BIT(8)_BIGINT. This scenario is a failure.');
create or replace procedure t_BIT_BIGINT(param_type string, variables_type string, param BIT(8) ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_BIGINT('BIT(8)', 'BIGINT', 0xaa ) ;
drop procedure t_BIT_BIGINT ;


call print_message('t_BIT VARYING_BIGINT. This scenario is a failure.');
create or replace procedure t_BITVARYING_BIGINT(param_type string, variables_type string, param BIT VARYING ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_BIGINT('BIT VARYING', 'BIGINT', 0xaa ) ;
drop procedure t_BITVARYING_BIGINT ;


call print_message('t_CHAR_BIGINT. This scenario is a success.');
create or replace procedure t_CHAR_BIGINT(param_type string, variables_type string, param CHAR ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_BIGINT('CHAR', 'BIGINT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_BIGINT ;


call print_message('t_VARCHAR_BIGINT. This scenario is a success.');
create or replace procedure t_VARCHAR_BIGINT(param_type string, variables_type string, param VARCHAR ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_BIGINT('VARCHAR', 'BIGINT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_BIGINT ;


call print_message('t_SET_BIGINT. This scenario is a failure.');
create or replace procedure t_SET_BIGINT(param_type string, variables_type string, param SET ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_BIGINT('SET', 'BIGINT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_BIGINT ;


call print_message('t_MULTISET_BIGINT. This scenario is a failure.');
create or replace procedure t_MULTISET_BIGINT(param_type string, variables_type string, param MULTISET ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_BIGINT('MULTISET', 'BIGINT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_BIGINT ;


call print_message('t_LIST_BIGINT. This scenario is a failure.');
create or replace procedure t_LIST_BIGINT(param_type string, variables_type string, param LIST ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_BIGINT('LIST', 'BIGINT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_BIGINT ;


call print_message('t_ENUM_BIGINT. This scenario is a failure.');
create or replace procedure t_ENUM_BIGINT(param_type string, variables_type string, param ENUM ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_BIGINT('ENUM', 'BIGINT', 'yellow' ) ;
drop procedure t_ENUM_BIGINT ;


call print_message('t_BLOB_BIGINT. This scenario is a failure.');
create or replace procedure t_BLOB_BIGINT(param_type string, variables_type string, param BLOB ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_BIGINT('BLOB', 'BIGINT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_BIGINT ;


call print_message('t_CLOB_BIGINT. This scenario is a failure.');
create or replace procedure t_CLOB_BIGINT(param_type string, variables_type string, param CLOB ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_BIGINT('CLOB', 'BIGINT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_BIGINT ;


call print_message('t_JSON_BIGINT. This scenario is a failure.');
create or replace procedure t_JSON_BIGINT(param_type string, variables_type string, param JSON ) as 
VAR BIGINT := param ;
VAR1 BIGINT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_BIGINT('JSON', 'BIGINT', '{"a":1}' ) ;
drop procedure t_JSON_BIGINT ;
drop procedure print_message;

--+ server-message off
