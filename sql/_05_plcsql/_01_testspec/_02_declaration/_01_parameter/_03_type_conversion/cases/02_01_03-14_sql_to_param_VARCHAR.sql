--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_VARCHAR. This scenario is a success.');
create or replace procedure t_DATETIME_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_VARCHAR('DATETIME', 'VARCHAR', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_VARCHAR ;


call print_message('t_DATETIMELTZ_VARCHAR. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_VARCHAR('DATETIMELTZ', 'VARCHAR', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_VARCHAR ;


call print_message('t_DATETIMETZ_VARCHAR. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_VARCHAR('DATETIMETZ', 'VARCHAR', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_VARCHAR ;


call print_message('t_DATE_VARCHAR. This scenario is a success.');
create or replace procedure t_DATE_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_VARCHAR('DATE', 'VARCHAR', DATE'2008-10-31' ) ;
drop procedure t_DATE_VARCHAR ;


call print_message('t_TIME_VARCHAR. This scenario is a success.');
create or replace procedure t_TIME_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_VARCHAR('TIME', 'VARCHAR', TIME'13:15:45' ) ;
drop procedure t_TIME_VARCHAR ;


call print_message('t_TIMESTAMP_VARCHAR. This scenario is a success.');
create or replace procedure t_TIMESTAMP_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_VARCHAR('TIMESTAMP', 'VARCHAR', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_VARCHAR ;


call print_message('t_TIMESTAMPLTZ_VARCHAR. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_VARCHAR('TIMESTAMPLTZ', 'VARCHAR', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_VARCHAR ;


call print_message('t_TIMESTAMPTZ_VARCHAR. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_VARCHAR('TIMESTAMPTZ', 'VARCHAR', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_VARCHAR ;


call print_message('t_DOUBLE_VARCHAR. This scenario is a success.');
create or replace procedure t_DOUBLE_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_VARCHAR('DOUBLE', 'VARCHAR', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_VARCHAR ;


call print_message('t_FLOAT_VARCHAR. This scenario is a success.');
create or replace procedure t_FLOAT_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_VARCHAR('FLOAT', 'VARCHAR', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_VARCHAR ;


call print_message('t_NUMERIC_VARCHAR. This scenario is a success.');
create or replace procedure t_NUMERIC_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_VARCHAR('NUMERIC(8,4)', 'VARCHAR', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_VARCHAR ;


call print_message('t_BIGINT_VARCHAR. This scenario is a success.');
create or replace procedure t_BIGINT_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_VARCHAR('BIGINT', 'VARCHAR', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_VARCHAR ;


call print_message('t_INT_VARCHAR. This scenario is a success.');
create or replace procedure t_INT_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_VARCHAR('INT', 'VARCHAR', cast( 782346 as int ) ) ;
drop procedure t_INT_VARCHAR ;


call print_message('t_SHORT_VARCHAR. This scenario is a success.');
create or replace procedure t_SHORT_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_VARCHAR('SHORT', 'VARCHAR', cast( 8934 as short ) ) ;
drop procedure t_SHORT_VARCHAR ;


call print_message('t_BIT(8)_VARCHAR. This scenario is a failure.');
create or replace procedure t_BIT_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_VARCHAR('BIT(8)', 'VARCHAR', 0xaa ) ;
drop procedure t_BIT_VARCHAR ;


call print_message('t_BIT VARYING_VARCHAR. This scenario is a failure.');
create or replace procedure t_BITVARYING_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_VARCHAR('BIT VARYING', 'VARCHAR', 0xaa ) ;
drop procedure t_BITVARYING_VARCHAR ;


call print_message('t_CHAR_VARCHAR. This scenario is a success.');
create or replace procedure t_CHAR_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_VARCHAR('CHAR', 'VARCHAR', 'CHAR CUBRID' ) ;
drop procedure t_CHAR_VARCHAR ;


call print_message('t_VARCHAR_VARCHAR. This scenario is a success.');
create or replace procedure t_VARCHAR_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_VARCHAR('VARCHAR', 'VARCHAR', 'VARCHAR CUBRID' ) ;
drop procedure t_VARCHAR_VARCHAR ;
--BUG

call print_message('t_SET_VARCHAR. This scenario is a failure.');
create or replace procedure t_SET_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_VARCHAR('SET', 'VARCHAR', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_VARCHAR ;
--BUG

call print_message('t_MULTISET_VARCHAR. This scenario is a failure.');
create or replace procedure t_MULTISET_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_VARCHAR('MULTISET', 'VARCHAR', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_VARCHAR ;
--BUG

call print_message('t_LIST_VARCHAR. This scenario is a failure.');
create or replace procedure t_LIST_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_VARCHAR('LIST', 'VARCHAR', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_VARCHAR ;
--BUG

call print_message('t_ENUM_VARCHAR. This scenario is a failure.');
create or replace procedure t_ENUM_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_VARCHAR('ENUM', 'VARCHAR', 'yellow' ) ;
drop procedure t_ENUM_VARCHAR ;


call print_message('t_BLOB_VARCHAR. This scenario is a failure.');
create or replace procedure t_BLOB_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_VARCHAR('BLOB', 'VARCHAR', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_VARCHAR ;


call print_message('t_CLOB_VARCHAR. This scenario is a failure.');
create or replace procedure t_CLOB_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_VARCHAR('CLOB', 'VARCHAR', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_VARCHAR ;


call print_message('t_JSON_VARCHAR. This scenario is a failure.');
create or replace procedure t_JSON_VARCHAR(sql_type string, procedure_type string, param VARCHAR ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_VARCHAR('JSON', 'VARCHAR', '{"a":1}' ) ;
drop procedure t_JSON_VARCHAR ;
drop procedure print_message;

--+ server-message off


