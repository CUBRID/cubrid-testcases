--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DOUBLE. This scenario is a failure.');
create or replace function t_DATETIME_DOUBLE(variables_type string, return_type string, param_value DATETIME ) RETURN DOUBLE IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_DOUBLE('DATETIME', 'DOUBLE', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_DOUBLE('DATETIME', 'DOUBLE', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_DOUBLE ;



call print_message('t_DATETIMELTZ_DOUBLE. This scenario is a failure.');
create or replace function t_DATETIMELTZ_DOUBLE(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN DOUBLE IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_DOUBLE('DATETIMELTZ', 'DOUBLE', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_DOUBLE('DATETIMELTZ', 'DOUBLE', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_DOUBLE ;



call print_message('t_DATETIMETZ_DOUBLE. This scenario is a failure.');
create or replace function t_DATETIMETZ_DOUBLE(variables_type string, return_type string, param_value DATETIMETZ ) RETURN DOUBLE IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_DOUBLE('DATETIMETZ', 'DOUBLE', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_DOUBLE('DATETIMETZ', 'DOUBLE', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_DOUBLE ;



call print_message('t_DATE_DOUBLE. This scenario is a failure.');
create or replace function t_DATE_DOUBLE(variables_type string, return_type string, param_value DATE ) RETURN DOUBLE IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_DOUBLE('DATE', 'DOUBLE', DATE'2008-10-31' ), 
 typeof( t_DATE_DOUBLE('DATE', 'DOUBLE', DATE'2008-10-31' ) ) ;
drop function t_DATE_DOUBLE ;



call print_message('t_TIME_DOUBLE. This scenario is a failure.');
create or replace function t_TIME_DOUBLE(variables_type string, return_type string, param_value TIME ) RETURN DOUBLE IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_DOUBLE('TIME', 'DOUBLE', TIME'13:15:45' ), 
 typeof( t_TIME_DOUBLE('TIME', 'DOUBLE', TIME'13:15:45' ) ) ;
drop function t_TIME_DOUBLE ;



call print_message('t_TIMESTAMP_DOUBLE. This scenario is a failure.');
create or replace function t_TIMESTAMP_DOUBLE(variables_type string, return_type string, param_value TIMESTAMP ) RETURN DOUBLE IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_DOUBLE('TIMESTAMP', 'DOUBLE', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_DOUBLE('TIMESTAMP', 'DOUBLE', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_DOUBLE ;



call print_message('t_TIMESTAMPLTZ_DOUBLE. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_DOUBLE(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN DOUBLE IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_DOUBLE('TIMESTAMPLTZ', 'DOUBLE', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_DOUBLE('TIMESTAMPLTZ', 'DOUBLE', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_DOUBLE ;



call print_message('t_TIMESTAMPTZ_DOUBLE. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_DOUBLE(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN DOUBLE IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_DOUBLE('TIMESTAMPTZ', 'DOUBLE', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_DOUBLE('TIMESTAMPTZ', 'DOUBLE', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_DOUBLE ;



call print_message('t_DOUBLE_DOUBLE. This scenario is a success.');
create or replace function t_DOUBLE_DOUBLE(variables_type string, return_type string, param_value DOUBLE ) RETURN DOUBLE IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_DOUBLE('DOUBLE', 'DOUBLE', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_DOUBLE('DOUBLE', 'DOUBLE', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_DOUBLE ;



call print_message('t_FLOAT_DOUBLE. This scenario is a success.');
create or replace function t_FLOAT_DOUBLE(variables_type string, return_type string, param_value FLOAT ) RETURN DOUBLE IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_DOUBLE('FLOAT', 'DOUBLE', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_DOUBLE('FLOAT', 'DOUBLE', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_DOUBLE ;



call print_message('t_NUMERIC_DOUBLE. This scenario is a success.');
create or replace function t_NUMERIC_DOUBLE(variables_type string, return_type string, param_value NUMERIC ) RETURN DOUBLE IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_DOUBLE('NUMERIC(8,4)', 'DOUBLE', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_DOUBLE('NUMERIC(8,4)', 'DOUBLE', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_DOUBLE ;



call print_message('t_BIGINT_DOUBLE. This scenario is a success.');
create or replace function t_BIGINT_DOUBLE(variables_type string, return_type string, param_value BIGINT ) RETURN DOUBLE IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_DOUBLE('BIGINT', 'DOUBLE', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_DOUBLE('BIGINT', 'DOUBLE', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_DOUBLE ;



call print_message('t_INT_DOUBLE. This scenario is a success.');
create or replace function t_INT_DOUBLE(variables_type string, return_type string, param_value INT ) RETURN DOUBLE IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_DOUBLE('INT', 'DOUBLE', cast( 782346 as int ) ), 
 typeof( t_INT_DOUBLE('INT', 'DOUBLE', cast( 782346 as int ) ) ) ;
drop function t_INT_DOUBLE ;



call print_message('t_SHORT_DOUBLE. This scenario is a success.');
create or replace function t_SHORT_DOUBLE(variables_type string, return_type string, param_value SHORT ) RETURN DOUBLE IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_DOUBLE('SHORT', 'DOUBLE', cast( 8934 as short ) ), 
 typeof( t_SHORT_DOUBLE('SHORT', 'DOUBLE', cast( 8934 as short ) ) ) ;
drop function t_SHORT_DOUBLE ;



call print_message('t_BIT(8)_DOUBLE. This scenario is a failure.');
create or replace function t_BIT_DOUBLE(variables_type string, return_type string, param_value BIT ) RETURN DOUBLE IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_DOUBLE('BIT(8)', 'DOUBLE', 0xaa ), 
 typeof( t_BIT_DOUBLE('BIT(8)', 'DOUBLE', 0xaa ) ) ;
drop function t_BIT_DOUBLE ;



call print_message('t_BIT VARYING_DOUBLE. This scenario is a failure.');
create or replace function t_BITVARYING_DOUBLE(variables_type string, return_type string, param_value BITVARYING ) RETURN DOUBLE IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_DOUBLE('BIT VARYING', 'DOUBLE', 0xaa ), 
 typeof( t_BITVARYING_DOUBLE('BIT VARYING', 'DOUBLE', 0xaa ) ) ;
drop function t_BITVARYING_DOUBLE ;



call print_message('t_CHAR_DOUBLE. This scenario is a success.');
create or replace function t_CHAR_DOUBLE(variables_type string, return_type string, param_value CHAR ) RETURN DOUBLE IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_DOUBLE('CHAR', 'DOUBLE', cast( '123' as char(3) ) ), 
 typeof( t_CHAR_DOUBLE('CHAR', 'DOUBLE', cast( '123' as char(3) ) ) ) ;
drop function t_CHAR_DOUBLE ;



call print_message('t_VARCHAR_DOUBLE. This scenario is a success.');
create or replace function t_VARCHAR_DOUBLE(variables_type string, return_type string, param_value VARCHAR ) RETURN DOUBLE IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_DOUBLE('VARCHAR', 'DOUBLE', cast('567' as varchar ) ), 
 typeof( t_VARCHAR_DOUBLE('VARCHAR', 'DOUBLE', cast('567' as varchar ) ) ) ;
drop function t_VARCHAR_DOUBLE ;



call print_message('t_SET_DOUBLE. This scenario is a failure.');
create or replace function t_SET_DOUBLE(variables_type string, return_type string, param_value SET ) RETURN DOUBLE IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_DOUBLE('SET', 'DOUBLE', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_DOUBLE('SET', 'DOUBLE', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_DOUBLE ;



call print_message('t_MULTISET_DOUBLE. This scenario is a failure.');
create or replace function t_MULTISET_DOUBLE(variables_type string, return_type string, param_value MULTISET ) RETURN DOUBLE IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_DOUBLE('MULTISET', 'DOUBLE', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_DOUBLE('MULTISET', 'DOUBLE', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_DOUBLE ;



call print_message('t_LIST_DOUBLE. This scenario is a failure.');
create or replace function t_LIST_DOUBLE(variables_type string, return_type string, param_value LIST ) RETURN DOUBLE IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_DOUBLE('LIST', 'DOUBLE', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_DOUBLE('LIST', 'DOUBLE', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_DOUBLE ;



call print_message('t_ENUM_DOUBLE. This scenario is a failure.');
create or replace function t_ENUM_DOUBLE(variables_type string, return_type string, param_value ENUM ) RETURN DOUBLE IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_DOUBLE('ENUM', 'DOUBLE', 'yellow' ), 
 typeof( t_ENUM_DOUBLE('ENUM', 'DOUBLE', 'yellow' ) ) ;
drop function t_ENUM_DOUBLE ;



call print_message('t_BLOB_DOUBLE. This scenario is a failure.');
create or replace function t_BLOB_DOUBLE(variables_type string, return_type string, param_value BLOB ) RETURN DOUBLE IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_DOUBLE('BLOB', 'DOUBLE', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_DOUBLE('BLOB', 'DOUBLE', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_DOUBLE ;



call print_message('t_CLOB_DOUBLE. This scenario is a failure.');
create or replace function t_CLOB_DOUBLE(variables_type string, return_type string, param_value CLOB ) RETURN DOUBLE IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_DOUBLE('CLOB', 'DOUBLE', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_DOUBLE('CLOB', 'DOUBLE', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_DOUBLE ;



call print_message('t_JSON_DOUBLE. This scenario is a failure.');
create or replace function t_JSON_DOUBLE(variables_type string, return_type string, param_value JSON ) RETURN DOUBLE IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_DOUBLE('JSON', 'DOUBLE', '{"a":1}' ), 
 typeof( t_JSON_DOUBLE('JSON', 'DOUBLE', '{"a":1}' ) ) ;
drop function t_JSON_DOUBLE ;

drop procedure print_message;

--+ server-message off
