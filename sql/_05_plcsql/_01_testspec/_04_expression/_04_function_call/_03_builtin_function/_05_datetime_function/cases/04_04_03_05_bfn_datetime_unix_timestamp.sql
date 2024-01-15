--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(UNIX_TIMESTAMP(NULL)); -- parse NULL param error
    -- 0000-00-00 date/datetime value convert error
    /*
    dbms_output.put_line(UNIX_TIMESTAMP(TO_DATETIME('0000-00-00 00:00:00.000')));
    dbms_output.put_line(UNIX_TIMESTAMP(TIMESTAMP('0000-00-00 00:00:00.000')));
    dbms_output.put_line(UNIX_TIMESTAMP(TO_DATE('0000-00-00')));
    */
    dbms_output.put_line(UNIX_TIMESTAMP(TO_DATETIME('12:34:52.599 01/11/1999')));
    dbms_output.put_line(UNIX_TIMESTAMP(TIMESTAMP('1999-01-10 01:24:53.522')));
    dbms_output.put_line(UNIX_TIMESTAMP(TO_DATE('1/10/1999')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
