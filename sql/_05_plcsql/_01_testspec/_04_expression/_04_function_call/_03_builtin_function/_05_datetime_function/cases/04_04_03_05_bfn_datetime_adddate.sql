--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line('-- ADDDATE() basic option');
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), NULL));

    -- [CBRD-25866] fixed : ADDDATE() INTERVAL delimiter '' and option parse error
    dbms_output.put_line(ADDDATE(NULL, INTERVAL 123 MILLISECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 123 MILLISECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 123 SECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 123 MINUTE));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 123 HOUR));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 123 DAY));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 123 WEEK));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 12 MONTH));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 12 QUARTER));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL 12 YEAR));

    dbms_output.put_line('-- ADDDATE() extra option');
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '123.-4' SECOND_MILLISECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '59:00.999' MINUTE_MILLISECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12:12' MINUTE_SECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12:12:12.123' HOUR_MILLISECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12:12:12' HOUR_SECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12:12' HOUR_MINUTE));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12 12:12:12.123' DAY_MILLISECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12 12:12:12' DAY_SECOND));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12 12:12' DAY_MINUTE));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12 12' DAY_HOUR));
    dbms_output.put_line(ADDDATE(TO_DATETIME('1999-01-08'), INTERVAL '12-13' YEAR_MONTH));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

-- parse error
create or replace procedure t () as
begin
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), NULL));
end;

create or replace procedure t () as
begin
    dbms_output.put_line('-- DATE_ADD() basic option');

    -- [CBRD-25866] fixed : DATE_ADD() INTERVAL delimiter '' and option parse error
    dbms_output.put_line(DATE_ADD(NULL, INTERVAL 123 MILLISECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 123 MILLISECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 123 SECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 123 MINUTE));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 123 HOUR));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 123 DAY));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 123 WEEK));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 12 MONTH));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 12 QUARTER));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL 12 YEAR));

    dbms_output.put_line('-- DATE_ADD() extra option');
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '123.-4' SECOND_MILLISECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '59:00.999' MINUTE_MILLISECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12:12' MINUTE_SECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12:12:12.123' HOUR_MILLISECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12:12:12' HOUR_SECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12:12' HOUR_MINUTE));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12 12:12:12.123' DAY_MILLISECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12 12:12:12' DAY_SECOND));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12 12:12' DAY_MINUTE));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12 12' DAY_HOUR));
    dbms_output.put_line(DATE_ADD(TO_DATETIME('1999-01-08'), INTERVAL '12-13' YEAR_MONTH));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
