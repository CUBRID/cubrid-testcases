--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_DATETIME_TIMESTAMPTZ(variables_type string, return_type string, param_value DATETIME ) RETURN TIMESTAMPTZ IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_TIMESTAMPTZ('DATETIME', 'TIMESTAMPTZ', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_TIMESTAMPTZ('DATETIME', 'TIMESTAMPTZ', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_TIMESTAMPTZ ;



call print_message('t_DATETIMELTZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_DATETIMELTZ_TIMESTAMPTZ(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN TIMESTAMPTZ IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_TIMESTAMPTZ('DATETIMELTZ', 'TIMESTAMPTZ', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_TIMESTAMPTZ('DATETIMELTZ', 'TIMESTAMPTZ', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_TIMESTAMPTZ ;



call print_message('t_DATETIMETZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_DATETIMETZ_TIMESTAMPTZ(variables_type string, return_type string, param_value DATETIMETZ ) RETURN TIMESTAMPTZ IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_TIMESTAMPTZ('DATETIMETZ', 'TIMESTAMPTZ', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_TIMESTAMPTZ('DATETIMETZ', 'TIMESTAMPTZ', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_TIMESTAMPTZ ;



call print_message('t_DATE_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_DATE_TIMESTAMPTZ(variables_type string, return_type string, param_value DATE ) RETURN TIMESTAMPTZ IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_TIMESTAMPTZ('DATE', 'TIMESTAMPTZ', DATE'2008-10-31' ), 
 typeof( t_DATE_TIMESTAMPTZ('DATE', 'TIMESTAMPTZ', DATE'2008-10-31' ) ) ;
drop function t_DATE_TIMESTAMPTZ ;



call print_message('t_TIME_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_TIME_TIMESTAMPTZ(variables_type string, return_type string, param_value TIME ) RETURN TIMESTAMPTZ IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_TIMESTAMPTZ('TIME', 'TIMESTAMPTZ', TIME'13:15:45' ), 
 typeof( t_TIME_TIMESTAMPTZ('TIME', 'TIMESTAMPTZ', TIME'13:15:45' ) ) ;
drop function t_TIME_TIMESTAMPTZ ;



call print_message('t_TIMESTAMP_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_TIMESTAMP_TIMESTAMPTZ(variables_type string, return_type string, param_value TIMESTAMP ) RETURN TIMESTAMPTZ IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_TIMESTAMPTZ('TIMESTAMP', 'TIMESTAMPTZ', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_TIMESTAMPTZ('TIMESTAMP', 'TIMESTAMPTZ', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_TIMESTAMPTZ ;



call print_message('t_TIMESTAMPLTZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_TIMESTAMPTZ(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN TIMESTAMPTZ IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_TIMESTAMPTZ('TIMESTAMPLTZ', 'TIMESTAMPTZ', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_TIMESTAMPTZ('TIMESTAMPLTZ', 'TIMESTAMPTZ', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_TIMESTAMPTZ ;



call print_message('t_TIMESTAMPTZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_TIMESTAMPTZ(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN TIMESTAMPTZ IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_TIMESTAMPTZ('TIMESTAMPTZ', 'TIMESTAMPTZ', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_TIMESTAMPTZ('TIMESTAMPTZ', 'TIMESTAMPTZ', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_TIMESTAMPTZ ;



call print_message('t_DOUBLE_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_DOUBLE_TIMESTAMPTZ(variables_type string, return_type string, param_value DOUBLE ) RETURN TIMESTAMPTZ IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_TIMESTAMPTZ('DOUBLE', 'TIMESTAMPTZ', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_TIMESTAMPTZ('DOUBLE', 'TIMESTAMPTZ', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_TIMESTAMPTZ ;



call print_message('t_FLOAT_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_FLOAT_TIMESTAMPTZ(variables_type string, return_type string, param_value FLOAT ) RETURN TIMESTAMPTZ IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_TIMESTAMPTZ('FLOAT', 'TIMESTAMPTZ', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_TIMESTAMPTZ('FLOAT', 'TIMESTAMPTZ', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_TIMESTAMPTZ ;



call print_message('t_NUMERIC(8,4)_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_NUMERIC_TIMESTAMPTZ(variables_type string, return_type string, param_value NUMERIC ) RETURN TIMESTAMPTZ IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_TIMESTAMPTZ('NUMERIC(8,4)', 'TIMESTAMPTZ', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_TIMESTAMPTZ('NUMERIC(8,4)', 'TIMESTAMPTZ', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_TIMESTAMPTZ ;



call print_message('t_BIGINT_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_BIGINT_TIMESTAMPTZ(variables_type string, return_type string, param_value BIGINT ) RETURN TIMESTAMPTZ IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_TIMESTAMPTZ('BIGINT', 'TIMESTAMPTZ', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_TIMESTAMPTZ('BIGINT', 'TIMESTAMPTZ', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_TIMESTAMPTZ ;



call print_message('t_INT_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_INT_TIMESTAMPTZ(variables_type string, return_type string, param_value INT ) RETURN TIMESTAMPTZ IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_TIMESTAMPTZ('INT', 'TIMESTAMPTZ', cast( 782346 as int ) ), 
 typeof( t_INT_TIMESTAMPTZ('INT', 'TIMESTAMPTZ', cast( 782346 as int ) ) ) ;
drop function t_INT_TIMESTAMPTZ ;



call print_message('t_SHORT_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_SHORT_TIMESTAMPTZ(variables_type string, return_type string, param_value SHORT ) RETURN TIMESTAMPTZ IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_TIMESTAMPTZ('SHORT', 'TIMESTAMPTZ', cast( 8934 as short ) ), 
 typeof( t_SHORT_TIMESTAMPTZ('SHORT', 'TIMESTAMPTZ', cast( 8934 as short ) ) ) ;
drop function t_SHORT_TIMESTAMPTZ ;



call print_message('t_BIT(8)_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_BIT_TIMESTAMPTZ(variables_type string, return_type string, param_value BIT ) RETURN TIMESTAMPTZ IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_TIMESTAMPTZ('BIT(8)', 'TIMESTAMPTZ', 0xaa ), 
 typeof( t_BIT_TIMESTAMPTZ('BIT(8)', 'TIMESTAMPTZ', 0xaa ) ) ;
drop function t_BIT_TIMESTAMPTZ ;



call print_message('t_BIT VARYING_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_BITVARYING_TIMESTAMPTZ(variables_type string, return_type string, param_value BITVARYING ) RETURN TIMESTAMPTZ IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_TIMESTAMPTZ('BIT VARYING', 'TIMESTAMPTZ', 0xaa ), 
 typeof( t_BITVARYING_TIMESTAMPTZ('BIT VARYING', 'TIMESTAMPTZ', 0xaa ) ) ;
drop function t_BITVARYING_TIMESTAMPTZ ;



call print_message('t_CHAR_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_CHAR_TIMESTAMPTZ(variables_type string, return_type string, param_value CHAR ) RETURN TIMESTAMPTZ IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_TIMESTAMPTZ('CHAR', 'TIMESTAMPTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ), 
 typeof( t_CHAR_TIMESTAMPTZ('CHAR', 'TIMESTAMPTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ) ;
drop function t_CHAR_TIMESTAMPTZ ;



call print_message('t_VARCHAR_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_VARCHAR_TIMESTAMPTZ(variables_type string, return_type string, param_value VARCHAR ) RETURN TIMESTAMPTZ IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_TIMESTAMPTZ('VARCHAR', 'TIMESTAMPTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ), 
 typeof( t_VARCHAR_TIMESTAMPTZ('VARCHAR', 'TIMESTAMPTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ) ;
drop function t_VARCHAR_TIMESTAMPTZ ;



call print_message('t_SET_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_SET_TIMESTAMPTZ(variables_type string, return_type string, param_value SET ) RETURN TIMESTAMPTZ IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_TIMESTAMPTZ('SET', 'TIMESTAMPTZ', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_TIMESTAMPTZ('SET', 'TIMESTAMPTZ', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_TIMESTAMPTZ ;



call print_message('t_MULTISET_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_MULTISET_TIMESTAMPTZ(variables_type string, return_type string, param_value MULTISET ) RETURN TIMESTAMPTZ IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_TIMESTAMPTZ('MULTISET', 'TIMESTAMPTZ', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_TIMESTAMPTZ('MULTISET', 'TIMESTAMPTZ', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_TIMESTAMPTZ ;



call print_message('t_LIST_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_LIST_TIMESTAMPTZ(variables_type string, return_type string, param_value LIST ) RETURN TIMESTAMPTZ IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_TIMESTAMPTZ('LIST', 'TIMESTAMPTZ', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_TIMESTAMPTZ('LIST', 'TIMESTAMPTZ', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_TIMESTAMPTZ ;



call print_message('t_ENUM_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_ENUM_TIMESTAMPTZ(variables_type string, return_type string, param_value ENUM ) RETURN TIMESTAMPTZ IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_TIMESTAMPTZ('ENUM', 'TIMESTAMPTZ', 'yellow' ), 
 typeof( t_ENUM_TIMESTAMPTZ('ENUM', 'TIMESTAMPTZ', 'yellow' ) ) ;
drop function t_ENUM_TIMESTAMPTZ ;



call print_message('t_BLOB_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_BLOB_TIMESTAMPTZ(variables_type string, return_type string, param_value BLOB ) RETURN TIMESTAMPTZ IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_TIMESTAMPTZ('BLOB', 'TIMESTAMPTZ', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_TIMESTAMPTZ('BLOB', 'TIMESTAMPTZ', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_TIMESTAMPTZ ;



call print_message('t_CLOB_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_CLOB_TIMESTAMPTZ(variables_type string, return_type string, param_value CLOB ) RETURN TIMESTAMPTZ IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_TIMESTAMPTZ('CLOB', 'TIMESTAMPTZ', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_TIMESTAMPTZ('CLOB', 'TIMESTAMPTZ', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_TIMESTAMPTZ ;



call print_message('t_JSON_TIMESTAMPTZ. This scenario is a failure.');
create or replace function t_JSON_TIMESTAMPTZ(variables_type string, return_type string, param_value JSON ) RETURN TIMESTAMPTZ IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_TIMESTAMPTZ('JSON', 'TIMESTAMPTZ', '{"a":1}' ), 
 typeof( t_JSON_TIMESTAMPTZ('JSON', 'TIMESTAMPTZ', '{"a":1}' ) ) ;
drop function t_JSON_TIMESTAMPTZ ;

drop procedure print_message;

--+ server-message off
