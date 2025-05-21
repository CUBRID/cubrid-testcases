--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(date_time)');
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY'));
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH12:MI:SS.FF AM MON MM/DD/YY CC-Q-DY'));
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH24:MI:SS P.M. MONTH MM/DD/YYYY CC-Q-DAY D-d'));

    dbms_output.put_line('-- TO_CHAR(number)');
    dbms_output.put_line(TO_CHAR(1234567,'9,999,999,999'));
    dbms_output.put_line(TO_CHAR(1234567,'9,999,999.999'));
    dbms_output.put_line(TO_CHAR(1234567890123456789,'9,999,999.999'));
    dbms_output.put_line(TO_CHAR(1234567890.123456789,'9,999,999.999'));
    dbms_output.put_line(TO_CHAR(123.4567,'999.99999'));
    dbms_output.put_line(TO_CHAR(123.4567,'99999.999'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();


evaluate 'CBRD-25302: TO_CHAR 3rd arg parse error (NUMERIC: intl_date_lang=en_US)';
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(NUMERIC: 2 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_CHAR(123.456,'999.999'));
    dbms_output.put_line('-- TO_CHAR(3 arguments - en_US, ko_KR): intl_date_lang=en_US');
    dbms_output.put_line(TO_CHAR(123.456,'999.999','en_US'));
    dbms_output.put_line(TO_CHAR(123.456,'999.999','ko_KR'));
end;

call t();

evaluate 'CBRD-25302: TO_CHAR 3rd arg parse error (TO_DATE: intl_date_lang=en_US)';
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(TO_DATE: 2 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_CHAR(TO_DATE('01/11/1999'), 'dd/mon/yyyy'));
    dbms_output.put_line('-- TO_CHAR(TO_DATE: 3 arguments - en_US, ko_KR): intl_date_lang=en_US');
    dbms_output.put_line(TO_CHAR(TO_DATE('01/11/1999'), 'dd/mon/yyyy', 'en_US'));
    dbms_output.put_line(TO_CHAR(TO_DATE('01/11/1999'), 'dd/mm/yyyy', 'ko_KR'));
end;

call t();


evaluate 'CBRD-25302: TO_CHAR 3rd arg parse error (TO_DATETIME: intl_date_lang=en_US)';
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(TO_DATETIME: 2 arguments): intl_date_lang=en_US');
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY'));
    dbms_output.put_line('-- TO_CHAR(TO_DATETIME: 3 arguments - en_US, ko_KR): intl_date_lang=en_US');
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY', 'en_US'));
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY', 'ko_KR'));
end;

call t();


set system parameters 'intl_date_lang=ko_KR';


evaluate 'CBRD-25302: TO_CHAR 3rd arg parse error (NUMERIC: intl_date_lang=ko_KR)';
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(2 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_CHAR(123.456,'999.999'));
    dbms_output.put_line('-- TO_CHAR(3 arguments - en_US, ko_KR): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_CHAR(123.456,'999.999','en_US'));
    dbms_output.put_line(TO_CHAR(123.456,'999.999','ko_KR'));
end;

call t();

evaluate 'CBRD-25302: TO_CHAR 3rd arg parse error (TO_DATE: intl_date_lang=ko_KR)';
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(TO_DATE: 2 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_CHAR(TO_DATE('01/11/1999'), 'dd/mm/yyyy'));
    dbms_output.put_line('-- TO_CHAR(TO_DATE: 3 arguments - en_US, ko_KR): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_CHAR(TO_DATE('01/11/1999'), 'dd/mon/yyyy', 'en_US'));
    dbms_output.put_line(TO_CHAR(TO_DATE('01/11/1999'), 'dd/mm/yyyy', 'ko_KR'));
end;

call t();

evaluate 'CBRD-25302: TO_CHAR 3rd arg parse error (TO_DATETIME: intl_date_lang=ko_KR)';
create or replace procedure t () as
begin
    dbms_output.put_line('-- TO_CHAR(TO_DATETIME: 2 arguments): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY'));
    dbms_output.put_line('-- TO_CHAR(TO_DATETIME: 3 arguments - en_US, ko_KR): intl_date_lang=ko_KR');
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY', 'en_US'));
    dbms_output.put_line(TO_CHAR(TO_DATETIME('18:41:53.733 01/11/1999'), 'HH:MI:SS.FF AM MM/DD/YYYY', 'ko_KR'));
end;

call t();


set system parameters 'intl_date_lang=en_US';

drop procedure t;

evaluate 'CBRD-25302: select to_char(?, ?, ?)';
prepare st from 'select to_char(?, ?, ?) from dual';
execute st using 123.456, '999.999', 'en_US';
drop prepare st;

--+ server-message off
