--+ server-message on

create or replace procedure print_message(print_message string ) as begin
    dbms_output.put_line( print_message ); 
end;


call print_message('t_DATETIME_SET. This scenario is a failure.');
create or replace procedure t_DATETIME_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIME_SET('DATETIME', 'SET', DATETIME'2023-02-14 10:51:28.999' ) ;
drop procedure t_DATETIME_SET ;


call print_message('t_DATETIMELTZ_SET. This scenario is a failure.');
create or replace procedure t_DATETIMELTZ_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMELTZ_SET('DATETIMELTZ', 'SET', datetimeltz '09/01/2009 01:10:10 pm' ) ;
drop procedure t_DATETIMELTZ_SET ;


call print_message('t_DATETIMETZ_SET. This scenario is a failure.');
create or replace procedure t_DATETIMETZ_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATETIMETZ_SET('DATETIMETZ', 'SET', datetimetz '09/01/2008 02:20:20 pm' ) ;
drop procedure t_DATETIMETZ_SET ;


call print_message('t_DATE_SET. This scenario is a failure.');
create or replace procedure t_DATE_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DATE_SET('DATE', 'SET', DATE'2008-10-31' ) ;
drop procedure t_DATE_SET ;


call print_message('t_TIME_SET. This scenario is a failure.');
create or replace procedure t_TIME_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIME_SET('TIME', 'SET', TIME'13:15:45' ) ;
drop procedure t_TIME_SET ;


call print_message('t_TIMESTAMP_SET. This scenario is a failure.');
create or replace procedure t_TIMESTAMP_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMP_SET('TIMESTAMP', 'SET', TIMESTAMP'2023-10-31 13:15:45' ) ;
drop procedure t_TIMESTAMP_SET ;


call print_message('t_TIMESTAMPLTZ_SET. This scenario is a failure.');
create or replace procedure t_TIMESTAMPLTZ_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPLTZ_SET('TIMESTAMPLTZ', 'SET', timestamptz '09/01/2007 03:30:30 pm' ) ;
drop procedure t_TIMESTAMPLTZ_SET ;


call print_message('t_TIMESTAMPTZ_SET. This scenario is a failure.');
create or replace procedure t_TIMESTAMPTZ_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_TIMESTAMPTZ_SET('TIMESTAMPTZ', 'SET', timestamptz '09/01/2006 04:40:40 pm' ) ;
drop procedure t_TIMESTAMPTZ_SET ;


call print_message('t_DOUBLE_SET. This scenario is a failure.');
create or replace procedure t_DOUBLE_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_DOUBLE_SET('DOUBLE', 'SET', cast( 1234.56789 as double) ) ;
drop procedure t_DOUBLE_SET ;


call print_message('t_FLOAT_SET. This scenario is a failure.');
create or replace procedure t_FLOAT_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_FLOAT_SET('FLOAT', 'SET', cast( 16777.217 as float ) ) ;
drop procedure t_FLOAT_SET ;


call print_message('t_NUMERIC(8,4)_SET. This scenario is a failure.');
create or replace procedure t_NUMERIC_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_NUMERIC_SET('NUMERIC(8,4)', 'SET', cast( 0.123456789 as numeric(4,4) ) ) ;
drop procedure t_NUMERIC_SET ;


call print_message('t_BIGINT_SET. This scenario is a failure.');
create or replace procedure t_BIGINT_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIGINT_SET('BIGINT', 'SET', cast( 34589012 as bigint ) ) ;
drop procedure t_BIGINT_SET ;


call print_message('t_INT_SET. This scenario is a failure.');
create or replace procedure t_INT_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_INT_SET('INT', 'SET', cast( 782346 as int ) ) ;
drop procedure t_INT_SET ;


call print_message('t_SHORT_SET. This scenario is a failure.');
create or replace procedure t_SHORT_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SHORT_SET('SHORT', 'SET', cast( 8934 as short ) ) ;
drop procedure t_SHORT_SET ;


call print_message('t_BIT(8)_SET. This scenario is a failure.');
create or replace procedure t_BIT_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BIT_SET('BIT(8)', 'SET', 0xaa ) ;
drop procedure t_BIT_SET ;


call print_message('t_BIT VARYING_SET. This scenario is a failure.');
create or replace procedure t_BITVARYING_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BITVARYING_SET('BIT VARYING', 'SET', 0xaa ) ;
drop procedure t_BITVARYING_SET ;


call print_message('t_CHAR_SET. This scenario is a failure.');
create or replace procedure t_CHAR_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CHAR_SET('CHAR', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_CHAR_SET ;


call print_message('t_VARCHAR_SET. This scenario is a failure.');
create or replace procedure t_VARCHAR_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_VARCHAR_SET('VARCHAR', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_VARCHAR_SET ;


call print_message('t_SET_SET. This scenario is a failure.');
create or replace procedure t_SET_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_SET_SET('SET', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_SET_SET ;


call print_message('t_MULTISET_SET. This scenario is a failure.');
create or replace procedure t_MULTISET_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_MULTISET_SET('MULTISET', 'SET', {'c','c','c','b','b','a'} ) ;
drop procedure t_MULTISET_SET ;


call print_message('t_LIST_SET. This scenario is a failure.');
create or replace procedure t_LIST_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_LIST_SET('LIST', 'SET', {'c','c','c','b','b', 'a'} ) ;
drop procedure t_LIST_SET ;


call print_message('t_ENUM_SET. This scenario is a failure.');
create or replace procedure t_ENUM_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_ENUM_SET('ENUM', 'SET', 'yellow' ) ;
drop procedure t_ENUM_SET ;


call print_message('t_BLOB_SET. This scenario is a failure.');
create or replace procedure t_BLOB_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_BLOB_SET('BLOB', 'SET', BIT_TO_BLOB(X'000010') ) ;
drop procedure t_BLOB_SET ;


call print_message('t_CLOB_SET. This scenario is a failure.');
create or replace procedure t_CLOB_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_CLOB_SET('CLOB', 'SET', CHAR_TO_CLOB('This is a Dog') ) ;
drop procedure t_CLOB_SET ;


call print_message('t_JSON_SET. This scenario is a failure.');
create or replace procedure t_JSON_SET(sql_type string, procedure_type string, param SET ) as begin
    dbms_output.put_line('sql_type = ' ||sql_type ||', procedure_type = '||procedure_type||', current_value = '|| param ); 
end;
call t_JSON_SET('JSON', 'SET', '{"a":1}' ) ;
drop procedure t_JSON_SET ;
drop procedure print_message;

--+ server-message off
