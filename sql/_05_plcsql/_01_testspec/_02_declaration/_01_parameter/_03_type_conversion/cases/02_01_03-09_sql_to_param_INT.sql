--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_INT. This scenario is a failure.');
create or replace procedure t_DATETIME_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_INT('DATETIME', 'INT', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_INT ;


call print_message('t_DATETIMELTZ_INT. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_INT('DATETIMELTZ', 'INT', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_INT ;


call print_message('t_DATETIMETZ_INT. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_INT('DATETIMETZ', 'INT', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_INT ;


call print_message('t_DATE_INT. This scenario is a failure.');
create or replace procedure t_DATE_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_INT('DATE', 'INT', DATE'2008-10-31' ) ;
drop procedure t_DATE_INT ;


call print_message('t_TIME_INT. This scenario is a failure.');
create or replace procedure t_TIME_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_INT('TIME', 'INT', TIME'13:15:45' ) ;
drop procedure t_TIME_INT ;


call print_message('t_TIMESTAMP_INT. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_INT('TIMESTAMP', 'INT', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_INT ;


call print_message('t_TIMESTAMPLTZ_INT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_INT('TIMESTAMPLTZ', 'INT', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_INT ;


call print_message('t_TIMESTAMPTZ_INT. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_INT('TIMESTAMPTZ', 'INT', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_INT ;


call print_message('t_DOUBLE_INT. This scenario is a success.');
create or replace procedure t_DOUBLE_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_INT('DOUBLE', 'INT', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_INT ;


call print_message('t_FLOAT_INT. This scenario is a success.');
create or replace procedure t_FLOAT_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_INT('FLOAT', 'INT', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_INT ;


call print_message('t_NUMERIC_INT. This scenario is a success.');
create or replace procedure t_NUMERIC_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_INT('NUMERIC(8,4)', 'INT', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_INT ;


call print_message('t_BIGINT_INT. This scenario is a success.');
create or replace procedure t_BIGINT_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_INT('BIGINT', 'INT', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_INT ;


call print_message('t_INT_INT. This scenario is a success.');
create or replace procedure t_INT_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_INT('INT', 'INT', cast( 782346 as int ) ) ;
drop procedure t_INT_INT ;


call print_message('t_SHORT_INT. This scenario is a success.');
create or replace procedure t_SHORT_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_INT('SHORT', 'INT', cast( 8934 as short ) ) ;
drop procedure t_SHORT_INT ;


call print_message('t_BIT(8)_INT. This scenario is a failure.');
create or replace procedure t_BIT_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_INT('BIT(8)', 'INT', 0xaa ) ;
drop procedure t_BIT_INT ;


call print_message('t_BIT VARYING_INT. This scenario is a failure.');
create or replace procedure t_BITVARYING_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_INT('BIT VARYING', 'INT', 0xaa ) ;
drop procedure t_BITVARYING_INT ;


call print_message('t_CHAR_INT. This scenario is a success.');
create or replace procedure t_CHAR_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_INT('CHAR', 'INT', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_INT ;


call print_message('t_VARCHAR_INT. This scenario is a success.');
create or replace procedure t_VARCHAR_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_INT('VARCHAR', 'INT', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_INT ;


call print_message('t_SET_INT. This scenario is a failure.');
create or replace procedure t_SET_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_INT('SET', 'INT', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_INT ;


call print_message('t_MULTISET_INT. This scenario is a failure.');
create or replace procedure t_MULTISET_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_INT('MULTISET', 'INT', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_INT ;


call print_message('t_LIST_INT. This scenario is a failure.');
create or replace procedure t_LIST_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_INT('LIST', 'INT', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_INT ;


call print_message('t_ENUM_INT. This scenario is a failure.');
create or replace procedure t_ENUM_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_INT('ENUM', 'INT', 'yellow' ) ;
drop procedure t_ENUM_INT ;


call print_message('t_BLOB_INT. This scenario is a failure.');
create or replace procedure t_BLOB_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_INT('BLOB', 'INT', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_INT ;


call print_message('t_CLOB_INT. This scenario is a failure.');
create or replace procedure t_CLOB_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_INT('CLOB', 'INT', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_INT ;


call print_message('t_JSON_INT. This scenario is a failure.');
create or replace procedure t_JSON_INT(sql_type string, procedure_type string, param INT ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_INT('JSON', 'INT', '{"a":1}' ) ;
drop procedure t_JSON_INT ;
drop procedure print_message;

--+ server-message off
