--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- CAST( AS ) parse error
    dbms_output.put_line('-- CHAR');
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS CHAR));
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS CHAR(10)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS CHAR(20)));
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS CHAR(30)));
    dbms_output.put_line(CAST('0.87654321098765432109876543210987654321' AS CHAR(100)));
    dbms_output.put_line(CAST('-0.87654321098765432109876543210987654321' AS CHAR(1000)));

    dbms_output.put_line('-- VARCHAR');
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS VARCHAR));
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS VARCHAR(10)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS VARCHAR(20)));
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS VARCHAR(30)));
    dbms_output.put_line(CAST('0.87654321098765432109876543210987654321' AS VARCHAR(100)));
    dbms_output.put_line(CAST('-0.87654321098765432109876543210987654321' AS VARCHAR(1000)));

    dbms_output.put_line('-- BIT');
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(10)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(20)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(50)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(100)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(1000)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(1000)));

    dbms_output.put_line('-- BIT VARYING');
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(10)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(20)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(50)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(100)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(1000)));

    dbms_output.put_line('-- DATE');
    dbms_output.put_line(CAST('1/1/99' AS DATE));
    dbms_output.put_line(CAST('10/09/1999' AS DATE));
    dbms_output.put_line(CAST('1999-1-1' AS DATE));

    dbms_output.put_line('-- TIME');
    dbms_output.put_line(CAST('00:00' AS TIME));
    dbms_output.put_line(CAST('11:59' AS TIME));
    dbms_output.put_line(CAST('23:59:59' AS TIME));
    dbms_output.put_line(CAST('11:59:59 am' AS TIME));
    dbms_output.put_line(CAST('11:59:59 pm' AS TIME));

    dbms_output.put_line('-- DATETIME');
    dbms_output.put_line(CAST('00:00 01/01/99' AS DATETIME));
    dbms_output.put_line(CAST('00:00 01/01/1999' AS DATETIME));
    dbms_output.put_line(CAST('10:00 am 01/01/1999' AS DATETIME));
    dbms_output.put_line(CAST('10:00 pm 01/01/1999' AS DATETIME));
    dbms_output.put_line(CAST('00:00:00.998 1/1' AS DATETIME));
    dbms_output.put_line(CAST('00:00:00.998 01/01' AS DATETIME));
    dbms_output.put_line(CAST('00:00:00.998 01/01/99' AS DATETIME));
    dbms_output.put_line(CAST('00:00:00.998 01/01/1999' AS DATETIME));
    dbms_output.put_line(CAST('10:00:00.998 am 01/01/1999' AS DATETIME));
    dbms_output.put_line(CAST('10:00:00.998 pm 01/01/1999' AS DATETIME));

    dbms_output.put_line('-- TIMESTAMP');
    dbms_output.put_line(CAST('00:00 01/01/99' AS TIMESTAMP));
    dbms_output.put_line(CAST('00:00 01/01/1999' AS TIMESTAMP));
    dbms_output.put_line(CAST('10:00 am 01/01/1999' AS TIMESTAMP));
    dbms_output.put_line(CAST('10:00 pm 01/01/1999' AS TIMESTAMP));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
