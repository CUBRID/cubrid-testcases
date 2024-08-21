--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_VARCHAR. This scenario is a success.');
create or replace function t_DATETIME_VARCHAR(variables_type string, return_type string, param_value DATETIME ) RETURN VARCHAR IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_VARCHAR('DATETIME', 'VARCHAR', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_VARCHAR('DATETIME', 'VARCHAR', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_VARCHAR ;



call print_message('t_DATETIMELTZ_VARCHAR. This scenario is a failure.');
create or replace function t_DATETIMELTZ_VARCHAR(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN VARCHAR IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_VARCHAR('DATETIMELTZ', 'VARCHAR', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_VARCHAR('DATETIMELTZ', 'VARCHAR', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_VARCHAR ;



call print_message('t_DATETIMETZ_VARCHAR. This scenario is a failure.');
create or replace function t_DATETIMETZ_VARCHAR(variables_type string, return_type string, param_value DATETIMETZ ) RETURN VARCHAR IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_VARCHAR('DATETIMETZ', 'VARCHAR', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_VARCHAR('DATETIMETZ', 'VARCHAR', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_VARCHAR ;



call print_message('t_DATE_VARCHAR. This scenario is a success.');
create or replace function t_DATE_VARCHAR(variables_type string, return_type string, param_value DATE ) RETURN VARCHAR IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_VARCHAR('DATE', 'VARCHAR', DATE'2008-10-31' ), 
 typeof( t_DATE_VARCHAR('DATE', 'VARCHAR', DATE'2008-10-31' ) ) ;
drop function t_DATE_VARCHAR ;



call print_message('t_TIME_VARCHAR. This scenario is a success.');
create or replace function t_TIME_VARCHAR(variables_type string, return_type string, param_value TIME ) RETURN VARCHAR IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_VARCHAR('TIME', 'VARCHAR', TIME'13:15:45' ), 
 typeof( t_TIME_VARCHAR('TIME', 'VARCHAR', TIME'13:15:45' ) ) ;
drop function t_TIME_VARCHAR ;



call print_message('t_TIMESTAMP_VARCHAR. This scenario is a success.');
create or replace function t_TIMESTAMP_VARCHAR(variables_type string, return_type string, param_value TIMESTAMP ) RETURN VARCHAR IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_VARCHAR('TIMESTAMP', 'VARCHAR', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_VARCHAR('TIMESTAMP', 'VARCHAR', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_VARCHAR ;



call print_message('t_TIMESTAMPLTZ_VARCHAR. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_VARCHAR(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN VARCHAR IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_VARCHAR('TIMESTAMPLTZ', 'VARCHAR', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_VARCHAR('TIMESTAMPLTZ', 'VARCHAR', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_VARCHAR ;



call print_message('t_TIMESTAMPTZ_VARCHAR. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_VARCHAR(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN VARCHAR IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_VARCHAR('TIMESTAMPTZ', 'VARCHAR', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_VARCHAR('TIMESTAMPTZ', 'VARCHAR', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_VARCHAR ;



call print_message('t_DOUBLE_VARCHAR. This scenario is a success.');
create or replace function t_DOUBLE_VARCHAR(variables_type string, return_type string, param_value DOUBLE ) RETURN VARCHAR IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_VARCHAR('DOUBLE', 'VARCHAR', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_VARCHAR('DOUBLE', 'VARCHAR', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_VARCHAR ;



call print_message('t_FLOAT_VARCHAR. This scenario is a success.');
create or replace function t_FLOAT_VARCHAR(variables_type string, return_type string, param_value FLOAT ) RETURN VARCHAR IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_VARCHAR('FLOAT', 'VARCHAR', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_VARCHAR('FLOAT', 'VARCHAR', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_VARCHAR ;



call print_message('t_NUMERIC_VARCHAR. This scenario is a success.');
create or replace function t_NUMERIC_VARCHAR(variables_type string, return_type string, param_value NUMERIC ) RETURN VARCHAR IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_VARCHAR('NUMERIC(8,4)', 'VARCHAR', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_VARCHAR('NUMERIC(8,4)', 'VARCHAR', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_VARCHAR ;



call print_message('t_BIGINT_VARCHAR. This scenario is a success.');
create or replace function t_BIGINT_VARCHAR(variables_type string, return_type string, param_value BIGINT ) RETURN VARCHAR IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_VARCHAR('BIGINT', 'VARCHAR', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_VARCHAR('BIGINT', 'VARCHAR', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_VARCHAR ;



call print_message('t_INT_VARCHAR. This scenario is a success.');
create or replace function t_INT_VARCHAR(variables_type string, return_type string, param_value INT ) RETURN VARCHAR IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_VARCHAR('INT', 'VARCHAR', cast( 782346 as int ) ), 
 typeof( t_INT_VARCHAR('INT', 'VARCHAR', cast( 782346 as int ) ) ) ;
drop function t_INT_VARCHAR ;



call print_message('t_SHORT_VARCHAR. This scenario is a success.');
create or replace function t_SHORT_VARCHAR(variables_type string, return_type string, param_value SHORT ) RETURN VARCHAR IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_VARCHAR('SHORT', 'VARCHAR', cast( 8934 as short ) ), 
 typeof( t_SHORT_VARCHAR('SHORT', 'VARCHAR', cast( 8934 as short ) ) ) ;
drop function t_SHORT_VARCHAR ;



call print_message('t_BIT(8)_VARCHAR. This scenario is a failure.');
create or replace function t_BIT_VARCHAR(variables_type string, return_type string, param_value BIT ) RETURN VARCHAR IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_VARCHAR('BIT(8)', 'VARCHAR', 0xaa ), 
 typeof( t_BIT_VARCHAR('BIT(8)', 'VARCHAR', 0xaa ) ) ;
drop function t_BIT_VARCHAR ;



call print_message('t_BIT VARYING_VARCHAR. This scenario is a failure.');
create or replace function t_BITVARYING_VARCHAR(variables_type string, return_type string, param_value BITVARYING ) RETURN VARCHAR IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_VARCHAR('BIT VARYING', 'VARCHAR', 0xaa ), 
 typeof( t_BITVARYING_VARCHAR('BIT VARYING', 'VARCHAR', 0xaa ) ) ;
drop function t_BITVARYING_VARCHAR ;



call print_message('t_CHAR_VARCHAR. This scenario is a success.');
create or replace function t_CHAR_VARCHAR(variables_type string, return_type string, param_value CHAR ) RETURN VARCHAR IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_VARCHAR('CHAR', 'VARCHAR', 'CHAR CUBRID' ), 
 typeof( t_CHAR_VARCHAR('CHAR', 'VARCHAR', 'CHAR CUBRID' ) ) ;
drop function t_CHAR_VARCHAR ;



call print_message('t_VARCHAR_VARCHAR. This scenario is a success.');
create or replace function t_VARCHAR_VARCHAR(variables_type string, return_type string, param_value VARCHAR ) RETURN VARCHAR IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_VARCHAR('VARCHAR', 'VARCHAR', 'VARCHAR CUBRID' ), 
 typeof( t_VARCHAR_VARCHAR('VARCHAR', 'VARCHAR', 'VARCHAR CUBRID' ) ) ;
drop function t_VARCHAR_VARCHAR ;



call print_message('t_SET_VARCHAR. This scenario is a failure.');
create or replace function t_SET_VARCHAR(variables_type string, return_type string, param_value SET ) RETURN VARCHAR IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_VARCHAR('SET', 'VARCHAR', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_VARCHAR('SET', 'VARCHAR', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_VARCHAR ;



call print_message('t_MULTISET_VARCHAR. This scenario is a failure.');
create or replace function t_MULTISET_VARCHAR(variables_type string, return_type string, param_value MULTISET ) RETURN VARCHAR IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_VARCHAR('MULTISET', 'VARCHAR', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_VARCHAR('MULTISET', 'VARCHAR', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_VARCHAR ;



call print_message('t_LIST_VARCHAR. This scenario is a failure.');
create or replace function t_LIST_VARCHAR(variables_type string, return_type string, param_value LIST ) RETURN VARCHAR IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_VARCHAR('LIST', 'VARCHAR', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_VARCHAR('LIST', 'VARCHAR', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_VARCHAR ;



call print_message('t_ENUM_VARCHAR. This scenario is a failure.');
create or replace function t_ENUM_VARCHAR(variables_type string, return_type string, param_value ENUM ) RETURN VARCHAR IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_VARCHAR('ENUM', 'VARCHAR', 'yellow' ), 
 typeof( t_ENUM_VARCHAR('ENUM', 'VARCHAR', 'yellow' ) ) ;
drop function t_ENUM_VARCHAR ;



call print_message('t_BLOB_VARCHAR. This scenario is a failure.');
create or replace function t_BLOB_VARCHAR(variables_type string, return_type string, param_value BLOB ) RETURN VARCHAR IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_VARCHAR('BLOB', 'VARCHAR', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_VARCHAR('BLOB', 'VARCHAR', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_VARCHAR ;



call print_message('t_CLOB_VARCHAR. This scenario is a failure.');
create or replace function t_CLOB_VARCHAR(variables_type string, return_type string, param_value CLOB ) RETURN VARCHAR IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_VARCHAR('CLOB', 'VARCHAR', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_VARCHAR('CLOB', 'VARCHAR', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_VARCHAR ;



call print_message('t_JSON_VARCHAR. This scenario is a failure.');
create or replace function t_JSON_VARCHAR(variables_type string, return_type string, param_value JSON ) RETURN VARCHAR IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_VARCHAR('JSON', 'VARCHAR', '{"a":1}' ), 
 typeof( t_JSON_VARCHAR('JSON', 'VARCHAR', '{"a":1}' ) ) ;
drop function t_JSON_VARCHAR ;

drop procedure print_message;

--+ server-message off
