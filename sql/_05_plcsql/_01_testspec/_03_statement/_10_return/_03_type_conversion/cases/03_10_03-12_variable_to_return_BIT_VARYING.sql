--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIT VARYING. This scenario is a failure.');
create or replace function t_DATETIME_BITVARYING(variables_type string, return_type string, param_value DATETIME ) RETURN BIT VARYING IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_BITVARYING('DATETIME', 'BIT VARYING', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_BITVARYING('DATETIME', 'BIT VARYING', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_BITVARYING ;



call print_message('t_DATETIMELTZ_BIT VARYING. This scenario is a failure.');
create or replace function t_DATETIMELTZ_BITVARYING(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN BIT VARYING IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_BITVARYING('DATETIMELTZ', 'BIT VARYING', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_BITVARYING('DATETIMELTZ', 'BIT VARYING', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_BITVARYING ;



call print_message('t_DATETIMETZ_BIT VARYING. This scenario is a failure.');
create or replace function t_DATETIMETZ_BITVARYING(variables_type string, return_type string, param_value DATETIMETZ ) RETURN BIT VARYING IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_BITVARYING('DATETIMETZ', 'BIT VARYING', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_BITVARYING('DATETIMETZ', 'BIT VARYING', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_BITVARYING ;



call print_message('t_DATE_BIT VARYING. This scenario is a failure.');
create or replace function t_DATE_BITVARYING(variables_type string, return_type string, param_value DATE ) RETURN BIT VARYING IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_BITVARYING('DATE', 'BIT VARYING', DATE'2008-10-31' ), 
 typeof( t_DATE_BITVARYING('DATE', 'BIT VARYING', DATE'2008-10-31' ) ) ;
drop function t_DATE_BITVARYING ;



call print_message('t_TIME_BIT VARYING. This scenario is a failure.');
create or replace function t_TIME_BITVARYING(variables_type string, return_type string, param_value TIME ) RETURN BIT VARYING IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_BITVARYING('TIME', 'BIT VARYING', TIME'13:15:45' ), 
 typeof( t_TIME_BITVARYING('TIME', 'BIT VARYING', TIME'13:15:45' ) ) ;
drop function t_TIME_BITVARYING ;



call print_message('t_TIMESTAMP_BIT VARYING. This scenario is a failure.');
create or replace function t_TIMESTAMP_BITVARYING(variables_type string, return_type string, param_value TIMESTAMP ) RETURN BIT VARYING IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_BITVARYING('TIMESTAMP', 'BIT VARYING', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_BITVARYING('TIMESTAMP', 'BIT VARYING', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_BITVARYING ;



call print_message('t_TIMESTAMPLTZ_BIT VARYING. This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_BITVARYING(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN BIT VARYING IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_BITVARYING('TIMESTAMPLTZ', 'BIT VARYING', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_BITVARYING('TIMESTAMPLTZ', 'BIT VARYING', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_BITVARYING ;



call print_message('t_TIMESTAMPTZ_BIT VARYING. This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_BITVARYING(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN BIT VARYING IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_BITVARYING('TIMESTAMPTZ', 'BIT VARYING', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_BITVARYING('TIMESTAMPTZ', 'BIT VARYING', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_BITVARYING ;



call print_message('t_DOUBLE_BIT VARYING. This scenario is a failure.');
create or replace function t_DOUBLE_BITVARYING(variables_type string, return_type string, param_value DOUBLE ) RETURN BIT VARYING IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_BITVARYING('DOUBLE', 'BIT VARYING', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_BITVARYING('DOUBLE', 'BIT VARYING', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_BITVARYING ;



call print_message('t_FLOAT_BIT VARYING. This scenario is a failure.');
create or replace function t_FLOAT_BITVARYING(variables_type string, return_type string, param_value FLOAT ) RETURN BIT VARYING IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_BITVARYING('FLOAT', 'BIT VARYING', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_BITVARYING('FLOAT', 'BIT VARYING', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_BITVARYING ;



call print_message('t_NUMERIC(8,4)_BIT VARYING. This scenario is a failure.');
create or replace function t_NUMERIC_BITVARYING(variables_type string, return_type string, param_value NUMERIC ) RETURN BIT VARYING IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_BITVARYING('NUMERIC(8,4)', 'BIT VARYING', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_BITVARYING('NUMERIC(8,4)', 'BIT VARYING', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_BITVARYING ;



call print_message('t_BIGINT_BIT VARYING. This scenario is a failure.');
create or replace function t_BIGINT_BITVARYING(variables_type string, return_type string, param_value BIGINT ) RETURN BIT VARYING IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_BITVARYING('BIGINT', 'BIT VARYING', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_BITVARYING('BIGINT', 'BIT VARYING', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_BITVARYING ;



call print_message('t_INT_BIT VARYING. This scenario is a failure.');
create or replace function t_INT_BITVARYING(variables_type string, return_type string, param_value INT ) RETURN BIT VARYING IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_BITVARYING('INT', 'BIT VARYING', cast( 782346 as int ) ), 
 typeof( t_INT_BITVARYING('INT', 'BIT VARYING', cast( 782346 as int ) ) ) ;
drop function t_INT_BITVARYING ;



call print_message('t_SHORT_BIT VARYING. This scenario is a failure.');
create or replace function t_SHORT_BITVARYING(variables_type string, return_type string, param_value SHORT ) RETURN BIT VARYING IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_BITVARYING('SHORT', 'BIT VARYING', cast( 8934 as short ) ), 
 typeof( t_SHORT_BITVARYING('SHORT', 'BIT VARYING', cast( 8934 as short ) ) ) ;
drop function t_SHORT_BITVARYING ;



call print_message('t_BIT(8)_BIT VARYING. This scenario is a failure.');
create or replace function t_BIT_BITVARYING(variables_type string, return_type string, param_value BIT ) RETURN BIT VARYING IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_BITVARYING('BIT(8)', 'BIT VARYING', 0xaa ), 
 typeof( t_BIT_BITVARYING('BIT(8)', 'BIT VARYING', 0xaa ) ) ;
drop function t_BIT_BITVARYING ;



call print_message('t_BIT VARYING_BIT VARYING. This scenario is a failure.');
create or replace function t_BITVARYING_BITVARYING(variables_type string, return_type string, param_value BITVARYING ) RETURN BIT VARYING IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_BITVARYING('BIT VARYING', 'BIT VARYING', 0xaa ), 
 typeof( t_BITVARYING_BITVARYING('BIT VARYING', 'BIT VARYING', 0xaa ) ) ;
drop function t_BITVARYING_BITVARYING ;



call print_message('t_CHAR_BIT VARYING. This scenario is a failure.');
create or replace function t_CHAR_BITVARYING(variables_type string, return_type string, param_value CHAR ) RETURN BIT VARYING IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_BITVARYING('CHAR', 'BIT VARYING', 0xaa ), 
 typeof( t_CHAR_BITVARYING('CHAR', 'BIT VARYING', 0xaa ) ) ;
drop function t_CHAR_BITVARYING ;



call print_message('t_VARCHAR_BIT VARYING. This scenario is a failure.');
create or replace function t_VARCHAR_BITVARYING(variables_type string, return_type string, param_value VARCHAR ) RETURN BIT VARYING IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_BITVARYING('VARCHAR', 'BIT VARYING', 0xaa ), 
 typeof( t_VARCHAR_BITVARYING('VARCHAR', 'BIT VARYING', 0xaa ) ) ;
drop function t_VARCHAR_BITVARYING ;



call print_message('t_SET_BIT VARYING. This scenario is a failure.');
create or replace function t_SET_BITVARYING(variables_type string, return_type string, param_value SET ) RETURN BIT VARYING IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_BITVARYING('SET', 'BIT VARYING', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_BITVARYING('SET', 'BIT VARYING', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_BITVARYING ;



call print_message('t_MULTISET_BIT VARYING. This scenario is a failure.');
create or replace function t_MULTISET_BITVARYING(variables_type string, return_type string, param_value MULTISET ) RETURN BIT VARYING IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_BITVARYING('MULTISET', 'BIT VARYING', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_BITVARYING('MULTISET', 'BIT VARYING', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_BITVARYING ;



call print_message('t_LIST_BIT VARYING. This scenario is a failure.');
create or replace function t_LIST_BITVARYING(variables_type string, return_type string, param_value LIST ) RETURN BIT VARYING IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_BITVARYING('LIST', 'BIT VARYING', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_BITVARYING('LIST', 'BIT VARYING', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_BITVARYING ;



call print_message('t_ENUM_BIT VARYING. This scenario is a failure.');
create or replace function t_ENUM_BITVARYING(variables_type string, return_type string, param_value ENUM ) RETURN BIT VARYING IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_BITVARYING('ENUM', 'BIT VARYING', 'yellow' ), 
 typeof( t_ENUM_BITVARYING('ENUM', 'BIT VARYING', 'yellow' ) ) ;
drop function t_ENUM_BITVARYING ;



call print_message('t_BLOB_BIT VARYING. This scenario is a failure.');
create or replace function t_BLOB_BITVARYING(variables_type string, return_type string, param_value BLOB ) RETURN BIT VARYING IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_BITVARYING('BLOB', 'BIT VARYING', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_BITVARYING('BLOB', 'BIT VARYING', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_BITVARYING ;



call print_message('t_CLOB_BIT VARYING. This scenario is a failure.');
create or replace function t_CLOB_BITVARYING(variables_type string, return_type string, param_value CLOB ) RETURN BIT VARYING IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_BITVARYING('CLOB', 'BIT VARYING', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_BITVARYING('CLOB', 'BIT VARYING', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_BITVARYING ;



call print_message('t_JSON_BIT VARYING. This scenario is a failure.');
create or replace function t_JSON_BITVARYING(variables_type string, return_type string, param_value JSON ) RETURN BIT VARYING IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_BITVARYING('JSON', 'BIT VARYING', '{"a":1}' ), 
 typeof( t_JSON_BITVARYING('JSON', 'BIT VARYING', '{"a":1}' ) ) ;
drop function t_JSON_BITVARYING ;

drop procedure print_message;

--+ server-message off
