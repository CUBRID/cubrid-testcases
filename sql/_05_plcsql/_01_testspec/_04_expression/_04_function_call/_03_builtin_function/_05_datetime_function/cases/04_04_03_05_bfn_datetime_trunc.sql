--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TRUNC(NULL, NULL));
    dbms_output.put_line(TRUNC(TO_DATETIME('1999-01-11 12:34:52.333'), NULL));

    dbms_output.put_line(TRUNC(TO_DATETIME('1995-06-11 12:34:52.333'), 'yyyy'));
    dbms_output.put_line(TRUNC(TIMESTAMP('1999-07-11 12:34:52.333'), 'YY'));
    dbms_output.put_line(TRUNC(TO_DATE('1999-01-11'), 'mm'));
    dbms_output.put_line(TRUNC(TO_DATETIME('1999-03-11 12:34:52.333'), 'MONTH'));
    dbms_output.put_line(TRUNC(TIMESTAMP('1999-05-11 12:34:52'), 'q'));
    dbms_output.put_line(TRUNC(TO_DATE('1999-01-11'),'DAY'));
    dbms_output.put_line(TRUNC(TO_DATE('1999-01-11'), 'dd'));
    dbms_output.put_line(TRUNC(TO_DATETIME('1999-01-11 23:59:59.533'), 'SS'));
    dbms_output.put_line(TRUNC(TIMESTAMP('1999-01-11 23:59:59.533'), 'MI'));
    dbms_output.put_line(TRUNC(TO_DATETIME('1999-01-11 23:59:59.533'), 'HH'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
