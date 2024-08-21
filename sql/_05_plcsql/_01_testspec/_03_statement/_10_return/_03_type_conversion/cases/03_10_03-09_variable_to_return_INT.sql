--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_INT. This scenario is a failure.');
create or replace function t_DATETIME_INT(variables_type string, return_type string, param_value DATETIME ) RETURN INT IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_INT('DATETIME', 'INT', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_INT('DATETIME', 'INT', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_INT ;



call print_message('t_DATETIMELTZ_INT. This scenario is a failure.');
create or replace function t_DATETIMELTZ_INT(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN INT IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_INT('DATETIMELTZ', 'INT', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_INT('DATETIMELTZ', 'INT', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_INT ;



call print_message('t_DATETIMETZ_INT. This scenario is a failure.');
create or replace function t_DATETIMETZ_INT(variables_type string, return_type string, param_value DATETIMETZ ) RETURN INT IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_INT('DATETIMETZ', 'INT', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_INT('DATETIMETZ', 'INT', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_INT ;



call print_message('t_DATE_INT. This scenario is a failure.');
create or replace function t_DATE_INT(variables_type string, return_type string, param_value DATE ) RETURN INT IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_INT('DATE', 'INT', DATE'2008-10-31' ), 
 typeof( t_DATE_INT('DATE', 'INT', DATE'2008-10-31' ) ) ;
drop function t_DATE_INT ;



call print_message('t_TIME_INT. This scenario is a failure.');
create or replace function t_TIME_INT(variables_type string, return_type string, param_value TIME ) RETURN INT IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_INT('TIME', 'INT', TIME'13:15:45' ), 
 typeof( t_TIME_INT('TIME', 'INT', TIME'13:15:45' ) ) ;
drop function t_TIME_INT ;



call print_message('t_TIMESTAMP_INT. This scenario is a failure.');
create or replace function t_TIMESTAMP_INT(variables_type string, return_type string, param_value TIMESTAMP ) RETURN INT IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_INT('TIMESTAMP', 'INT', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_INT('TIMESTAMP', 'INT', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_INT ;



call print_message('t_TIMESTAMPLTZ_INT. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_INT(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN INT IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_INT('TIMESTAMPLTZ', 'INT', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_INT('TIMESTAMPLTZ', 'INT', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_INT ;



call print_message('t_TIMESTAMPTZ_INT. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_INT(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN INT IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_INT('TIMESTAMPTZ', 'INT', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_INT('TIMESTAMPTZ', 'INT', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_INT ;



call print_message('t_DOUBLE_INT. This scenario is a success.');
create or replace function t_DOUBLE_INT(variables_type string, return_type string, param_value DOUBLE ) RETURN INT IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_INT('DOUBLE', 'INT', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_INT('DOUBLE', 'INT', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_INT ;



call print_message('t_FLOAT_INT. This scenario is a success.');
create or replace function t_FLOAT_INT(variables_type string, return_type string, param_value FLOAT ) RETURN INT IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_INT('FLOAT', 'INT', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_INT('FLOAT', 'INT', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_INT ;



call print_message('t_NUMERIC_INT. This scenario is a success.');
create or replace function t_NUMERIC_INT(variables_type string, return_type string, param_value NUMERIC ) RETURN INT IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_INT('NUMERIC(8,4)', 'INT', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_INT('NUMERIC(8,4)', 'INT', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_INT ;



call print_message('t_BIGINT_INT. This scenario is a success.');
create or replace function t_BIGINT_INT(variables_type string, return_type string, param_value BIGINT ) RETURN INT IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_INT('BIGINT', 'INT', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_INT('BIGINT', 'INT', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_INT ;



call print_message('t_INT_INT. This scenario is a success.');
create or replace function t_INT_INT(variables_type string, return_type string, param_value INT ) RETURN INT IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_INT('INT', 'INT', cast( 782346 as int ) ), 
 typeof( t_INT_INT('INT', 'INT', cast( 782346 as int ) ) ) ;
drop function t_INT_INT ;



call print_message('t_SHORT_INT. This scenario is a success.');
create or replace function t_SHORT_INT(variables_type string, return_type string, param_value SHORT ) RETURN INT IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_INT('SHORT', 'INT', cast( 8934 as short ) ), 
 typeof( t_SHORT_INT('SHORT', 'INT', cast( 8934 as short ) ) ) ;
drop function t_SHORT_INT ;



call print_message('t_BIT(8)_INT. This scenario is a failure.');
create or replace function t_BIT_INT(variables_type string, return_type string, param_value BIT ) RETURN INT IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_INT('BIT(8)', 'INT', 0xaa ), 
 typeof( t_BIT_INT('BIT(8)', 'INT', 0xaa ) ) ;
drop function t_BIT_INT ;



call print_message('t_BIT VARYING_INT. This scenario is a failure.');
create or replace function t_BITVARYING_INT(variables_type string, return_type string, param_value BITVARYING ) RETURN INT IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_INT('BIT VARYING', 'INT', 0xaa ), 
 typeof( t_BITVARYING_INT('BIT VARYING', 'INT', 0xaa ) ) ;
drop function t_BITVARYING_INT ;



call print_message('t_CHAR_INT. This scenario is a success.');
create or replace function t_CHAR_INT(variables_type string, return_type string, param_value CHAR ) RETURN INT IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_INT('CHAR', 'INT', cast( '123' as char(3) ) ), 
 typeof( t_CHAR_INT('CHAR', 'INT', cast( '123' as char(3) ) ) ) ;
drop function t_CHAR_INT ;



call print_message('t_VARCHAR_INT. This scenario is a success.');
create or replace function t_VARCHAR_INT(variables_type string, return_type string, param_value VARCHAR ) RETURN INT IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_INT('VARCHAR', 'INT', cast('567' as varchar ) ), 
 typeof( t_VARCHAR_INT('VARCHAR', 'INT', cast('567' as varchar ) ) ) ;
drop function t_VARCHAR_INT ;



call print_message('t_SET_INT. This scenario is a failure.');
create or replace function t_SET_INT(variables_type string, return_type string, param_value SET ) RETURN INT IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_INT('SET', 'INT', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_INT('SET', 'INT', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_INT ;



call print_message('t_MULTISET_INT. This scenario is a failure.');
create or replace function t_MULTISET_INT(variables_type string, return_type string, param_value MULTISET ) RETURN INT IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_INT('MULTISET', 'INT', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_INT('MULTISET', 'INT', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_INT ;



call print_message('t_LIST_INT. This scenario is a failure.');
create or replace function t_LIST_INT(variables_type string, return_type string, param_value LIST ) RETURN INT IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_INT('LIST', 'INT', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_INT('LIST', 'INT', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_INT ;



call print_message('t_ENUM_INT. This scenario is a failure.');
create or replace function t_ENUM_INT(variables_type string, return_type string, param_value ENUM ) RETURN INT IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_INT('ENUM', 'INT', 'yellow' ), 
 typeof( t_ENUM_INT('ENUM', 'INT', 'yellow' ) ) ;
drop function t_ENUM_INT ;



call print_message('t_BLOB_INT. This scenario is a failure.');
create or replace function t_BLOB_INT(variables_type string, return_type string, param_value BLOB ) RETURN INT IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_INT('BLOB', 'INT', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_INT('BLOB', 'INT', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_INT ;



call print_message('t_CLOB_INT. This scenario is a failure.');
create or replace function t_CLOB_INT(variables_type string, return_type string, param_value CLOB ) RETURN INT IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_INT('CLOB', 'INT', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_INT('CLOB', 'INT', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_INT ;



call print_message('t_JSON_INT. This scenario is a failure.');
create or replace function t_JSON_INT(variables_type string, return_type string, param_value JSON ) RETURN INT IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_INT('JSON', 'INT', '{"a":1}' ), 
 typeof( t_JSON_INT('JSON', 'INT', '{"a":1}' ) ) ;
drop function t_JSON_INT ;

drop procedure print_message;

--+ server-message off
