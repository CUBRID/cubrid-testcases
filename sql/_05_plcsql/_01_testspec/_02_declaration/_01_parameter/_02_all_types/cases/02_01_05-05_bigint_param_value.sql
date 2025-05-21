--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by bigint type parameters.

create or replace procedure t( ) as
    var_min BIGINT := -9223372036854775808;
    var_max BIGINT := 9223372036854775807;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -9223372036854775809;
    var_max := 9223372036854775808;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();



create or replace procedure t(i_min BIGINT, i_max BIGINT ) as
    var_min BIGINT := i_min;
    var_max BIGINT := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-9223372036854775808, 9223372036854775807 );

call t(-9223372036854775809, 0);

call t(0, 9223372036854775808);

drop procedure t;

select cast(-9223372036854775809 as bigint );


--+ server-message off

