--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by float type parameters.

--bug
select 'An error should occur if "3.402823466E+39" is assigned to a decimal variable, but "Infinity" is output. This is a bug.';

create or replace procedure t( ) as
    var_min REAL := -3.402823466E+38;
    var_max REAL := 3.402823466E+38;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -3.402823466E+39;
    var_max := 3.402823466E+39;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();



create or replace procedure t(i_min FLOAT, i_max FLOAT ) as
    var_min FLOAT := i_min;
    var_max FLOAT := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;
-- normal
call t(-3.402823466E+38, 3.402823466E+38);

--bug
call t(-3.402823466E+39, 0);  --bug
--bug
call t(0, 3.402823466E+39);  --bug

select cast(-3.402823466E+39 as float);

drop procedure t;


--+ server-message off

