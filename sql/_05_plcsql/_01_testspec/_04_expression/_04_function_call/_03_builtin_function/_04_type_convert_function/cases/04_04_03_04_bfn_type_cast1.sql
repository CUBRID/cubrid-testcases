--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- [CBRD-25866] fixed : CAST( AS ) parse error

    dbms_output.put_line('INTEGER');
    dbms_output.put_line(CAST(NULL AS INTEGER));
    dbms_output.put_line(CAST(NULL AS INTEGER));
    dbms_output.put_line(CAST('0' AS INTEGER));
    dbms_output.put_line(CAST('2147483647' AS INTEGER));
    dbms_output.put_line(CAST('-2147483648' AS INTEGER));

    dbms_output.put_line('-- INT');
    dbms_output.put_line(CAST(NULL AS INT));
    dbms_output.put_line(CAST('0' AS INT));
    dbms_output.put_line(CAST('2147483647' AS INT));
    dbms_output.put_line(CAST('-2147483648' AS INT));

    dbms_output.put_line('-- SHORT');
    dbms_output.put_line(CAST(NULL AS SHORT));
    dbms_output.put_line(CAST('0' AS SHORT));
    dbms_output.put_line(CAST('32767' AS SHORT));
    dbms_output.put_line(CAST('-32768' AS SHORT));

    dbms_output.put_line('-- SMALLINT');
    dbms_output.put_line(CAST(NULL AS SMALLINT));
    dbms_output.put_line(CAST('0' AS SMALLINT));
    dbms_output.put_line(CAST('32767' AS SMALLINT));
    dbms_output.put_line(CAST('-32768' AS SMALLINT));

    dbms_output.put_line('-- BIGINT');
    dbms_output.put_line(CAST(NULL AS BIGINT));
    dbms_output.put_line(CAST('0' AS BIGINT));
    dbms_output.put_line(CAST('9223372036854775807' AS BIGINT));
    dbms_output.put_line(CAST('-9223372036854775808' AS BIGINT));

    dbms_output.put_line('-- FLOAT');
    dbms_output.put_line(CAST(NULL AS FLOAT));
    dbms_output.put_line(CAST('0.0' AS FLOAT));
    dbms_output.put_line(CAST('3.402823466E+38' AS FLOAT));
    dbms_output.put_line(CAST('-3.402823466E+38' AS FLOAT));

    dbms_output.put_line('-- REAL');
    dbms_output.put_line(CAST(NULL AS REAL));
    dbms_output.put_line(CAST('0.0' AS REAL));
    dbms_output.put_line(CAST('3.402823466E+38' AS REAL));
    dbms_output.put_line(CAST('-3.402823466E+38' AS REAL));

    dbms_output.put_line('-- DOUBLE');
    dbms_output.put_line(CAST(NULL AS DOUBLE));
    dbms_output.put_line(CAST('0.0' AS DOUBLE));
    dbms_output.put_line(CAST('1.7976931348623157E+308' AS DOUBLE));
    dbms_output.put_line(CAST('-1.7976931348623157E+308' AS DOUBLE));

    dbms_output.put_line('-- DOUBLE PRECISION');
    dbms_output.put_line(CAST(NULL AS DOUBLE PRECISION));
    dbms_output.put_line(CAST('0.0' AS DOUBLE PRECISION));
    dbms_output.put_line(CAST('1.7976931348623157E+308' AS DOUBLE PRECISION));
    dbms_output.put_line(CAST('-1.7976931348623157E+308' AS DOUBLE PRECISION));

    dbms_output.put_line('-- NUMERIC');
    dbms_output.put_line(CAST(NULL AS NUMERIC));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS NUMERIC(38,0)));
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS NUMERIC(38,0)));
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS NUMERIC(38,0)));
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS NUMERIC(38,0)));
    dbms_output.put_line(CAST('0.87654321098765432109876543210987654321' AS NUMERIC(38,38)));
    dbms_output.put_line(CAST('-0.87654321098765432109876543210987654321' AS NUMERIC(38,38)));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
