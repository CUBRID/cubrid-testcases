--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(MONTHS_BETWEEN(NULL, NULL)); -- parse NULL param error
    -- dbms_output.put_line(MONTHS_BETWEEN(TO_DATETIME('1999-01-11 12:34:52.333'), NULL)));  -- parse NULL param error
    dbms_output.put_line(MONTHS_BETWEEN(NULL, TO_DATETIME('1999-01-11 12:34:52.333')));

    dbms_output.put_line(MONTHS_BETWEEN(TO_DATETIME('1999-01-11 12:34:52.333'), TO_DATETIME('1999-02-11 12:34:52.333')));
    dbms_output.put_line(MONTHS_BETWEEN(TIMESTAMP('1999-01-11 12:34:52.333'), TO_DATETIME('1999-02-11 12:34:52.333')));
    dbms_output.put_line(MONTHS_BETWEEN(TO_DATE('1999-01-11'), TO_DATETIME('1999-02-11')));

    dbms_output.put_line(MONTHS_BETWEEN(TO_DATETIME('1999-02-11 12:34:52.333'), TIMESTAMP('1999-01-11 12:34:52.333')));
    dbms_output.put_line(MONTHS_BETWEEN(TIMESTAMP('1999-02-11 12:34:52.333'), TIMESTAMP('1999-01-11 12:34:52.333')));
    dbms_output.put_line(MONTHS_BETWEEN(TO_DATE('1999-02-11'), TIMESTAMP('1999-01-11')));

    dbms_output.put_line(MONTHS_BETWEEN(TO_DATETIME('1999-01-11 12:34:52.333'), TO_DATETIME('1999-01-11 12:34:52.333')));
    dbms_output.put_line(MONTHS_BETWEEN(TIMESTAMP('1999-01-11 12:34:52.333'), TO_DATETIME('1999-01-11 12:34:52.333')));
    dbms_output.put_line(MONTHS_BETWEEN(TO_DATE('1999-01-11'), TO_DATETIME('1999-01-11')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
