--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_DATETIME_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_TIMESTAMPTZ('DATETIME', 'TIMESTAMPTZ', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_TIMESTAMPTZ ;


call print_message('t_DATETIMELTZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_TIMESTAMPTZ('DATETIMELTZ', 'TIMESTAMPTZ', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_TIMESTAMPTZ ;


call print_message('t_DATETIMETZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_TIMESTAMPTZ('DATETIMETZ', 'TIMESTAMPTZ', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_TIMESTAMPTZ ;


call print_message('t_DATE_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_DATE_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_TIMESTAMPTZ('DATE', 'TIMESTAMPTZ', DATE'2008-10-31' ) ;
drop procedure t_DATE_TIMESTAMPTZ ;


call print_message('t_TIME_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_TIME_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_TIMESTAMPTZ('TIME', 'TIMESTAMPTZ', TIME'13:15:45' ) ;
drop procedure t_TIME_TIMESTAMPTZ ;


call print_message('t_TIMESTAMP_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_TIMESTAMPTZ('TIMESTAMP', 'TIMESTAMPTZ', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_TIMESTAMPTZ ;


call print_message('t_TIMESTAMPLTZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_TIMESTAMPTZ('TIMESTAMPLTZ', 'TIMESTAMPTZ', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_TIMESTAMPTZ ;


call print_message('t_TIMESTAMPTZ_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_TIMESTAMPTZ('TIMESTAMPTZ', 'TIMESTAMPTZ', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_TIMESTAMPTZ ;


call print_message('t_DOUBLE_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_DOUBLE_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_TIMESTAMPTZ('DOUBLE', 'TIMESTAMPTZ', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_TIMESTAMPTZ ;


call print_message('t_FLOAT_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_FLOAT_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_TIMESTAMPTZ('FLOAT', 'TIMESTAMPTZ', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_TIMESTAMPTZ ;


call print_message('t_NUMERIC(8,4)_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_NUMERIC_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_TIMESTAMPTZ('NUMERIC(8,4)', 'TIMESTAMPTZ', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_TIMESTAMPTZ ;


call print_message('t_BIGINT_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_BIGINT_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_TIMESTAMPTZ('BIGINT', 'TIMESTAMPTZ', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_TIMESTAMPTZ ;


call print_message('t_INT_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_INT_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_TIMESTAMPTZ('INT', 'TIMESTAMPTZ', cast( 782346 as int ) ) ;
drop procedure t_INT_TIMESTAMPTZ ;


call print_message('t_SHORT_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_SHORT_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_TIMESTAMPTZ('SHORT', 'TIMESTAMPTZ', cast( 8934 as short ) ) ;
drop procedure t_SHORT_TIMESTAMPTZ ;


call print_message('t_BIT(8)_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_BIT_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_TIMESTAMPTZ('BIT(8)', 'TIMESTAMPTZ', 0xaa ) ;
drop procedure t_BIT_TIMESTAMPTZ ;


call print_message('t_BIT VARYING_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_BITVARYING_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_TIMESTAMPTZ('BIT VARYING', 'TIMESTAMPTZ', 0xaa ) ;
drop procedure t_BITVARYING_TIMESTAMPTZ ;


call print_message('t_CHAR_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_CHAR_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_TIMESTAMPTZ('CHAR', 'TIMESTAMPTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_TIMESTAMPTZ ;


call print_message('t_VARCHAR_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_VARCHAR_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_TIMESTAMPTZ('VARCHAR', 'TIMESTAMPTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_TIMESTAMPTZ ;


call print_message('t_SET_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_SET_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_TIMESTAMPTZ('SET', 'TIMESTAMPTZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_TIMESTAMPTZ ;


call print_message('t_MULTISET_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_MULTISET_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_TIMESTAMPTZ('MULTISET', 'TIMESTAMPTZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_TIMESTAMPTZ ;


call print_message('t_LIST_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_LIST_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_TIMESTAMPTZ('LIST', 'TIMESTAMPTZ', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_TIMESTAMPTZ ;


call print_message('t_ENUM_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_ENUM_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_TIMESTAMPTZ('ENUM', 'TIMESTAMPTZ', 'yellow' ) ;
drop procedure t_ENUM_TIMESTAMPTZ ;


call print_message('t_BLOB_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_BLOB_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_TIMESTAMPTZ('BLOB', 'TIMESTAMPTZ', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_TIMESTAMPTZ ;


call print_message('t_CLOB_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_CLOB_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_TIMESTAMPTZ('CLOB', 'TIMESTAMPTZ', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_TIMESTAMPTZ ;


call print_message('t_JSON_TIMESTAMPTZ. This scenario is a failure.');
create or replace procedure t_JSON_TIMESTAMPTZ(sql_type string, procedure_type string, param TIMESTAMPTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_TIMESTAMPTZ('JSON', 'TIMESTAMPTZ', '{"a":1}' ) ;
drop procedure t_JSON_TIMESTAMPTZ ;
drop procedure print_message;

--+ server-message off
