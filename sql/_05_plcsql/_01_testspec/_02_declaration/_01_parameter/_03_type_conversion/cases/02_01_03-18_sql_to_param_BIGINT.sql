--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_BIGINT. This scenario is a failure.');
create or replace procedure t_DATETIME_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_BIGINT('DATETIME', 'BIGINT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_BIGINT ;


call print_message('t_DATETIMELTZ_BIGINT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_BIGINT('DATETIMELTZ', 'BIGINT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_BIGINT ;


call print_message('t_DATETIMETZ_BIGINT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_BIGINT('DATETIMETZ', 'BIGINT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_BIGINT ;


call print_message('t_DATE_BIGINT. This scenario is a failure.');
create or replace procedure t_DATE_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_BIGINT('DATE', 'BIGINT', DATE'2008-10-31' ) ;
drop procedure t_DATE_BIGINT ;


call print_message('t_TIME_BIGINT. This scenario is a failure.');
create or replace procedure t_TIME_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_BIGINT('TIME', 'BIGINT', TIME'13:15:45' ) ;
drop procedure t_TIME_BIGINT ;


call print_message('t_TIMESTAMP_BIGINT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_BIGINT('TIMESTAMP', 'BIGINT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_BIGINT ;


call print_message('t_TIMESTAMPLTZ_BIGINT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_BIGINT('TIMESTAMPLTZ', 'BIGINT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_BIGINT ;


call print_message('t_TIMESTAMPTZ_BIGINT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_BIGINT('TIMESTAMPTZ', 'BIGINT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_BIGINT ;


call print_message('t_DOUBLE_BIGINT. This scenario is a success.');
create or replace procedure t_DOUBLE_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_BIGINT('DOUBLE', 'BIGINT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_BIGINT ;


call print_message('t_FLOAT_BIGINT. This scenario is a success.');
create or replace procedure t_FLOAT_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_BIGINT('FLOAT', 'BIGINT', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_BIGINT ;


call print_message('t_NUMERIC_BIGINT. This scenario is a success.');
create or replace procedure t_NUMERIC_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_BIGINT('NUMERIC(8,4)', 'BIGINT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_BIGINT ;


call print_message('t_BIGINT_BIGINT. This scenario is a success.');
create or replace procedure t_BIGINT_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_BIGINT('BIGINT', 'BIGINT', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_BIGINT ;


call print_message('t_INT_BIGINT. This scenario is a success.');
create or replace procedure t_INT_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_BIGINT('INT', 'BIGINT', cast( 782346 as int ) ) ;
drop procedure t_INT_BIGINT ;


call print_message('t_SHORT_BIGINT. This scenario is a success.');
create or replace procedure t_SHORT_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_BIGINT('SHORT', 'BIGINT', cast( 8934 as short ) ) ;
drop procedure t_SHORT_BIGINT ;


call print_message('t_BIT(8)_BIGINT. This scenario is a failure.');
create or replace procedure t_BIT_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_BIGINT('BIT(8)', 'BIGINT', 0xaa ) ;
drop procedure t_BIT_BIGINT ;


call print_message('t_BIT VARYING_BIGINT. This scenario is a failure.');
create or replace procedure t_BITVARYING_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_BIGINT('BIT VARYING', 'BIGINT', 0xaa ) ;
drop procedure t_BITVARYING_BIGINT ;


call print_message('t_CHAR_BIGINT. This scenario is a success.');
create or replace procedure t_CHAR_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_BIGINT('CHAR', 'BIGINT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_BIGINT ;


call print_message('t_VARCHAR_BIGINT. This scenario is a success.');
create or replace procedure t_VARCHAR_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_BIGINT('VARCHAR', 'BIGINT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_BIGINT ;


call print_message('t_SET_BIGINT. This scenario is a failure.');
create or replace procedure t_SET_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_BIGINT('SET', 'BIGINT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_BIGINT ;


call print_message('t_MULTISET_BIGINT. This scenario is a failure.');
create or replace procedure t_MULTISET_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_BIGINT('MULTISET', 'BIGINT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_BIGINT ;


call print_message('t_LIST_BIGINT. This scenario is a failure.');
create or replace procedure t_LIST_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_BIGINT('LIST', 'BIGINT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_BIGINT ;


call print_message('t_ENUM_BIGINT. This scenario is a failure.');
create or replace procedure t_ENUM_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_BIGINT('ENUM', 'BIGINT', 'yellow' ) ;
drop procedure t_ENUM_BIGINT ;


call print_message('t_BLOB_BIGINT. This scenario is a failure.');
create or replace procedure t_BLOB_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_BIGINT('BLOB', 'BIGINT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_BIGINT ;


call print_message('t_CLOB_BIGINT. This scenario is a failure.');
create or replace procedure t_CLOB_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_BIGINT('CLOB', 'BIGINT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_BIGINT ;


call print_message('t_JSON_BIGINT. This scenario is a failure.');
create or replace procedure t_JSON_BIGINT(sql_type string, procedure_type string, param BIGINT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_BIGINT('JSON', 'BIGINT', '{"a":1}' ) ;
drop procedure t_JSON_BIGINT ;
drop procedure print_message;

--+ server-message off
