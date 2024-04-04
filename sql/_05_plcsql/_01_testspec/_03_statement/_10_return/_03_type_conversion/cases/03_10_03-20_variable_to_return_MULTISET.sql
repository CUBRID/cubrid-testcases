--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_MULTISET. This scenario is a failure.');
create or replace function t_DATETIME_MULTISET(variables_type string, return_type string, param_value DATETIME ) RETURN MULTISET IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_MULTISET('DATETIME', 'MULTISET', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_MULTISET('DATETIME', 'MULTISET', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_MULTISET ;



call print_message('t_DATETIMELTZ_MULTISET. This scenario is a failure.');
create or replace function t_DATETIMELTZ_MULTISET(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN MULTISET IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_MULTISET('DATETIMELTZ', 'MULTISET', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_MULTISET('DATETIMELTZ', 'MULTISET', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_MULTISET ;



call print_message('t_DATETIMETZ_MULTISET. This scenario is a failure.');
create or replace function t_DATETIMETZ_MULTISET(variables_type string, return_type string, param_value DATETIMETZ ) RETURN MULTISET IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_MULTISET('DATETIMETZ', 'MULTISET', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_MULTISET('DATETIMETZ', 'MULTISET', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_MULTISET ;



call print_message('t_DATE_MULTISET. This scenario is a failure.');
create or replace function t_DATE_MULTISET(variables_type string, return_type string, param_value DATE ) RETURN MULTISET IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_MULTISET('DATE', 'MULTISET', DATE'2008-10-31' ), 
 typeof( t_DATE_MULTISET('DATE', 'MULTISET', DATE'2008-10-31' ) ) ;
drop function t_DATE_MULTISET ;



call print_message('t_TIME_MULTISET. This scenario is a failure.');
create or replace function t_TIME_MULTISET(variables_type string, return_type string, param_value TIME ) RETURN MULTISET IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_MULTISET('TIME', 'MULTISET', TIME'13:15:45' ), 
 typeof( t_TIME_MULTISET('TIME', 'MULTISET', TIME'13:15:45' ) ) ;
drop function t_TIME_MULTISET ;



call print_message('t_TIMESTAMP_MULTISET. This scenario is a failure.');
create or replace function t_TIMESTAMP_MULTISET(variables_type string, return_type string, param_value TIMESTAMP ) RETURN MULTISET IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_MULTISET('TIMESTAMP', 'MULTISET', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_MULTISET('TIMESTAMP', 'MULTISET', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_MULTISET ;



call print_message('t_TIMESTAMPLTZ_MULTISET. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_MULTISET(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN MULTISET IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_MULTISET('TIMESTAMPLTZ', 'MULTISET', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_MULTISET('TIMESTAMPLTZ', 'MULTISET', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_MULTISET ;



call print_message('t_TIMESTAMPTZ_MULTISET. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_MULTISET(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN MULTISET IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_MULTISET('TIMESTAMPTZ', 'MULTISET', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_MULTISET('TIMESTAMPTZ', 'MULTISET', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_MULTISET ;



call print_message('t_DOUBLE_MULTISET. This scenario is a failure.');
create or replace function t_DOUBLE_MULTISET(variables_type string, return_type string, param_value DOUBLE ) RETURN MULTISET IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_MULTISET('DOUBLE', 'MULTISET', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_MULTISET('DOUBLE', 'MULTISET', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_MULTISET ;



call print_message('t_FLOAT_MULTISET. This scenario is a failure.');
create or replace function t_FLOAT_MULTISET(variables_type string, return_type string, param_value FLOAT ) RETURN MULTISET IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_MULTISET('FLOAT', 'MULTISET', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_MULTISET('FLOAT', 'MULTISET', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_MULTISET ;



call print_message('t_NUMERIC(8,4)_MULTISET. This scenario is a failure.');
create or replace function t_NUMERIC_MULTISET(variables_type string, return_type string, param_value NUMERIC ) RETURN MULTISET IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_MULTISET('NUMERIC(8,4)', 'MULTISET', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_MULTISET('NUMERIC(8,4)', 'MULTISET', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_MULTISET ;



call print_message('t_BIGINT_MULTISET. This scenario is a failure.');
create or replace function t_BIGINT_MULTISET(variables_type string, return_type string, param_value BIGINT ) RETURN MULTISET IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_MULTISET('BIGINT', 'MULTISET', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_MULTISET('BIGINT', 'MULTISET', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_MULTISET ;



call print_message('t_INT_MULTISET. This scenario is a failure.');
create or replace function t_INT_MULTISET(variables_type string, return_type string, param_value INT ) RETURN MULTISET IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_MULTISET('INT', 'MULTISET', cast( 782346 as int ) ), 
 typeof( t_INT_MULTISET('INT', 'MULTISET', cast( 782346 as int ) ) ) ;
drop function t_INT_MULTISET ;



call print_message('t_SHORT_MULTISET. This scenario is a failure.');
create or replace function t_SHORT_MULTISET(variables_type string, return_type string, param_value SHORT ) RETURN MULTISET IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_MULTISET('SHORT', 'MULTISET', cast( 8934 as short ) ), 
 typeof( t_SHORT_MULTISET('SHORT', 'MULTISET', cast( 8934 as short ) ) ) ;
drop function t_SHORT_MULTISET ;



call print_message('t_BIT(8)_MULTISET. This scenario is a failure.');
create or replace function t_BIT_MULTISET(variables_type string, return_type string, param_value BIT ) RETURN MULTISET IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_MULTISET('BIT(8)', 'MULTISET', 0xaa ), 
 typeof( t_BIT_MULTISET('BIT(8)', 'MULTISET', 0xaa ) ) ;
drop function t_BIT_MULTISET ;



call print_message('t_BIT VARYING_MULTISET. This scenario is a failure.');
create or replace function t_BITVARYING_MULTISET(variables_type string, return_type string, param_value BITVARYING ) RETURN MULTISET IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_MULTISET('BIT VARYING', 'MULTISET', 0xaa ), 
 typeof( t_BITVARYING_MULTISET('BIT VARYING', 'MULTISET', 0xaa ) ) ;
drop function t_BITVARYING_MULTISET ;



call print_message('t_CHAR_MULTISET. This scenario is a failure.');
create or replace function t_CHAR_MULTISET(variables_type string, return_type string, param_value CHAR ) RETURN MULTISET IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_MULTISET('CHAR', 'MULTISET', {'c','c','c','b','b','a'} ), 
 typeof( t_CHAR_MULTISET('CHAR', 'MULTISET', {'c','c','c','b','b','a'} ) ) ;
drop function t_CHAR_MULTISET ;



call print_message('t_VARCHAR_MULTISET. This scenario is a failure.');
create or replace function t_VARCHAR_MULTISET(variables_type string, return_type string, param_value VARCHAR ) RETURN MULTISET IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_MULTISET('VARCHAR', 'MULTISET', {'c','c','c','b','b','a'} ), 
 typeof( t_VARCHAR_MULTISET('VARCHAR', 'MULTISET', {'c','c','c','b','b','a'} ) ) ;
drop function t_VARCHAR_MULTISET ;



call print_message('t_SET_MULTISET. This scenario is a failure.');
create or replace function t_SET_MULTISET(variables_type string, return_type string, param_value SET ) RETURN MULTISET IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_MULTISET('SET', 'MULTISET', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_MULTISET('SET', 'MULTISET', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_MULTISET ;



call print_message('t_MULTISET_MULTISET. This scenario is a failure.');
create or replace function t_MULTISET_MULTISET(variables_type string, return_type string, param_value MULTISET ) RETURN MULTISET IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_MULTISET('MULTISET', 'MULTISET', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_MULTISET('MULTISET', 'MULTISET', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_MULTISET ;



call print_message('t_LIST_MULTISET. This scenario is a failure.');
create or replace function t_LIST_MULTISET(variables_type string, return_type string, param_value LIST ) RETURN MULTISET IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_MULTISET('LIST', 'MULTISET', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_MULTISET('LIST', 'MULTISET', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_MULTISET ;



call print_message('t_ENUM_MULTISET. This scenario is a failure.');
create or replace function t_ENUM_MULTISET(variables_type string, return_type string, param_value ENUM ) RETURN MULTISET IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_MULTISET('ENUM', 'MULTISET', 'yellow' ), 
 typeof( t_ENUM_MULTISET('ENUM', 'MULTISET', 'yellow' ) ) ;
drop function t_ENUM_MULTISET ;



call print_message('t_BLOB_MULTISET. This scenario is a failure.');
create or replace function t_BLOB_MULTISET(variables_type string, return_type string, param_value BLOB ) RETURN MULTISET IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_MULTISET('BLOB', 'MULTISET', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_MULTISET('BLOB', 'MULTISET', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_MULTISET ;



call print_message('t_CLOB_MULTISET. This scenario is a failure.');
create or replace function t_CLOB_MULTISET(variables_type string, return_type string, param_value CLOB ) RETURN MULTISET IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_MULTISET('CLOB', 'MULTISET', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_MULTISET('CLOB', 'MULTISET', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_MULTISET ;



call print_message('t_JSON_MULTISET. This scenario is a failure.');
create or replace function t_JSON_MULTISET(variables_type string, return_type string, param_value JSON ) RETURN MULTISET IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_MULTISET('JSON', 'MULTISET', '{"a":1}' ), 
 typeof( t_JSON_MULTISET('JSON', 'MULTISET', '{"a":1}' ) ) ;
drop function t_JSON_MULTISET ;

drop procedure print_message;

--+ server-message off
