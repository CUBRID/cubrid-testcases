--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_DATETIME_NUMERIC(variables_type string, return_type string, param_value DATETIME ) RETURN NUMERIC IS 
   VAR DATETIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIME_NUMERIC('DATETIME', 'NUMERIC(38,15)', DATETIME'2023-02-14 10:51:28.999' ), 
 typeof( t_DATETIME_NUMERIC('DATETIME', 'NUMERIC(38,15)', DATETIME'2023-02-14 10:51:28.999' ) ) ;
drop function t_DATETIME_NUMERIC ;



call print_message('t_DATETIMELTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_DATETIMELTZ_NUMERIC(variables_type string, return_type string, param_value DATETIMELTZ ) RETURN NUMERIC IS 
   VAR DATETIMELTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMELTZ_NUMERIC('DATETIMELTZ', 'NUMERIC(38,15)', datetimeltz '09/01/2009 01:10:10 pm' ), 
 typeof( t_DATETIMELTZ_NUMERIC('DATETIMELTZ', 'NUMERIC(38,15)', datetimeltz '09/01/2009 01:10:10 pm' ) ) ;
drop function t_DATETIMELTZ_NUMERIC ;



call print_message('t_DATETIMETZ_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_DATETIMETZ_NUMERIC(variables_type string, return_type string, param_value DATETIMETZ ) RETURN NUMERIC IS 
   VAR DATETIMETZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATETIMETZ_NUMERIC('DATETIMETZ', 'NUMERIC(38,15)', datetimetz '09/01/2008 02:20:20 pm' ), 
 typeof( t_DATETIMETZ_NUMERIC('DATETIMETZ', 'NUMERIC(38,15)', datetimetz '09/01/2008 02:20:20 pm' ) ) ;
drop function t_DATETIMETZ_NUMERIC ;



call print_message('t_DATE_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_DATE_NUMERIC(variables_type string, return_type string, param_value DATE ) RETURN NUMERIC IS 
   VAR DATE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DATE_NUMERIC('DATE', 'NUMERIC(38,15)', DATE'2008-10-31' ), 
 typeof( t_DATE_NUMERIC('DATE', 'NUMERIC(38,15)', DATE'2008-10-31' ) ) ;
drop function t_DATE_NUMERIC ;



call print_message('t_TIME_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_TIME_NUMERIC(variables_type string, return_type string, param_value TIME ) RETURN NUMERIC IS 
   VAR TIME  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIME_NUMERIC('TIME', 'NUMERIC(38,15)', TIME'13:15:45' ), 
 typeof( t_TIME_NUMERIC('TIME', 'NUMERIC(38,15)', TIME'13:15:45' ) ) ;
drop function t_TIME_NUMERIC ;



call print_message('t_TIMESTAMP_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_TIMESTAMP_NUMERIC(variables_type string, return_type string, param_value TIMESTAMP ) RETURN NUMERIC IS 
   VAR TIMESTAMP  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMP_NUMERIC('TIMESTAMP', 'NUMERIC(38,15)', TIMESTAMP'2023-10-31 13:15:45' ), 
 typeof( t_TIMESTAMP_NUMERIC('TIMESTAMP', 'NUMERIC(38,15)', TIMESTAMP'2023-10-31 13:15:45' ) ) ;
drop function t_TIMESTAMP_NUMERIC ;



call print_message('t_TIMESTAMPLTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_TIMESTAMPLTZ_NUMERIC(variables_type string, return_type string, param_value TIMESTAMPLTZ ) RETURN NUMERIC IS 
   VAR TIMESTAMPLTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPLTZ_NUMERIC('TIMESTAMPLTZ', 'NUMERIC(38,15)', timestamptz '09/01/2007 03:30:30 pm' ), 
 typeof( t_TIMESTAMPLTZ_NUMERIC('TIMESTAMPLTZ', 'NUMERIC(38,15)', timestamptz '09/01/2007 03:30:30 pm' ) ) ;
drop function t_TIMESTAMPLTZ_NUMERIC ;



call print_message('t_TIMESTAMPTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_TIMESTAMPTZ_NUMERIC(variables_type string, return_type string, param_value TIMESTAMPTZ ) RETURN NUMERIC IS 
   VAR TIMESTAMPTZ  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_TIMESTAMPTZ_NUMERIC('TIMESTAMPTZ', 'NUMERIC(38,15)', timestamptz '09/01/2006 04:40:40 pm' ), 
 typeof( t_TIMESTAMPTZ_NUMERIC('TIMESTAMPTZ', 'NUMERIC(38,15)', timestamptz '09/01/2006 04:40:40 pm' ) ) ;
drop function t_TIMESTAMPTZ_NUMERIC ;



call print_message('t_DOUBLE_NUMERIC. This scenario is a success.');
create or replace function t_DOUBLE_NUMERIC(variables_type string, return_type string, param_value DOUBLE ) RETURN NUMERIC IS 
   VAR DOUBLE  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_DOUBLE_NUMERIC('DOUBLE', 'NUMERIC(38,15)', cast( 1234.56789 as double) ), 
 typeof( t_DOUBLE_NUMERIC('DOUBLE', 'NUMERIC(38,15)', cast( 1234.56789 as double) ) ) ;
drop function t_DOUBLE_NUMERIC ;



call print_message('t_FLOAT_NUMERIC. This scenario is a success.');
create or replace function t_FLOAT_NUMERIC(variables_type string, return_type string, param_value FLOAT ) RETURN NUMERIC IS 
   VAR FLOAT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_FLOAT_NUMERIC('FLOAT', 'NUMERIC(38,15)', cast( 16777.217 as float ) ), 
 typeof( t_FLOAT_NUMERIC('FLOAT', 'NUMERIC(38,15)', cast( 16777.217 as float ) ) ) ;
drop function t_FLOAT_NUMERIC ;



call print_message('t_NUMERIC_NUMERIC. This scenario is a success.');
create or replace function t_NUMERIC_NUMERIC(variables_type string, return_type string, param_value NUMERIC ) RETURN NUMERIC IS 
   VAR NUMERIC(8,4)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_NUMERIC_NUMERIC('NUMERIC(8,4)', 'NUMERIC(38,15)', cast( 0.123456789 as numeric(4,4) ) ), 
 typeof( t_NUMERIC_NUMERIC('NUMERIC(8,4)', 'NUMERIC(38,15)', cast( 0.123456789 as numeric(4,4) ) ) ) ;
drop function t_NUMERIC_NUMERIC ;



call print_message('t_BIGINT_NUMERIC. This scenario is a success.');
create or replace function t_BIGINT_NUMERIC(variables_type string, return_type string, param_value BIGINT ) RETURN NUMERIC IS 
   VAR BIGINT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIGINT_NUMERIC('BIGINT', 'NUMERIC(38,15)', cast( 34589012 as bigint ) ), 
 typeof( t_BIGINT_NUMERIC('BIGINT', 'NUMERIC(38,15)', cast( 34589012 as bigint ) ) ) ;
drop function t_BIGINT_NUMERIC ;



call print_message('t_INT_NUMERIC. This scenario is a success.');
create or replace function t_INT_NUMERIC(variables_type string, return_type string, param_value INT ) RETURN NUMERIC IS 
   VAR INT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_INT_NUMERIC('INT', 'NUMERIC(38,15)', cast( 782346 as int ) ), 
 typeof( t_INT_NUMERIC('INT', 'NUMERIC(38,15)', cast( 782346 as int ) ) ) ;
drop function t_INT_NUMERIC ;



call print_message('t_SHORT_NUMERIC. This scenario is a success.');
create or replace function t_SHORT_NUMERIC(variables_type string, return_type string, param_value SHORT ) RETURN NUMERIC IS 
   VAR SHORT  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SHORT_NUMERIC('SHORT', 'NUMERIC(38,15)', cast( 8934 as short ) ), 
 typeof( t_SHORT_NUMERIC('SHORT', 'NUMERIC(38,15)', cast( 8934 as short ) ) ) ;
drop function t_SHORT_NUMERIC ;



call print_message('t_BIT(8)_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_BIT_NUMERIC(variables_type string, return_type string, param_value BIT ) RETURN NUMERIC IS 
   VAR BIT(8)  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BIT_NUMERIC('BIT(8)', 'NUMERIC(38,15)', 0xaa ), 
 typeof( t_BIT_NUMERIC('BIT(8)', 'NUMERIC(38,15)', 0xaa ) ) ;
drop function t_BIT_NUMERIC ;



call print_message('t_BIT VARYING_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_BITVARYING_NUMERIC(variables_type string, return_type string, param_value BITVARYING ) RETURN NUMERIC IS 
   VAR BIT VARYING  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BITVARYING_NUMERIC('BIT VARYING', 'NUMERIC(38,15)', 0xaa ), 
 typeof( t_BITVARYING_NUMERIC('BIT VARYING', 'NUMERIC(38,15)', 0xaa ) ) ;
drop function t_BITVARYING_NUMERIC ;



call print_message('t_CHAR_NUMERIC. This scenario is a success.');
create or replace function t_CHAR_NUMERIC(variables_type string, return_type string, param_value CHAR ) RETURN NUMERIC IS 
   VAR CHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CHAR_NUMERIC('CHAR', 'NUMERIC(38,15)', cast( '123' as char(3) ) ), 
 typeof( t_CHAR_NUMERIC('CHAR', 'NUMERIC(38,15)', cast( '123' as char(3) ) ) ) ;
drop function t_CHAR_NUMERIC ;



call print_message('t_VARCHAR_NUMERIC. This scenario is a success.');
create or replace function t_VARCHAR_NUMERIC(variables_type string, return_type string, param_value VARCHAR ) RETURN NUMERIC IS 
   VAR VARCHAR  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_VARCHAR_NUMERIC('VARCHAR', 'NUMERIC(38,15)', cast('567' as varchar ) ), 
 typeof( t_VARCHAR_NUMERIC('VARCHAR', 'NUMERIC(38,15)', cast('567' as varchar ) ) ) ;
drop function t_VARCHAR_NUMERIC ;



call print_message('t_SET_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_SET_NUMERIC(variables_type string, return_type string, param_value SET ) RETURN NUMERIC IS 
   VAR SET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_SET_NUMERIC('SET', 'NUMERIC(38,15)', {'c','c','c','b','b','a'} ), 
 typeof( t_SET_NUMERIC('SET', 'NUMERIC(38,15)', {'c','c','c','b','b','a'} ) ) ;
drop function t_SET_NUMERIC ;



call print_message('t_MULTISET_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_MULTISET_NUMERIC(variables_type string, return_type string, param_value MULTISET ) RETURN NUMERIC IS 
   VAR MULTISET  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_MULTISET_NUMERIC('MULTISET', 'NUMERIC(38,15)', {'c','c','c','b','b','a'} ), 
 typeof( t_MULTISET_NUMERIC('MULTISET', 'NUMERIC(38,15)', {'c','c','c','b','b','a'} ) ) ;
drop function t_MULTISET_NUMERIC ;



call print_message('t_LIST_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_LIST_NUMERIC(variables_type string, return_type string, param_value LIST ) RETURN NUMERIC IS 
   VAR LIST  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_LIST_NUMERIC('LIST', 'NUMERIC(38,15)', {'c','c','c','b','b', 'a'} ), 
 typeof( t_LIST_NUMERIC('LIST', 'NUMERIC(38,15)', {'c','c','c','b','b', 'a'} ) ) ;
drop function t_LIST_NUMERIC ;



call print_message('t_ENUM_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_ENUM_NUMERIC(variables_type string, return_type string, param_value ENUM ) RETURN NUMERIC IS 
   VAR ENUM  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_ENUM_NUMERIC('ENUM', 'NUMERIC(38,15)', 'yellow' ), 
 typeof( t_ENUM_NUMERIC('ENUM', 'NUMERIC(38,15)', 'yellow' ) ) ;
drop function t_ENUM_NUMERIC ;



call print_message('t_BLOB_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_BLOB_NUMERIC(variables_type string, return_type string, param_value BLOB ) RETURN NUMERIC IS 
   VAR BLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_BLOB_NUMERIC('BLOB', 'NUMERIC(38,15)', BIT_TO_BLOB(X'000010') ), 
 typeof( t_BLOB_NUMERIC('BLOB', 'NUMERIC(38,15)', BIT_TO_BLOB(X'000010') ) ) ;
drop function t_BLOB_NUMERIC ;



call print_message('t_CLOB_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_CLOB_NUMERIC(variables_type string, return_type string, param_value CLOB ) RETURN NUMERIC IS 
   VAR CLOB  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_CLOB_NUMERIC('CLOB', 'NUMERIC(38,15)', CHAR_TO_CLOB('This is a Dog') ), 
 typeof( t_CLOB_NUMERIC('CLOB', 'NUMERIC(38,15)', CHAR_TO_CLOB('This is a Dog') ) ) ;
drop function t_CLOB_NUMERIC ;



call print_message('t_JSON_NUMERIC(38,15). This scenario is a failure.');
create or replace function t_JSON_NUMERIC(variables_type string, return_type string, param_value JSON ) RETURN NUMERIC IS 
   VAR JSON  ;
begin
   VAR := param_value ;
        dbms_output.put_line('variables_type = ' ||variables_type ||', return_type = '||return_type||', param_value(variable value) = '|| VAR ); 
    
   RETURN VAR ; 
end;
select  t_JSON_NUMERIC('JSON', 'NUMERIC(38,15)', '{"a":1}' ), 
 typeof( t_JSON_NUMERIC('JSON', 'NUMERIC(38,15)', '{"a":1}' ) ) ;
drop function t_JSON_NUMERIC ;

drop procedure print_message;

--+ server-message off
