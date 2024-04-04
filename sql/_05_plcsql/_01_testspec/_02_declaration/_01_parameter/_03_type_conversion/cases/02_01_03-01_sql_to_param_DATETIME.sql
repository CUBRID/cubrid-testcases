--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DATETIME. This scenario is a success.');
create or replace procedure t_DATETIME_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_DATETIME('DATETIME', 'DATETIME', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_DATETIME ;


call print_message('t_DATETIMELTZ_DATETIME. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_DATETIME('DATETIMELTZ', 'DATETIME', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_DATETIME ;


call print_message('t_DATETIMETZ_DATETIME. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_DATETIME('DATETIMETZ', 'DATETIME', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_DATETIME ;


call print_message('t_DATE_DATETIME. This scenario is a success.');
create or replace procedure t_DATE_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_DATETIME('DATE', 'DATETIME', DATE'2008-10-31' ) ;
drop procedure t_DATE_DATETIME ;
--BUG

call print_message('t_TIME_DATETIME. This scenario is a failure.');
create or replace procedure t_TIME_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_DATETIME('TIME', 'DATETIME', TIME'13:15:45' ) ;
drop procedure t_TIME_DATETIME ;


call print_message('t_TIMESTAMP_DATETIME. This scenario is a success.');
create or replace procedure t_TIMESTAMP_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_DATETIME('TIMESTAMP', 'DATETIME', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_DATETIME ;


call print_message('t_TIMESTAMPLTZ_DATETIME. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_DATETIME('TIMESTAMPLTZ', 'DATETIME', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_DATETIME ;


call print_message('t_TIMESTAMPTZ_DATETIME. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_DATETIME('TIMESTAMPTZ', 'DATETIME', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_DATETIME ;


call print_message('t_DOUBLE_DATETIME. This scenario is a failure.');
create or replace procedure t_DOUBLE_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_DATETIME('DOUBLE', 'DATETIME', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_DATETIME ;


call print_message('t_FLOAT_DATETIME. This scenario is a failure.');
create or replace procedure t_FLOAT_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_DATETIME('FLOAT', 'DATETIME', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_DATETIME ;


call print_message('t_NUMERIC(8,4)_DATETIME. This scenario is a failure.');
create or replace procedure t_NUMERIC_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_DATETIME('NUMERIC(8,4)', 'DATETIME', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_DATETIME ;


call print_message('t_BIGINT_DATETIME. This scenario is a failure.');
create or replace procedure t_BIGINT_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_DATETIME('BIGINT', 'DATETIME', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_DATETIME ;


call print_message('t_INT_DATETIME. This scenario is a failure.');
create or replace procedure t_INT_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_DATETIME('INT', 'DATETIME', cast( 782346 as int ) ) ;
drop procedure t_INT_DATETIME ;


call print_message('t_SHORT_DATETIME. This scenario is a failure.');
create or replace procedure t_SHORT_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_DATETIME('SHORT', 'DATETIME', cast( 8934 as short ) ) ;
drop procedure t_SHORT_DATETIME ;


call print_message('t_BIT(8)_DATETIME. This scenario is a failure.');
create or replace procedure t_BIT_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_DATETIME('BIT(8)', 'DATETIME', 0xaa ) ;
drop procedure t_BIT_DATETIME ;


call print_message('t_BIT VARYING_DATETIME. This scenario is a failure.');
create or replace procedure t_BITVARYING_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_DATETIME('BIT VARYING', 'DATETIME', 0xaa ) ;
drop procedure t_BITVARYING_DATETIME ;


call print_message('t_CHAR_DATETIME. This scenario is a success.');
create or replace procedure t_CHAR_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_DATETIME('CHAR', 'DATETIME', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_DATETIME ;


call print_message('t_VARCHAR_DATETIME. This scenario is a success.');
create or replace procedure t_VARCHAR_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_DATETIME('VARCHAR', 'DATETIME', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_DATETIME ;


call print_message('t_SET_DATETIME. This scenario is a failure.');
create or replace procedure t_SET_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_DATETIME('SET', 'DATETIME', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_DATETIME ;


call print_message('t_MULTISET_DATETIME. This scenario is a failure.');
create or replace procedure t_MULTISET_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_DATETIME('MULTISET', 'DATETIME', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_DATETIME ;


call print_message('t_LIST_DATETIME. This scenario is a failure.');
create or replace procedure t_LIST_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_DATETIME('LIST', 'DATETIME', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_DATETIME ;


call print_message('t_ENUM_DATETIME. This scenario is a failure.');
create or replace procedure t_ENUM_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_DATETIME('ENUM', 'DATETIME', 'yellow' ) ;
drop procedure t_ENUM_DATETIME ;


call print_message('t_BLOB_DATETIME. This scenario is a failure.');
create or replace procedure t_BLOB_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_DATETIME('BLOB', 'DATETIME', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_DATETIME ;


call print_message('t_CLOB_DATETIME. This scenario is a failure.');
create or replace procedure t_CLOB_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_DATETIME('CLOB', 'DATETIME', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_DATETIME ;


call print_message('t_JSON_DATETIME. This scenario is a failure.');
create or replace procedure t_JSON_DATETIME(sql_type string, procedure_type string, param DATETIME ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_DATETIME('JSON', 'DATETIME', '{"a":1}' ) ;
drop procedure t_JSON_DATETIME ;
drop procedure print_message;

--+ server-message off
