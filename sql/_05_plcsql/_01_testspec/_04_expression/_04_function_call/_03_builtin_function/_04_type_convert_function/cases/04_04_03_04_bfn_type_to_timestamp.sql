--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TO_TIMESTAMP(NULL, 'MM/DD/YYYY'));
    dbms_output.put_line(TO_TIMESTAMP('01/11/1999', NULL));

    dbms_output.put_line('-- TO_TIMESTAMP(date input)');
    dbms_output.put_line(TO_TIMESTAMP('01/11/1999', 'MM/DD/YYYY'));
    dbms_output.put_line(TO_TIMESTAMP('1999-01-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_TIMESTAMP('1999-1-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_TIMESTAMP('19990111', 'YYYYMMDD'));

    dbms_output.put_line('-- TO_TIMESTAMP(date with time input)');
    dbms_output.put_line(TO_TIMESTAMP('01/11/1999 18:41:53', 'MM/DD/YYYY HH24:MI:SS'));
    dbms_output.put_line(TO_TIMESTAMP('01/11/1999 6:41:53 PM', 'MM/DD/YYYY HH12:MI:SS PM'));

    dbms_output.put_line('-- TO_TIMESTAMP(extra)');
    dbms_output.put_line(TO_TIMESTAMP('YEAR: 2008 DATE: 12-25 TIME: 13:10:30', '"YEAR:" YYYY "DATE:" MM-DD "TIME:" HH24:MI:SS'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
