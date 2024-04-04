--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_FLOAT. This scenario is a failure.');
create or replace procedure t_DATETIME_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_FLOAT('DATETIME', 'FLOAT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_FLOAT ;


call print_message('t_DATETIMELTZ_FLOAT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_FLOAT('DATETIMELTZ', 'FLOAT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_FLOAT ;


call print_message('t_DATETIMETZ_FLOAT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_FLOAT('DATETIMETZ', 'FLOAT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_FLOAT ;


call print_message('t_DATE_FLOAT. This scenario is a failure.');
create or replace procedure t_DATE_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_FLOAT('DATE', 'FLOAT', DATE'2008-10-31' ) ;
drop procedure t_DATE_FLOAT ;


call print_message('t_TIME_FLOAT. This scenario is a failure.');
create or replace procedure t_TIME_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_FLOAT('TIME', 'FLOAT', TIME'13:15:45' ) ;
drop procedure t_TIME_FLOAT ;


call print_message('t_TIMESTAMP_FLOAT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_FLOAT('TIMESTAMP', 'FLOAT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_FLOAT ;


call print_message('t_TIMESTAMPLTZ_FLOAT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_FLOAT('TIMESTAMPLTZ', 'FLOAT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_FLOAT ;


call print_message('t_TIMESTAMPTZ_FLOAT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_FLOAT('TIMESTAMPTZ', 'FLOAT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_FLOAT ;


call print_message('t_DOUBLE_FLOAT. This scenario is a success.');
create or replace procedure t_DOUBLE_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_FLOAT('DOUBLE', 'FLOAT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_FLOAT ;


call print_message('t_FLOAT_FLOAT. This scenario is a success.');
create or replace procedure t_FLOAT_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_FLOAT('FLOAT', 'FLOAT', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_FLOAT ;


call print_message('t_NUMERIC_FLOAT. This scenario is a success.');
create or replace procedure t_NUMERIC_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_FLOAT('NUMERIC(8,4)', 'FLOAT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_FLOAT ;


call print_message('t_BIGINT_FLOAT. This scenario is a success.');
create or replace procedure t_BIGINT_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_FLOAT('BIGINT', 'FLOAT', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_FLOAT ;


call print_message('t_INT_FLOAT. This scenario is a success.');
create or replace procedure t_INT_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_FLOAT('INT', 'FLOAT', cast( 782346 as int ) ) ;
drop procedure t_INT_FLOAT ;


call print_message('t_SHORT_FLOAT. This scenario is a success.');
create or replace procedure t_SHORT_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_FLOAT('SHORT', 'FLOAT', cast( 8934 as short ) ) ;
drop procedure t_SHORT_FLOAT ;


call print_message('t_BIT(8)_FLOAT. This scenario is a failure.');
create or replace procedure t_BIT_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_FLOAT('BIT(8)', 'FLOAT', 0xaa ) ;
drop procedure t_BIT_FLOAT ;


call print_message('t_BIT VARYING_FLOAT. This scenario is a failure.');
create or replace procedure t_BITVARYING_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_FLOAT('BIT VARYING', 'FLOAT', 0xaa ) ;
drop procedure t_BITVARYING_FLOAT ;


call print_message('t_CHAR_FLOAT. This scenario is a success.');
create or replace procedure t_CHAR_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_FLOAT('CHAR', 'FLOAT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_FLOAT ;


call print_message('t_VARCHAR_FLOAT. This scenario is a success.');
create or replace procedure t_VARCHAR_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_FLOAT('VARCHAR', 'FLOAT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_FLOAT ;


call print_message('t_SET_FLOAT. This scenario is a failure.');
create or replace procedure t_SET_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_FLOAT('SET', 'FLOAT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_FLOAT ;


call print_message('t_MULTISET_FLOAT. This scenario is a failure.');
create or replace procedure t_MULTISET_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_FLOAT('MULTISET', 'FLOAT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_FLOAT ;


call print_message('t_LIST_FLOAT. This scenario is a failure.');
create or replace procedure t_LIST_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_FLOAT('LIST', 'FLOAT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_FLOAT ;


call print_message('t_ENUM_FLOAT. This scenario is a failure.');
create or replace procedure t_ENUM_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_FLOAT('ENUM', 'FLOAT', 'yellow' ) ;
drop procedure t_ENUM_FLOAT ;


call print_message('t_BLOB_FLOAT. This scenario is a failure.');
create or replace procedure t_BLOB_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_FLOAT('BLOB', 'FLOAT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_FLOAT ;


call print_message('t_CLOB_FLOAT. This scenario is a failure.');
create or replace procedure t_CLOB_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_FLOAT('CLOB', 'FLOAT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_FLOAT ;


call print_message('t_JSON_FLOAT. This scenario is a failure.');
create or replace procedure t_JSON_FLOAT(sql_type string, procedure_type string, param FLOAT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_FLOAT('JSON', 'FLOAT', '{"a":1}' ) ;
drop procedure t_JSON_FLOAT ;
drop procedure print_message;

--+ server-message off
