--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATETIME_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_NUMERIC('DATETIME', 'NUMERIC(38,15)', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_NUMERIC ;


call print_message('t_DATETIMELTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_NUMERIC('DATETIMELTZ', 'NUMERIC(38,15)', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_NUMERIC ;


call print_message('t_DATETIMETZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATETIMETZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_NUMERIC('DATETIMETZ', 'NUMERIC(38,15)', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_NUMERIC ;


call print_message('t_DATE_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_DATE_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_NUMERIC('DATE', 'NUMERIC(38,15)', DATE'2008-10-31' ) ;
drop procedure t_DATE_NUMERIC ;


call print_message('t_TIME_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIME_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_NUMERIC('TIME', 'NUMERIC(38,15)', TIME'13:15:45' ) ;
drop procedure t_TIME_NUMERIC ;


call print_message('t_TIMESTAMP_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIMESTAMP_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_NUMERIC('TIMESTAMP', 'NUMERIC(38,15)', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_NUMERIC ;


call print_message('t_TIMESTAMPLTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_NUMERIC('TIMESTAMPLTZ', 'NUMERIC(38,15)', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_NUMERIC ;


call print_message('t_TIMESTAMPTZ_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_NUMERIC('TIMESTAMPTZ', 'NUMERIC(38,15)', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_NUMERIC ;


call print_message('t_DOUBLE_NUMERIC. This scenario is a success.');
create or replace procedure t_DOUBLE_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_NUMERIC('DOUBLE', 'NUMERIC(38,15)', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_NUMERIC ;


call print_message('t_FLOAT_NUMERIC. This scenario is a success.');
create or replace procedure t_FLOAT_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_NUMERIC('FLOAT', 'NUMERIC(38,15)', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_NUMERIC ;


call print_message('t_NUMERIC_NUMERIC. This scenario is a success.');
create or replace procedure t_NUMERIC_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_NUMERIC('NUMERIC(8,4)', 'NUMERIC(38,15)', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_NUMERIC ;


call print_message('t_BIGINT_NUMERIC. This scenario is a success.');
create or replace procedure t_BIGINT_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_NUMERIC('BIGINT', 'NUMERIC(38,15)', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_NUMERIC ;


call print_message('t_INT_NUMERIC. This scenario is a success.');
create or replace procedure t_INT_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_NUMERIC('INT', 'NUMERIC(38,15)', cast( 782346 as int ) ) ;
drop procedure t_INT_NUMERIC ;


call print_message('t_SHORT_NUMERIC. This scenario is a success.');
create or replace procedure t_SHORT_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_NUMERIC('SHORT', 'NUMERIC(38,15)', cast( 8934 as short ) ) ;
drop procedure t_SHORT_NUMERIC ;


call print_message('t_BIT(8)_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_BIT_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_NUMERIC('BIT(8)', 'NUMERIC(38,15)', 0xaa ) ;
drop procedure t_BIT_NUMERIC ;


call print_message('t_BIT VARYING_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_BITVARYING_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_NUMERIC('BIT VARYING', 'NUMERIC(38,15)', 0xaa ) ;
drop procedure t_BITVARYING_NUMERIC ;


call print_message('t_CHAR_NUMERIC. This scenario is a success.');
create or replace procedure t_CHAR_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_NUMERIC('CHAR', 'NUMERIC(38,15)', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_NUMERIC ;


call print_message('t_VARCHAR_NUMERIC. This scenario is a success.');
create or replace procedure t_VARCHAR_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_NUMERIC('VARCHAR', 'NUMERIC(38,15)', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_NUMERIC ;


call print_message('t_SET_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_SET_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_NUMERIC('SET', 'NUMERIC(38,15)', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_NUMERIC ;


call print_message('t_MULTISET_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_MULTISET_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_NUMERIC('MULTISET', 'NUMERIC(38,15)', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_NUMERIC ;


call print_message('t_LIST_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_LIST_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_NUMERIC('LIST', 'NUMERIC(38,15)', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_NUMERIC ;


call print_message('t_ENUM_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_ENUM_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_NUMERIC('ENUM', 'NUMERIC(38,15)', 'yellow' ) ;
drop procedure t_ENUM_NUMERIC ;


call print_message('t_BLOB_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_BLOB_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_NUMERIC('BLOB', 'NUMERIC(38,15)', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_NUMERIC ;


call print_message('t_CLOB_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_CLOB_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_NUMERIC('CLOB', 'NUMERIC(38,15)', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_NUMERIC ;


call print_message('t_JSON_NUMERIC(38,15). This scenario is a failure.');
create or replace procedure t_JSON_NUMERIC(sql_type string, procedure_type string, param NUMERIC(38,15) ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_NUMERIC('JSON', 'NUMERIC(38,15)', '{"a":1}' ) ;
drop procedure t_JSON_NUMERIC ;
drop procedure print_message;

--+ server-message off
