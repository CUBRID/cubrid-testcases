--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIME_DOUBLE(param_type string, variables_type string, param DATETIME ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_DOUBLE('DATETIME', 'DOUBLE', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_DOUBLE ;


call print_message('t_DATETIMELTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DOUBLE(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_DOUBLE('DATETIMELTZ', 'DOUBLE', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_DOUBLE ;


call print_message('t_DATETIMETZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DOUBLE(param_type string, variables_type string, param DATETIMETZ ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_DOUBLE('DATETIMETZ', 'DOUBLE', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_DOUBLE ;


call print_message('t_DATE_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATE_DOUBLE(param_type string, variables_type string, param DATE ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_DOUBLE('DATE', 'DOUBLE', DATE'2008-10-31' ) ;
drop procedure t_DATE_DOUBLE ;


call print_message('t_TIME_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIME_DOUBLE(param_type string, variables_type string, param TIME ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_DOUBLE('TIME', 'DOUBLE', TIME'13:15:45' ) ;
drop procedure t_TIME_DOUBLE ;


call print_message('t_TIMESTAMP_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_DOUBLE(param_type string, variables_type string, param TIMESTAMP ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_DOUBLE('TIMESTAMP', 'DOUBLE', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_DOUBLE ;


call print_message('t_TIMESTAMPLTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DOUBLE(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_DOUBLE('TIMESTAMPLTZ', 'DOUBLE', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_DOUBLE ;


call print_message('t_TIMESTAMPTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DOUBLE(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_DOUBLE('TIMESTAMPTZ', 'DOUBLE', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_DOUBLE ;


call print_message('t_DOUBLE_DOUBLE. This scenario is a success.');
create or replace procedure t_DOUBLE_DOUBLE(param_type string, variables_type string, param DOUBLE ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_DOUBLE('DOUBLE', 'DOUBLE', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_DOUBLE ;


call print_message('t_FLOAT_DOUBLE. This scenario is a success.');
create or replace procedure t_FLOAT_DOUBLE(param_type string, variables_type string, param FLOAT ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_DOUBLE('FLOAT', 'DOUBLE', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_DOUBLE ;


call print_message('t_NUMERIC_DOUBLE. This scenario is a success.');
create or replace procedure t_NUMERIC_DOUBLE(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_DOUBLE('NUMERIC(8,4)', 'DOUBLE', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_DOUBLE ;


call print_message('t_BIGINT_DOUBLE. This scenario is a success.');
create or replace procedure t_BIGINT_DOUBLE(param_type string, variables_type string, param BIGINT ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_DOUBLE('BIGINT', 'DOUBLE', decode('DOUBLE', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_DOUBLE ;


call print_message('t_INT_DOUBLE. This scenario is a success.');
create or replace procedure t_INT_DOUBLE(param_type string, variables_type string, param INT ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_DOUBLE('INT', 'DOUBLE', decode('DOUBLE', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_DOUBLE ;


call print_message('t_SHORT_DOUBLE. This scenario is a success.');
create or replace procedure t_SHORT_DOUBLE(param_type string, variables_type string, param SHORT ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_DOUBLE('SHORT', 'DOUBLE', decode('DOUBLE', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_DOUBLE ;


call print_message('t_BIT(8)_DOUBLE. This scenario is a failure.');
create or replace procedure t_BIT_DOUBLE(param_type string, variables_type string, param BIT(8) ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_DOUBLE('BIT(8)', 'DOUBLE', 0xaa ) ;
drop procedure t_BIT_DOUBLE ;


call print_message('t_BIT VARYING_DOUBLE. This scenario is a failure.');
create or replace procedure t_BITVARYING_DOUBLE(param_type string, variables_type string, param BIT VARYING ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_DOUBLE('BIT VARYING', 'DOUBLE', 0xaa ) ;
drop procedure t_BITVARYING_DOUBLE ;


call print_message('t_CHAR_DOUBLE. This scenario is a success.');
create or replace procedure t_CHAR_DOUBLE(param_type string, variables_type string, param CHAR ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_DOUBLE('CHAR', 'DOUBLE', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_DOUBLE ;


call print_message('t_VARCHAR_DOUBLE. This scenario is a success.');
create or replace procedure t_VARCHAR_DOUBLE(param_type string, variables_type string, param VARCHAR ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_DOUBLE('VARCHAR', 'DOUBLE', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_DOUBLE ;


call print_message('t_SET_DOUBLE. This scenario is a failure.');
create or replace procedure t_SET_DOUBLE(param_type string, variables_type string, param SET ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_DOUBLE('SET', 'DOUBLE', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_DOUBLE ;


call print_message('t_MULTISET_DOUBLE. This scenario is a failure.');
create or replace procedure t_MULTISET_DOUBLE(param_type string, variables_type string, param MULTISET ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_DOUBLE('MULTISET', 'DOUBLE', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_DOUBLE ;


call print_message('t_LIST_DOUBLE. This scenario is a failure.');
create or replace procedure t_LIST_DOUBLE(param_type string, variables_type string, param LIST ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_DOUBLE('LIST', 'DOUBLE', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_DOUBLE ;


call print_message('t_ENUM_DOUBLE. This scenario is a failure.');
create or replace procedure t_ENUM_DOUBLE(param_type string, variables_type string, param ENUM ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_DOUBLE('ENUM', 'DOUBLE', 'yellow' ) ;
drop procedure t_ENUM_DOUBLE ;


call print_message('t_BLOB_DOUBLE. This scenario is a failure.');
create or replace procedure t_BLOB_DOUBLE(param_type string, variables_type string, param BLOB ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_DOUBLE('BLOB', 'DOUBLE', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_DOUBLE ;


call print_message('t_CLOB_DOUBLE. This scenario is a failure.');
create or replace procedure t_CLOB_DOUBLE(param_type string, variables_type string, param CLOB ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_DOUBLE('CLOB', 'DOUBLE', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_DOUBLE ;


call print_message('t_JSON_DOUBLE. This scenario is a failure.');
create or replace procedure t_JSON_DOUBLE(param_type string, variables_type string, param JSON ) as 
VAR DOUBLE := param ;
VAR1 DOUBLE  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_DOUBLE('JSON', 'DOUBLE', '{"a":1}' ) ;
drop procedure t_JSON_DOUBLE ;
drop procedure print_message;

--+ server-message off
