--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIGINT. This scenario is a failure.');
create or replace function t_DATETIME_BIGINT(variables_type string, return_type string, param_value DATETIME ) RETURN BIGINT IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_BIGINT('DATETIME', 'BIGINT', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_BIGINT('DATETIME', 'BIGINT', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_BIGINT ;



call print_message('t_DATETIMELTZ_BIGINT. This scenario is a failure.');
create or replace function t_DATETIMELTZ_BIGINT(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN BIGINT IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_BIGINT('DATETIMELTZ', 'BIGINT', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_BIGINT('DATETIMELTZ', 'BIGINT', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_BIGINT ;



call print_message('t_DATETIMETZ_BIGINT. This scenario is a failure.');
create or replace function t_DATETIMETZ_BIGINT(variables_type string, return_type string, param_value DATETIMETZ ) RETURN BIGINT IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_BIGINT('DATETIMETZ', 'BIGINT', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_BIGINT('DATETIMETZ', 'BIGINT', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_BIGINT ;



call print_message('t_DATE_BIGINT. This scenario is a failure.');
create or replace function t_DATE_BIGINT(variables_type string, return_type string, param_value DATE ) RETURN BIGINT IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_BIGINT('DATE', 'BIGINT', DATE'2008-10-31' ), 
 typeof( t_DATE_BIGINT('DATE', 'BIGINT', DATE'2008-10-31' ) ) ;
drop function t_DATE_BIGINT ;



call print_message('t_TIME_BIGINT. This scenario is a failure.');
create or replace function t_TIME_BIGINT(variables_type string, return_type string, param_value TIME ) RETURN BIGINT IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_BIGINT('TIME', 'BIGINT', TIME'13:15:45' ), 
 typeof( t_TIME_BIGINT('TIME', 'BIGINT', TIME'13:15:45' ) ) ;
drop function t_TIME_BIGINT ;



call print_message('t_TIMESTAMP_BIGINT. This scenario is a failure.');
create or replace function t_TIMESTAMP_BIGINT(variables_type string, return_type string, param_value TIMESTAMP ) RETURN BIGINT IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_BIGINT('TIMESTAMP', 'BIGINT', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_BIGINT('TIMESTAMP', 'BIGINT', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_BIGINT ;



call print_message('t_TIMESTAMPLTZ_BIGINT. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_BIGINT(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN BIGINT IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_BIGINT('TIMESTAMPLTZ', 'BIGINT', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_BIGINT('TIMESTAMPLTZ', 'BIGINT', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_BIGINT ;



call print_message('t_TIMESTAMPTZ_BIGINT. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_BIGINT(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN BIGINT IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_BIGINT('TIMESTAMPTZ', 'BIGINT', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_BIGINT('TIMESTAMPTZ', 'BIGINT', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_BIGINT ;



call print_message('t_DOUBLE_BIGINT. This scenario is a success.');
create or replace function t_DOUBLE_BIGINT(variables_type string, return_type string, param_value DOUBLE ) RETURN BIGINT IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_BIGINT('DOUBLE', 'BIGINT', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_BIGINT('DOUBLE', 'BIGINT', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_BIGINT ;



call print_message('t_FLOAT_BIGINT. This scenario is a success.');
create or replace function t_FLOAT_BIGINT(variables_type string, return_type string, param_value FLOAT ) RETURN BIGINT IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_BIGINT('FLOAT', 'BIGINT', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_BIGINT('FLOAT', 'BIGINT', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_BIGINT ;



call print_message('t_NUMERIC_BIGINT. This scenario is a success.');
create or replace function t_NUMERIC_BIGINT(variables_type string, return_type string, param_value NUMERIC ) RETURN BIGINT IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_BIGINT('NUMERIC(8,4)', 'BIGINT', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_BIGINT('NUMERIC(8,4)', 'BIGINT', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_BIGINT ;



call print_message('t_BIGINT_BIGINT. This scenario is a success.');
create or replace function t_BIGINT_BIGINT(variables_type string, return_type string, param_value BIGINT ) RETURN BIGINT IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_BIGINT('BIGINT', 'BIGINT', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_BIGINT('BIGINT', 'BIGINT', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_BIGINT ;



call print_message('t_INT_BIGINT. This scenario is a success.');
create or replace function t_INT_BIGINT(variables_type string, return_type string, param_value INT ) RETURN BIGINT IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_BIGINT('INT', 'BIGINT', cast( 782346 as int ) ), 
 typeof( t_INT_BIGINT('INT', 'BIGINT', cast( 782346 as int ) ) ) ;
drop function t_INT_BIGINT ;



call print_message('t_SHORT_BIGINT. This scenario is a success.');
create or replace function t_SHORT_BIGINT(variables_type string, return_type string, param_value SHORT ) RETURN BIGINT IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_BIGINT('SHORT', 'BIGINT', cast( 8934 as short ) ), 
 typeof( t_SHORT_BIGINT('SHORT', 'BIGINT', cast( 8934 as short ) ) ) ;
drop function t_SHORT_BIGINT ;



call print_message('t_BIT(8)_BIGINT. This scenario is a failure.');
create or replace function t_BIT_BIGINT(variables_type string, return_type string, param_value BIT ) RETURN BIGINT IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_BIGINT('BIT(8)', 'BIGINT', 0xaa ), 
 typeof( t_BIT_BIGINT('BIT(8)', 'BIGINT', 0xaa ) ) ;
drop function t_BIT_BIGINT ;



call print_message('t_BIT VARYING_BIGINT. This scenario is a failure.');
create or replace function t_BITVARYING_BIGINT(variables_type string, return_type string, param_value BITVARYING ) RETURN BIGINT IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_BIGINT('BIT VARYING', 'BIGINT', 0xaa ), 
 typeof( t_BITVARYING_BIGINT('BIT VARYING', 'BIGINT', 0xaa ) ) ;
drop function t_BITVARYING_BIGINT ;



call print_message('t_CHAR_BIGINT. This scenario is a success.');
create or replace function t_CHAR_BIGINT(variables_type string, return_type string, param_value CHAR ) RETURN BIGINT IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_BIGINT('CHAR', 'BIGINT', cast( '123' as char(3) ) ), 
 typeof( t_CHAR_BIGINT('CHAR', 'BIGINT', cast( '123' as char(3) ) ) ) ;
drop function t_CHAR_BIGINT ;



call print_message('t_VARCHAR_BIGINT. This scenario is a success.');
create or replace function t_VARCHAR_BIGINT(variables_type string, return_type string, param_value VARCHAR ) RETURN BIGINT IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_BIGINT('VARCHAR', 'BIGINT', cast('567' as varchar ) ), 
 typeof( t_VARCHAR_BIGINT('VARCHAR', 'BIGINT', cast('567' as varchar ) ) ) ;
drop function t_VARCHAR_BIGINT ;



call print_message('t_SET_BIGINT. This scenario is a failure.');
create or replace function t_SET_BIGINT(variables_type string, return_type string, param_value SET ) RETURN BIGINT IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_BIGINT('SET', 'BIGINT', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_BIGINT('SET', 'BIGINT', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_BIGINT ;



call print_message('t_MULTISET_BIGINT. This scenario is a failure.');
create or replace function t_MULTISET_BIGINT(variables_type string, return_type string, param_value MULTISET ) RETURN BIGINT IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_BIGINT('MULTISET', 'BIGINT', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_BIGINT('MULTISET', 'BIGINT', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_BIGINT ;



call print_message('t_LIST_BIGINT. This scenario is a failure.');
create or replace function t_LIST_BIGINT(variables_type string, return_type string, param_value LIST ) RETURN BIGINT IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_BIGINT('LIST', 'BIGINT', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_BIGINT('LIST', 'BIGINT', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_BIGINT ;



call print_message('t_ENUM_BIGINT. This scenario is a failure.');
create or replace function t_ENUM_BIGINT(variables_type string, return_type string, param_value ENUM ) RETURN BIGINT IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_BIGINT('ENUM', 'BIGINT', 'yellow' ), 
 typeof( t_ENUM_BIGINT('ENUM', 'BIGINT', 'yellow' ) ) ;
drop function t_ENUM_BIGINT ;



call print_message('t_BLOB_BIGINT. This scenario is a failure.');
create or replace function t_BLOB_BIGINT(variables_type string, return_type string, param_value BLOB ) RETURN BIGINT IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_BIGINT('BLOB', 'BIGINT', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_BIGINT('BLOB', 'BIGINT', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_BIGINT ;



call print_message('t_CLOB_BIGINT. This scenario is a failure.');
create or replace function t_CLOB_BIGINT(variables_type string, return_type string, param_value CLOB ) RETURN BIGINT IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_BIGINT('CLOB', 'BIGINT', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_BIGINT('CLOB', 'BIGINT', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_BIGINT ;



call print_message('t_JSON_BIGINT. This scenario is a failure.');
create or replace function t_JSON_BIGINT(variables_type string, return_type string, param_value JSON ) RETURN BIGINT IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_BIGINT('JSON', 'BIGINT', '{"a":1}' ), 
 typeof( t_JSON_BIGINT('JSON', 'BIGINT', '{"a":1}' ) ) ;
drop function t_JSON_BIGINT ;

drop procedure print_message;

--+ server-message off
