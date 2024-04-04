--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_DATETIME_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_TIMESTAMPLTZ('DATETIME', 'TIMESTAMPLTZ', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_TIMESTAMPLTZ ;


call print_message('t_DATETIMELTZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_TIMESTAMPLTZ('DATETIMELTZ', 'TIMESTAMPLTZ', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_TIMESTAMPLTZ ;


call print_message('t_DATETIMETZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_TIMESTAMPLTZ('DATETIMETZ', 'TIMESTAMPLTZ', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_TIMESTAMPLTZ ;


call print_message('t_DATE_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_DATE_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_TIMESTAMPLTZ('DATE', 'TIMESTAMPLTZ', DATE'2008-10-31' ) ;
drop procedure t_DATE_TIMESTAMPLTZ ;


call print_message('t_TIME_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_TIME_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_TIMESTAMPLTZ('TIME', 'TIMESTAMPLTZ', TIME'13:15:45' ) ;
drop procedure t_TIME_TIMESTAMPLTZ ;


call print_message('t_TIMESTAMP_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_TIMESTAMPLTZ('TIMESTAMP', 'TIMESTAMPLTZ', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_TIMESTAMPLTZ ;


call print_message('t_TIMESTAMPLTZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_TIMESTAMPLTZ('TIMESTAMPLTZ', 'TIMESTAMPLTZ', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_TIMESTAMPLTZ ;


call print_message('t_TIMESTAMPTZ_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_TIMESTAMPLTZ('TIMESTAMPTZ', 'TIMESTAMPLTZ', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_TIMESTAMPLTZ ;


call print_message('t_DOUBLE_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_DOUBLE_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_TIMESTAMPLTZ('DOUBLE', 'TIMESTAMPLTZ', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_TIMESTAMPLTZ ;


call print_message('t_FLOAT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_FLOAT_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_TIMESTAMPLTZ('FLOAT', 'TIMESTAMPLTZ', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_TIMESTAMPLTZ ;


call print_message('t_NUMERIC(8,4)_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_NUMERIC_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_TIMESTAMPLTZ('NUMERIC(8,4)', 'TIMESTAMPLTZ', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_TIMESTAMPLTZ ;


call print_message('t_BIGINT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_BIGINT_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_TIMESTAMPLTZ('BIGINT', 'TIMESTAMPLTZ', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_TIMESTAMPLTZ ;


call print_message('t_INT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_INT_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_TIMESTAMPLTZ('INT', 'TIMESTAMPLTZ', cast( 782346 as int ) ) ;
drop procedure t_INT_TIMESTAMPLTZ ;


call print_message('t_SHORT_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_SHORT_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_TIMESTAMPLTZ('SHORT', 'TIMESTAMPLTZ', cast( 8934 as short ) ) ;
drop procedure t_SHORT_TIMESTAMPLTZ ;


call print_message('t_BIT(8)_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_BIT_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_TIMESTAMPLTZ('BIT(8)', 'TIMESTAMPLTZ', 0xaa ) ;
drop procedure t_BIT_TIMESTAMPLTZ ;


call print_message('t_BIT VARYING_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_BITVARYING_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_TIMESTAMPLTZ('BIT VARYING', 'TIMESTAMPLTZ', 0xaa ) ;
drop procedure t_BITVARYING_TIMESTAMPLTZ ;


call print_message('t_CHAR_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_CHAR_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_TIMESTAMPLTZ('CHAR', 'TIMESTAMPLTZ', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_TIMESTAMPLTZ ;


call print_message('t_VARCHAR_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_VARCHAR_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_TIMESTAMPLTZ('VARCHAR', 'TIMESTAMPLTZ', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_TIMESTAMPLTZ ;


call print_message('t_SET_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_SET_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_TIMESTAMPLTZ('SET', 'TIMESTAMPLTZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_TIMESTAMPLTZ ;


call print_message('t_MULTISET_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_MULTISET_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_TIMESTAMPLTZ('MULTISET', 'TIMESTAMPLTZ', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_TIMESTAMPLTZ ;


call print_message('t_LIST_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_LIST_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_TIMESTAMPLTZ('LIST', 'TIMESTAMPLTZ', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_TIMESTAMPLTZ ;


call print_message('t_ENUM_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_ENUM_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_TIMESTAMPLTZ('ENUM', 'TIMESTAMPLTZ', 'yellow' ) ;
drop procedure t_ENUM_TIMESTAMPLTZ ;


call print_message('t_BLOB_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_BLOB_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_TIMESTAMPLTZ('BLOB', 'TIMESTAMPLTZ', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_TIMESTAMPLTZ ;


call print_message('t_CLOB_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_CLOB_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_TIMESTAMPLTZ('CLOB', 'TIMESTAMPLTZ', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_TIMESTAMPLTZ ;


call print_message('t_JSON_TIMESTAMPLTZ. This scenario is a failure.');
create or replace procedure t_JSON_TIMESTAMPLTZ(sql_type string, procedure_type string, param TIMESTAMPLTZ ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_TIMESTAMPLTZ('JSON', 'TIMESTAMPLTZ', '{"a":1}' ) ;
drop procedure t_JSON_TIMESTAMPLTZ ;
drop procedure print_message;

--+ server-message off
