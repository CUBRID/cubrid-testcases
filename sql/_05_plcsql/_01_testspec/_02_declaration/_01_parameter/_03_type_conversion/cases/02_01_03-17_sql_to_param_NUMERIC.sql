--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_NUMERIC. This scenario is a failure.');
create or replace procedure t_DATETIME_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_NUMERIC('DATETIME', 'NUMERIC', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_NUMERIC ;


call print_message('t_DATETIMELTZ_NUMERIC. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_NUMERIC('DATETIMELTZ', 'NUMERIC', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_NUMERIC ;


call print_message('t_DATETIMETZ_NUMERIC. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_NUMERIC('DATETIMETZ', 'NUMERIC', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_NUMERIC ;


call print_message('t_DATE_NUMERIC. This scenario is a failure.');
create or replace procedure t_DATE_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_NUMERIC('DATE', 'NUMERIC', DATE'2008-10-31' ) ;
drop procedure t_DATE_NUMERIC ;


call print_message('t_TIME_NUMERIC. This scenario is a failure.');
create or replace procedure t_TIME_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_NUMERIC('TIME', 'NUMERIC', TIME'13:15:45' ) ;
drop procedure t_TIME_NUMERIC ;


call print_message('t_TIMESTAMP_NUMERIC. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_NUMERIC('TIMESTAMP', 'NUMERIC', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_NUMERIC ;


call print_message('t_TIMESTAMPLTZ_NUMERIC. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_NUMERIC('TIMESTAMPLTZ', 'NUMERIC', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_NUMERIC ;


call print_message('t_TIMESTAMPTZ_NUMERIC. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_NUMERIC('TIMESTAMPTZ', 'NUMERIC', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_NUMERIC ;

--BUG( normal : 1234.567890000000000,  BUG : 1234.567890000000033978722058236598968505859375 ) - CBRD-25566
call print_message('t_DOUBLE_NUMERIC. This scenario is a success.');
create or replace procedure t_DOUBLE_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_NUMERIC('DOUBLE', 'NUMERIC', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_NUMERIC ;

--BUG ( normal : 16777.210000000000000, BUG : 16777.216796875 ) - CBRD-25566
call print_message('t_FLOAT_NUMERIC. This scenario is a success.');
create or replace procedure t_FLOAT_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_NUMERIC('FLOAT', 'NUMERIC', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_NUMERIC ;

call print_message('t_NUMERIC_NUMERIC. This scenario is a success.');
create or replace procedure t_NUMERIC_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_NUMERIC('NUMERIC(4,4)', 'NUMERIC', cast( 0.123456789 as numeric(4,4) ) ) ;
call t_NUMERIC_NUMERIC('NUMERIC(8,4)', 'NUMERIC', cast( 0.123456789 as numeric(8,4) ) ) ;
drop procedure t_NUMERIC_NUMERIC ;

call print_message('t_BIGINT_NUMERIC. This scenario is a success.');
create or replace procedure t_BIGINT_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_NUMERIC('BIGINT', 'NUMERIC', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_NUMERIC ;

call print_message('t_INT_NUMERIC. This scenario is a success.');
create or replace procedure t_INT_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_NUMERIC('INT', 'NUMERIC', cast( 782346 as int ) ) ;
drop procedure t_INT_NUMERIC ;

call print_message('t_SHORT_NUMERIC. This scenario is a success.');
create or replace procedure t_SHORT_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_NUMERIC('SHORT', 'NUMERIC', cast( 8934 as short ) ) ;
drop procedure t_SHORT_NUMERIC ;


call print_message('t_BIT(8)_NUMERIC. This scenario is a failure.');
create or replace procedure t_BIT_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_NUMERIC('BIT(8)', 'NUMERIC', 0xaa ) ;
drop procedure t_BIT_NUMERIC ;


call print_message('t_BIT VARYING_NUMERIC. This scenario is a failure.');
create or replace procedure t_BITVARYING_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_NUMERIC('BIT VARYING', 'NUMERIC', 0xaa ) ;
drop procedure t_BITVARYING_NUMERIC ;

call print_message('t_CHAR_NUMERIC. This scenario is a success.');
create or replace procedure t_CHAR_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_NUMERIC('CHAR', 'NUMERIC', cast( '123' as char(3) ) ) ;
drop procedure t_CHAR_NUMERIC ;

call print_message('t_VARCHAR_NUMERIC. This scenario is a success.');
create or replace procedure t_VARCHAR_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_NUMERIC('VARCHAR', 'NUMERIC', cast('567' as varchar ) ) ;
drop procedure t_VARCHAR_NUMERIC ;


call print_message('t_SET_NUMERIC. This scenario is a failure.');
create or replace procedure t_SET_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_NUMERIC('SET', 'NUMERIC', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_NUMERIC ;


call print_message('t_MULTISET_NUMERIC. This scenario is a failure.');
create or replace procedure t_MULTISET_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_NUMERIC('MULTISET', 'NUMERIC', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_NUMERIC ;


call print_message('t_LIST_NUMERIC. This scenario is a failure.');
create or replace procedure t_LIST_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_NUMERIC('LIST', 'NUMERIC', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_NUMERIC ;


call print_message('t_ENUM_NUMERIC. This scenario is a failure.');
create or replace procedure t_ENUM_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_NUMERIC('ENUM', 'NUMERIC', 'yellow' ) ;
drop procedure t_ENUM_NUMERIC ;


call print_message('t_BLOB_NUMERIC. This scenario is a failure.');
create or replace procedure t_BLOB_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_NUMERIC('BLOB', 'NUMERIC', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_NUMERIC ;


call print_message('t_CLOB_NUMERIC. This scenario is a failure.');
create or replace procedure t_CLOB_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_NUMERIC('CLOB', 'NUMERIC', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_NUMERIC ;


call print_message('t_JSON_NUMERIC. This scenario is a failure.');
create or replace procedure t_JSON_NUMERIC(sql_type string, procedure_type string, param NUMERIC ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_NUMERIC('JSON', 'NUMERIC ;
drop procedure t_JSON_NUMERIC ;
drop procedure print_message;

--+ server-message off
