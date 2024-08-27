--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_CLOB. This scenario is a failure.');
create or replace function t_DATETIME_CLOB(variables_type string, return_type string, param_value DATETIME ) RETURN CLOB IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_CLOB('DATETIME', 'CLOB', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_CLOB('DATETIME', 'CLOB', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_CLOB ;



call print_message('t_DATETIMELTZ_CLOB. This scenario is a failure.');
create or replace function t_DATETIMELTZ_CLOB(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN CLOB IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_CLOB('DATETIMELTZ', 'CLOB', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_CLOB('DATETIMELTZ', 'CLOB', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_CLOB ;



call print_message('t_DATETIMETZ_CLOB. This scenario is a failure.');
create or replace function t_DATETIMETZ_CLOB(variables_type string, return_type string, param_value DATETIMETZ ) RETURN CLOB IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_CLOB('DATETIMETZ', 'CLOB', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_CLOB('DATETIMETZ', 'CLOB', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_CLOB ;



call print_message('t_DATE_CLOB. This scenario is a failure.');
create or replace function t_DATE_CLOB(variables_type string, return_type string, param_value DATE ) RETURN CLOB IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_CLOB('DATE', 'CLOB', DATE'2008-10-31' ), 
 typeof( t_DATE_CLOB('DATE', 'CLOB', DATE'2008-10-31' ) ) ;
drop function t_DATE_CLOB ;



call print_message('t_TIME_CLOB. This scenario is a failure.');
create or replace function t_TIME_CLOB(variables_type string, return_type string, param_value TIME ) RETURN CLOB IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_CLOB('TIME', 'CLOB', TIME'13:15:45' ), 
 typeof( t_TIME_CLOB('TIME', 'CLOB', TIME'13:15:45' ) ) ;
drop function t_TIME_CLOB ;



call print_message('t_TIMESTAMP_CLOB. This scenario is a failure.');
create or replace function t_TIMESTAMP_CLOB(variables_type string, return_type string, param_value TIMESTAMP ) RETURN CLOB IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_CLOB('TIMESTAMP', 'CLOB', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_CLOB('TIMESTAMP', 'CLOB', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_CLOB ;



call print_message('t_TIMESTAMPLTZ_CLOB. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_CLOB(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN CLOB IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_CLOB('TIMESTAMPLTZ', 'CLOB', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_CLOB('TIMESTAMPLTZ', 'CLOB', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_CLOB ;



call print_message('t_TIMESTAMPTZ_CLOB. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_CLOB(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN CLOB IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_CLOB('TIMESTAMPTZ', 'CLOB', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_CLOB('TIMESTAMPTZ', 'CLOB', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_CLOB ;



call print_message('t_DOUBLE_CLOB. This scenario is a failure.');
create or replace function t_DOUBLE_CLOB(variables_type string, return_type string, param_value DOUBLE ) RETURN CLOB IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_CLOB('DOUBLE', 'CLOB', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_CLOB('DOUBLE', 'CLOB', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_CLOB ;



call print_message('t_FLOAT_CLOB. This scenario is a failure.');
create or replace function t_FLOAT_CLOB(variables_type string, return_type string, param_value FLOAT ) RETURN CLOB IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_CLOB('FLOAT', 'CLOB', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_CLOB('FLOAT', 'CLOB', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_CLOB ;



call print_message('t_NUMERIC(8,4)_CLOB. This scenario is a failure.');
create or replace function t_NUMERIC_CLOB(variables_type string, return_type string, param_value NUMERIC ) RETURN CLOB IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_CLOB('NUMERIC(8,4)', 'CLOB', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_CLOB('NUMERIC(8,4)', 'CLOB', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_CLOB ;



call print_message('t_BIGINT_CLOB. This scenario is a failure.');
create or replace function t_BIGINT_CLOB(variables_type string, return_type string, param_value BIGINT ) RETURN CLOB IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_CLOB('BIGINT', 'CLOB', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_CLOB('BIGINT', 'CLOB', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_CLOB ;



call print_message('t_INT_CLOB. This scenario is a failure.');
create or replace function t_INT_CLOB(variables_type string, return_type string, param_value INT ) RETURN CLOB IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_CLOB('INT', 'CLOB', cast( 782346 as int ) ), 
 typeof( t_INT_CLOB('INT', 'CLOB', cast( 782346 as int ) ) ) ;
drop function t_INT_CLOB ;



call print_message('t_SHORT_CLOB. This scenario is a failure.');
create or replace function t_SHORT_CLOB(variables_type string, return_type string, param_value SHORT ) RETURN CLOB IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_CLOB('SHORT', 'CLOB', cast( 8934 as short ) ), 
 typeof( t_SHORT_CLOB('SHORT', 'CLOB', cast( 8934 as short ) ) ) ;
drop function t_SHORT_CLOB ;



call print_message('t_BIT(8)_CLOB. This scenario is a failure.');
create or replace function t_BIT_CLOB(variables_type string, return_type string, param_value BIT ) RETURN CLOB IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_CLOB('BIT(8)', 'CLOB', 0xaa ), 
 typeof( t_BIT_CLOB('BIT(8)', 'CLOB', 0xaa ) ) ;
drop function t_BIT_CLOB ;



call print_message('t_BIT VARYING_CLOB. This scenario is a failure.');
create or replace function t_BITVARYING_CLOB(variables_type string, return_type string, param_value BITVARYING ) RETURN CLOB IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_CLOB('BIT VARYING', 'CLOB', 0xaa ), 
 typeof( t_BITVARYING_CLOB('BIT VARYING', 'CLOB', 0xaa ) ) ;
drop function t_BITVARYING_CLOB ;



call print_message('t_CHAR_CLOB. This scenario is a failure.');
create or replace function t_CHAR_CLOB(variables_type string, return_type string, param_value CHAR ) RETURN CLOB IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_CLOB('CHAR', 'CLOB', 'CHAR CUBRID' ), 
 typeof( t_CHAR_CLOB('CHAR', 'CLOB', 'CHAR CUBRID' ) ) ;
drop function t_CHAR_CLOB ;



call print_message('t_VARCHAR_CLOB. This scenario is a failure.');
create or replace function t_VARCHAR_CLOB(variables_type string, return_type string, param_value VARCHAR ) RETURN CLOB IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_CLOB('VARCHAR', 'CLOB', 'VARCHAR CUBRID' ), 
 typeof( t_VARCHAR_CLOB('VARCHAR', 'CLOB', 'VARCHAR CUBRID' ) ) ;
drop function t_VARCHAR_CLOB ;



call print_message('t_SET_CLOB. This scenario is a failure.');
create or replace function t_SET_CLOB(variables_type string, return_type string, param_value SET ) RETURN CLOB IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_CLOB('SET', 'CLOB', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_CLOB('SET', 'CLOB', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_CLOB ;



call print_message('t_MULTISET_CLOB. This scenario is a failure.');
create or replace function t_MULTISET_CLOB(variables_type string, return_type string, param_value MULTISET ) RETURN CLOB IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_CLOB('MULTISET', 'CLOB', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_CLOB('MULTISET', 'CLOB', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_CLOB ;



call print_message('t_LIST_CLOB. This scenario is a failure.');
create or replace function t_LIST_CLOB(variables_type string, return_type string, param_value LIST ) RETURN CLOB IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_CLOB('LIST', 'CLOB', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_CLOB('LIST', 'CLOB', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_CLOB ;



call print_message('t_ENUM_CLOB. This scenario is a failure.');
create or replace function t_ENUM_CLOB(variables_type string, return_type string, param_value ENUM ) RETURN CLOB IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_CLOB('ENUM', 'CLOB', 'yellow' ), 
 typeof( t_ENUM_CLOB('ENUM', 'CLOB', 'yellow' ) ) ;
drop function t_ENUM_CLOB ;



call print_message('t_BLOB_CLOB. This scenario is a failure.');
create or replace function t_BLOB_CLOB(variables_type string, return_type string, param_value BLOB ) RETURN CLOB IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_CLOB('BLOB', 'CLOB', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_CLOB('BLOB', 'CLOB', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_CLOB ;



call print_message('t_CLOB_CLOB. This scenario is a failure.');
create or replace function t_CLOB_CLOB(variables_type string, return_type string, param_value CLOB ) RETURN CLOB IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_CLOB('CLOB', 'CLOB', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_CLOB('CLOB', 'CLOB', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_CLOB ;



call print_message('t_JSON_CLOB. This scenario is a failure.');
create or replace function t_JSON_CLOB(variables_type string, return_type string, param_value JSON ) RETURN CLOB IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_CLOB('JSON', 'CLOB', '{"a":1}' ), 
 typeof( t_JSON_CLOB('JSON', 'CLOB', '{"a":1}' ) ) ;
drop function t_JSON_CLOB ;

drop procedure print_message;

--+ server-message off
