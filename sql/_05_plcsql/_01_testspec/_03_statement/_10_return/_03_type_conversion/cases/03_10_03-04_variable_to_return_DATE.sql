--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATE. This scenario is a success.');
create or replace function t_DATETIME_DATE(variables_type string, return_type string, param_value DATETIME ) RETURN DATE IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_DATE('DATETIME', 'DATE', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_DATE('DATETIME', 'DATE', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_DATE ;



call print_message('t_DATETIMELTZ_DATE. This scenario is a failure.');
create or replace function t_DATETIMELTZ_DATE(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN DATE IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_DATE('DATETIMELTZ', 'DATE', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_DATE('DATETIMELTZ', 'DATE', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_DATE ;



call print_message('t_DATETIMETZ_DATE. This scenario is a failure.');
create or replace function t_DATETIMETZ_DATE(variables_type string, return_type string, param_value DATETIMETZ ) RETURN DATE IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_DATE('DATETIMETZ', 'DATE', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_DATE('DATETIMETZ', 'DATE', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_DATE ;



call print_message('t_DATE_DATE. This scenario is a success.');
create or replace function t_DATE_DATE(variables_type string, return_type string, param_value DATE ) RETURN DATE IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_DATE('DATE', 'DATE', DATE'2008-10-31' ), 
 typeof( t_DATE_DATE('DATE', 'DATE', DATE'2008-10-31' ) ) ;
drop function t_DATE_DATE ;



call print_message('t_TIME_DATE. This scenario is a failure.');
create or replace function t_TIME_DATE(variables_type string, return_type string, param_value TIME ) RETURN DATE IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_DATE('TIME', 'DATE', TIME'13:15:45' ), 
 typeof( t_TIME_DATE('TIME', 'DATE', TIME'13:15:45' ) ) ;
drop function t_TIME_DATE ;



call print_message('t_TIMESTAMP_DATE. This scenario is a success.');
create or replace function t_TIMESTAMP_DATE(variables_type string, return_type string, param_value TIMESTAMP ) RETURN DATE IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_DATE('TIMESTAMP', 'DATE', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_DATE('TIMESTAMP', 'DATE', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_DATE ;



call print_message('t_TIMESTAMPLTZ_DATE. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_DATE(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN DATE IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_DATE('TIMESTAMPLTZ', 'DATE', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_DATE('TIMESTAMPLTZ', 'DATE', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_DATE ;



call print_message('t_TIMESTAMPTZ_DATE. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_DATE(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN DATE IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_DATE('TIMESTAMPTZ', 'DATE', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_DATE('TIMESTAMPTZ', 'DATE', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_DATE ;



call print_message('t_DOUBLE_DATE. This scenario is a failure.');
create or replace function t_DOUBLE_DATE(variables_type string, return_type string, param_value DOUBLE ) RETURN DATE IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_DATE('DOUBLE', 'DATE', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_DATE('DOUBLE', 'DATE', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_DATE ;



call print_message('t_FLOAT_DATE. This scenario is a failure.');
create or replace function t_FLOAT_DATE(variables_type string, return_type string, param_value FLOAT ) RETURN DATE IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_DATE('FLOAT', 'DATE', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_DATE('FLOAT', 'DATE', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_DATE ;



call print_message('t_NUMERIC(8,4)_DATE. This scenario is a failure.');
create or replace function t_NUMERIC_DATE(variables_type string, return_type string, param_value NUMERIC ) RETURN DATE IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_DATE('NUMERIC(8,4)', 'DATE', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_DATE('NUMERIC(8,4)', 'DATE', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_DATE ;



call print_message('t_BIGINT_DATE. This scenario is a failure.');
create or replace function t_BIGINT_DATE(variables_type string, return_type string, param_value BIGINT ) RETURN DATE IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_DATE('BIGINT', 'DATE', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_DATE('BIGINT', 'DATE', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_DATE ;



call print_message('t_INT_DATE. This scenario is a failure.');
create or replace function t_INT_DATE(variables_type string, return_type string, param_value INT ) RETURN DATE IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_DATE('INT', 'DATE', cast( 782346 as int ) ), 
 typeof( t_INT_DATE('INT', 'DATE', cast( 782346 as int ) ) ) ;
drop function t_INT_DATE ;



call print_message('t_SHORT_DATE. This scenario is a failure.');
create or replace function t_SHORT_DATE(variables_type string, return_type string, param_value SHORT ) RETURN DATE IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_DATE('SHORT', 'DATE', cast( 8934 as short ) ), 
 typeof( t_SHORT_DATE('SHORT', 'DATE', cast( 8934 as short ) ) ) ;
drop function t_SHORT_DATE ;



call print_message('t_BIT(8)_DATE. This scenario is a failure.');
create or replace function t_BIT_DATE(variables_type string, return_type string, param_value BIT ) RETURN DATE IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_DATE('BIT(8)', 'DATE', 0xaa ), 
 typeof( t_BIT_DATE('BIT(8)', 'DATE', 0xaa ) ) ;
drop function t_BIT_DATE ;



call print_message('t_BIT VARYING_DATE. This scenario is a failure.');
create or replace function t_BITVARYING_DATE(variables_type string, return_type string, param_value BITVARYING ) RETURN DATE IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_DATE('BIT VARYING', 'DATE', 0xaa ), 
 typeof( t_BITVARYING_DATE('BIT VARYING', 'DATE', 0xaa ) ) ;
drop function t_BITVARYING_DATE ;



call print_message('t_CHAR_DATE. This scenario is a success.');
create or replace function t_CHAR_DATE(variables_type string, return_type string, param_value CHAR ) RETURN DATE IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_DATE('CHAR', 'DATE', cast( '09/01/2005' as char(10) ) ), 
 typeof( t_CHAR_DATE('CHAR', 'DATE', cast( '09/01/2005' as char(10) ) ) ) ;
drop function t_CHAR_DATE ;



call print_message('t_VARCHAR_DATE. This scenario is a success.');
create or replace function t_VARCHAR_DATE(variables_type string, return_type string, param_value VARCHAR ) RETURN DATE IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_DATE('VARCHAR', 'DATE', cast( '09/01/2019' as varchar(10) ) ), 
 typeof( t_VARCHAR_DATE('VARCHAR', 'DATE', cast( '09/01/2019' as varchar(10) ) ) ) ;
drop function t_VARCHAR_DATE ;



call print_message('t_SET_DATE. This scenario is a failure.');
create or replace function t_SET_DATE(variables_type string, return_type string, param_value SET ) RETURN DATE IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_DATE('SET', 'DATE', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_DATE('SET', 'DATE', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_DATE ;



call print_message('t_MULTISET_DATE. This scenario is a failure.');
create or replace function t_MULTISET_DATE(variables_type string, return_type string, param_value MULTISET ) RETURN DATE IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_DATE('MULTISET', 'DATE', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_DATE('MULTISET', 'DATE', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_DATE ;



call print_message('t_LIST_DATE. This scenario is a failure.');
create or replace function t_LIST_DATE(variables_type string, return_type string, param_value LIST ) RETURN DATE IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_DATE('LIST', 'DATE', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_DATE('LIST', 'DATE', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_DATE ;



call print_message('t_ENUM_DATE. This scenario is a failure.');
create or replace function t_ENUM_DATE(variables_type string, return_type string, param_value ENUM ) RETURN DATE IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_DATE('ENUM', 'DATE', 'yellow' ), 
 typeof( t_ENUM_DATE('ENUM', 'DATE', 'yellow' ) ) ;
drop function t_ENUM_DATE ;



call print_message('t_BLOB_DATE. This scenario is a failure.');
create or replace function t_BLOB_DATE(variables_type string, return_type string, param_value BLOB ) RETURN DATE IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_DATE('BLOB', 'DATE', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_DATE('BLOB', 'DATE', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_DATE ;



call print_message('t_CLOB_DATE. This scenario is a failure.');
create or replace function t_CLOB_DATE(variables_type string, return_type string, param_value CLOB ) RETURN DATE IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_DATE('CLOB', 'DATE', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_DATE('CLOB', 'DATE', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_DATE ;



call print_message('t_JSON_DATE. This scenario is a failure.');
create or replace function t_JSON_DATE(variables_type string, return_type string, param_value JSON ) RETURN DATE IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_DATE('JSON', 'DATE', '{"a":1}' ), 
 typeof( t_JSON_DATE('JSON', 'DATE', '{"a":1}' ) ) ;
drop function t_JSON_DATE ;

drop procedure print_message;

--+ server-message off
