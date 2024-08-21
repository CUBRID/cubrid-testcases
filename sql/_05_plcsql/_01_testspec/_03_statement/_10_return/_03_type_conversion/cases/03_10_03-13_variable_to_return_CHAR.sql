--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_CHAR. This scenario is a success.');
create or replace function t_DATETIME_CHAR(variables_type string, return_type string, param_value DATETIME ) RETURN CHAR(40) IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_CHAR('DATETIME', 'CHAR', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_CHAR('DATETIME', 'CHAR', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_CHAR ;



call print_message('t_DATETIMELTZ_CHAR. This scenario is a failure.');
create or replace function t_DATETIMELTZ_CHAR(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN CHAR(40) IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_CHAR('DATETIMELTZ', 'CHAR', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_CHAR('DATETIMELTZ', 'CHAR', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_CHAR ;



call print_message('t_DATETIMETZ_CHAR. This scenario is a failure.');
create or replace function t_DATETIMETZ_CHAR(variables_type string, return_type string, param_value DATETIMETZ ) RETURN CHAR(40) IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_CHAR('DATETIMETZ', 'CHAR', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_CHAR('DATETIMETZ', 'CHAR', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_CHAR ;



call print_message('t_DATE_CHAR. This scenario is a success.');
create or replace function t_DATE_CHAR(variables_type string, return_type string, param_value DATE ) RETURN CHAR(40) IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_CHAR('DATE', 'CHAR', DATE'2008-10-31' ), 
 typeof( t_DATE_CHAR('DATE', 'CHAR', DATE'2008-10-31' ) ) ;
drop function t_DATE_CHAR ;



call print_message('t_TIME_CHAR. This scenario is a success.');
create or replace function t_TIME_CHAR(variables_type string, return_type string, param_value TIME ) RETURN CHAR(40) IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_CHAR('TIME', 'CHAR', TIME'13:15:45' ), 
 typeof( t_TIME_CHAR('TIME', 'CHAR', TIME'13:15:45' ) ) ;
drop function t_TIME_CHAR ;



call print_message('t_TIMESTAMP_CHAR. This scenario is a success.');
create or replace function t_TIMESTAMP_CHAR(variables_type string, return_type string, param_value TIMESTAMP ) RETURN CHAR(40) IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_CHAR('TIMESTAMP', 'CHAR', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_CHAR('TIMESTAMP', 'CHAR', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_CHAR ;



call print_message('t_TIMESTAMPLTZ_CHAR. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_CHAR(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN CHAR(40) IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_CHAR('TIMESTAMPLTZ', 'CHAR', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_CHAR('TIMESTAMPLTZ', 'CHAR', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_CHAR ;



call print_message('t_TIMESTAMPTZ_CHAR. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_CHAR(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN CHAR(40) IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_CHAR('TIMESTAMPTZ', 'CHAR', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_CHAR('TIMESTAMPTZ', 'CHAR', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_CHAR ;



call print_message('t_DOUBLE_CHAR. This scenario is a success.');
create or replace function t_DOUBLE_CHAR(variables_type string, return_type string, param_value DOUBLE ) RETURN CHAR(40) IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_CHAR('DOUBLE', 'CHAR', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_CHAR('DOUBLE', 'CHAR', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_CHAR ;



call print_message('t_FLOAT_CHAR. This scenario is a success.');
create or replace function t_FLOAT_CHAR(variables_type string, return_type string, param_value FLOAT ) RETURN CHAR(40) IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_CHAR('FLOAT', 'CHAR', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_CHAR('FLOAT', 'CHAR', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_CHAR ;



call print_message('t_NUMERIC_CHAR. This scenario is a success.');
create or replace function t_NUMERIC_CHAR(variables_type string, return_type string, param_value NUMERIC ) RETURN CHAR(40) IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_CHAR('NUMERIC(8,4)', 'CHAR', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_CHAR('NUMERIC(8,4)', 'CHAR', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_CHAR ;



call print_message('t_BIGINT_CHAR. This scenario is a success.');
create or replace function t_BIGINT_CHAR(variables_type string, return_type string, param_value BIGINT ) RETURN CHAR(40) IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_CHAR('BIGINT', 'CHAR', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_CHAR('BIGINT', 'CHAR', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_CHAR ;



call print_message('t_INT_CHAR. This scenario is a success.');
create or replace function t_INT_CHAR(variables_type string, return_type string, param_value INT ) RETURN CHAR(40) IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_CHAR('INT', 'CHAR', cast( 782346 as int ) ), 
 typeof( t_INT_CHAR('INT', 'CHAR', cast( 782346 as int ) ) ) ;
drop function t_INT_CHAR ;



call print_message('t_SHORT_CHAR. This scenario is a success.');
create or replace function t_SHORT_CHAR(variables_type string, return_type string, param_value SHORT ) RETURN CHAR(40) IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_CHAR('SHORT', 'CHAR', cast( 8934 as short ) ), 
 typeof( t_SHORT_CHAR('SHORT', 'CHAR', cast( 8934 as short ) ) ) ;
drop function t_SHORT_CHAR ;



call print_message('t_BIT(8)_CHAR. This scenario is a failure.');
create or replace function t_BIT_CHAR(variables_type string, return_type string, param_value BIT ) RETURN CHAR(40) IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_CHAR('BIT(8)', 'CHAR', 0xaa ), 
 typeof( t_BIT_CHAR('BIT(8)', 'CHAR', 0xaa ) ) ;
drop function t_BIT_CHAR ;



call print_message('t_BIT VARYING_CHAR. This scenario is a failure.');
create or replace function t_BITVARYING_CHAR(variables_type string, return_type string, param_value BITVARYING ) RETURN CHAR(40) IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_CHAR('BIT VARYING', 'CHAR', 0xaa ), 
 typeof( t_BITVARYING_CHAR('BIT VARYING', 'CHAR', 0xaa ) ) ;
drop function t_BITVARYING_CHAR ;



call print_message('t_CHAR_CHAR. This scenario is a success.');
create or replace function t_CHAR_CHAR(variables_type string, return_type string, param_value CHAR ) RETURN CHAR(40) IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_CHAR('CHAR', 'CHAR', 'CHAR CUBRID' ), 
 typeof( t_CHAR_CHAR('CHAR', 'CHAR', 'CHAR CUBRID' ) ) ;
drop function t_CHAR_CHAR ;



call print_message('t_VARCHAR_CHAR. This scenario is a success.');
create or replace function t_VARCHAR_CHAR(variables_type string, return_type string, param_value VARCHAR ) RETURN CHAR(40) IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_CHAR('VARCHAR', 'CHAR', 'VARCHAR CUBRID' ), 
 typeof( t_VARCHAR_CHAR('VARCHAR', 'CHAR', 'VARCHAR CUBRID' ) ) ;
drop function t_VARCHAR_CHAR ;



call print_message('t_SET_CHAR. This scenario is a failure.');
create or replace function t_SET_CHAR(variables_type string, return_type string, param_value SET ) RETURN CHAR(40) IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_CHAR('SET', 'CHAR', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_CHAR('SET', 'CHAR', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_CHAR ;



call print_message('t_MULTISET_CHAR. This scenario is a failure.');
create or replace function t_MULTISET_CHAR(variables_type string, return_type string, param_value MULTISET ) RETURN CHAR(40) IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_CHAR('MULTISET', 'CHAR', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_CHAR('MULTISET', 'CHAR', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_CHAR ;



call print_message('t_LIST_CHAR. This scenario is a failure.');
create or replace function t_LIST_CHAR(variables_type string, return_type string, param_value LIST ) RETURN CHAR(40) IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_CHAR('LIST', 'CHAR', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_CHAR('LIST', 'CHAR', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_CHAR ;



call print_message('t_ENUM_CHAR. This scenario is a failure.');
create or replace function t_ENUM_CHAR(variables_type string, return_type string, param_value ENUM ) RETURN CHAR(40) IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_CHAR('ENUM', 'CHAR', 'yellow' ), 
 typeof( t_ENUM_CHAR('ENUM', 'CHAR', 'yellow' ) ) ;
drop function t_ENUM_CHAR ;



call print_message('t_BLOB_CHAR. This scenario is a failure.');
create or replace function t_BLOB_CHAR(variables_type string, return_type string, param_value BLOB ) RETURN CHAR(40) IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_CHAR('BLOB', 'CHAR', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_CHAR('BLOB', 'CHAR', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_CHAR ;



call print_message('t_CLOB_CHAR. This scenario is a failure.');
create or replace function t_CLOB_CHAR(variables_type string, return_type string, param_value CLOB ) RETURN CHAR(40) IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_CHAR('CLOB', 'CHAR', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_CHAR('CLOB', 'CHAR', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_CHAR ;



call print_message('t_JSON_CHAR. This scenario is a failure.');
create or replace function t_JSON_CHAR(variables_type string, return_type string, param_value JSON ) RETURN CHAR(40) IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_CHAR('JSON', 'CHAR', '{"a":1}' ), 
 typeof( t_JSON_CHAR('JSON', 'CHAR', '{"a":1}' ) ) ;
drop function t_JSON_CHAR ;

drop procedure print_message;

--+ server-message off
