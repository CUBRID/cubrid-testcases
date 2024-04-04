--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_CHAR. This scenario is a success.');
create or replace procedure t_DATETIME_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_CHAR('DATETIME', 'CHAR', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_CHAR ;


call print_message('t_DATETIMELTZ_CHAR. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_CHAR('DATETIMELTZ', 'CHAR', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_CHAR ;


call print_message('t_DATETIMETZ_CHAR. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_CHAR('DATETIMETZ', 'CHAR', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_CHAR ;


call print_message('t_DATE_CHAR. This scenario is a success.');
create or replace procedure t_DATE_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_CHAR('DATE', 'CHAR', DATE'2008-10-31' ) ;
drop procedure t_DATE_CHAR ;


call print_message('t_TIME_CHAR. This scenario is a success.');
create or replace procedure t_TIME_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_CHAR('TIME', 'CHAR', TIME'13:15:45' ) ;
drop procedure t_TIME_CHAR ;


call print_message('t_TIMESTAMP_CHAR. This scenario is a success.');
create or replace procedure t_TIMESTAMP_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_CHAR('TIMESTAMP', 'CHAR', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_CHAR ;


call print_message('t_TIMESTAMPLTZ_CHAR. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_CHAR('TIMESTAMPLTZ', 'CHAR', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_CHAR ;


call print_message('t_TIMESTAMPTZ_CHAR. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_CHAR('TIMESTAMPTZ', 'CHAR', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_CHAR ;


call print_message('t_DOUBLE_CHAR. This scenario is a success.');
create or replace procedure t_DOUBLE_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_CHAR('DOUBLE', 'CHAR', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_CHAR ;


call print_message('t_FLOAT_CHAR. This scenario is a success.');
create or replace procedure t_FLOAT_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_CHAR('FLOAT', 'CHAR', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_CHAR ;


call print_message('t_NUMERIC_CHAR. This scenario is a success.');
create or replace procedure t_NUMERIC_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_CHAR('NUMERIC(8,4)', 'CHAR', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_CHAR ;


call print_message('t_BIGINT_CHAR. This scenario is a success.');
create or replace procedure t_BIGINT_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_CHAR('BIGINT', 'CHAR', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_CHAR ;


call print_message('t_INT_CHAR. This scenario is a success.');
create or replace procedure t_INT_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_CHAR('INT', 'CHAR', cast( 782346 as int ) ) ;
drop procedure t_INT_CHAR ;


call print_message('t_SHORT_CHAR. This scenario is a success.');
create or replace procedure t_SHORT_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_CHAR('SHORT', 'CHAR', cast( 8934 as short ) ) ;
drop procedure t_SHORT_CHAR ;


call print_message('t_BIT(8)_CHAR. This scenario is a failure.');
create or replace procedure t_BIT_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_CHAR('BIT(8)', 'CHAR', 0xaa ) ;
drop procedure t_BIT_CHAR ;


call print_message('t_BIT VARYING_CHAR. This scenario is a failure.');
create or replace procedure t_BITVARYING_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_CHAR('BIT VARYING', 'CHAR', 0xaa ) ;
drop procedure t_BITVARYING_CHAR ;


call print_message('t_CHAR_CHAR. This scenario is a success.');
create or replace procedure t_CHAR_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_CHAR('CHAR', 'CHAR', 'CHAR CUBRID' ) ;
drop procedure t_CHAR_CHAR ;


call print_message('t_VARCHAR_CHAR. This scenario is a success.');
create or replace procedure t_VARCHAR_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_CHAR('VARCHAR', 'CHAR', 'VARCHAR CUBRID' ) ;
drop procedure t_VARCHAR_CHAR ;
--BUG

call print_message('t_SET_CHAR. This scenario is a failure.');
create or replace procedure t_SET_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_CHAR('SET', 'CHAR', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_CHAR ;
--BUG

call print_message('t_MULTISET_CHAR. This scenario is a failure.');
create or replace procedure t_MULTISET_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_CHAR('MULTISET', 'CHAR', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_CHAR ;
--BUG

call print_message('t_LIST_CHAR. This scenario is a failure.');
create or replace procedure t_LIST_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_CHAR('LIST', 'CHAR', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_CHAR ;
--BUG

call print_message('t_ENUM_CHAR. This scenario is a failure.');
create or replace procedure t_ENUM_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_CHAR('ENUM', 'CHAR', 'yellow' ) ;
drop procedure t_ENUM_CHAR ;


call print_message('t_BLOB_CHAR. This scenario is a failure.');
create or replace procedure t_BLOB_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_CHAR('BLOB', 'CHAR', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_CHAR ;


call print_message('t_CLOB_CHAR. This scenario is a failure.');
create or replace procedure t_CLOB_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_CHAR('CLOB', 'CHAR', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_CHAR ;
--BUG

call print_message('t_JSON_CHAR. This scenario is a failure.');
create or replace procedure t_JSON_CHAR(sql_type string, procedure_type string, param CHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_CHAR('JSON', 'CHAR', '{"a":1}' ) ;
drop procedure t_JSON_CHAR ;
drop procedure print_message;

--+ server-message off
