--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(DAYOFMONTH(NULL)); -- parse NULL param error
    dbms_output.put_line(DAYOFMONTH('1999-01-11 12:34:52.333'));
    dbms_output.put_line(DAYOFMONTH('1999-01-11 12:34:52'));
    dbms_output.put_line(DAYOFMONTH('1999-01-11'));
    dbms_output.put_line(DAYOFMONTH('0000-00-00 00:00:00.000'));
    dbms_output.put_line(DAYOFMONTH('0000-00-00 00:00:00'));
    dbms_output.put_line(DAYOFMONTH('0000-00-00'));

    dbms_output.put_line(DAYOFWEEK(NULL)); -- parse NULL param error
    dbms_output.put_line(DAYOFWEEK('1999-01-11 12:34:52.333'));
    dbms_output.put_line(DAYOFWEEK('1999-01-11 12:34:52'));
    dbms_output.put_line(DAYOFWEEK('1999-01-11'));

    dbms_output.put_line(DAYOFYEAR(NULL)); -- parse NULL param error
    dbms_output.put_line(DAYOFYEAR('1999-01-11 12:34:52.333'));
    dbms_output.put_line(DAYOFYEAR('1999-01-11 12:34:52'));
    dbms_output.put_line(DAYOFYEAR('1999-01-11'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
