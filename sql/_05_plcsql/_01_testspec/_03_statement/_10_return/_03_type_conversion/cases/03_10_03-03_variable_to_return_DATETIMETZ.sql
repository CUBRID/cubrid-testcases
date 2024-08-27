--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIMETZ. This scenario is a failure.');
create or replace function t_DATETIME_DATETIMETZ(variables_type string, return_type string, param_value DATETIME ) RETURN DATETIMETZ IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_DATETIMETZ('DATETIME', 'DATETIMETZ', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_DATETIMETZ('DATETIME', 'DATETIMETZ', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_DATETIMETZ ;



call print_message('t_DATETIMELTZ_DATETIMETZ. This scenario is a failure.');
create or replace function t_DATETIMELTZ_DATETIMETZ(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN DATETIMETZ IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_DATETIMETZ('DATETIMELTZ', 'DATETIMETZ', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_DATETIMETZ('DATETIMELTZ', 'DATETIMETZ', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_DATETIMETZ ;



call print_message('t_DATETIMETZ_DATETIMETZ. This scenario is a failure.');
create or replace function t_DATETIMETZ_DATETIMETZ(variables_type string, return_type string, param_value DATETIMETZ ) RETURN DATETIMETZ IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_DATETIMETZ('DATETIMETZ', 'DATETIMETZ', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_DATETIMETZ('DATETIMETZ', 'DATETIMETZ', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_DATETIMETZ ;



call print_message('t_DATE_DATETIMETZ. This scenario is a failure.');
create or replace function t_DATE_DATETIMETZ(variables_type string, return_type string, param_value DATE ) RETURN DATETIMETZ IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_DATETIMETZ('DATE', 'DATETIMETZ', DATE'2008-10-31' ), 
 typeof( t_DATE_DATETIMETZ('DATE', 'DATETIMETZ', DATE'2008-10-31' ) ) ;
drop function t_DATE_DATETIMETZ ;



call print_message('t_TIME_DATETIMETZ. This scenario is a failure.');
create or replace function t_TIME_DATETIMETZ(variables_type string, return_type string, param_value TIME ) RETURN DATETIMETZ IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_DATETIMETZ('TIME', 'DATETIMETZ', TIME'13:15:45' ), 
 typeof( t_TIME_DATETIMETZ('TIME', 'DATETIMETZ', TIME'13:15:45' ) ) ;
drop function t_TIME_DATETIMETZ ;



call print_message('t_TIMESTAMP_DATETIMETZ. This scenario is a failure.');
create or replace function t_TIMESTAMP_DATETIMETZ(variables_type string, return_type string, param_value TIMESTAMP ) RETURN DATETIMETZ IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_DATETIMETZ('TIMESTAMP', 'DATETIMETZ', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_DATETIMETZ('TIMESTAMP', 'DATETIMETZ', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_DATETIMETZ ;



call print_message('t_TIMESTAMPLTZ_DATETIMETZ. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_DATETIMETZ(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN DATETIMETZ IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_DATETIMETZ('TIMESTAMPLTZ', 'DATETIMETZ', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_DATETIMETZ('TIMESTAMPLTZ', 'DATETIMETZ', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_DATETIMETZ ;



call print_message('t_TIMESTAMPTZ_DATETIMETZ. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_DATETIMETZ(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN DATETIMETZ IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_DATETIMETZ('TIMESTAMPTZ', 'DATETIMETZ', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_DATETIMETZ('TIMESTAMPTZ', 'DATETIMETZ', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_DATETIMETZ ;



call print_message('t_DOUBLE_DATETIMETZ. This scenario is a failure.');
create or replace function t_DOUBLE_DATETIMETZ(variables_type string, return_type string, param_value DOUBLE ) RETURN DATETIMETZ IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_DATETIMETZ('DOUBLE', 'DATETIMETZ', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_DATETIMETZ('DOUBLE', 'DATETIMETZ', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_DATETIMETZ ;



call print_message('t_FLOAT_DATETIMETZ. This scenario is a failure.');
create or replace function t_FLOAT_DATETIMETZ(variables_type string, return_type string, param_value FLOAT ) RETURN DATETIMETZ IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_DATETIMETZ('FLOAT', 'DATETIMETZ', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_DATETIMETZ('FLOAT', 'DATETIMETZ', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_DATETIMETZ ;



call print_message('t_NUMERIC(8,4)_DATETIMETZ. This scenario is a failure.');
create or replace function t_NUMERIC_DATETIMETZ(variables_type string, return_type string, param_value NUMERIC ) RETURN DATETIMETZ IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_DATETIMETZ('NUMERIC(8,4)', 'DATETIMETZ', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_DATETIMETZ('NUMERIC(8,4)', 'DATETIMETZ', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_DATETIMETZ ;



call print_message('t_BIGINT_DATETIMETZ. This scenario is a failure.');
create or replace function t_BIGINT_DATETIMETZ(variables_type string, return_type string, param_value BIGINT ) RETURN DATETIMETZ IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_DATETIMETZ('BIGINT', 'DATETIMETZ', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_DATETIMETZ('BIGINT', 'DATETIMETZ', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_DATETIMETZ ;



call print_message('t_INT_DATETIMETZ. This scenario is a failure.');
create or replace function t_INT_DATETIMETZ(variables_type string, return_type string, param_value INT ) RETURN DATETIMETZ IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_DATETIMETZ('INT', 'DATETIMETZ', cast( 782346 as int ) ), 
 typeof( t_INT_DATETIMETZ('INT', 'DATETIMETZ', cast( 782346 as int ) ) ) ;
drop function t_INT_DATETIMETZ ;



call print_message('t_SHORT_DATETIMETZ. This scenario is a failure.');
create or replace function t_SHORT_DATETIMETZ(variables_type string, return_type string, param_value SHORT ) RETURN DATETIMETZ IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_DATETIMETZ('SHORT', 'DATETIMETZ', cast( 8934 as short ) ), 
 typeof( t_SHORT_DATETIMETZ('SHORT', 'DATETIMETZ', cast( 8934 as short ) ) ) ;
drop function t_SHORT_DATETIMETZ ;



call print_message('t_BIT(8)_DATETIMETZ. This scenario is a failure.');
create or replace function t_BIT_DATETIMETZ(variables_type string, return_type string, param_value BIT ) RETURN DATETIMETZ IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_DATETIMETZ('BIT(8)', 'DATETIMETZ', 0xaa ), 
 typeof( t_BIT_DATETIMETZ('BIT(8)', 'DATETIMETZ', 0xaa ) ) ;
drop function t_BIT_DATETIMETZ ;



call print_message('t_BIT VARYING_DATETIMETZ. This scenario is a failure.');
create or replace function t_BITVARYING_DATETIMETZ(variables_type string, return_type string, param_value BITVARYING ) RETURN DATETIMETZ IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_DATETIMETZ('BIT VARYING', 'DATETIMETZ', 0xaa ), 
 typeof( t_BITVARYING_DATETIMETZ('BIT VARYING', 'DATETIMETZ', 0xaa ) ) ;
drop function t_BITVARYING_DATETIMETZ ;



call print_message('t_CHAR_DATETIMETZ. This scenario is a failure.');
create or replace function t_CHAR_DATETIMETZ(variables_type string, return_type string, param_value CHAR ) RETURN DATETIMETZ IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_DATETIMETZ('CHAR', 'DATETIMETZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ), 
 typeof( t_CHAR_DATETIMETZ('CHAR', 'DATETIMETZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ) ;
drop function t_CHAR_DATETIMETZ ;



call print_message('t_VARCHAR_DATETIMETZ. This scenario is a failure.');
create or replace function t_VARCHAR_DATETIMETZ(variables_type string, return_type string, param_value VARCHAR ) RETURN DATETIMETZ IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_DATETIMETZ('VARCHAR', 'DATETIMETZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ), 
 typeof( t_VARCHAR_DATETIMETZ('VARCHAR', 'DATETIMETZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ) ;
drop function t_VARCHAR_DATETIMETZ ;



call print_message('t_SET_DATETIMETZ. This scenario is a failure.');
create or replace function t_SET_DATETIMETZ(variables_type string, return_type string, param_value SET ) RETURN DATETIMETZ IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_DATETIMETZ('SET', 'DATETIMETZ', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_DATETIMETZ('SET', 'DATETIMETZ', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_DATETIMETZ ;



call print_message('t_MULTISET_DATETIMETZ. This scenario is a failure.');
create or replace function t_MULTISET_DATETIMETZ(variables_type string, return_type string, param_value MULTISET ) RETURN DATETIMETZ IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_DATETIMETZ('MULTISET', 'DATETIMETZ', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_DATETIMETZ('MULTISET', 'DATETIMETZ', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_DATETIMETZ ;



call print_message('t_LIST_DATETIMETZ. This scenario is a failure.');
create or replace function t_LIST_DATETIMETZ(variables_type string, return_type string, param_value LIST ) RETURN DATETIMETZ IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_DATETIMETZ('LIST', 'DATETIMETZ', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_DATETIMETZ('LIST', 'DATETIMETZ', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_DATETIMETZ ;



call print_message('t_ENUM_DATETIMETZ. This scenario is a failure.');
create or replace function t_ENUM_DATETIMETZ(variables_type string, return_type string, param_value ENUM ) RETURN DATETIMETZ IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_DATETIMETZ('ENUM', 'DATETIMETZ', 'yellow' ), 
 typeof( t_ENUM_DATETIMETZ('ENUM', 'DATETIMETZ', 'yellow' ) ) ;
drop function t_ENUM_DATETIMETZ ;



call print_message('t_BLOB_DATETIMETZ. This scenario is a failure.');
create or replace function t_BLOB_DATETIMETZ(variables_type string, return_type string, param_value BLOB ) RETURN DATETIMETZ IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_DATETIMETZ('BLOB', 'DATETIMETZ', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_DATETIMETZ('BLOB', 'DATETIMETZ', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_DATETIMETZ ;



call print_message('t_CLOB_DATETIMETZ. This scenario is a failure.');
create or replace function t_CLOB_DATETIMETZ(variables_type string, return_type string, param_value CLOB ) RETURN DATETIMETZ IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_DATETIMETZ('CLOB', 'DATETIMETZ', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_DATETIMETZ('CLOB', 'DATETIMETZ', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_DATETIMETZ ;



call print_message('t_JSON_DATETIMETZ. This scenario is a failure.');
create or replace function t_JSON_DATETIMETZ(variables_type string, return_type string, param_value JSON ) RETURN DATETIMETZ IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_DATETIMETZ('JSON', 'DATETIMETZ', '{"a":1}' ), 
 typeof( t_JSON_DATETIMETZ('JSON', 'DATETIMETZ', '{"a":1}' ) ) ;
drop function t_JSON_DATETIMETZ ;

drop procedure print_message;

--+ server-message off
