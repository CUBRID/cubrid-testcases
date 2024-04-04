--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_JSON. This scenario is a failure.');
create or replace procedure t_DATETIME_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_JSON('DATETIME', 'JSON', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_JSON ;


call print_message('t_DATETIMELTZ_JSON. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_JSON('DATETIMELTZ', 'JSON', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_JSON ;


call print_message('t_DATETIMETZ_JSON. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_JSON('DATETIMETZ', 'JSON', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_JSON ;


call print_message('t_DATE_JSON. This scenario is a failure.');
create or replace procedure t_DATE_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_JSON('DATE', 'JSON', DATE'2008-10-31' ) ;
drop procedure t_DATE_JSON ;


call print_message('t_TIME_JSON. This scenario is a failure.');
create or replace procedure t_TIME_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_JSON('TIME', 'JSON', TIME'13:15:45' ) ;
drop procedure t_TIME_JSON ;


call print_message('t_TIMESTAMP_JSON. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_JSON('TIMESTAMP', 'JSON', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_JSON ;


call print_message('t_TIMESTAMPLTZ_JSON. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_JSON('TIMESTAMPLTZ', 'JSON', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_JSON ;


call print_message('t_TIMESTAMPTZ_JSON. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_JSON('TIMESTAMPTZ', 'JSON', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_JSON ;


call print_message('t_DOUBLE_JSON. This scenario is a failure.');
create or replace procedure t_DOUBLE_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_JSON('DOUBLE', 'JSON', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_JSON ;


call print_message('t_FLOAT_JSON. This scenario is a failure.');
create or replace procedure t_FLOAT_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_JSON('FLOAT', 'JSON', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_JSON ;


call print_message('t_NUMERIC(8,4)_JSON. This scenario is a failure.');
create or replace procedure t_NUMERIC_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_JSON('NUMERIC(8,4)', 'JSON', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_JSON ;


call print_message('t_BIGINT_JSON. This scenario is a failure.');
create or replace procedure t_BIGINT_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_JSON('BIGINT', 'JSON', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_JSON ;


call print_message('t_INT_JSON. This scenario is a failure.');
create or replace procedure t_INT_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_JSON('INT', 'JSON', cast( 782346 as int ) ) ;
drop procedure t_INT_JSON ;


call print_message('t_SHORT_JSON. This scenario is a failure.');
create or replace procedure t_SHORT_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_JSON('SHORT', 'JSON', cast( 8934 as short ) ) ;
drop procedure t_SHORT_JSON ;


call print_message('t_BIT(8)_JSON. This scenario is a failure.');
create or replace procedure t_BIT_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_JSON('BIT(8)', 'JSON', 0xaa ) ;
drop procedure t_BIT_JSON ;


call print_message('t_BIT VARYING_JSON. This scenario is a failure.');
create or replace procedure t_BITVARYING_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_JSON('BIT VARYING', 'JSON', 0xaa ) ;
drop procedure t_BITVARYING_JSON ;


call print_message('t_CHAR_JSON. This scenario is a failure.');
create or replace procedure t_CHAR_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_JSON('CHAR', 'JSON', '{"a":1}' ) ;
drop procedure t_CHAR_JSON ;


call print_message('t_VARCHAR_JSON. This scenario is a failure.');
create or replace procedure t_VARCHAR_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_JSON('VARCHAR', 'JSON', '{"a":1}' ) ;
drop procedure t_VARCHAR_JSON ;


call print_message('t_SET_JSON. This scenario is a failure.');
create or replace procedure t_SET_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_JSON('SET', 'JSON', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_JSON ;


call print_message('t_MULTISET_JSON. This scenario is a failure.');
create or replace procedure t_MULTISET_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_JSON('MULTISET', 'JSON', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_JSON ;


call print_message('t_LIST_JSON. This scenario is a failure.');
create or replace procedure t_LIST_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_JSON('LIST', 'JSON', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_JSON ;


call print_message('t_ENUM_JSON. This scenario is a failure.');
create or replace procedure t_ENUM_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_JSON('ENUM', 'JSON', 'yellow' ) ;
drop procedure t_ENUM_JSON ;


call print_message('t_BLOB_JSON. This scenario is a failure.');
create or replace procedure t_BLOB_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_JSON('BLOB', 'JSON', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_JSON ;


call print_message('t_CLOB_JSON. This scenario is a failure.');
create or replace procedure t_CLOB_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_JSON('CLOB', 'JSON', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_JSON ;


call print_message('t_JSON_JSON. This scenario is a failure.');
create or replace procedure t_JSON_JSON(sql_type string, procedure_type string, param JSON ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_JSON('JSON', 'JSON', '{"a":1}' ) ;
drop procedure t_JSON_JSON ;
drop procedure print_message;

--+ server-message off
