--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by timestamp type parameters.

-- normal
create or replace procedure t( ) as
    var_min TIMESTAMP := TIMESTAMP'1970-01-01 09:00:01';
    var_max TIMESTAMP := TIMESTAMP'1970-01-01 09:00:01';
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := TIMESTAMP'1970-01-01 09:00:01';
    var_max := TIMESTAMP'1970-01-01 09:00:01';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();

-- bug - TIMESTAMP'1970-01-01 09:00:00'
create or replace procedure t( ) as
    var_min TIMESTAMP := TIMESTAMP'1970-01-01 09:00:00';
    var_max TIMESTAMP := TIMESTAMP'1970-01-01 09:00:00';
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := TIMESTAMP'1974-01-01 09:00:00';
    var_max := TIMESTAMP'1974-01-01 09:00:00';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

select TIMESTAMP'1973-01-01 09:00:00';



-- normal
create or replace procedure t(i_min TIMESTAMP, i_max TIMESTAMP ) as
    var_min TIMESTAMP := i_min;
    var_max TIMESTAMP := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(TIMESTAMP'1970-01-01 09:00:01', TIMESTAMP'2038-01-19 12:14:07'  );

call t(TIMESTAMP'1970-01-01 09:00:00', TIMESTAMP'2038-01-19 12:14:07'  );

call t(TIMESTAMP'10/31', TIMESTAMP'10/31/2008');

call t(TIMESTAMP'10/31', TIMESTAMP'10/32/2008'); --error

drop procedure t;


--+ server-message off

