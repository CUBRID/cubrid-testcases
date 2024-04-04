--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_JSON. This scenario is a failure.');
create or replace function t_DATETIME_JSON(variables_type string, return_type string, param_value DATETIME ) RETURN JSON IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_JSON('DATETIME', 'JSON', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_JSON('DATETIME', 'JSON', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_JSON ;



call print_message('t_DATETIMELTZ_JSON. This scenario is a failure.');
create or replace function t_DATETIMELTZ_JSON(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN JSON IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_JSON('DATETIMELTZ', 'JSON', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_JSON('DATETIMELTZ', 'JSON', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_JSON ;



call print_message('t_DATETIMETZ_JSON. This scenario is a failure.');
create or replace function t_DATETIMETZ_JSON(variables_type string, return_type string, param_value DATETIMETZ ) RETURN JSON IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_JSON('DATETIMETZ', 'JSON', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_JSON('DATETIMETZ', 'JSON', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_JSON ;



call print_message('t_DATE_JSON. This scenario is a failure.');
create or replace function t_DATE_JSON(variables_type string, return_type string, param_value DATE ) RETURN JSON IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_JSON('DATE', 'JSON', DATE'2008-10-31' ), 
 typeof( t_DATE_JSON('DATE', 'JSON', DATE'2008-10-31' ) ) ;
drop function t_DATE_JSON ;



call print_message('t_TIME_JSON. This scenario is a failure.');
create or replace function t_TIME_JSON(variables_type string, return_type string, param_value TIME ) RETURN JSON IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_JSON('TIME', 'JSON', TIME'13:15:45' ), 
 typeof( t_TIME_JSON('TIME', 'JSON', TIME'13:15:45' ) ) ;
drop function t_TIME_JSON ;



call print_message('t_TIMESTAMP_JSON. This scenario is a failure.');
create or replace function t_TIMESTAMP_JSON(variables_type string, return_type string, param_value TIMESTAMP ) RETURN JSON IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_JSON('TIMESTAMP', 'JSON', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_JSON('TIMESTAMP', 'JSON', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_JSON ;



call print_message('t_TIMESTAMPLTZ_JSON. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_JSON(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN JSON IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_JSON('TIMESTAMPLTZ', 'JSON', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_JSON('TIMESTAMPLTZ', 'JSON', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_JSON ;



call print_message('t_TIMESTAMPTZ_JSON. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_JSON(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN JSON IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_JSON('TIMESTAMPTZ', 'JSON', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_JSON('TIMESTAMPTZ', 'JSON', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_JSON ;



call print_message('t_DOUBLE_JSON. This scenario is a failure.');
create or replace function t_DOUBLE_JSON(variables_type string, return_type string, param_value DOUBLE ) RETURN JSON IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_JSON('DOUBLE', 'JSON', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_JSON('DOUBLE', 'JSON', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_JSON ;



call print_message('t_FLOAT_JSON. This scenario is a failure.');
create or replace function t_FLOAT_JSON(variables_type string, return_type string, param_value FLOAT ) RETURN JSON IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_JSON('FLOAT', 'JSON', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_JSON('FLOAT', 'JSON', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_JSON ;



call print_message('t_NUMERIC(8,4)_JSON. This scenario is a failure.');
create or replace function t_NUMERIC_JSON(variables_type string, return_type string, param_value NUMERIC ) RETURN JSON IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_JSON('NUMERIC(8,4)', 'JSON', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_JSON('NUMERIC(8,4)', 'JSON', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_JSON ;



call print_message('t_BIGINT_JSON. This scenario is a failure.');
create or replace function t_BIGINT_JSON(variables_type string, return_type string, param_value BIGINT ) RETURN JSON IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_JSON('BIGINT', 'JSON', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_JSON('BIGINT', 'JSON', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_JSON ;



call print_message('t_INT_JSON. This scenario is a failure.');
create or replace function t_INT_JSON(variables_type string, return_type string, param_value INT ) RETURN JSON IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_JSON('INT', 'JSON', cast( 782346 as int ) ), 
 typeof( t_INT_JSON('INT', 'JSON', cast( 782346 as int ) ) ) ;
drop function t_INT_JSON ;



call print_message('t_SHORT_JSON. This scenario is a failure.');
create or replace function t_SHORT_JSON(variables_type string, return_type string, param_value SHORT ) RETURN JSON IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_JSON('SHORT', 'JSON', cast( 8934 as short ) ), 
 typeof( t_SHORT_JSON('SHORT', 'JSON', cast( 8934 as short ) ) ) ;
drop function t_SHORT_JSON ;



call print_message('t_BIT(8)_JSON. This scenario is a failure.');
create or replace function t_BIT_JSON(variables_type string, return_type string, param_value BIT ) RETURN JSON IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_JSON('BIT(8)', 'JSON', 0xaa ), 
 typeof( t_BIT_JSON('BIT(8)', 'JSON', 0xaa ) ) ;
drop function t_BIT_JSON ;



call print_message('t_BIT VARYING_JSON. This scenario is a failure.');
create or replace function t_BITVARYING_JSON(variables_type string, return_type string, param_value BITVARYING ) RETURN JSON IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_JSON('BIT VARYING', 'JSON', 0xaa ), 
 typeof( t_BITVARYING_JSON('BIT VARYING', 'JSON', 0xaa ) ) ;
drop function t_BITVARYING_JSON ;



call print_message('t_CHAR_JSON. This scenario is a failure.');
create or replace function t_CHAR_JSON(variables_type string, return_type string, param_value CHAR ) RETURN JSON IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_JSON('CHAR', 'JSON', '{"a":1}' ), 
 typeof( t_CHAR_JSON('CHAR', 'JSON', '{"a":1}' ) ) ;
drop function t_CHAR_JSON ;



call print_message('t_VARCHAR_JSON. This scenario is a failure.');
create or replace function t_VARCHAR_JSON(variables_type string, return_type string, param_value VARCHAR ) RETURN JSON IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_JSON('VARCHAR', 'JSON', '{"a":1}' ), 
 typeof( t_VARCHAR_JSON('VARCHAR', 'JSON', '{"a":1}' ) ) ;
drop function t_VARCHAR_JSON ;



call print_message('t_SET_JSON. This scenario is a failure.');
create or replace function t_SET_JSON(variables_type string, return_type string, param_value SET ) RETURN JSON IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_JSON('SET', 'JSON', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_JSON('SET', 'JSON', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_JSON ;



call print_message('t_MULTISET_JSON. This scenario is a failure.');
create or replace function t_MULTISET_JSON(variables_type string, return_type string, param_value MULTISET ) RETURN JSON IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_JSON('MULTISET', 'JSON', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_JSON('MULTISET', 'JSON', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_JSON ;



call print_message('t_LIST_JSON. This scenario is a failure.');
create or replace function t_LIST_JSON(variables_type string, return_type string, param_value LIST ) RETURN JSON IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_JSON('LIST', 'JSON', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_JSON('LIST', 'JSON', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_JSON ;



call print_message('t_ENUM_JSON. This scenario is a failure.');
create or replace function t_ENUM_JSON(variables_type string, return_type string, param_value ENUM ) RETURN JSON IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_JSON('ENUM', 'JSON', 'yellow' ), 
 typeof( t_ENUM_JSON('ENUM', 'JSON', 'yellow' ) ) ;
drop function t_ENUM_JSON ;



call print_message('t_BLOB_JSON. This scenario is a failure.');
create or replace function t_BLOB_JSON(variables_type string, return_type string, param_value BLOB ) RETURN JSON IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_JSON('BLOB', 'JSON', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_JSON('BLOB', 'JSON', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_JSON ;



call print_message('t_CLOB_JSON. This scenario is a failure.');
create or replace function t_CLOB_JSON(variables_type string, return_type string, param_value CLOB ) RETURN JSON IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_JSON('CLOB', 'JSON', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_JSON('CLOB', 'JSON', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_JSON ;



call print_message('t_JSON_JSON. This scenario is a failure.');
create or replace function t_JSON_JSON(variables_type string, return_type string, param_value JSON ) RETURN JSON IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_JSON('JSON', 'JSON', '{"a":1}' ), 
 typeof( t_JSON_JSON('JSON', 'JSON', '{"a":1}' ) ) ;
drop function t_JSON_JSON ;

drop procedure print_message;

--+ server-message off
