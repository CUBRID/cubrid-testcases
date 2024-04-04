--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_MULTISET. This scenario is a failure.');
create or replace procedure t_DATETIME_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_MULTISET('DATETIME', 'MULTISET', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_MULTISET ;


call print_message('t_DATETIMELTZ_MULTISET. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_MULTISET('DATETIMELTZ', 'MULTISET', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_MULTISET ;


call print_message('t_DATETIMETZ_MULTISET. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_MULTISET('DATETIMETZ', 'MULTISET', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_MULTISET ;


call print_message('t_DATE_MULTISET. This scenario is a failure.');
create or replace procedure t_DATE_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_MULTISET('DATE', 'MULTISET', DATE'2008-10-31' ) ;
drop procedure t_DATE_MULTISET ;


call print_message('t_TIME_MULTISET. This scenario is a failure.');
create or replace procedure t_TIME_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_MULTISET('TIME', 'MULTISET', TIME'13:15:45' ) ;
drop procedure t_TIME_MULTISET ;


call print_message('t_TIMESTAMP_MULTISET. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_MULTISET('TIMESTAMP', 'MULTISET', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_MULTISET ;


call print_message('t_TIMESTAMPLTZ_MULTISET. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_MULTISET('TIMESTAMPLTZ', 'MULTISET', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_MULTISET ;


call print_message('t_TIMESTAMPTZ_MULTISET. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_MULTISET('TIMESTAMPTZ', 'MULTISET', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_MULTISET ;


call print_message('t_DOUBLE_MULTISET. This scenario is a failure.');
create or replace procedure t_DOUBLE_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_MULTISET('DOUBLE', 'MULTISET', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_MULTISET ;


call print_message('t_FLOAT_MULTISET. This scenario is a failure.');
create or replace procedure t_FLOAT_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_MULTISET('FLOAT', 'MULTISET', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_MULTISET ;


call print_message('t_NUMERIC(8,4)_MULTISET. This scenario is a failure.');
create or replace procedure t_NUMERIC_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_MULTISET('NUMERIC(8,4)', 'MULTISET', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_MULTISET ;


call print_message('t_BIGINT_MULTISET. This scenario is a failure.');
create or replace procedure t_BIGINT_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_MULTISET('BIGINT', 'MULTISET', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_MULTISET ;


call print_message('t_INT_MULTISET. This scenario is a failure.');
create or replace procedure t_INT_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_MULTISET('INT', 'MULTISET', cast( 782346 as int ) ) ;
drop procedure t_INT_MULTISET ;


call print_message('t_SHORT_MULTISET. This scenario is a failure.');
create or replace procedure t_SHORT_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_MULTISET('SHORT', 'MULTISET', cast( 8934 as short ) ) ;
drop procedure t_SHORT_MULTISET ;


call print_message('t_BIT(8)_MULTISET. This scenario is a failure.');
create or replace procedure t_BIT_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_MULTISET('BIT(8)', 'MULTISET', 0xaa ) ;
drop procedure t_BIT_MULTISET ;


call print_message('t_BIT VARYING_MULTISET. This scenario is a failure.');
create or replace procedure t_BITVARYING_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_MULTISET('BIT VARYING', 'MULTISET', 0xaa ) ;
drop procedure t_BITVARYING_MULTISET ;


call print_message('t_CHAR_MULTISET. This scenario is a failure.');
create or replace procedure t_CHAR_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_MULTISET('CHAR', 'MULTISET', {'c','c','c','b','b','a'} ) ;
drop procedure t_CHAR_MULTISET ;


call print_message('t_VARCHAR_MULTISET. This scenario is a failure.');
create or replace procedure t_VARCHAR_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_MULTISET('VARCHAR', 'MULTISET', {'c','c','c','b','b','a'} ) ;
drop procedure t_VARCHAR_MULTISET ;


call print_message('t_SET_MULTISET. This scenario is a failure.');
create or replace procedure t_SET_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_MULTISET('SET', 'MULTISET', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_MULTISET ;


call print_message('t_MULTISET_MULTISET. This scenario is a failure.');
create or replace procedure t_MULTISET_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_MULTISET('MULTISET', 'MULTISET', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_MULTISET ;


call print_message('t_LIST_MULTISET. This scenario is a failure.');
create or replace procedure t_LIST_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_MULTISET('LIST', 'MULTISET', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_MULTISET ;


call print_message('t_ENUM_MULTISET. This scenario is a failure.');
create or replace procedure t_ENUM_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_MULTISET('ENUM', 'MULTISET', 'yellow' ) ;
drop procedure t_ENUM_MULTISET ;


call print_message('t_BLOB_MULTISET. This scenario is a failure.');
create or replace procedure t_BLOB_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_MULTISET('BLOB', 'MULTISET', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_MULTISET ;


call print_message('t_CLOB_MULTISET. This scenario is a failure.');
create or replace procedure t_CLOB_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_MULTISET('CLOB', 'MULTISET', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_MULTISET ;


call print_message('t_JSON_MULTISET. This scenario is a failure.');
create or replace procedure t_JSON_MULTISET(sql_type string, procedure_type string, param MULTISET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_MULTISET('JSON', 'MULTISET', '{"a":1}' ) ;
drop procedure t_JSON_MULTISET ;
drop procedure print_message;

--+ server-message off
