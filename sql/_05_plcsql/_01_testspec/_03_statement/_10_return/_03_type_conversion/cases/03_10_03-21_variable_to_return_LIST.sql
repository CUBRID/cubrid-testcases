--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_LIST. This scenario is a failure.');
create or replace function t_DATETIME_LIST(variables_type string, return_type string, param_value DATETIME ) RETURN LIST IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_LIST('DATETIME', 'LIST', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_LIST('DATETIME', 'LIST', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_LIST ;



call print_message('t_DATETIMELTZ_LIST. This scenario is a failure.');
create or replace function t_DATETIMELTZ_LIST(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN LIST IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_LIST('DATETIMELTZ', 'LIST', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_LIST('DATETIMELTZ', 'LIST', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_LIST ;



call print_message('t_DATETIMETZ_LIST. This scenario is a failure.');
create or replace function t_DATETIMETZ_LIST(variables_type string, return_type string, param_value DATETIMETZ ) RETURN LIST IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_LIST('DATETIMETZ', 'LIST', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_LIST('DATETIMETZ', 'LIST', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_LIST ;



call print_message('t_DATE_LIST. This scenario is a failure.');
create or replace function t_DATE_LIST(variables_type string, return_type string, param_value DATE ) RETURN LIST IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_LIST('DATE', 'LIST', DATE'2008-10-31' ), 
 typeof( t_DATE_LIST('DATE', 'LIST', DATE'2008-10-31' ) ) ;
drop function t_DATE_LIST ;



call print_message('t_TIME_LIST. This scenario is a failure.');
create or replace function t_TIME_LIST(variables_type string, return_type string, param_value TIME ) RETURN LIST IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_LIST('TIME', 'LIST', TIME'13:15:45' ), 
 typeof( t_TIME_LIST('TIME', 'LIST', TIME'13:15:45' ) ) ;
drop function t_TIME_LIST ;



call print_message('t_TIMESTAMP_LIST. This scenario is a failure.');
create or replace function t_TIMESTAMP_LIST(variables_type string, return_type string, param_value TIMESTAMP ) RETURN LIST IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_LIST('TIMESTAMP', 'LIST', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_LIST('TIMESTAMP', 'LIST', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_LIST ;



call print_message('t_TIMESTAMPLTZ_LIST. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_LIST(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN LIST IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_LIST('TIMESTAMPLTZ', 'LIST', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_LIST('TIMESTAMPLTZ', 'LIST', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_LIST ;



call print_message('t_TIMESTAMPTZ_LIST. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_LIST(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN LIST IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_LIST('TIMESTAMPTZ', 'LIST', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_LIST('TIMESTAMPTZ', 'LIST', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_LIST ;



call print_message('t_DOUBLE_LIST. This scenario is a failure.');
create or replace function t_DOUBLE_LIST(variables_type string, return_type string, param_value DOUBLE ) RETURN LIST IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_LIST('DOUBLE', 'LIST', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_LIST('DOUBLE', 'LIST', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_LIST ;



call print_message('t_FLOAT_LIST. This scenario is a failure.');
create or replace function t_FLOAT_LIST(variables_type string, return_type string, param_value FLOAT ) RETURN LIST IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_LIST('FLOAT', 'LIST', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_LIST('FLOAT', 'LIST', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_LIST ;



call print_message('t_NUMERIC(8,4)_LIST. This scenario is a failure.');
create or replace function t_NUMERIC_LIST(variables_type string, return_type string, param_value NUMERIC ) RETURN LIST IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_LIST('NUMERIC(8,4)', 'LIST', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_LIST('NUMERIC(8,4)', 'LIST', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_LIST ;



call print_message('t_BIGINT_LIST. This scenario is a failure.');
create or replace function t_BIGINT_LIST(variables_type string, return_type string, param_value BIGINT ) RETURN LIST IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_LIST('BIGINT', 'LIST', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_LIST('BIGINT', 'LIST', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_LIST ;



call print_message('t_INT_LIST. This scenario is a failure.');
create or replace function t_INT_LIST(variables_type string, return_type string, param_value INT ) RETURN LIST IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_LIST('INT', 'LIST', cast( 782346 as int ) ), 
 typeof( t_INT_LIST('INT', 'LIST', cast( 782346 as int ) ) ) ;
drop function t_INT_LIST ;



call print_message('t_SHORT_LIST. This scenario is a failure.');
create or replace function t_SHORT_LIST(variables_type string, return_type string, param_value SHORT ) RETURN LIST IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_LIST('SHORT', 'LIST', cast( 8934 as short ) ), 
 typeof( t_SHORT_LIST('SHORT', 'LIST', cast( 8934 as short ) ) ) ;
drop function t_SHORT_LIST ;



call print_message('t_BIT(8)_LIST. This scenario is a failure.');
create or replace function t_BIT_LIST(variables_type string, return_type string, param_value BIT ) RETURN LIST IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_LIST('BIT(8)', 'LIST', 0xaa ), 
 typeof( t_BIT_LIST('BIT(8)', 'LIST', 0xaa ) ) ;
drop function t_BIT_LIST ;



call print_message('t_BIT VARYING_LIST. This scenario is a failure.');
create or replace function t_BITVARYING_LIST(variables_type string, return_type string, param_value BITVARYING ) RETURN LIST IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_LIST('BIT VARYING', 'LIST', 0xaa ), 
 typeof( t_BITVARYING_LIST('BIT VARYING', 'LIST', 0xaa ) ) ;
drop function t_BITVARYING_LIST ;



call print_message('t_CHAR_LIST. This scenario is a failure.');
create or replace function t_CHAR_LIST(variables_type string, return_type string, param_value CHAR ) RETURN LIST IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_LIST('CHAR', 'LIST', {'c','c','c','b','b','a'} ), 
 typeof( t_CHAR_LIST('CHAR', 'LIST', {'c','c','c','b','b','a'} ) ) ;
drop function t_CHAR_LIST ;



call print_message('t_VARCHAR_LIST. This scenario is a failure.');
create or replace function t_VARCHAR_LIST(variables_type string, return_type string, param_value VARCHAR ) RETURN LIST IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_LIST('VARCHAR', 'LIST', {'c','c','c','b','b','a'} ), 
 typeof( t_VARCHAR_LIST('VARCHAR', 'LIST', {'c','c','c','b','b','a'} ) ) ;
drop function t_VARCHAR_LIST ;



call print_message('t_SET_LIST. This scenario is a failure.');
create or replace function t_SET_LIST(variables_type string, return_type string, param_value SET ) RETURN LIST IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_LIST('SET', 'LIST', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_LIST('SET', 'LIST', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_LIST ;



call print_message('t_MULTISET_LIST. This scenario is a failure.');
create or replace function t_MULTISET_LIST(variables_type string, return_type string, param_value MULTISET ) RETURN LIST IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_LIST('MULTISET', 'LIST', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_LIST('MULTISET', 'LIST', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_LIST ;



call print_message('t_LIST_LIST. This scenario is a failure.');
create or replace function t_LIST_LIST(variables_type string, return_type string, param_value LIST ) RETURN LIST IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_LIST('LIST', 'LIST', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_LIST('LIST', 'LIST', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_LIST ;



call print_message('t_ENUM_LIST. This scenario is a failure.');
create or replace function t_ENUM_LIST(variables_type string, return_type string, param_value ENUM ) RETURN LIST IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_LIST('ENUM', 'LIST', 'yellow' ), 
 typeof( t_ENUM_LIST('ENUM', 'LIST', 'yellow' ) ) ;
drop function t_ENUM_LIST ;



call print_message('t_BLOB_LIST. This scenario is a failure.');
create or replace function t_BLOB_LIST(variables_type string, return_type string, param_value BLOB ) RETURN LIST IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_LIST('BLOB', 'LIST', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_LIST('BLOB', 'LIST', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_LIST ;



call print_message('t_CLOB_LIST. This scenario is a failure.');
create or replace function t_CLOB_LIST(variables_type string, return_type string, param_value CLOB ) RETURN LIST IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_LIST('CLOB', 'LIST', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_LIST('CLOB', 'LIST', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_LIST ;



call print_message('t_JSON_LIST. This scenario is a failure.');
create or replace function t_JSON_LIST(variables_type string, return_type string, param_value JSON ) RETURN LIST IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_LIST('JSON', 'LIST', '{"a":1}' ), 
 typeof( t_JSON_LIST('JSON', 'LIST', '{"a":1}' ) ) ;
drop function t_JSON_LIST ;

drop procedure print_message;

--+ server-message off
