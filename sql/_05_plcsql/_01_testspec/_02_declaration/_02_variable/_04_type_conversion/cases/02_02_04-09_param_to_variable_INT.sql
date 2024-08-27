--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_INT. This scenario is a failure.');
create or replace procedure t_DATETIME_INT(param_type string, variables_type string, param DATETIME ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_INT('DATETIME', 'INT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_INT ;


call print_message('t_DATETIMELTZ_INT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_INT(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_INT('DATETIMELTZ', 'INT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_INT ;


call print_message('t_DATETIMETZ_INT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_INT(param_type string, variables_type string, param DATETIMETZ ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_INT('DATETIMETZ', 'INT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_INT ;


call print_message('t_DATE_INT. This scenario is a failure.');
create or replace procedure t_DATE_INT(param_type string, variables_type string, param DATE ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_INT('DATE', 'INT', DATE'2008-10-31' ) ;
drop procedure t_DATE_INT ;


call print_message('t_TIME_INT. This scenario is a failure.');
create or replace procedure t_TIME_INT(param_type string, variables_type string, param TIME ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_INT('TIME', 'INT', TIME'13:15:45' ) ;
drop procedure t_TIME_INT ;


call print_message('t_TIMESTAMP_INT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_INT(param_type string, variables_type string, param TIMESTAMP ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_INT('TIMESTAMP', 'INT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_INT ;


call print_message('t_TIMESTAMPLTZ_INT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_INT(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_INT('TIMESTAMPLTZ', 'INT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_INT ;


call print_message('t_TIMESTAMPTZ_INT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_INT(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_INT('TIMESTAMPTZ', 'INT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_INT ;


call print_message('t_DOUBLE_INT. This scenario is a success.');
create or replace procedure t_DOUBLE_INT(param_type string, variables_type string, param DOUBLE ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_INT('DOUBLE', 'INT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_INT ;


call print_message('t_FLOAT_INT. This scenario is a success.');
create or replace procedure t_FLOAT_INT(param_type string, variables_type string, param FLOAT ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_INT('FLOAT', 'INT', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_INT ;


call print_message('t_NUMERIC_INT. This scenario is a success.');
create or replace procedure t_NUMERIC_INT(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_INT('NUMERIC(8,4)', 'INT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_INT ;


call print_message('t_BIGINT_INT. This scenario is a success.');
create or replace procedure t_BIGINT_INT(param_type string, variables_type string, param BIGINT ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_INT('BIGINT', 'INT', decode('INT', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_INT ;


call print_message('t_INT_INT. This scenario is a success.');
create or replace procedure t_INT_INT(param_type string, variables_type string, param INT ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_INT('INT', 'INT', decode('INT', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_INT ;


call print_message('t_SHORT_INT. This scenario is a success.');
create or replace procedure t_SHORT_INT(param_type string, variables_type string, param SHORT ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_INT('SHORT', 'INT', decode('INT', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_INT ;


call print_message('t_BIT(8)_INT. This scenario is a failure.');
create or replace procedure t_BIT_INT(param_type string, variables_type string, param BIT(8) ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_INT('BIT(8)', 'INT', 0xaa ) ;
drop procedure t_BIT_INT ;


call print_message('t_BIT VARYING_INT. This scenario is a failure.');
create or replace procedure t_BITVARYING_INT(param_type string, variables_type string, param BIT VARYING ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_INT('BIT VARYING', 'INT', 0xaa ) ;
drop procedure t_BITVARYING_INT ;


call print_message('t_CHAR_INT. This scenario is a success.');
create or replace procedure t_CHAR_INT(param_type string, variables_type string, param CHAR ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_INT('CHAR', 'INT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_INT ;


call print_message('t_VARCHAR_INT. This scenario is a success.');
create or replace procedure t_VARCHAR_INT(param_type string, variables_type string, param VARCHAR ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_INT('VARCHAR', 'INT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_INT ;


call print_message('t_SET_INT. This scenario is a failure.');
create or replace procedure t_SET_INT(param_type string, variables_type string, param SET ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_INT('SET', 'INT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_INT ;


call print_message('t_MULTISET_INT. This scenario is a failure.');
create or replace procedure t_MULTISET_INT(param_type string, variables_type string, param MULTISET ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_INT('MULTISET', 'INT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_INT ;


call print_message('t_LIST_INT. This scenario is a failure.');
create or replace procedure t_LIST_INT(param_type string, variables_type string, param LIST ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_INT('LIST', 'INT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_INT ;


call print_message('t_ENUM_INT. This scenario is a failure.');
create or replace procedure t_ENUM_INT(param_type string, variables_type string, param ENUM ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_INT('ENUM', 'INT', 'yellow' ) ;
drop procedure t_ENUM_INT ;


call print_message('t_BLOB_INT. This scenario is a failure.');
create or replace procedure t_BLOB_INT(param_type string, variables_type string, param BLOB ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_INT('BLOB', 'INT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_INT ;


call print_message('t_CLOB_INT. This scenario is a failure.');
create or replace procedure t_CLOB_INT(param_type string, variables_type string, param CLOB ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_INT('CLOB', 'INT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_INT ;


call print_message('t_JSON_INT. This scenario is a failure.');
create or replace procedure t_JSON_INT(param_type string, variables_type string, param JSON ) as 
VAR INT := param ;
VAR1 INT  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_INT('JSON', 'INT', '{"a":1}' ) ;
drop procedure t_JSON_INT ;
drop procedure print_message;

--+ server-message off
