--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_TIMESTAMP. This scenario is a success.');
create or replace procedure t_DATETIME_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_TIMESTAMP('DATETIME', 'TIMESTAMP', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_TIMESTAMP ;


call print_message('t_DATETIMELTZ_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_TIMESTAMP('DATETIMELTZ', 'TIMESTAMP', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_TIMESTAMP ;


call print_message('t_DATETIMETZ_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_TIMESTAMP('DATETIMETZ', 'TIMESTAMP', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_TIMESTAMP ;


call print_message('t_DATE_TIMESTAMP. This scenario is a success.');
create or replace procedure t_DATE_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_TIMESTAMP('DATE', 'TIMESTAMP', DATE'2008-10-31' ) ;
drop procedure t_DATE_TIMESTAMP ;
--BUG

call print_message('t_TIME_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_TIME_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_TIMESTAMP('TIME', 'TIMESTAMP', TIME'13:15:45' ) ;
drop procedure t_TIME_TIMESTAMP ;


call print_message('t_TIMESTAMP_TIMESTAMP. This scenario is a success.');
create or replace procedure t_TIMESTAMP_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_TIMESTAMP('TIMESTAMP', 'TIMESTAMP', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_TIMESTAMP ;


call print_message('t_TIMESTAMPLTZ_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_TIMESTAMP('TIMESTAMPLTZ', 'TIMESTAMP', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_TIMESTAMP ;


call print_message('t_TIMESTAMPTZ_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_TIMESTAMP('TIMESTAMPTZ', 'TIMESTAMP', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_TIMESTAMP ;
--BUG

call print_message('t_DOUBLE_TIMESTAMP. This scenario is a success.');
create or replace procedure t_DOUBLE_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_TIMESTAMP('DOUBLE', 'TIMESTAMP', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_TIMESTAMP ;
--BUG

call print_message('t_FLOAT_TIMESTAMP. This scenario is a success.');
create or replace procedure t_FLOAT_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_TIMESTAMP('FLOAT', 'TIMESTAMP', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_TIMESTAMP ;
--BUG

call print_message('t_NUMERIC_TIMESTAMP. This scenario is a success.');
create or replace procedure t_NUMERIC_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_TIMESTAMP('NUMERIC(8,4)', 'TIMESTAMP', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_TIMESTAMP ;
--BUG

call print_message('t_BIGINT_TIMESTAMP. This scenario is a success.');
create or replace procedure t_BIGINT_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_TIMESTAMP('BIGINT', 'TIMESTAMP', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_TIMESTAMP ;
--BUG

call print_message('t_INT_TIMESTAMP. This scenario is a success.');
create or replace procedure t_INT_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_TIMESTAMP('INT', 'TIMESTAMP', cast( 782346 as int ) ) ;
drop procedure t_INT_TIMESTAMP ;
--BUG

call print_message('t_SHORT_TIMESTAMP. This scenario is a success.');
create or replace procedure t_SHORT_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_TIMESTAMP('SHORT', 'TIMESTAMP', cast( 8934 as short ) ) ;
drop procedure t_SHORT_TIMESTAMP ;


call print_message('t_BIT(8)_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_BIT_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_TIMESTAMP('BIT(8)', 'TIMESTAMP', 0xaa ) ;
drop procedure t_BIT_TIMESTAMP ;


call print_message('t_BIT VARYING_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_BITVARYING_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_TIMESTAMP('BIT VARYING', 'TIMESTAMP', 0xaa ) ;
drop procedure t_BITVARYING_TIMESTAMP ;


call print_message('t_CHAR_TIMESTAMP. This scenario is a success.');
create or replace procedure t_CHAR_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_TIMESTAMP('CHAR', 'TIMESTAMP', cast( '09/01/2005 05:05:05 pm' as char(22) ) ) ;
drop procedure t_CHAR_TIMESTAMP ;


call print_message('t_VARCHAR_TIMESTAMP. This scenario is a success.');
create or replace procedure t_VARCHAR_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_TIMESTAMP('VARCHAR', 'TIMESTAMP', cast( '09/01/2019 09:09:09 pm' as varchar ) ) ;
drop procedure t_VARCHAR_TIMESTAMP ;


call print_message('t_SET_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_SET_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_TIMESTAMP('SET', 'TIMESTAMP', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_TIMESTAMP ;


call print_message('t_MULTISET_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_MULTISET_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_TIMESTAMP('MULTISET', 'TIMESTAMP', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_TIMESTAMP ;


call print_message('t_LIST_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_LIST_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_TIMESTAMP('LIST', 'TIMESTAMP', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_TIMESTAMP ;


call print_message('t_ENUM_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_ENUM_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_TIMESTAMP('ENUM', 'TIMESTAMP', 'yellow' ) ;
drop procedure t_ENUM_TIMESTAMP ;


call print_message('t_BLOB_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_BLOB_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_TIMESTAMP('BLOB', 'TIMESTAMP', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_TIMESTAMP ;


call print_message('t_CLOB_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_CLOB_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_TIMESTAMP('CLOB', 'TIMESTAMP', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_TIMESTAMP ;


call print_message('t_JSON_TIMESTAMP. This scenario is a failure.');
create or replace procedure t_JSON_TIMESTAMP(sql_type string, procedure_type string, param TIMESTAMP ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_TIMESTAMP('JSON', 'TIMESTAMP', '{"a":1}' ) ;
drop procedure t_JSON_TIMESTAMP ;
drop procedure print_message;

--+ server-message off
