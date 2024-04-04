--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIMESTAMP. This scenario is a success.');
create or replace function t_DATETIME_TIMESTAMP(variables_type string, return_type string, param_value DATETIME ) RETURN TIMESTAMP IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_TIMESTAMP('DATETIME', 'TIMESTAMP', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_TIMESTAMP('DATETIME', 'TIMESTAMP', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_TIMESTAMP ;



call print_message('t_DATETIMELTZ_TIMESTAMP. This scenario is a failure.');
create or replace function t_DATETIMELTZ_TIMESTAMP(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN TIMESTAMP IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_TIMESTAMP('DATETIMELTZ', 'TIMESTAMP', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_TIMESTAMP('DATETIMELTZ', 'TIMESTAMP', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_TIMESTAMP ;



call print_message('t_DATETIMETZ_TIMESTAMP. This scenario is a failure.');
create or replace function t_DATETIMETZ_TIMESTAMP(variables_type string, return_type string, param_value DATETIMETZ ) RETURN TIMESTAMP IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_TIMESTAMP('DATETIMETZ', 'TIMESTAMP', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_TIMESTAMP('DATETIMETZ', 'TIMESTAMP', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_TIMESTAMP ;



call print_message('t_DATE_TIMESTAMP. This scenario is a success.');
create or replace function t_DATE_TIMESTAMP(variables_type string, return_type string, param_value DATE ) RETURN TIMESTAMP IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_TIMESTAMP('DATE', 'TIMESTAMP', DATE'2008-10-31' ), 
 typeof( t_DATE_TIMESTAMP('DATE', 'TIMESTAMP', DATE'2008-10-31' ) ) ;
drop function t_DATE_TIMESTAMP ;



call print_message('t_TIME_TIMESTAMP. This scenario is a failure.');
create or replace function t_TIME_TIMESTAMP(variables_type string, return_type string, param_value TIME ) RETURN TIMESTAMP IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_TIMESTAMP('TIME', 'TIMESTAMP', TIME'13:15:45' ), 
 typeof( t_TIME_TIMESTAMP('TIME', 'TIMESTAMP', TIME'13:15:45' ) ) ;
drop function t_TIME_TIMESTAMP ;



call print_message('t_TIMESTAMP_TIMESTAMP. This scenario is a success.');
create or replace function t_TIMESTAMP_TIMESTAMP(variables_type string, return_type string, param_value TIMESTAMP ) RETURN TIMESTAMP IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_TIMESTAMP('TIMESTAMP', 'TIMESTAMP', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_TIMESTAMP('TIMESTAMP', 'TIMESTAMP', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_TIMESTAMP ;



call print_message('t_TIMESTAMPLTZ_TIMESTAMP. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_TIMESTAMP(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN TIMESTAMP IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_TIMESTAMP('TIMESTAMPLTZ', 'TIMESTAMP', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_TIMESTAMP('TIMESTAMPLTZ', 'TIMESTAMP', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_TIMESTAMP ;



call print_message('t_TIMESTAMPTZ_TIMESTAMP. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_TIMESTAMP(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN TIMESTAMP IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_TIMESTAMP('TIMESTAMPTZ', 'TIMESTAMP', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_TIMESTAMP('TIMESTAMPTZ', 'TIMESTAMP', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_TIMESTAMP ;



call print_message('t_DOUBLE_TIMESTAMP. This scenario is a success.');
create or replace function t_DOUBLE_TIMESTAMP(variables_type string, return_type string, param_value DOUBLE ) RETURN TIMESTAMP IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_TIMESTAMP('DOUBLE', 'TIMESTAMP', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_TIMESTAMP('DOUBLE', 'TIMESTAMP', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_TIMESTAMP ;



call print_message('t_FLOAT_TIMESTAMP. This scenario is a success.');
create or replace function t_FLOAT_TIMESTAMP(variables_type string, return_type string, param_value FLOAT ) RETURN TIMESTAMP IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_TIMESTAMP('FLOAT', 'TIMESTAMP', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_TIMESTAMP('FLOAT', 'TIMESTAMP', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_TIMESTAMP ;



call print_message('t_NUMERIC_TIMESTAMP. This scenario is a success.');
create or replace function t_NUMERIC_TIMESTAMP(variables_type string, return_type string, param_value NUMERIC ) RETURN TIMESTAMP IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_TIMESTAMP('NUMERIC(8,4)', 'TIMESTAMP', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_TIMESTAMP('NUMERIC(8,4)', 'TIMESTAMP', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_TIMESTAMP ;



call print_message('t_BIGINT_TIMESTAMP. This scenario is a success.');
create or replace function t_BIGINT_TIMESTAMP(variables_type string, return_type string, param_value BIGINT ) RETURN TIMESTAMP IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_TIMESTAMP('BIGINT', 'TIMESTAMP', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_TIMESTAMP('BIGINT', 'TIMESTAMP', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_TIMESTAMP ;



call print_message('t_INT_TIMESTAMP. This scenario is a success.');
create or replace function t_INT_TIMESTAMP(variables_type string, return_type string, param_value INT ) RETURN TIMESTAMP IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_TIMESTAMP('INT', 'TIMESTAMP', cast( 782346 as int ) ), 
 typeof( t_INT_TIMESTAMP('INT', 'TIMESTAMP', cast( 782346 as int ) ) ) ;
drop function t_INT_TIMESTAMP ;



call print_message('t_SHORT_TIMESTAMP. This scenario is a success.');
create or replace function t_SHORT_TIMESTAMP(variables_type string, return_type string, param_value SHORT ) RETURN TIMESTAMP IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_TIMESTAMP('SHORT', 'TIMESTAMP', cast( 8934 as short ) ), 
 typeof( t_SHORT_TIMESTAMP('SHORT', 'TIMESTAMP', cast( 8934 as short ) ) ) ;
drop function t_SHORT_TIMESTAMP ;



call print_message('t_BIT(8)_TIMESTAMP. This scenario is a failure.');
create or replace function t_BIT_TIMESTAMP(variables_type string, return_type string, param_value BIT ) RETURN TIMESTAMP IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_TIMESTAMP('BIT(8)', 'TIMESTAMP', 0xaa ), 
 typeof( t_BIT_TIMESTAMP('BIT(8)', 'TIMESTAMP', 0xaa ) ) ;
drop function t_BIT_TIMESTAMP ;



call print_message('t_BIT VARYING_TIMESTAMP. This scenario is a failure.');
create or replace function t_BITVARYING_TIMESTAMP(variables_type string, return_type string, param_value BITVARYING ) RETURN TIMESTAMP IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_TIMESTAMP('BIT VARYING', 'TIMESTAMP', 0xaa ), 
 typeof( t_BITVARYING_TIMESTAMP('BIT VARYING', 'TIMESTAMP', 0xaa ) ) ;
drop function t_BITVARYING_TIMESTAMP ;



call print_message('t_CHAR_TIMESTAMP. This scenario is a success.');
create or replace function t_CHAR_TIMESTAMP(variables_type string, return_type string, param_value CHAR ) RETURN TIMESTAMP IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_TIMESTAMP('CHAR', 'TIMESTAMP', cast( '09/01/2005 05:05:05 pm' as char(22) ) ), 
 typeof( t_CHAR_TIMESTAMP('CHAR', 'TIMESTAMP', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ) ;
drop function t_CHAR_TIMESTAMP ;



call print_message('t_VARCHAR_TIMESTAMP. This scenario is a success.');
create or replace function t_VARCHAR_TIMESTAMP(variables_type string, return_type string, param_value VARCHAR ) RETURN TIMESTAMP IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_TIMESTAMP('VARCHAR', 'TIMESTAMP', cast( '09/01/2019 09:09:09 pm' as varchar ) ), 
 typeof( t_VARCHAR_TIMESTAMP('VARCHAR', 'TIMESTAMP', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ) ;
drop function t_VARCHAR_TIMESTAMP ;



call print_message('t_SET_TIMESTAMP. This scenario is a failure.');
create or replace function t_SET_TIMESTAMP(variables_type string, return_type string, param_value SET ) RETURN TIMESTAMP IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_TIMESTAMP('SET', 'TIMESTAMP', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_TIMESTAMP('SET', 'TIMESTAMP', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_TIMESTAMP ;



call print_message('t_MULTISET_TIMESTAMP. This scenario is a failure.');
create or replace function t_MULTISET_TIMESTAMP(variables_type string, return_type string, param_value MULTISET ) RETURN TIMESTAMP IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_TIMESTAMP('MULTISET', 'TIMESTAMP', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_TIMESTAMP('MULTISET', 'TIMESTAMP', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_TIMESTAMP ;



call print_message('t_LIST_TIMESTAMP. This scenario is a failure.');
create or replace function t_LIST_TIMESTAMP(variables_type string, return_type string, param_value LIST ) RETURN TIMESTAMP IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_TIMESTAMP('LIST', 'TIMESTAMP', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_TIMESTAMP('LIST', 'TIMESTAMP', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_TIMESTAMP ;



call print_message('t_ENUM_TIMESTAMP. This scenario is a failure.');
create or replace function t_ENUM_TIMESTAMP(variables_type string, return_type string, param_value ENUM ) RETURN TIMESTAMP IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_TIMESTAMP('ENUM', 'TIMESTAMP', 'yellow' ), 
 typeof( t_ENUM_TIMESTAMP('ENUM', 'TIMESTAMP', 'yellow' ) ) ;
drop function t_ENUM_TIMESTAMP ;



call print_message('t_BLOB_TIMESTAMP. This scenario is a failure.');
create or replace function t_BLOB_TIMESTAMP(variables_type string, return_type string, param_value BLOB ) RETURN TIMESTAMP IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_TIMESTAMP('BLOB', 'TIMESTAMP', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_TIMESTAMP('BLOB', 'TIMESTAMP', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_TIMESTAMP ;



call print_message('t_CLOB_TIMESTAMP. This scenario is a failure.');
create or replace function t_CLOB_TIMESTAMP(variables_type string, return_type string, param_value CLOB ) RETURN TIMESTAMP IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_TIMESTAMP('CLOB', 'TIMESTAMP', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_TIMESTAMP('CLOB', 'TIMESTAMP', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_TIMESTAMP ;



call print_message('t_JSON_TIMESTAMP. This scenario is a failure.');
create or replace function t_JSON_TIMESTAMP(variables_type string, return_type string, param_value JSON ) RETURN TIMESTAMP IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_TIMESTAMP('JSON', 'TIMESTAMP', '{"a":1}' ), 
 typeof( t_JSON_TIMESTAMP('JSON', 'TIMESTAMP', '{"a":1}' ) ) ;
drop function t_JSON_TIMESTAMP ;

drop procedure print_message;

--+ server-message off
