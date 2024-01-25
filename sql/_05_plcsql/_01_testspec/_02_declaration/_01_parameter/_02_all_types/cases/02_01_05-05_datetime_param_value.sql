--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by datetime type parameters.

-- normal
create or replace procedure t( ) as
    var_min DATETIME := DATETIME'0001-01-01 00:00:00.000';
    var_max DATETIME := DATETIME'1999-12-31 23:59:59.999';
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := DATETIME'10/31/2023';
    var_max := DATETIME'10/31/2008';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();


-- bug - DATETIME'9999-12-31 23:59:59.999'
create or replace procedure t( ) as
    var_min DATETIME := DATETIME'0001-01-01 00:00:00.000';
    var_max DATETIME := DATETIME'9999-12-31 23:59:59.999';
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := DATETIME'10/31/2023';
    var_max := DATETIME'10/31/2008';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

select DATETIME'9999-12-31 23:59:59.999'; 



-- normal
create or replace procedure t(i_min DATETIME, i_max DATETIME ) as
    var_min DATETIME := i_min;
    var_max DATETIME := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(DATETIME'0001-01-01 00:00:00.000', DATETIME'9999-12-31 23:59:59.999');

call t( DATETIME'10/31/2023', DATETIME'10/31/2008' );

call t( DATETIME'10/31/2023', DATETIME'13/31/2008' );

drop procedure t;


--+ server-message off

