--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIT. This scenario is a failure.');
create or replace function t_DATETIME_BIT(variables_type string, return_type string, param_value DATETIME ) RETURN BIT IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_BIT('DATETIME', 'BIT', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_BIT('DATETIME', 'BIT', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_BIT ;



call print_message('t_DATETIMELTZ_BIT. This scenario is a failure.');
create or replace function t_DATETIMELTZ_BIT(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN BIT IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_BIT('DATETIMELTZ', 'BIT', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_BIT('DATETIMELTZ', 'BIT', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_BIT ;



call print_message('t_DATETIMETZ_BIT. This scenario is a failure.');
create or replace function t_DATETIMETZ_BIT(variables_type string, return_type string, param_value DATETIMETZ ) RETURN BIT IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_BIT('DATETIMETZ', 'BIT', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_BIT('DATETIMETZ', 'BIT', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_BIT ;



call print_message('t_DATE_BIT. This scenario is a failure.');
create or replace function t_DATE_BIT(variables_type string, return_type string, param_value DATE ) RETURN BIT IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_BIT('DATE', 'BIT', DATE'2008-10-31' ), 
 typeof( t_DATE_BIT('DATE', 'BIT', DATE'2008-10-31' ) ) ;
drop function t_DATE_BIT ;



call print_message('t_TIME_BIT. This scenario is a failure.');
create or replace function t_TIME_BIT(variables_type string, return_type string, param_value TIME ) RETURN BIT IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_BIT('TIME', 'BIT', TIME'13:15:45' ), 
 typeof( t_TIME_BIT('TIME', 'BIT', TIME'13:15:45' ) ) ;
drop function t_TIME_BIT ;



call print_message('t_TIMESTAMP_BIT. This scenario is a failure.');
create or replace function t_TIMESTAMP_BIT(variables_type string, return_type string, param_value TIMESTAMP ) RETURN BIT IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_BIT('TIMESTAMP', 'BIT', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_BIT('TIMESTAMP', 'BIT', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_BIT ;



call print_message('t_TIMESTAMPLTZ_BIT. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_BIT(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN BIT IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_BIT('TIMESTAMPLTZ', 'BIT', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_BIT('TIMESTAMPLTZ', 'BIT', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_BIT ;



call print_message('t_TIMESTAMPTZ_BIT. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_BIT(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN BIT IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_BIT('TIMESTAMPTZ', 'BIT', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_BIT('TIMESTAMPTZ', 'BIT', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_BIT ;



call print_message('t_DOUBLE_BIT. This scenario is a failure.');
create or replace function t_DOUBLE_BIT(variables_type string, return_type string, param_value DOUBLE ) RETURN BIT IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_BIT('DOUBLE', 'BIT', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_BIT('DOUBLE', 'BIT', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_BIT ;



call print_message('t_FLOAT_BIT. This scenario is a failure.');
create or replace function t_FLOAT_BIT(variables_type string, return_type string, param_value FLOAT ) RETURN BIT IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_BIT('FLOAT', 'BIT', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_BIT('FLOAT', 'BIT', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_BIT ;



call print_message('t_NUMERIC(8,4)_BIT. This scenario is a failure.');
create or replace function t_NUMERIC_BIT(variables_type string, return_type string, param_value NUMERIC ) RETURN BIT IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_BIT('NUMERIC(8,4)', 'BIT', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_BIT('NUMERIC(8,4)', 'BIT', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_BIT ;



call print_message('t_BIGINT_BIT. This scenario is a failure.');
create or replace function t_BIGINT_BIT(variables_type string, return_type string, param_value BIGINT ) RETURN BIT IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_BIT('BIGINT', 'BIT', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_BIT('BIGINT', 'BIT', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_BIT ;



call print_message('t_INT_BIT. This scenario is a failure.');
create or replace function t_INT_BIT(variables_type string, return_type string, param_value INT ) RETURN BIT IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_BIT('INT', 'BIT', cast( 782346 as int ) ), 
 typeof( t_INT_BIT('INT', 'BIT', cast( 782346 as int ) ) ) ;
drop function t_INT_BIT ;



call print_message('t_SHORT_BIT. This scenario is a failure.');
create or replace function t_SHORT_BIT(variables_type string, return_type string, param_value SHORT ) RETURN BIT IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_BIT('SHORT', 'BIT', cast( 8934 as short ) ), 
 typeof( t_SHORT_BIT('SHORT', 'BIT', cast( 8934 as short ) ) ) ;
drop function t_SHORT_BIT ;



call print_message('t_BIT(8)_BIT. This scenario is a failure.');
create or replace function t_BIT_BIT(variables_type string, return_type string, param_value BIT ) RETURN BIT IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_BIT('BIT(8)', 'BIT', 0xaa ), 
 typeof( t_BIT_BIT('BIT(8)', 'BIT', 0xaa ) ) ;
drop function t_BIT_BIT ;



call print_message('t_BIT VARYING_BIT. This scenario is a failure.');
create or replace function t_BITVARYING_BIT(variables_type string, return_type string, param_value BITVARYING ) RETURN BIT IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_BIT('BIT VARYING', 'BIT', 0xaa ), 
 typeof( t_BITVARYING_BIT('BIT VARYING', 'BIT', 0xaa ) ) ;
drop function t_BITVARYING_BIT ;



call print_message('t_CHAR_BIT. This scenario is a failure.');
create or replace function t_CHAR_BIT(variables_type string, return_type string, param_value CHAR ) RETURN BIT IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_BIT('CHAR', 'BIT', 'CHAR CUBRID' ), 
 typeof( t_CHAR_BIT('CHAR', 'BIT', 'CHAR CUBRID' ) ) ;
drop function t_CHAR_BIT ;



call print_message('t_VARCHAR_BIT. This scenario is a failure.');
create or replace function t_VARCHAR_BIT(variables_type string, return_type string, param_value VARCHAR ) RETURN BIT IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_BIT('VARCHAR', 'BIT', 'VARCHAR CUBRID' ), 
 typeof( t_VARCHAR_BIT('VARCHAR', 'BIT', 'VARCHAR CUBRID' ) ) ;
drop function t_VARCHAR_BIT ;



call print_message('t_SET_BIT. This scenario is a failure.');
create or replace function t_SET_BIT(variables_type string, return_type string, param_value SET ) RETURN BIT IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_BIT('SET', 'BIT', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_BIT('SET', 'BIT', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_BIT ;



call print_message('t_MULTISET_BIT. This scenario is a failure.');
create or replace function t_MULTISET_BIT(variables_type string, return_type string, param_value MULTISET ) RETURN BIT IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_BIT('MULTISET', 'BIT', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_BIT('MULTISET', 'BIT', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_BIT ;



call print_message('t_LIST_BIT. This scenario is a failure.');
create or replace function t_LIST_BIT(variables_type string, return_type string, param_value LIST ) RETURN BIT IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_BIT('LIST', 'BIT', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_BIT('LIST', 'BIT', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_BIT ;



call print_message('t_ENUM_BIT. This scenario is a failure.');
create or replace function t_ENUM_BIT(variables_type string, return_type string, param_value ENUM ) RETURN BIT IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_BIT('ENUM', 'BIT', 'yellow' ), 
 typeof( t_ENUM_BIT('ENUM', 'BIT', 'yellow' ) ) ;
drop function t_ENUM_BIT ;



call print_message('t_BLOB_BIT. This scenario is a failure.');
create or replace function t_BLOB_BIT(variables_type string, return_type string, param_value BLOB ) RETURN BIT IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_BIT('BLOB', 'BIT', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_BIT('BLOB', 'BIT', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_BIT ;



call print_message('t_CLOB_BIT. This scenario is a failure.');
create or replace function t_CLOB_BIT(variables_type string, return_type string, param_value CLOB ) RETURN BIT IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_BIT('CLOB', 'BIT', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_BIT('CLOB', 'BIT', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_BIT ;



call print_message('t_JSON_BIT. This scenario is a failure.');
create or replace function t_JSON_BIT(variables_type string, return_type string, param_value JSON ) RETURN BIT IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_BIT('JSON', 'BIT', '{"a":1}' ), 
 typeof( t_JSON_BIT('JSON', 'BIT', '{"a":1}' ) ) ;
drop function t_JSON_BIT ;

drop procedure print_message;

--+ server-message off
