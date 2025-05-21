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
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();


-- CBRD-25302: TO_DATE 3rd arg parse error
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_DATE(2 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_DATE('12/05/1999', 'dd/mm/yyyy'));
    dbms_output.put_line('-- TO_DATE(3 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_DATE('12/may/1999', 'dd/mon/yyyy', 'en_US'));
    dbms_output.put_line(TO_DATE('12/05/1999', 'dd/mm/yyyy', 'ko_KR'));
end;

call t();


set system parameters 'intl_date_lang=ko_KR';

create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_DATE(2 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_DATE('12/05/1999', 'dd/mm/yyyy'));
    dbms_output.put_line('-- TO_DATE(3 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_DATE('12/may/1999', 'dd/mon/yyyy', 'en_US'));
    dbms_output.put_line(TO_DATE('12/05/1999', 'dd/mm/yyyy', 'ko_KR'));
end;

call t();

set system parameters 'intl_date_lang=en_US';

drop procedure t;

--CBRD-25302
prepare st from 'select to_date(?, ?, ?) from dual';
execute st using '12/may/1999', 'dd/mon/yyyy', 'en_US';
drop prepare st;

--+ server-message off
