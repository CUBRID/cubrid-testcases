--+ server-message on
-- The output order of dbms_output.put_line is strange.
-- Error:-889 Stored procedure execute error:   (line 9, column 48) division by zero

select 'This test throws an execution error. ( t_string, string )' as t_string;

create or replace procedure t_exe_error_string_string( tc_comment string ) as
    left_string                   string        := '123';
    right_string                  string        := '999';

begin
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string = ' || NVL(left_string,'NULL') );
    dbms_output.put_line('right_string = ' || NVL(right_string,'NULL') );
    dbms_output.put_line('***************************************');
    dbms_output.put_line('left_string div 0 = ' || left_string div 0 ) ;
    dbms_output.put_line('');
end;

call t_exe_error_string_string(' Integer Arithmetic operations : string, string ' );

drop procedure t_exe_error_string_string;

--+ server-message off
