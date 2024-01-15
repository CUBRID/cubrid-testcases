--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- parse param error on TIMEDIFF()
    /*
    dbms_output.put_line(TIMEDIFF(NULL, NULL));
    dbms_output.put_line(TIMEDIFF(TO_DATE('0000-00-00'), NULL));
    dbms_output.put_line(TIMEDIFF(NULL, TO_DATE('00/00/0000')));

    dbms_output.put_line(TIMEDIFF(TO_DATE('1999-01-11'), TO_TIME('23:59:59')));
    dbms_output.put_line(TIMEDIFF(TO_TIME('12:34:52'), TO_TIME('00:00:00')));
    dbms_output.put_line(TIMEDIFF(TO_DATETIME('1999-01-11 12:34:52.533'), '1999-01-11 00:01:01'));
    dbms_output.put_line(TIMEDIFF(TIMESTAMP('1999-01-11 12:34:52.533'), '1999-01-11 11:11:11'));
    */
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
