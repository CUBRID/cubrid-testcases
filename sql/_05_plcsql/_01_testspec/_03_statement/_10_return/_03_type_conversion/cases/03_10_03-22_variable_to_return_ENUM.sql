--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_ENUM. This scenario is a failure.');
create or replace function t_DATETIME_ENUM(variables_type string, return_type string, param_value DATETIME ) RETURN ENUM IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_ENUM('DATETIME', 'ENUM', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_ENUM('DATETIME', 'ENUM', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_ENUM ;



call print_message('t_DATETIMELTZ_ENUM. This scenario is a failure.');
create or replace function t_DATETIMELTZ_ENUM(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN ENUM IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_ENUM('DATETIMELTZ', 'ENUM', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_ENUM('DATETIMELTZ', 'ENUM', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_ENUM ;



call print_message('t_DATETIMETZ_ENUM. This scenario is a failure.');
create or replace function t_DATETIMETZ_ENUM(variables_type string, return_type string, param_value DATETIMETZ ) RETURN ENUM IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_ENUM('DATETIMETZ', 'ENUM', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_ENUM('DATETIMETZ', 'ENUM', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_ENUM ;



call print_message('t_DATE_ENUM. This scenario is a failure.');
create or replace function t_DATE_ENUM(variables_type string, return_type string, param_value DATE ) RETURN ENUM IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_ENUM('DATE', 'ENUM', DATE'2008-10-31' ), 
 typeof( t_DATE_ENUM('DATE', 'ENUM', DATE'2008-10-31' ) ) ;
drop function t_DATE_ENUM ;



call print_message('t_TIME_ENUM. This scenario is a failure.');
create or replace function t_TIME_ENUM(variables_type string, return_type string, param_value TIME ) RETURN ENUM IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_ENUM('TIME', 'ENUM', TIME'13:15:45' ), 
 typeof( t_TIME_ENUM('TIME', 'ENUM', TIME'13:15:45' ) ) ;
drop function t_TIME_ENUM ;



call print_message('t_TIMESTAMP_ENUM. This scenario is a failure.');
create or replace function t_TIMESTAMP_ENUM(variables_type string, return_type string, param_value TIMESTAMP ) RETURN ENUM IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_ENUM('TIMESTAMP', 'ENUM', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_ENUM('TIMESTAMP', 'ENUM', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_ENUM ;



call print_message('t_TIMESTAMPLTZ_ENUM. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_ENUM(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN ENUM IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_ENUM('TIMESTAMPLTZ', 'ENUM', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_ENUM('TIMESTAMPLTZ', 'ENUM', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_ENUM ;



call print_message('t_TIMESTAMPTZ_ENUM. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_ENUM(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN ENUM IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_ENUM('TIMESTAMPTZ', 'ENUM', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_ENUM('TIMESTAMPTZ', 'ENUM', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_ENUM ;



call print_message('t_DOUBLE_ENUM. This scenario is a failure.');
create or replace function t_DOUBLE_ENUM(variables_type string, return_type string, param_value DOUBLE ) RETURN ENUM IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_ENUM('DOUBLE', 'ENUM', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_ENUM('DOUBLE', 'ENUM', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_ENUM ;



call print_message('t_FLOAT_ENUM. This scenario is a failure.');
create or replace function t_FLOAT_ENUM(variables_type string, return_type string, param_value FLOAT ) RETURN ENUM IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_ENUM('FLOAT', 'ENUM', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_ENUM('FLOAT', 'ENUM', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_ENUM ;



call print_message('t_NUMERIC(8,4)_ENUM. This scenario is a failure.');
create or replace function t_NUMERIC_ENUM(variables_type string, return_type string, param_value NUMERIC ) RETURN ENUM IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_ENUM('NUMERIC(8,4)', 'ENUM', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_ENUM('NUMERIC(8,4)', 'ENUM', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_ENUM ;



call print_message('t_BIGINT_ENUM. This scenario is a failure.');
create or replace function t_BIGINT_ENUM(variables_type string, return_type string, param_value BIGINT ) RETURN ENUM IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_ENUM('BIGINT', 'ENUM', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_ENUM('BIGINT', 'ENUM', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_ENUM ;



call print_message('t_INT_ENUM. This scenario is a failure.');
create or replace function t_INT_ENUM(variables_type string, return_type string, param_value INT ) RETURN ENUM IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_ENUM('INT', 'ENUM', cast( 782346 as int ) ), 
 typeof( t_INT_ENUM('INT', 'ENUM', cast( 782346 as int ) ) ) ;
drop function t_INT_ENUM ;



call print_message('t_SHORT_ENUM. This scenario is a failure.');
create or replace function t_SHORT_ENUM(variables_type string, return_type string, param_value SHORT ) RETURN ENUM IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_ENUM('SHORT', 'ENUM', cast( 8934 as short ) ), 
 typeof( t_SHORT_ENUM('SHORT', 'ENUM', cast( 8934 as short ) ) ) ;
drop function t_SHORT_ENUM ;



call print_message('t_BIT(8)_ENUM. This scenario is a failure.');
create or replace function t_BIT_ENUM(variables_type string, return_type string, param_value BIT ) RETURN ENUM IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_ENUM('BIT(8)', 'ENUM', 0xaa ), 
 typeof( t_BIT_ENUM('BIT(8)', 'ENUM', 0xaa ) ) ;
drop function t_BIT_ENUM ;



call print_message('t_BIT VARYING_ENUM. This scenario is a failure.');
create or replace function t_BITVARYING_ENUM(variables_type string, return_type string, param_value BITVARYING ) RETURN ENUM IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_ENUM('BIT VARYING', 'ENUM', 0xaa ), 
 typeof( t_BITVARYING_ENUM('BIT VARYING', 'ENUM', 0xaa ) ) ;
drop function t_BITVARYING_ENUM ;



call print_message('t_CHAR_ENUM. This scenario is a failure.');
create or replace function t_CHAR_ENUM(variables_type string, return_type string, param_value CHAR ) RETURN ENUM IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_ENUM('CHAR', 'ENUM', 'yellow' ), 
 typeof( t_CHAR_ENUM('CHAR', 'ENUM', 'yellow' ) ) ;
drop function t_CHAR_ENUM ;



call print_message('t_VARCHAR_ENUM. This scenario is a failure.');
create or replace function t_VARCHAR_ENUM(variables_type string, return_type string, param_value VARCHAR ) RETURN ENUM IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_ENUM('VARCHAR', 'ENUM', 'yellow' ), 
 typeof( t_VARCHAR_ENUM('VARCHAR', 'ENUM', 'yellow' ) ) ;
drop function t_VARCHAR_ENUM ;



call print_message('t_SET_ENUM. This scenario is a failure.');
create or replace function t_SET_ENUM(variables_type string, return_type string, param_value SET ) RETURN ENUM IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_ENUM('SET', 'ENUM', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_ENUM('SET', 'ENUM', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_ENUM ;



call print_message('t_MULTISET_ENUM. This scenario is a failure.');
create or replace function t_MULTISET_ENUM(variables_type string, return_type string, param_value MULTISET ) RETURN ENUM IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_ENUM('MULTISET', 'ENUM', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_ENUM('MULTISET', 'ENUM', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_ENUM ;



call print_message('t_LIST_ENUM. This scenario is a failure.');
create or replace function t_LIST_ENUM(variables_type string, return_type string, param_value LIST ) RETURN ENUM IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_ENUM('LIST', 'ENUM', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_ENUM('LIST', 'ENUM', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_ENUM ;



call print_message('t_ENUM_ENUM. This scenario is a failure.');
create or replace function t_ENUM_ENUM(variables_type string, return_type string, param_value ENUM ) RETURN ENUM IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_ENUM('ENUM', 'ENUM', 'yellow' ), 
 typeof( t_ENUM_ENUM('ENUM', 'ENUM', 'yellow' ) ) ;
drop function t_ENUM_ENUM ;



call print_message('t_BLOB_ENUM. This scenario is a failure.');
create or replace function t_BLOB_ENUM(variables_type string, return_type string, param_value BLOB ) RETURN ENUM IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_ENUM('BLOB', 'ENUM', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_ENUM('BLOB', 'ENUM', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_ENUM ;



call print_message('t_CLOB_ENUM. This scenario is a failure.');
create or replace function t_CLOB_ENUM(variables_type string, return_type string, param_value CLOB ) RETURN ENUM IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_ENUM('CLOB', 'ENUM', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_ENUM('CLOB', 'ENUM', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_ENUM ;



call print_message('t_JSON_ENUM. This scenario is a failure.');
create or replace function t_JSON_ENUM(variables_type string, return_type string, param_value JSON ) RETURN ENUM IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_ENUM('JSON', 'ENUM', '{"a":1}' ), 
 typeof( t_JSON_ENUM('JSON', 'ENUM', '{"a":1}' ) ) ;
drop function t_JSON_ENUM ;

drop procedure print_message;

--+ server-message off
