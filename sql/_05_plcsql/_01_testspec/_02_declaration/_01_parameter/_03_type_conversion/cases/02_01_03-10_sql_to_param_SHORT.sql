--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIME_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_SHORT('DATETIME', 'SHORT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_SHORT ;


call print_message('t_DATETIMELTZ_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_SHORT('DATETIMELTZ', 'SHORT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_SHORT ;


call print_message('t_DATETIMETZ_SHORT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_SHORT('DATETIMETZ', 'SHORT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_SHORT ;


call print_message('t_DATE_SHORT. This scenario is a failure.');
create or replace procedure t_DATE_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_SHORT('DATE', 'SHORT', DATE'2008-10-31' ) ;
drop procedure t_DATE_SHORT ;


call print_message('t_TIME_SHORT. This scenario is a failure.');
create or replace procedure t_TIME_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_SHORT('TIME', 'SHORT', TIME'13:15:45' ) ;
drop procedure t_TIME_SHORT ;


call print_message('t_TIMESTAMP_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_SHORT('TIMESTAMP', 'SHORT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_SHORT ;


call print_message('t_TIMESTAMPLTZ_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_SHORT('TIMESTAMPLTZ', 'SHORT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_SHORT ;


call print_message('t_TIMESTAMPTZ_SHORT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_SHORT('TIMESTAMPTZ', 'SHORT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_SHORT ;


call print_message('t_DOUBLE_SHORT. This scenario is a success.');
create or replace procedure t_DOUBLE_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_SHORT('DOUBLE', 'SHORT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_SHORT ;


call print_message('t_FLOAT_SHORT. This scenario is a success.');
create or replace procedure t_FLOAT_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_SHORT('FLOAT', 'SHORT', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_SHORT ;


call print_message('t_NUMERIC_SHORT. This scenario is a success.');
create or replace procedure t_NUMERIC_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_SHORT('NUMERIC(8,4)', 'SHORT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_SHORT ;


call print_message('t_BIGINT_SHORT. This scenario is a success.');
create or replace procedure t_BIGINT_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_SHORT('BIGINT', 'SHORT', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_SHORT ;


call print_message('t_INT_SHORT. This scenario is a success.');
create or replace procedure t_INT_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_SHORT('INT', 'SHORT', cast( 782346 as int ) ) ;
drop procedure t_INT_SHORT ;


call print_message('t_SHORT_SHORT. This scenario is a success.');
create or replace procedure t_SHORT_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_SHORT('SHORT', 'SHORT', cast( 8934 as short ) ) ;
drop procedure t_SHORT_SHORT ;


call print_message('t_BIT(8)_SHORT. This scenario is a failure.');
create or replace procedure t_BIT_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_SHORT('BIT(8)', 'SHORT', 0xaa ) ;
drop procedure t_BIT_SHORT ;


call print_message('t_BIT VARYING_SHORT. This scenario is a failure.');
create or replace procedure t_BITVARYING_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_SHORT('BIT VARYING', 'SHORT', 0xaa ) ;
drop procedure t_BITVARYING_SHORT ;


call print_message('t_CHAR_SHORT. This scenario is a success.');
create or replace procedure t_CHAR_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_SHORT('CHAR', 'SHORT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_SHORT ;


call print_message('t_VARCHAR_SHORT. This scenario is a success.');
create or replace procedure t_VARCHAR_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_SHORT('VARCHAR', 'SHORT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_SHORT ;


call print_message('t_SET_SHORT. This scenario is a failure.');
create or replace procedure t_SET_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_SHORT('SET', 'SHORT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_SHORT ;


call print_message('t_MULTISET_SHORT. This scenario is a failure.');
create or replace procedure t_MULTISET_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_SHORT('MULTISET', 'SHORT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_SHORT ;


call print_message('t_LIST_SHORT. This scenario is a failure.');
create or replace procedure t_LIST_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_SHORT('LIST', 'SHORT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_SHORT ;


call print_message('t_ENUM_SHORT. This scenario is a failure.');
create or replace procedure t_ENUM_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_SHORT('ENUM', 'SHORT', 'yellow' ) ;
drop procedure t_ENUM_SHORT ;


call print_message('t_BLOB_SHORT. This scenario is a failure.');
create or replace procedure t_BLOB_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_SHORT('BLOB', 'SHORT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_SHORT ;


call print_message('t_CLOB_SHORT. This scenario is a failure.');
create or replace procedure t_CLOB_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_SHORT('CLOB', 'SHORT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_SHORT ;


call print_message('t_JSON_SHORT. This scenario is a failure.');
create or replace procedure t_JSON_SHORT(sql_type string, procedure_type string, param SHORT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_SHORT('JSON', 'SHORT', '{"a":1}' ) ;
drop procedure t_JSON_SHORT ;
drop procedure print_message;

--+ server-message off
