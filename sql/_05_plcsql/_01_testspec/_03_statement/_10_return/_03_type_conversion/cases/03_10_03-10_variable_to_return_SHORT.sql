--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_SHORT. This scenario is a failure.');
create or replace function t_DATETIME_SHORT(variables_type string, return_type string, param_value DATETIME ) RETURN SHORT IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_SHORT('DATETIME', 'SHORT', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_SHORT('DATETIME', 'SHORT', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_SHORT ;



call print_message('t_DATETIMELTZ_SHORT. This scenario is a failure.');
create or replace function t_DATETIMELTZ_SHORT(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN SHORT IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_SHORT('DATETIMELTZ', 'SHORT', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_SHORT('DATETIMELTZ', 'SHORT', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_SHORT ;



call print_message('t_DATETIMETZ_SHORT. This scenario is a failure.');
create or replace function t_DATETIMETZ_SHORT(variables_type string, return_type string, param_value DATETIMETZ ) RETURN SHORT IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_SHORT('DATETIMETZ', 'SHORT', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_SHORT('DATETIMETZ', 'SHORT', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_SHORT ;



call print_message('t_DATE_SHORT. This scenario is a failure.');
create or replace function t_DATE_SHORT(variables_type string, return_type string, param_value DATE ) RETURN SHORT IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_SHORT('DATE', 'SHORT', DATE'2008-10-31' ), 
 typeof( t_DATE_SHORT('DATE', 'SHORT', DATE'2008-10-31' ) ) ;
drop function t_DATE_SHORT ;



call print_message('t_TIME_SHORT. This scenario is a failure.');
create or replace function t_TIME_SHORT(variables_type string, return_type string, param_value TIME ) RETURN SHORT IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_SHORT('TIME', 'SHORT', TIME'13:15:45' ), 
 typeof( t_TIME_SHORT('TIME', 'SHORT', TIME'13:15:45' ) ) ;
drop function t_TIME_SHORT ;



call print_message('t_TIMESTAMP_SHORT. This scenario is a failure.');
create or replace function t_TIMESTAMP_SHORT(variables_type string, return_type string, param_value TIMESTAMP ) RETURN SHORT IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_SHORT('TIMESTAMP', 'SHORT', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_SHORT('TIMESTAMP', 'SHORT', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_SHORT ;



call print_message('t_TIMESTAMPLTZ_SHORT. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_SHORT(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN SHORT IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_SHORT('TIMESTAMPLTZ', 'SHORT', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_SHORT('TIMESTAMPLTZ', 'SHORT', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_SHORT ;



call print_message('t_TIMESTAMPTZ_SHORT. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_SHORT(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN SHORT IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_SHORT('TIMESTAMPTZ', 'SHORT', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_SHORT('TIMESTAMPTZ', 'SHORT', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_SHORT ;



call print_message('t_DOUBLE_SHORT. This scenario is a success.');
create or replace function t_DOUBLE_SHORT(variables_type string, return_type string, param_value DOUBLE ) RETURN SHORT IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_SHORT('DOUBLE', 'SHORT', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_SHORT('DOUBLE', 'SHORT', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_SHORT ;



call print_message('t_FLOAT_SHORT. This scenario is a success.');
create or replace function t_FLOAT_SHORT(variables_type string, return_type string, param_value FLOAT ) RETURN SHORT IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_SHORT('FLOAT', 'SHORT', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_SHORT('FLOAT', 'SHORT', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_SHORT ;



call print_message('t_NUMERIC_SHORT. This scenario is a success.');
create or replace function t_NUMERIC_SHORT(variables_type string, return_type string, param_value NUMERIC ) RETURN SHORT IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_SHORT('NUMERIC(8,4)', 'SHORT', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_SHORT('NUMERIC(8,4)', 'SHORT', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_SHORT ;



call print_message('t_BIGINT_SHORT. This scenario is a success.');
create or replace function t_BIGINT_SHORT(variables_type string, return_type string, param_value BIGINT ) RETURN SHORT IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_SHORT('BIGINT', 'SHORT', cast( 3458 as bigint ) ), 
 typeof( t_BIGINT_SHORT('BIGINT', 'SHORT', cast( 3458 as bigint ) ) ) ;
drop function t_BIGINT_SHORT ;



call print_message('t_INT_SHORT. This scenario is a success.');
create or replace function t_INT_SHORT(variables_type string, return_type string, param_value INT ) RETURN SHORT IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_SHORT('INT', 'SHORT', cast( 7823 as int ) ), 
 typeof( t_INT_SHORT('INT', 'SHORT', cast( 7823 as int ) ) ) ;
drop function t_INT_SHORT ;



call print_message('t_SHORT_SHORT. This scenario is a success.');
create or replace function t_SHORT_SHORT(variables_type string, return_type string, param_value SHORT ) RETURN SHORT IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_SHORT('SHORT', 'SHORT', cast( 8934 as short ) ), 
 typeof( t_SHORT_SHORT('SHORT', 'SHORT', cast( 8934 as short ) ) ) ;
drop function t_SHORT_SHORT ;



call print_message('t_BIT(8)_SHORT. This scenario is a failure.');
create or replace function t_BIT_SHORT(variables_type string, return_type string, param_value BIT ) RETURN SHORT IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_SHORT('BIT(8)', 'SHORT', 0xaa ), 
 typeof( t_BIT_SHORT('BIT(8)', 'SHORT', 0xaa ) ) ;
drop function t_BIT_SHORT ;



call print_message('t_BIT VARYING_SHORT. This scenario is a failure.');
create or replace function t_BITVARYING_SHORT(variables_type string, return_type string, param_value BITVARYING ) RETURN SHORT IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_SHORT('BIT VARYING', 'SHORT', 0xaa ), 
 typeof( t_BITVARYING_SHORT('BIT VARYING', 'SHORT', 0xaa ) ) ;
drop function t_BITVARYING_SHORT ;



call print_message('t_CHAR_SHORT. This scenario is a success.');
create or replace function t_CHAR_SHORT(variables_type string, return_type string, param_value CHAR ) RETURN SHORT IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_SHORT('CHAR', 'SHORT', cast( '123' as char(3) ) ), 
 typeof( t_CHAR_SHORT('CHAR', 'SHORT', cast( '123' as char(3) ) ) ) ;
drop function t_CHAR_SHORT ;



call print_message('t_VARCHAR_SHORT. This scenario is a success.');
create or replace function t_VARCHAR_SHORT(variables_type string, return_type string, param_value VARCHAR ) RETURN SHORT IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_SHORT('VARCHAR', 'SHORT', cast('567' as varchar ) ), 
 typeof( t_VARCHAR_SHORT('VARCHAR', 'SHORT', cast('567' as varchar ) ) ) ;
drop function t_VARCHAR_SHORT ;



call print_message('t_SET_SHORT. This scenario is a failure.');
create or replace function t_SET_SHORT(variables_type string, return_type string, param_value SET ) RETURN SHORT IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_SHORT('SET', 'SHORT', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_SHORT('SET', 'SHORT', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_SHORT ;



call print_message('t_MULTISET_SHORT. This scenario is a failure.');
create or replace function t_MULTISET_SHORT(variables_type string, return_type string, param_value MULTISET ) RETURN SHORT IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_SHORT('MULTISET', 'SHORT', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_SHORT('MULTISET', 'SHORT', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_SHORT ;



call print_message('t_LIST_SHORT. This scenario is a failure.');
create or replace function t_LIST_SHORT(variables_type string, return_type string, param_value LIST ) RETURN SHORT IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_SHORT('LIST', 'SHORT', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_SHORT('LIST', 'SHORT', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_SHORT ;



call print_message('t_ENUM_SHORT. This scenario is a failure.');
create or replace function t_ENUM_SHORT(variables_type string, return_type string, param_value ENUM ) RETURN SHORT IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_SHORT('ENUM', 'SHORT', 'yellow' ), 
 typeof( t_ENUM_SHORT('ENUM', 'SHORT', 'yellow' ) ) ;
drop function t_ENUM_SHORT ;



call print_message('t_BLOB_SHORT. This scenario is a failure.');
create or replace function t_BLOB_SHORT(variables_type string, return_type string, param_value BLOB ) RETURN SHORT IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_SHORT('BLOB', 'SHORT', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_SHORT('BLOB', 'SHORT', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_SHORT ;



call print_message('t_CLOB_SHORT. This scenario is a failure.');
create or replace function t_CLOB_SHORT(variables_type string, return_type string, param_value CLOB ) RETURN SHORT IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_SHORT('CLOB', 'SHORT', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_SHORT('CLOB', 'SHORT', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_SHORT ;



call print_message('t_JSON_SHORT. This scenario is a failure.');
create or replace function t_JSON_SHORT(variables_type string, return_type string, param_value JSON ) RETURN SHORT IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_SHORT('JSON', 'SHORT', '{"a":1}' ), 
 typeof( t_JSON_SHORT('JSON', 'SHORT', '{"a":1}' ) ) ;
drop function t_JSON_SHORT ;

drop procedure print_message;

--+ server-message off
