--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_DATETIME_TIMESTAMPLTZ(variables_type string, return_type string, param_value DATETIME ) RETURN TIMESTAMPLTZ IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_TIMESTAMPLTZ('DATETIME', 'TIMESTAMPLTZ', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_TIMESTAMPLTZ('DATETIME', 'TIMESTAMPLTZ', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_TIMESTAMPLTZ ;



call print_message('t_DATETIMELTZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_DATETIMELTZ_TIMESTAMPLTZ(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN TIMESTAMPLTZ IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_TIMESTAMPLTZ('DATETIMELTZ', 'TIMESTAMPLTZ', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_TIMESTAMPLTZ('DATETIMELTZ', 'TIMESTAMPLTZ', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_TIMESTAMPLTZ ;



call print_message('t_DATETIMETZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_DATETIMETZ_TIMESTAMPLTZ(variables_type string, return_type string, param_value DATETIMETZ ) RETURN TIMESTAMPLTZ IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_TIMESTAMPLTZ('DATETIMETZ', 'TIMESTAMPLTZ', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_TIMESTAMPLTZ('DATETIMETZ', 'TIMESTAMPLTZ', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_TIMESTAMPLTZ ;



call print_message('t_DATE_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_DATE_TIMESTAMPLTZ(variables_type string, return_type string, param_value DATE ) RETURN TIMESTAMPLTZ IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_TIMESTAMPLTZ('DATE', 'TIMESTAMPLTZ', DATE'2008-10-31' ), 
 typeof( t_DATE_TIMESTAMPLTZ('DATE', 'TIMESTAMPLTZ', DATE'2008-10-31' ) ) ;
drop function t_DATE_TIMESTAMPLTZ ;



call print_message('t_TIME_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_TIME_TIMESTAMPLTZ(variables_type string, return_type string, param_value TIME ) RETURN TIMESTAMPLTZ IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_TIMESTAMPLTZ('TIME', 'TIMESTAMPLTZ', TIME'13:15:45' ), 
 typeof( t_TIME_TIMESTAMPLTZ('TIME', 'TIMESTAMPLTZ', TIME'13:15:45' ) ) ;
drop function t_TIME_TIMESTAMPLTZ ;



call print_message('t_TIMESTAMP_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_TIMESTAMP_TIMESTAMPLTZ(variables_type string, return_type string, param_value TIMESTAMP ) RETURN TIMESTAMPLTZ IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_TIMESTAMPLTZ('TIMESTAMP', 'TIMESTAMPLTZ', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_TIMESTAMPLTZ('TIMESTAMP', 'TIMESTAMPLTZ', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_TIMESTAMPLTZ ;



call print_message('t_TIMESTAMPLTZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_TIMESTAMPLTZ(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN TIMESTAMPLTZ IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_TIMESTAMPLTZ('TIMESTAMPLTZ', 'TIMESTAMPLTZ', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_TIMESTAMPLTZ('TIMESTAMPLTZ', 'TIMESTAMPLTZ', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_TIMESTAMPLTZ ;



call print_message('t_TIMESTAMPTZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_TIMESTAMPLTZ(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN TIMESTAMPLTZ IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_TIMESTAMPLTZ('TIMESTAMPTZ', 'TIMESTAMPLTZ', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_TIMESTAMPLTZ('TIMESTAMPTZ', 'TIMESTAMPLTZ', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_TIMESTAMPLTZ ;



call print_message('t_DOUBLE_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_DOUBLE_TIMESTAMPLTZ(variables_type string, return_type string, param_value DOUBLE ) RETURN TIMESTAMPLTZ IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_TIMESTAMPLTZ('DOUBLE', 'TIMESTAMPLTZ', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_TIMESTAMPLTZ('DOUBLE', 'TIMESTAMPLTZ', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_TIMESTAMPLTZ ;



call print_message('t_FLOAT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_FLOAT_TIMESTAMPLTZ(variables_type string, return_type string, param_value FLOAT ) RETURN TIMESTAMPLTZ IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_TIMESTAMPLTZ('FLOAT', 'TIMESTAMPLTZ', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_TIMESTAMPLTZ('FLOAT', 'TIMESTAMPLTZ', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_TIMESTAMPLTZ ;



call print_message('t_NUMERIC(8,4)_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_NUMERIC_TIMESTAMPLTZ(variables_type string, return_type string, param_value NUMERIC ) RETURN TIMESTAMPLTZ IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_TIMESTAMPLTZ('NUMERIC(8,4)', 'TIMESTAMPLTZ', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_TIMESTAMPLTZ('NUMERIC(8,4)', 'TIMESTAMPLTZ', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_TIMESTAMPLTZ ;



call print_message('t_BIGINT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_BIGINT_TIMESTAMPLTZ(variables_type string, return_type string, param_value BIGINT ) RETURN TIMESTAMPLTZ IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_TIMESTAMPLTZ('BIGINT', 'TIMESTAMPLTZ', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_TIMESTAMPLTZ('BIGINT', 'TIMESTAMPLTZ', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_TIMESTAMPLTZ ;



call print_message('t_INT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_INT_TIMESTAMPLTZ(variables_type string, return_type string, param_value INT ) RETURN TIMESTAMPLTZ IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_TIMESTAMPLTZ('INT', 'TIMESTAMPLTZ', cast( 782346 as int ) ), 
 typeof( t_INT_TIMESTAMPLTZ('INT', 'TIMESTAMPLTZ', cast( 782346 as int ) ) ) ;
drop function t_INT_TIMESTAMPLTZ ;



call print_message('t_SHORT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_SHORT_TIMESTAMPLTZ(variables_type string, return_type string, param_value SHORT ) RETURN TIMESTAMPLTZ IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_TIMESTAMPLTZ('SHORT', 'TIMESTAMPLTZ', cast( 8934 as short ) ), 
 typeof( t_SHORT_TIMESTAMPLTZ('SHORT', 'TIMESTAMPLTZ', cast( 8934 as short ) ) ) ;
drop function t_SHORT_TIMESTAMPLTZ ;



call print_message('t_BIT(8)_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_BIT_TIMESTAMPLTZ(variables_type string, return_type string, param_value BIT ) RETURN TIMESTAMPLTZ IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_TIMESTAMPLTZ('BIT(8)', 'TIMESTAMPLTZ', 0xaa ), 
 typeof( t_BIT_TIMESTAMPLTZ('BIT(8)', 'TIMESTAMPLTZ', 0xaa ) ) ;
drop function t_BIT_TIMESTAMPLTZ ;



call print_message('t_BIT VARYING_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_BITVARYING_TIMESTAMPLTZ(variables_type string, return_type string, param_value BITVARYING ) RETURN TIMESTAMPLTZ IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_TIMESTAMPLTZ('BIT VARYING', 'TIMESTAMPLTZ', 0xaa ), 
 typeof( t_BITVARYING_TIMESTAMPLTZ('BIT VARYING', 'TIMESTAMPLTZ', 0xaa ) ) ;
drop function t_BITVARYING_TIMESTAMPLTZ ;



call print_message('t_CHAR_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_CHAR_TIMESTAMPLTZ(variables_type string, return_type string, param_value CHAR ) RETURN TIMESTAMPLTZ IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_TIMESTAMPLTZ('CHAR', 'TIMESTAMPLTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ), 
 typeof( t_CHAR_TIMESTAMPLTZ('CHAR', 'TIMESTAMPLTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ) ;
drop function t_CHAR_TIMESTAMPLTZ ;



call print_message('t_VARCHAR_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_VARCHAR_TIMESTAMPLTZ(variables_type string, return_type string, param_value VARCHAR ) RETURN TIMESTAMPLTZ IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_TIMESTAMPLTZ('VARCHAR', 'TIMESTAMPLTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ), 
 typeof( t_VARCHAR_TIMESTAMPLTZ('VARCHAR', 'TIMESTAMPLTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ) ;
drop function t_VARCHAR_TIMESTAMPLTZ ;



call print_message('t_SET_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_SET_TIMESTAMPLTZ(variables_type string, return_type string, param_value SET ) RETURN TIMESTAMPLTZ IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_TIMESTAMPLTZ('SET', 'TIMESTAMPLTZ', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_TIMESTAMPLTZ('SET', 'TIMESTAMPLTZ', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_TIMESTAMPLTZ ;



call print_message('t_MULTISET_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_MULTISET_TIMESTAMPLTZ(variables_type string, return_type string, param_value MULTISET ) RETURN TIMESTAMPLTZ IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_TIMESTAMPLTZ('MULTISET', 'TIMESTAMPLTZ', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_TIMESTAMPLTZ('MULTISET', 'TIMESTAMPLTZ', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_TIMESTAMPLTZ ;



call print_message('t_LIST_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_LIST_TIMESTAMPLTZ(variables_type string, return_type string, param_value LIST ) RETURN TIMESTAMPLTZ IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_TIMESTAMPLTZ('LIST', 'TIMESTAMPLTZ', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_TIMESTAMPLTZ('LIST', 'TIMESTAMPLTZ', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_TIMESTAMPLTZ ;



call print_message('t_ENUM_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_ENUM_TIMESTAMPLTZ(variables_type string, return_type string, param_value ENUM ) RETURN TIMESTAMPLTZ IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_TIMESTAMPLTZ('ENUM', 'TIMESTAMPLTZ', 'yellow' ), 
 typeof( t_ENUM_TIMESTAMPLTZ('ENUM', 'TIMESTAMPLTZ', 'yellow' ) ) ;
drop function t_ENUM_TIMESTAMPLTZ ;



call print_message('t_BLOB_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_BLOB_TIMESTAMPLTZ(variables_type string, return_type string, param_value BLOB ) RETURN TIMESTAMPLTZ IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_TIMESTAMPLTZ('BLOB', 'TIMESTAMPLTZ', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_TIMESTAMPLTZ('BLOB', 'TIMESTAMPLTZ', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_TIMESTAMPLTZ ;



call print_message('t_CLOB_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_CLOB_TIMESTAMPLTZ(variables_type string, return_type string, param_value CLOB ) RETURN TIMESTAMPLTZ IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_TIMESTAMPLTZ('CLOB', 'TIMESTAMPLTZ', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_TIMESTAMPLTZ('CLOB', 'TIMESTAMPLTZ', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_TIMESTAMPLTZ ;



call print_message('t_JSON_TIMESTAMPLTZ. This scenario is a failure.');
create or replace function t_JSON_TIMESTAMPLTZ(variables_type string, return_type string, param_value JSON ) RETURN TIMESTAMPLTZ IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_TIMESTAMPLTZ('JSON', 'TIMESTAMPLTZ', '{"a":1}' ), 
 typeof( t_JSON_TIMESTAMPLTZ('JSON', 'TIMESTAMPLTZ', '{"a":1}' ) ) ;
drop function t_JSON_TIMESTAMPLTZ ;

drop procedure print_message;

--+ server-message off
