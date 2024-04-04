--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIME. This scenario is a success.');
create or replace function t_DATETIME_TIME(variables_type string, return_type string, param_value DATETIME ) RETURN TIME IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_TIME('DATETIME', 'TIME', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_TIME('DATETIME', 'TIME', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_TIME ;



call print_message('t_DATETIMELTZ_TIME. This scenario is a failure.');
create or replace function t_DATETIMELTZ_TIME(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN TIME IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_TIME('DATETIMELTZ', 'TIME', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_TIME('DATETIMELTZ', 'TIME', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_TIME ;



call print_message('t_DATETIMETZ_TIME. This scenario is a failure.');
create or replace function t_DATETIMETZ_TIME(variables_type string, return_type string, param_value DATETIMETZ ) RETURN TIME IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_TIME('DATETIMETZ', 'TIME', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_TIME('DATETIMETZ', 'TIME', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_TIME ;



call print_message('t_DATE_TIME. This scenario is a failure.');
create or replace function t_DATE_TIME(variables_type string, return_type string, param_value DATE ) RETURN TIME IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_TIME('DATE', 'TIME', DATE'2008-10-31' ), 
 typeof( t_DATE_TIME('DATE', 'TIME', DATE'2008-10-31' ) ) ;
drop function t_DATE_TIME ;



call print_message('t_TIME_TIME. This scenario is a success.');
create or replace function t_TIME_TIME(variables_type string, return_type string, param_value TIME ) RETURN TIME IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_TIME('TIME', 'TIME', TIME'13:15:45' ), 
 typeof( t_TIME_TIME('TIME', 'TIME', TIME'13:15:45' ) ) ;
drop function t_TIME_TIME ;



call print_message('t_TIMESTAMP_TIME. This scenario is a success.');
create or replace function t_TIMESTAMP_TIME(variables_type string, return_type string, param_value TIMESTAMP ) RETURN TIME IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_TIME('TIMESTAMP', 'TIME', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_TIME('TIMESTAMP', 'TIME', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_TIME ;



call print_message('t_TIMESTAMPLTZ_TIME. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_TIME(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN TIME IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_TIME('TIMESTAMPLTZ', 'TIME', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_TIME('TIMESTAMPLTZ', 'TIME', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_TIME ;



call print_message('t_TIMESTAMPTZ_TIME. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_TIME(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN TIME IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_TIME('TIMESTAMPTZ', 'TIME', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_TIME('TIMESTAMPTZ', 'TIME', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_TIME ;



call print_message('t_DOUBLE_TIME. This scenario is a success.');
create or replace function t_DOUBLE_TIME(variables_type string, return_type string, param_value DOUBLE ) RETURN TIME IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_TIME('DOUBLE', 'TIME', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_TIME('DOUBLE', 'TIME', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_TIME ;



call print_message('t_FLOAT_TIME. This scenario is a success.');
create or replace function t_FLOAT_TIME(variables_type string, return_type string, param_value FLOAT ) RETURN TIME IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_TIME('FLOAT', 'TIME', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_TIME('FLOAT', 'TIME', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_TIME ;



call print_message('t_NUMERIC(8,4)_TIME. This scenario is a failure.');
create or replace function t_NUMERIC_TIME(variables_type string, return_type string, param_value NUMERIC ) RETURN TIME IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_TIME('NUMERIC(8,4)', 'TIME', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_TIME('NUMERIC(8,4)', 'TIME', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_TIME ;



call print_message('t_BIGINT_TIME. This scenario is a success.');
create or replace function t_BIGINT_TIME(variables_type string, return_type string, param_value BIGINT ) RETURN TIME IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_TIME('BIGINT', 'TIME', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_TIME('BIGINT', 'TIME', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_TIME ;



call print_message('t_INT_TIME. This scenario is a success.');
create or replace function t_INT_TIME(variables_type string, return_type string, param_value INT ) RETURN TIME IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_TIME('INT', 'TIME', cast( 782346 as int ) ), 
 typeof( t_INT_TIME('INT', 'TIME', cast( 782346 as int ) ) ) ;
drop function t_INT_TIME ;



call print_message('t_SHORT_TIME. This scenario is a success.');
create or replace function t_SHORT_TIME(variables_type string, return_type string, param_value SHORT ) RETURN TIME IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_TIME('SHORT', 'TIME', cast( 8934 as short ) ), 
 typeof( t_SHORT_TIME('SHORT', 'TIME', cast( 8934 as short ) ) ) ;
drop function t_SHORT_TIME ;



call print_message('t_BIT(8)_TIME. This scenario is a failure.');
create or replace function t_BIT_TIME(variables_type string, return_type string, param_value BIT ) RETURN TIME IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_TIME('BIT(8)', 'TIME', 0xaa ), 
 typeof( t_BIT_TIME('BIT(8)', 'TIME', 0xaa ) ) ;
drop function t_BIT_TIME ;



call print_message('t_BIT VARYING_TIME. This scenario is a failure.');
create or replace function t_BITVARYING_TIME(variables_type string, return_type string, param_value BITVARYING ) RETURN TIME IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_TIME('BIT VARYING', 'TIME', 0xaa ), 
 typeof( t_BITVARYING_TIME('BIT VARYING', 'TIME', 0xaa ) ) ;
drop function t_BITVARYING_TIME ;



call print_message('t_CHAR_TIME. This scenario is a success.');
create or replace function t_CHAR_TIME(variables_type string, return_type string, param_value CHAR ) RETURN TIME IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_TIME('CHAR', 'TIME', cast( '05:05:05 pm' as char(11) ) ), 
 typeof( t_CHAR_TIME('CHAR', 'TIME', cast( '05:05:05 pm' as char(11) ) ) ) ;
drop function t_CHAR_TIME ;



call print_message('t_VARCHAR_TIME. This scenario is a success.');
create or replace function t_VARCHAR_TIME(variables_type string, return_type string, param_value VARCHAR ) RETURN TIME IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_TIME('VARCHAR', 'TIME', cast( '09:09:09 pm' as varchar ) ), 
 typeof( t_VARCHAR_TIME('VARCHAR', 'TIME', cast( '09:09:09 pm' as varchar ) ) ) ;
drop function t_VARCHAR_TIME ;



call print_message('t_SET_TIME. This scenario is a failure.');
create or replace function t_SET_TIME(variables_type string, return_type string, param_value SET ) RETURN TIME IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_TIME('SET', 'TIME', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_TIME('SET', 'TIME', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_TIME ;



call print_message('t_MULTISET_TIME. This scenario is a failure.');
create or replace function t_MULTISET_TIME(variables_type string, return_type string, param_value MULTISET ) RETURN TIME IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_TIME('MULTISET', 'TIME', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_TIME('MULTISET', 'TIME', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_TIME ;



call print_message('t_LIST_TIME. This scenario is a failure.');
create or replace function t_LIST_TIME(variables_type string, return_type string, param_value LIST ) RETURN TIME IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_TIME('LIST', 'TIME', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_TIME('LIST', 'TIME', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_TIME ;



call print_message('t_ENUM_TIME. This scenario is a failure.');
create or replace function t_ENUM_TIME(variables_type string, return_type string, param_value ENUM ) RETURN TIME IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_TIME('ENUM', 'TIME', 'yellow' ), 
 typeof( t_ENUM_TIME('ENUM', 'TIME', 'yellow' ) ) ;
drop function t_ENUM_TIME ;



call print_message('t_BLOB_TIME. This scenario is a failure.');
create or replace function t_BLOB_TIME(variables_type string, return_type string, param_value BLOB ) RETURN TIME IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_TIME('BLOB', 'TIME', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_TIME('BLOB', 'TIME', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_TIME ;



call print_message('t_CLOB_TIME. This scenario is a failure.');
create or replace function t_CLOB_TIME(variables_type string, return_type string, param_value CLOB ) RETURN TIME IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_TIME('CLOB', 'TIME', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_TIME('CLOB', 'TIME', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_TIME ;



call print_message('t_JSON_TIME. This scenario is a failure.');
create or replace function t_JSON_TIME(variables_type string, return_type string, param_value JSON ) RETURN TIME IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_TIME('JSON', 'TIME', '{"a":1}' ), 
 typeof( t_JSON_TIME('JSON', 'TIME', '{"a":1}' ) ) ;
drop function t_JSON_TIME ;

drop procedure print_message;

--+ server-message off
