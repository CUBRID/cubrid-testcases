--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(DATEDIFF(NULL, NULL));
    dbms_output.put_line(DATEDIFF(TO_DATE('0000-00-00'), NULL));
    dbms_output.put_line(DATEDIFF(NULL, TO_DATE('00/00/0000')));
    
    dbms_output.put_line(DATEDIFF(TO_DATE('1999-01-11'), TO_DATE('1999-01-10')));
    dbms_output.put_line(DATEDIFF(TO_DATETIME('1999-01-11'), TO_DATETIME('1999-01-10')));
    dbms_output.put_line(DATEDIFF(TIMESTAMP('1999-01-11'), TIMESTAMP('1999-01-10')));

    dbms_output.put_line(DATEDIFF(TO_DATE('1999-02-11'), TO_DATE('1999-01-10')));
    dbms_output.put_line(DATEDIFF(TO_DATETIME('1999-03-11'), TO_DATETIME('1999-01-10')));
    dbms_output.put_line(DATEDIFF(TIMESTAMP('2000-04-11'), TIMESTAMP('1999-01-10')));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
