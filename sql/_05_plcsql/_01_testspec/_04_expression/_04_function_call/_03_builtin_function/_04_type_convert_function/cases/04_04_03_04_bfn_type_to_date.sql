--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TO_DATE(NULL, 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATE('01/11/1999', NULL));
    dbms_output.put_line(TO_DATE('1/11/1999', 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATE('01/11/1999', 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATE('1999-01-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_DATE('1999-01-11', 'YYYY-MM-DD'));
    dbms_output.put_line(TO_DATE('01/11/99', 'MM/DD/YY'));
    dbms_output.put_line(TO_DATE('1/11/1999', 'MM/DD/YYYY'));
    dbms_output.put_line(TO_DATE('1999-01 JAN', 'YYYY-DD MON'));
    dbms_output.put_line(TO_DATE('1999-01 MAY', 'YYYY-DD MONTH'));
    dbms_output.put_line(TO_DATE('1999-11-11 THURSDAY', 'YYYY-MM-DD DAY'));
    dbms_output.put_line(TO_DATE('12/may/1999', 'dd/mon/yyyy', 'en_US')); -- TO_DATE 3rd arg parse error
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
