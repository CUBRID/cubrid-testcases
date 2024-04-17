--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by double type parameters.

--bug
select 'An error should occur if "1.7976931348623157E+309" is assigned to a decimal variable, but "Infinity" is output. This is a bug.';

create or replace procedure t( ) as
    var_min DOUBLE PRECISION := -1.7976931348623157E+308;
    var_max DOUBLE PRECISION := 1.7976931348623157E+308;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -1.7976931348623157E+309;
    var_max := 1.7976931348623157E+309;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();


--normal
create or replace procedure t(i_min DOUBLE, i_max DOUBLE ) as
    var_min DOUBLE := i_min;
    var_max DOUBLE := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-1.7976931348623157E+308, +1.7976931348623157E+308);
call t(-1.7976931348623157E+309, 0);
call t(0, +1.7976931348623157E+309);


drop procedure t;


--+ server-message off

