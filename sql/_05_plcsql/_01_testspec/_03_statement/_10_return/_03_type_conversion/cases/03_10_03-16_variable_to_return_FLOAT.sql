--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_FLOAT. This scenario is a failure.');
create or replace function t_DATETIME_FLOAT(variables_type string, return_type string, param_value DATETIME ) RETURN FLOAT IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_FLOAT('DATETIME', 'FLOAT', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_FLOAT('DATETIME', 'FLOAT', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_FLOAT ;



call print_message('t_DATETIMELTZ_FLOAT. This scenario is a failure.');
create or replace function t_DATETIMELTZ_FLOAT(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN FLOAT IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_FLOAT('DATETIMELTZ', 'FLOAT', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_FLOAT('DATETIMELTZ', 'FLOAT', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_FLOAT ;



call print_message('t_DATETIMETZ_FLOAT. This scenario is a failure.');
create or replace function t_DATETIMETZ_FLOAT(variables_type string, return_type string, param_value DATETIMETZ ) RETURN FLOAT IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_FLOAT('DATETIMETZ', 'FLOAT', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_FLOAT('DATETIMETZ', 'FLOAT', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_FLOAT ;



call print_message('t_DATE_FLOAT. This scenario is a failure.');
create or replace function t_DATE_FLOAT(variables_type string, return_type string, param_value DATE ) RETURN FLOAT IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_FLOAT('DATE', 'FLOAT', DATE'2008-10-31' ), 
 typeof( t_DATE_FLOAT('DATE', 'FLOAT', DATE'2008-10-31' ) ) ;
drop function t_DATE_FLOAT ;



call print_message('t_TIME_FLOAT. This scenario is a failure.');
create or replace function t_TIME_FLOAT(variables_type string, return_type string, param_value TIME ) RETURN FLOAT IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_FLOAT('TIME', 'FLOAT', TIME'13:15:45' ), 
 typeof( t_TIME_FLOAT('TIME', 'FLOAT', TIME'13:15:45' ) ) ;
drop function t_TIME_FLOAT ;



call print_message('t_TIMESTAMP_FLOAT. This scenario is a failure.');
create or replace function t_TIMESTAMP_FLOAT(variables_type string, return_type string, param_value TIMESTAMP ) RETURN FLOAT IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_FLOAT('TIMESTAMP', 'FLOAT', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_FLOAT('TIMESTAMP', 'FLOAT', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_FLOAT ;



call print_message('t_TIMESTAMPLTZ_FLOAT. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_FLOAT(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN FLOAT IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_FLOAT('TIMESTAMPLTZ', 'FLOAT', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_FLOAT('TIMESTAMPLTZ', 'FLOAT', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_FLOAT ;



call print_message('t_TIMESTAMPTZ_FLOAT. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_FLOAT(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN FLOAT IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_FLOAT('TIMESTAMPTZ', 'FLOAT', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_FLOAT('TIMESTAMPTZ', 'FLOAT', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_FLOAT ;



call print_message('t_DOUBLE_FLOAT. This scenario is a success.');
create or replace function t_DOUBLE_FLOAT(variables_type string, return_type string, param_value DOUBLE ) RETURN FLOAT IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_FLOAT('DOUBLE', 'FLOAT', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_FLOAT('DOUBLE', 'FLOAT', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_FLOAT ;



call print_message('t_FLOAT_FLOAT. This scenario is a success.');
create or replace function t_FLOAT_FLOAT(variables_type string, return_type string, param_value FLOAT ) RETURN FLOAT IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_FLOAT('FLOAT', 'FLOAT', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_FLOAT('FLOAT', 'FLOAT', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_FLOAT ;



call print_message('t_NUMERIC_FLOAT. This scenario is a success.');
create or replace function t_NUMERIC_FLOAT(variables_type string, return_type string, param_value NUMERIC ) RETURN FLOAT IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_FLOAT('NUMERIC(8,4)', 'FLOAT', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_FLOAT('NUMERIC(8,4)', 'FLOAT', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_FLOAT ;



call print_message('t_BIGINT_FLOAT. This scenario is a success.');
create or replace function t_BIGINT_FLOAT(variables_type string, return_type string, param_value BIGINT ) RETURN FLOAT IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_FLOAT('BIGINT', 'FLOAT', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_FLOAT('BIGINT', 'FLOAT', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_FLOAT ;



call print_message('t_INT_FLOAT. This scenario is a success.');
create or replace function t_INT_FLOAT(variables_type string, return_type string, param_value INT ) RETURN FLOAT IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_FLOAT('INT', 'FLOAT', cast( 782346 as int ) ), 
 typeof( t_INT_FLOAT('INT', 'FLOAT', cast( 782346 as int ) ) ) ;
drop function t_INT_FLOAT ;



call print_message('t_SHORT_FLOAT. This scenario is a success.');
create or replace function t_SHORT_FLOAT(variables_type string, return_type string, param_value SHORT ) RETURN FLOAT IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_FLOAT('SHORT', 'FLOAT', cast( 8934 as short ) ), 
 typeof( t_SHORT_FLOAT('SHORT', 'FLOAT', cast( 8934 as short ) ) ) ;
drop function t_SHORT_FLOAT ;



call print_message('t_BIT(8)_FLOAT. This scenario is a failure.');
create or replace function t_BIT_FLOAT(variables_type string, return_type string, param_value BIT ) RETURN FLOAT IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_FLOAT('BIT(8)', 'FLOAT', 0xaa ), 
 typeof( t_BIT_FLOAT('BIT(8)', 'FLOAT', 0xaa ) ) ;
drop function t_BIT_FLOAT ;



call print_message('t_BIT VARYING_FLOAT. This scenario is a failure.');
create or replace function t_BITVARYING_FLOAT(variables_type string, return_type string, param_value BITVARYING ) RETURN FLOAT IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_FLOAT('BIT VARYING', 'FLOAT', 0xaa ), 
 typeof( t_BITVARYING_FLOAT('BIT VARYING', 'FLOAT', 0xaa ) ) ;
drop function t_BITVARYING_FLOAT ;



call print_message('t_CHAR_FLOAT. This scenario is a success.');
create or replace function t_CHAR_FLOAT(variables_type string, return_type string, param_value CHAR ) RETURN FLOAT IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_FLOAT('CHAR', 'FLOAT', cast( '123' as char(3) ) ), 
 typeof( t_CHAR_FLOAT('CHAR', 'FLOAT', cast( '123' as char(3) ) ) ) ;
drop function t_CHAR_FLOAT ;



call print_message('t_VARCHAR_FLOAT. This scenario is a success.');
create or replace function t_VARCHAR_FLOAT(variables_type string, return_type string, param_value VARCHAR ) RETURN FLOAT IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_FLOAT('VARCHAR', 'FLOAT', cast('567' as varchar ) ), 
 typeof( t_VARCHAR_FLOAT('VARCHAR', 'FLOAT', cast('567' as varchar ) ) ) ;
drop function t_VARCHAR_FLOAT ;



call print_message('t_SET_FLOAT. This scenario is a failure.');
create or replace function t_SET_FLOAT(variables_type string, return_type string, param_value SET ) RETURN FLOAT IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_FLOAT('SET', 'FLOAT', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_FLOAT('SET', 'FLOAT', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_FLOAT ;



call print_message('t_MULTISET_FLOAT. This scenario is a failure.');
create or replace function t_MULTISET_FLOAT(variables_type string, return_type string, param_value MULTISET ) RETURN FLOAT IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_FLOAT('MULTISET', 'FLOAT', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_FLOAT('MULTISET', 'FLOAT', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_FLOAT ;



call print_message('t_LIST_FLOAT. This scenario is a failure.');
create or replace function t_LIST_FLOAT(variables_type string, return_type string, param_value LIST ) RETURN FLOAT IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_FLOAT('LIST', 'FLOAT', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_FLOAT('LIST', 'FLOAT', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_FLOAT ;



call print_message('t_ENUM_FLOAT. This scenario is a failure.');
create or replace function t_ENUM_FLOAT(variables_type string, return_type string, param_value ENUM ) RETURN FLOAT IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_FLOAT('ENUM', 'FLOAT', 'yellow' ), 
 typeof( t_ENUM_FLOAT('ENUM', 'FLOAT', 'yellow' ) ) ;
drop function t_ENUM_FLOAT ;



call print_message('t_BLOB_FLOAT. This scenario is a failure.');
create or replace function t_BLOB_FLOAT(variables_type string, return_type string, param_value BLOB ) RETURN FLOAT IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_FLOAT('BLOB', 'FLOAT', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_FLOAT('BLOB', 'FLOAT', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_FLOAT ;



call print_message('t_CLOB_FLOAT. This scenario is a failure.');
create or replace function t_CLOB_FLOAT(variables_type string, return_type string, param_value CLOB ) RETURN FLOAT IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_FLOAT('CLOB', 'FLOAT', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_FLOAT('CLOB', 'FLOAT', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_FLOAT ;



call print_message('t_JSON_FLOAT. This scenario is a failure.');
create or replace function t_JSON_FLOAT(variables_type string, return_type string, param_value JSON ) RETURN FLOAT IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_FLOAT('JSON', 'FLOAT', '{"a":1}' ), 
 typeof( t_JSON_FLOAT('JSON', 'FLOAT', '{"a":1}' ) ) ;
drop function t_JSON_FLOAT ;

drop procedure print_message;

--+ server-message off
