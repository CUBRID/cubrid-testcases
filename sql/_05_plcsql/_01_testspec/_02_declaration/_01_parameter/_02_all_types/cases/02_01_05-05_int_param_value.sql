--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by int type parameters. 

create or replace procedure t( ) as
    var_min INT := -2147483648;
    var_max INT := 2147483647;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -2147483649;
    var_max := 2147483648;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();


create or replace procedure t(i_min int, i_max int ) as
    var_min integer := i_min;
    var_max integer := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-2147483648, 2147483647);

call t(-2147483649, 0);

call t(0, 2147483648);

drop procedure t;

select cast( -2147483649 as int);

--+ server-message off

