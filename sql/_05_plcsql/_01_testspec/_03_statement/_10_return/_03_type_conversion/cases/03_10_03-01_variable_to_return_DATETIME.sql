--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIME. This scenario is a success.');
create or replace function t_DATETIME_DATETIME(variables_type string, return_type string, param_value DATETIME ) RETURN DATETIME IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_DATETIME('DATETIME', 'DATETIME', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_DATETIME('DATETIME', 'DATETIME', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_DATETIME ;



call print_message('t_DATETIMELTZ_DATETIME. This scenario is a failure.');
create or replace function t_DATETIMELTZ_DATETIME(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN DATETIME IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_DATETIME('DATETIMELTZ', 'DATETIME', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_DATETIME('DATETIMELTZ', 'DATETIME', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_DATETIME ;



call print_message('t_DATETIMETZ_DATETIME. This scenario is a failure.');
create or replace function t_DATETIMETZ_DATETIME(variables_type string, return_type string, param_value DATETIMETZ ) RETURN DATETIME IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_DATETIME('DATETIMETZ', 'DATETIME', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_DATETIME('DATETIMETZ', 'DATETIME', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_DATETIME ;



call print_message('t_DATE_DATETIME. This scenario is a success.');
create or replace function t_DATE_DATETIME(variables_type string, return_type string, param_value DATE ) RETURN DATETIME IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_DATETIME('DATE', 'DATETIME', DATE'2008-10-31' ), 
 typeof( t_DATE_DATETIME('DATE', 'DATETIME', DATE'2008-10-31' ) ) ;
drop function t_DATE_DATETIME ;



call print_message('t_TIME_DATETIME. This scenario is a failure.');
create or replace function t_TIME_DATETIME(variables_type string, return_type string, param_value TIME ) RETURN DATETIME IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_DATETIME('TIME', 'DATETIME', TIME'13:15:45' ), 
 typeof( t_TIME_DATETIME('TIME', 'DATETIME', TIME'13:15:45' ) ) ;
drop function t_TIME_DATETIME ;



call print_message('t_TIMESTAMP_DATETIME. This scenario is a success.');
create or replace function t_TIMESTAMP_DATETIME(variables_type string, return_type string, param_value TIMESTAMP ) RETURN DATETIME IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_DATETIME('TIMESTAMP', 'DATETIME', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_DATETIME('TIMESTAMP', 'DATETIME', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_DATETIME ;



call print_message('t_TIMESTAMPLTZ_DATETIME. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_DATETIME(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN DATETIME IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_DATETIME('TIMESTAMPLTZ', 'DATETIME', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_DATETIME('TIMESTAMPLTZ', 'DATETIME', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_DATETIME ;



call print_message('t_TIMESTAMPTZ_DATETIME. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_DATETIME(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN DATETIME IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_DATETIME('TIMESTAMPTZ', 'DATETIME', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_DATETIME('TIMESTAMPTZ', 'DATETIME', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_DATETIME ;



call print_message('t_DOUBLE_DATETIME. This scenario is a failure.');
create or replace function t_DOUBLE_DATETIME(variables_type string, return_type string, param_value DOUBLE ) RETURN DATETIME IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_DATETIME('DOUBLE', 'DATETIME', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_DATETIME('DOUBLE', 'DATETIME', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_DATETIME ;



call print_message('t_FLOAT_DATETIME. This scenario is a failure.');
create or replace function t_FLOAT_DATETIME(variables_type string, return_type string, param_value FLOAT ) RETURN DATETIME IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_DATETIME('FLOAT', 'DATETIME', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_DATETIME('FLOAT', 'DATETIME', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_DATETIME ;



call print_message('t_NUMERIC(8,4)_DATETIME. This scenario is a failure.');
create or replace function t_NUMERIC_DATETIME(variables_type string, return_type string, param_value NUMERIC ) RETURN DATETIME IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_DATETIME('NUMERIC(8,4)', 'DATETIME', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_DATETIME('NUMERIC(8,4)', 'DATETIME', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_DATETIME ;



call print_message('t_BIGINT_DATETIME. This scenario is a failure.');
create or replace function t_BIGINT_DATETIME(variables_type string, return_type string, param_value BIGINT ) RETURN DATETIME IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_DATETIME('BIGINT', 'DATETIME', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_DATETIME('BIGINT', 'DATETIME', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_DATETIME ;



call print_message('t_INT_DATETIME. This scenario is a failure.');
create or replace function t_INT_DATETIME(variables_type string, return_type string, param_value INT ) RETURN DATETIME IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_DATETIME('INT', 'DATETIME', cast( 782346 as int ) ), 
 typeof( t_INT_DATETIME('INT', 'DATETIME', cast( 782346 as int ) ) ) ;
drop function t_INT_DATETIME ;



call print_message('t_SHORT_DATETIME. This scenario is a failure.');
create or replace function t_SHORT_DATETIME(variables_type string, return_type string, param_value SHORT ) RETURN DATETIME IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_DATETIME('SHORT', 'DATETIME', cast( 8934 as short ) ), 
 typeof( t_SHORT_DATETIME('SHORT', 'DATETIME', cast( 8934 as short ) ) ) ;
drop function t_SHORT_DATETIME ;



call print_message('t_BIT(8)_DATETIME. This scenario is a failure.');
create or replace function t_BIT_DATETIME(variables_type string, return_type string, param_value BIT ) RETURN DATETIME IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_DATETIME('BIT(8)', 'DATETIME', 0xaa ), 
 typeof( t_BIT_DATETIME('BIT(8)', 'DATETIME', 0xaa ) ) ;
drop function t_BIT_DATETIME ;



call print_message('t_BIT VARYING_DATETIME. This scenario is a failure.');
create or replace function t_BITVARYING_DATETIME(variables_type string, return_type string, param_value BITVARYING ) RETURN DATETIME IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_DATETIME('BIT VARYING', 'DATETIME', 0xaa ), 
 typeof( t_BITVARYING_DATETIME('BIT VARYING', 'DATETIME', 0xaa ) ) ;
drop function t_BITVARYING_DATETIME ;



call print_message('t_CHAR_DATETIME. This scenario is a success.');
create or replace function t_CHAR_DATETIME(variables_type string, return_type string, param_value CHAR ) RETURN DATETIME IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_DATETIME('CHAR', 'DATETIME', cast( '09/01/2005 05:05:05 pm' as char(22) ) ), 
 typeof( t_CHAR_DATETIME('CHAR', 'DATETIME', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ) ;
drop function t_CHAR_DATETIME ;



call print_message('t_VARCHAR_DATETIME. This scenario is a success.');
create or replace function t_VARCHAR_DATETIME(variables_type string, return_type string, param_value VARCHAR ) RETURN DATETIME IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_DATETIME('VARCHAR', 'DATETIME', cast( '09/01/2019 09:09:09 pm' as varchar ) ), 
 typeof( t_VARCHAR_DATETIME('VARCHAR', 'DATETIME', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ) ;
drop function t_VARCHAR_DATETIME ;



call print_message('t_SET_DATETIME. This scenario is a failure.');
create or replace function t_SET_DATETIME(variables_type string, return_type string, param_value SET ) RETURN DATETIME IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_DATETIME('SET', 'DATETIME', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_DATETIME('SET', 'DATETIME', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_DATETIME ;



call print_message('t_MULTISET_DATETIME. This scenario is a failure.');
create or replace function t_MULTISET_DATETIME(variables_type string, return_type string, param_value MULTISET ) RETURN DATETIME IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_DATETIME('MULTISET', 'DATETIME', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_DATETIME('MULTISET', 'DATETIME', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_DATETIME ;



call print_message('t_LIST_DATETIME. This scenario is a failure.');
create or replace function t_LIST_DATETIME(variables_type string, return_type string, param_value LIST ) RETURN DATETIME IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_DATETIME('LIST', 'DATETIME', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_DATETIME('LIST', 'DATETIME', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_DATETIME ;



call print_message('t_ENUM_DATETIME. This scenario is a failure.');
create or replace function t_ENUM_DATETIME(variables_type string, return_type string, param_value ENUM ) RETURN DATETIME IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_DATETIME('ENUM', 'DATETIME', 'yellow' ), 
 typeof( t_ENUM_DATETIME('ENUM', 'DATETIME', 'yellow' ) ) ;
drop function t_ENUM_DATETIME ;



call print_message('t_BLOB_DATETIME. This scenario is a failure.');
create or replace function t_BLOB_DATETIME(variables_type string, return_type string, param_value BLOB ) RETURN DATETIME IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_DATETIME('BLOB', 'DATETIME', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_DATETIME('BLOB', 'DATETIME', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_DATETIME ;



call print_message('t_CLOB_DATETIME. This scenario is a failure.');
create or replace function t_CLOB_DATETIME(variables_type string, return_type string, param_value CLOB ) RETURN DATETIME IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_DATETIME('CLOB', 'DATETIME', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_DATETIME('CLOB', 'DATETIME', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_DATETIME ;



call print_message('t_JSON_DATETIME. This scenario is a failure.');
create or replace function t_JSON_DATETIME(variables_type string, return_type string, param_value JSON ) RETURN DATETIME IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_DATETIME('JSON', 'DATETIME', '{"a":1}' ), 
 typeof( t_JSON_DATETIME('JSON', 'DATETIME', '{"a":1}' ) ) ;
drop function t_JSON_DATETIME ;

drop procedure print_message;

--+ server-message off
