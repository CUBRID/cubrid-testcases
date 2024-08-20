--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_ENUM. This scenario is a failure.');
create or replace procedure t_DATETIME_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_ENUM('DATETIME', 'ENUM', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_ENUM ;


call print_message('t_DATETIMELTZ_ENUM. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_ENUM('DATETIMELTZ', 'ENUM', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_ENUM ;


call print_message('t_DATETIMETZ_ENUM. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_ENUM('DATETIMETZ', 'ENUM', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_ENUM ;


call print_message('t_DATE_ENUM. This scenario is a failure.');
create or replace procedure t_DATE_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_ENUM('DATE', 'ENUM', DATE'2008-10-31' ) ;
drop procedure t_DATE_ENUM ;


call print_message('t_TIME_ENUM. This scenario is a failure.');
create or replace procedure t_TIME_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_ENUM('TIME', 'ENUM', TIME'13:15:45' ) ;
drop procedure t_TIME_ENUM ;


call print_message('t_TIMESTAMP_ENUM. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_ENUM('TIMESTAMP', 'ENUM', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_ENUM ;


call print_message('t_TIMESTAMPLTZ_ENUM. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_ENUM('TIMESTAMPLTZ', 'ENUM', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_ENUM ;


call print_message('t_TIMESTAMPTZ_ENUM. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_ENUM('TIMESTAMPTZ', 'ENUM', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_ENUM ;


call print_message('t_DOUBLE_ENUM. This scenario is a failure.');
create or replace procedure t_DOUBLE_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_ENUM('DOUBLE', 'ENUM', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_ENUM ;


call print_message('t_FLOAT_ENUM. This scenario is a failure.');
create or replace procedure t_FLOAT_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_ENUM('FLOAT', 'ENUM', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_ENUM ;


call print_message('t_NUMERIC(8,4)_ENUM. This scenario is a failure.');
create or replace procedure t_NUMERIC_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_ENUM('NUMERIC(8,4)', 'ENUM', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_ENUM ;


call print_message('t_BIGINT_ENUM. This scenario is a failure.');
create or replace procedure t_BIGINT_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_ENUM('BIGINT', 'ENUM', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_ENUM ;


call print_message('t_INT_ENUM. This scenario is a failure.');
create or replace procedure t_INT_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_ENUM('INT', 'ENUM', cast( 782346 as int ) ) ;
drop procedure t_INT_ENUM ;


call print_message('t_SHORT_ENUM. This scenario is a failure.');
create or replace procedure t_SHORT_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_ENUM('SHORT', 'ENUM', cast( 8934 as short ) ) ;
drop procedure t_SHORT_ENUM ;


call print_message('t_BIT(8)_ENUM. This scenario is a failure.');
create or replace procedure t_BIT_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_ENUM('BIT(8)', 'ENUM', 0xaa ) ;
drop procedure t_BIT_ENUM ;


call print_message('t_BIT VARYING_ENUM. This scenario is a failure.');
create or replace procedure t_BITVARYING_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_ENUM('BIT VARYING', 'ENUM', 0xaa ) ;
drop procedure t_BITVARYING_ENUM ;


call print_message('t_CHAR_ENUM. This scenario is a failure.');
create or replace procedure t_CHAR_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_ENUM('CHAR', 'ENUM', 'yellow' ) ;
drop procedure t_CHAR_ENUM ;


call print_message('t_VARCHAR_ENUM. This scenario is a failure.');
create or replace procedure t_VARCHAR_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_ENUM('VARCHAR', 'ENUM', 'yellow' ) ;
drop procedure t_VARCHAR_ENUM ;


call print_message('t_SET_ENUM. This scenario is a failure.');
create or replace procedure t_SET_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_ENUM('SET', 'ENUM', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_ENUM ;


call print_message('t_MULTISET_ENUM. This scenario is a failure.');
create or replace procedure t_MULTISET_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_ENUM('MULTISET', 'ENUM', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_ENUM ;


call print_message('t_LIST_ENUM. This scenario is a failure.');
create or replace procedure t_LIST_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_ENUM('LIST', 'ENUM', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_ENUM ;


call print_message('t_ENUM_ENUM. This scenario is a failure.');
create or replace procedure t_ENUM_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_ENUM('ENUM', 'ENUM', 'yellow' ) ;
drop procedure t_ENUM_ENUM ;


call print_message('t_BLOB_ENUM. This scenario is a failure.');
create or replace procedure t_BLOB_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_ENUM('BLOB', 'ENUM', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_ENUM ;


call print_message('t_CLOB_ENUM. This scenario is a failure.');
create or replace procedure t_CLOB_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_ENUM('CLOB', 'ENUM', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_ENUM ;


call print_message('t_JSON_ENUM. This scenario is a failure.');
create or replace procedure t_JSON_ENUM(sql_type string, procedure_type string, param ENUM ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_ENUM('JSON', 'ENUM', '{"a":1}' ) ;
drop procedure t_JSON_ENUM ;
drop procedure print_message;

--+ server-message off
