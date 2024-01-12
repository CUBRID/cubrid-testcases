--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(ADDTIME(NULL, NULL));
    dbms_output.put_line(ADDTIME(TO_DATETIME('1999-01-08'), NULL));
    dbms_output.put_line(ADDTIME(TO_DATE('1999-01-08'), NULL));
    dbms_output.put_line(ADDTIME(TO_TIME('12:00:00'), NULL));
    dbms_output.put_line(ADDTIME(TIMESTAMP('1999-01-08 12:00:00'), NULL));
    dbms_output.put_line(ADDTIME(NULL, TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TO_DATETIME('1999-01-08'), TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TO_DATE('1999-01-08'), TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TO_TIME('12:00:00'), TO_TIME('02:30:52')));
    dbms_output.put_line(ADDTIME(TIMESTAMP('1999-01-08 12:00:00'), TO_TIME('02:30:52')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
