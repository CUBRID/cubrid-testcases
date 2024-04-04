--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIME_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_DOUBLE('DATETIME', 'DOUBLE', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_DOUBLE ;


call print_message('t_DATETIMELTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_DOUBLE('DATETIMELTZ', 'DOUBLE', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_DOUBLE ;


call print_message('t_DATETIMETZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_DOUBLE('DATETIMETZ', 'DOUBLE', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_DOUBLE ;


call print_message('t_DATE_DOUBLE. This scenario is a failure.');
create or replace procedure t_DATE_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_DOUBLE('DATE', 'DOUBLE', DATE'2008-10-31' ) ;
drop procedure t_DATE_DOUBLE ;


call print_message('t_TIME_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIME_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_DOUBLE('TIME', 'DOUBLE', TIME'13:15:45' ) ;
drop procedure t_TIME_DOUBLE ;


call print_message('t_TIMESTAMP_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_DOUBLE('TIMESTAMP', 'DOUBLE', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_DOUBLE ;


call print_message('t_TIMESTAMPLTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_DOUBLE('TIMESTAMPLTZ', 'DOUBLE', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_DOUBLE ;


call print_message('t_TIMESTAMPTZ_DOUBLE. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_DOUBLE('TIMESTAMPTZ', 'DOUBLE', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_DOUBLE ;


call print_message('t_DOUBLE_DOUBLE. This scenario is a success.');
create or replace procedure t_DOUBLE_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_DOUBLE('DOUBLE', 'DOUBLE', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_DOUBLE ;


call print_message('t_FLOAT_DOUBLE. This scenario is a success.');
create or replace procedure t_FLOAT_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_DOUBLE('FLOAT', 'DOUBLE', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_DOUBLE ;


call print_message('t_NUMERIC_DOUBLE. This scenario is a success.');
create or replace procedure t_NUMERIC_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_DOUBLE('NUMERIC(8,4)', 'DOUBLE', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_DOUBLE ;


call print_message('t_BIGINT_DOUBLE. This scenario is a success.');
create or replace procedure t_BIGINT_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_DOUBLE('BIGINT', 'DOUBLE', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_DOUBLE ;


call print_message('t_INT_DOUBLE. This scenario is a success.');
create or replace procedure t_INT_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_DOUBLE('INT', 'DOUBLE', cast( 782346 as int ) ) ;
drop procedure t_INT_DOUBLE ;


call print_message('t_SHORT_DOUBLE. This scenario is a success.');
create or replace procedure t_SHORT_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_DOUBLE('SHORT', 'DOUBLE', cast( 8934 as short ) ) ;
drop procedure t_SHORT_DOUBLE ;


call print_message('t_BIT(8)_DOUBLE. This scenario is a failure.');
create or replace procedure t_BIT_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_DOUBLE('BIT(8)', 'DOUBLE', 0xaa ) ;
drop procedure t_BIT_DOUBLE ;


call print_message('t_BIT VARYING_DOUBLE. This scenario is a failure.');
create or replace procedure t_BITVARYING_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_DOUBLE('BIT VARYING', 'DOUBLE', 0xaa ) ;
drop procedure t_BITVARYING_DOUBLE ;


call print_message('t_CHAR_DOUBLE. This scenario is a success.');
create or replace procedure t_CHAR_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_DOUBLE('CHAR', 'DOUBLE', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_DOUBLE ;


call print_message('t_VARCHAR_DOUBLE. This scenario is a success.');
create or replace procedure t_VARCHAR_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_DOUBLE('VARCHAR', 'DOUBLE', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_DOUBLE ;


call print_message('t_SET_DOUBLE. This scenario is a failure.');
create or replace procedure t_SET_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_DOUBLE('SET', 'DOUBLE', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_DOUBLE ;


call print_message('t_MULTISET_DOUBLE. This scenario is a failure.');
create or replace procedure t_MULTISET_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_DOUBLE('MULTISET', 'DOUBLE', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_DOUBLE ;


call print_message('t_LIST_DOUBLE. This scenario is a failure.');
create or replace procedure t_LIST_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_DOUBLE('LIST', 'DOUBLE', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_DOUBLE ;


call print_message('t_ENUM_DOUBLE. This scenario is a failure.');
create or replace procedure t_ENUM_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_DOUBLE('ENUM', 'DOUBLE', 'yellow' ) ;
drop procedure t_ENUM_DOUBLE ;


call print_message('t_BLOB_DOUBLE. This scenario is a failure.');
create or replace procedure t_BLOB_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_DOUBLE('BLOB', 'DOUBLE', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_DOUBLE ;


call print_message('t_CLOB_DOUBLE. This scenario is a failure.');
create or replace procedure t_CLOB_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_DOUBLE('CLOB', 'DOUBLE', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_DOUBLE ;


call print_message('t_JSON_DOUBLE. This scenario is a failure.');
create or replace procedure t_JSON_DOUBLE(sql_type string, procedure_type string, param DOUBLE ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_DOUBLE('JSON', 'DOUBLE', '{"a":1}' ) ;
drop procedure t_JSON_DOUBLE ;
drop procedure print_message;

--+ server-message off
