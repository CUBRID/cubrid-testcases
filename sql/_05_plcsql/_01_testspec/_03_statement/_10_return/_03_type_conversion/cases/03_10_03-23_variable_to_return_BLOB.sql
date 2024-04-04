--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BLOB. This scenario is a failure.');
create or replace function t_DATETIME_BLOB(variables_type string, return_type string, param_value DATETIME ) RETURN BLOB IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_BLOB('DATETIME', 'BLOB', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_BLOB('DATETIME', 'BLOB', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_BLOB ;



call print_message('t_DATETIMELTZ_BLOB. This scenario is a failure.');
create or replace function t_DATETIMELTZ_BLOB(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN BLOB IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_BLOB('DATETIMELTZ', 'BLOB', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_BLOB('DATETIMELTZ', 'BLOB', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_BLOB ;



call print_message('t_DATETIMETZ_BLOB. This scenario is a failure.');
create or replace function t_DATETIMETZ_BLOB(variables_type string, return_type string, param_value DATETIMETZ ) RETURN BLOB IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_BLOB('DATETIMETZ', 'BLOB', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_BLOB('DATETIMETZ', 'BLOB', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_BLOB ;



call print_message('t_DATE_BLOB. This scenario is a failure.');
create or replace function t_DATE_BLOB(variables_type string, return_type string, param_value DATE ) RETURN BLOB IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_BLOB('DATE', 'BLOB', DATE'2008-10-31' ), 
 typeof( t_DATE_BLOB('DATE', 'BLOB', DATE'2008-10-31' ) ) ;
drop function t_DATE_BLOB ;



call print_message('t_TIME_BLOB. This scenario is a failure.');
create or replace function t_TIME_BLOB(variables_type string, return_type string, param_value TIME ) RETURN BLOB IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_BLOB('TIME', 'BLOB', TIME'13:15:45' ), 
 typeof( t_TIME_BLOB('TIME', 'BLOB', TIME'13:15:45' ) ) ;
drop function t_TIME_BLOB ;



call print_message('t_TIMESTAMP_BLOB. This scenario is a failure.');
create or replace function t_TIMESTAMP_BLOB(variables_type string, return_type string, param_value TIMESTAMP ) RETURN BLOB IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_BLOB('TIMESTAMP', 'BLOB', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_BLOB('TIMESTAMP', 'BLOB', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_BLOB ;



call print_message('t_TIMESTAMPLTZ_BLOB. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_BLOB(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN BLOB IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_BLOB('TIMESTAMPLTZ', 'BLOB', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_BLOB('TIMESTAMPLTZ', 'BLOB', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_BLOB ;



call print_message('t_TIMESTAMPTZ_BLOB. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_BLOB(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN BLOB IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_BLOB('TIMESTAMPTZ', 'BLOB', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_BLOB('TIMESTAMPTZ', 'BLOB', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_BLOB ;



call print_message('t_DOUBLE_BLOB. This scenario is a failure.');
create or replace function t_DOUBLE_BLOB(variables_type string, return_type string, param_value DOUBLE ) RETURN BLOB IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_BLOB('DOUBLE', 'BLOB', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_BLOB('DOUBLE', 'BLOB', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_BLOB ;



call print_message('t_FLOAT_BLOB. This scenario is a failure.');
create or replace function t_FLOAT_BLOB(variables_type string, return_type string, param_value FLOAT ) RETURN BLOB IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_BLOB('FLOAT', 'BLOB', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_BLOB('FLOAT', 'BLOB', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_BLOB ;



call print_message('t_NUMERIC(8,4)_BLOB. This scenario is a failure.');
create or replace function t_NUMERIC_BLOB(variables_type string, return_type string, param_value NUMERIC ) RETURN BLOB IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_BLOB('NUMERIC(8,4)', 'BLOB', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_BLOB('NUMERIC(8,4)', 'BLOB', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_BLOB ;



call print_message('t_BIGINT_BLOB. This scenario is a failure.');
create or replace function t_BIGINT_BLOB(variables_type string, return_type string, param_value BIGINT ) RETURN BLOB IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_BLOB('BIGINT', 'BLOB', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_BLOB('BIGINT', 'BLOB', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_BLOB ;



call print_message('t_INT_BLOB. This scenario is a failure.');
create or replace function t_INT_BLOB(variables_type string, return_type string, param_value INT ) RETURN BLOB IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_BLOB('INT', 'BLOB', cast( 782346 as int ) ), 
 typeof( t_INT_BLOB('INT', 'BLOB', cast( 782346 as int ) ) ) ;
drop function t_INT_BLOB ;



call print_message('t_SHORT_BLOB. This scenario is a failure.');
create or replace function t_SHORT_BLOB(variables_type string, return_type string, param_value SHORT ) RETURN BLOB IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_BLOB('SHORT', 'BLOB', cast( 8934 as short ) ), 
 typeof( t_SHORT_BLOB('SHORT', 'BLOB', cast( 8934 as short ) ) ) ;
drop function t_SHORT_BLOB ;



call print_message('t_BIT(8)_BLOB. This scenario is a failure.');
create or replace function t_BIT_BLOB(variables_type string, return_type string, param_value BIT ) RETURN BLOB IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_BLOB('BIT(8)', 'BLOB', 0xaa ), 
 typeof( t_BIT_BLOB('BIT(8)', 'BLOB', 0xaa ) ) ;
drop function t_BIT_BLOB ;



call print_message('t_BIT VARYING_BLOB. This scenario is a failure.');
create or replace function t_BITVARYING_BLOB(variables_type string, return_type string, param_value BITVARYING ) RETURN BLOB IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_BLOB('BIT VARYING', 'BLOB', 0xaa ), 
 typeof( t_BITVARYING_BLOB('BIT VARYING', 'BLOB', 0xaa ) ) ;
drop function t_BITVARYING_BLOB ;



call print_message('t_CHAR_BLOB. This scenario is a failure.');
create or replace function t_CHAR_BLOB(variables_type string, return_type string, param_value CHAR ) RETURN BLOB IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_BLOB('CHAR', 'BLOB', 0xaa ), 
 typeof( t_CHAR_BLOB('CHAR', 'BLOB', 0xaa ) ) ;
drop function t_CHAR_BLOB ;



call print_message('t_VARCHAR_BLOB. This scenario is a failure.');
create or replace function t_VARCHAR_BLOB(variables_type string, return_type string, param_value VARCHAR ) RETURN BLOB IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_BLOB('VARCHAR', 'BLOB', 0xaa ), 
 typeof( t_VARCHAR_BLOB('VARCHAR', 'BLOB', 0xaa ) ) ;
drop function t_VARCHAR_BLOB ;



call print_message('t_SET_BLOB. This scenario is a failure.');
create or replace function t_SET_BLOB(variables_type string, return_type string, param_value SET ) RETURN BLOB IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_BLOB('SET', 'BLOB', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_BLOB('SET', 'BLOB', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_BLOB ;



call print_message('t_MULTISET_BLOB. This scenario is a failure.');
create or replace function t_MULTISET_BLOB(variables_type string, return_type string, param_value MULTISET ) RETURN BLOB IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_BLOB('MULTISET', 'BLOB', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_BLOB('MULTISET', 'BLOB', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_BLOB ;



call print_message('t_LIST_BLOB. This scenario is a failure.');
create or replace function t_LIST_BLOB(variables_type string, return_type string, param_value LIST ) RETURN BLOB IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_BLOB('LIST', 'BLOB', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_BLOB('LIST', 'BLOB', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_BLOB ;



call print_message('t_ENUM_BLOB. This scenario is a failure.');
create or replace function t_ENUM_BLOB(variables_type string, return_type string, param_value ENUM ) RETURN BLOB IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_BLOB('ENUM', 'BLOB', 'yellow' ), 
 typeof( t_ENUM_BLOB('ENUM', 'BLOB', 'yellow' ) ) ;
drop function t_ENUM_BLOB ;



call print_message('t_BLOB_BLOB. This scenario is a failure.');
create or replace function t_BLOB_BLOB(variables_type string, return_type string, param_value BLOB ) RETURN BLOB IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_BLOB('BLOB', 'BLOB', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_BLOB('BLOB', 'BLOB', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_BLOB ;



call print_message('t_CLOB_BLOB. This scenario is a failure.');
create or replace function t_CLOB_BLOB(variables_type string, return_type string, param_value CLOB ) RETURN BLOB IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_BLOB('CLOB', 'BLOB', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_BLOB('CLOB', 'BLOB', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_BLOB ;



call print_message('t_JSON_BLOB. This scenario is a failure.');
create or replace function t_JSON_BLOB(variables_type string, return_type string, param_value JSON ) RETURN BLOB IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_BLOB('JSON', 'BLOB', '{"a":1}' ), 
 typeof( t_JSON_BLOB('JSON', 'BLOB', '{"a":1}' ) ) ;
drop function t_JSON_BLOB ;

drop procedure print_message;

--+ server-message off
