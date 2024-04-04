--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_SET. This scenario is a failure.');
create or replace procedure t_DATETIME_SET(param_type string, variables_type string, param DATETIME ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIME_SET('DATETIME', 'SET', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_SET ;


call print_message('t_DATETIMELTZ_SET. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_SET(param_type string, variables_type string, param DATETIMELTZ ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMELTZ_SET('DATETIMELTZ', 'SET', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_SET ;


call print_message('t_DATETIMETZ_SET. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_SET(param_type string, variables_type string, param DATETIMETZ ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATETIMETZ_SET('DATETIMETZ', 'SET', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_SET ;


call print_message('t_DATE_SET. This scenario is a failure.');
create or replace procedure t_DATE_SET(param_type string, variables_type string, param DATE ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DATE_SET('DATE', 'SET', DATE'2008-10-31' ) ;
drop procedure t_DATE_SET ;


call print_message('t_TIME_SET. This scenario is a failure.');
create or replace procedure t_TIME_SET(param_type string, variables_type string, param TIME ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIME_SET('TIME', 'SET', TIME'13:15:45' ) ;
drop procedure t_TIME_SET ;


call print_message('t_TIMESTAMP_SET. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_SET(param_type string, variables_type string, param TIMESTAMP ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMP_SET('TIMESTAMP', 'SET', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_SET ;


call print_message('t_TIMESTAMPLTZ_SET. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_SET(param_type string, variables_type string, param TIMESTAMPLTZ ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPLTZ_SET('TIMESTAMPLTZ', 'SET', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_SET ;


call print_message('t_TIMESTAMPTZ_SET. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_SET(param_type string, variables_type string, param TIMESTAMPTZ ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_TIMESTAMPTZ_SET('TIMESTAMPTZ', 'SET', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_SET ;


call print_message('t_DOUBLE_SET. This scenario is a failure.');
create or replace procedure t_DOUBLE_SET(param_type string, variables_type string, param DOUBLE ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_DOUBLE_SET('DOUBLE', 'SET', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_SET ;


call print_message('t_FLOAT_SET. This scenario is a failure.');
create or replace procedure t_FLOAT_SET(param_type string, variables_type string, param FLOAT ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_FLOAT_SET('FLOAT', 'SET', cast( 1677.217 as float ) ) ;
drop procedure t_FLOAT_SET ;


call print_message('t_NUMERIC(8,4)_SET. This scenario is a failure.');
create or replace procedure t_NUMERIC_SET(param_type string, variables_type string, param NUMERIC(8,4) ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_NUMERIC_SET('NUMERIC(8,4)', 'SET', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_SET ;


call print_message('t_BIGINT_SET. This scenario is a failure.');
create or replace procedure t_BIGINT_SET(param_type string, variables_type string, param BIGINT ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIGINT_SET('BIGINT', 'SET', decode('SET', 'INT',cast( 34589012 as bigint ) /1000, 'SHORT', cast( 34589012 as bigint ) /10000, 'NUMERIC(8,4)', cast( 34589012 as bigint ) /10000, cast( 34589012 as bigint ) )  ) ;
drop procedure t_BIGINT_SET ;


call print_message('t_INT_SET. This scenario is a failure.');
create or replace procedure t_INT_SET(param_type string, variables_type string, param INT ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_INT_SET('INT', 'SET', decode('SET', 'INT',cast( 782346 as int ) /1000, 'SHORT', cast( 782346 as int ) /10000, 'NUMERIC(8,4)', cast( 782346 as int ) /10000, cast( 782346 as int ) )  ) ;
drop procedure t_INT_SET ;


call print_message('t_SHORT_SET. This scenario is a failure.');
create or replace procedure t_SHORT_SET(param_type string, variables_type string, param SHORT ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SHORT_SET('SHORT', 'SET', decode('SET', 'INT',cast( 8934 as short ) /1000, 'SHORT', cast( 8934 as short ) /10000, 'NUMERIC(8,4)', cast( 8934 as short ) /10000, cast( 8934 as short ) )  ) ;
drop procedure t_SHORT_SET ;


call print_message('t_BIT(8)_SET. This scenario is a failure.');
create or replace procedure t_BIT_SET(param_type string, variables_type string, param BIT(8) ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BIT_SET('BIT(8)', 'SET', 0xaa ) ;
drop procedure t_BIT_SET ;


call print_message('t_BIT VARYING_SET. This scenario is a failure.');
create or replace procedure t_BITVARYING_SET(param_type string, variables_type string, param BIT VARYING ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BITVARYING_SET('BIT VARYING', 'SET', 0xaa ) ;
drop procedure t_BITVARYING_SET ;


call print_message('t_CHAR_SET. This scenario is a failure.');
create or replace procedure t_CHAR_SET(param_type string, variables_type string, param CHAR ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CHAR_SET('CHAR', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_CHAR_SET ;


call print_message('t_VARCHAR_SET. This scenario is a failure.');
create or replace procedure t_VARCHAR_SET(param_type string, variables_type string, param VARCHAR ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_VARCHAR_SET('VARCHAR', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_VARCHAR_SET ;


call print_message('t_SET_SET. This scenario is a failure.');
create or replace procedure t_SET_SET(param_type string, variables_type string, param SET ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_SET_SET('SET', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_SET ;


call print_message('t_MULTISET_SET. This scenario is a failure.');
create or replace procedure t_MULTISET_SET(param_type string, variables_type string, param MULTISET ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_MULTISET_SET('MULTISET', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_SET ;


call print_message('t_LIST_SET. This scenario is a failure.');
create or replace procedure t_LIST_SET(param_type string, variables_type string, param LIST ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_LIST_SET('LIST', 'SET', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_SET ;


call print_message('t_ENUM_SET. This scenario is a failure.');
create or replace procedure t_ENUM_SET(param_type string, variables_type string, param ENUM ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_ENUM_SET('ENUM', 'SET', 'yellow' ) ;
drop procedure t_ENUM_SET ;


call print_message('t_BLOB_SET. This scenario is a failure.');
create or replace procedure t_BLOB_SET(param_type string, variables_type string, param BLOB ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_BLOB_SET('BLOB', 'SET', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_SET ;


call print_message('t_CLOB_SET. This scenario is a failure.');
create or replace procedure t_CLOB_SET(param_type string, variables_type string, param CLOB ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_CLOB_SET('CLOB', 'SET', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_SET ;


call print_message('t_JSON_SET. This scenario is a failure.');
create or replace procedure t_JSON_SET(param_type string, variables_type string, param JSON ) as 
VAR SET := param ;
VAR1 SET  ;
begin
VAR1 := VAR ;
    dbms_output.put_line('param_type = ' ||param_type ||', variables_type = '||variables_type||', param=>variables = '|| VAR ); 
    dbms_output.put_line('variables=>variables = ' || VAR1  ); 
end;
call t_JSON_SET('JSON', 'SET', '{"a":1}' ) ;
drop procedure t_JSON_SET ;
drop procedure print_message;

--+ server-message off
