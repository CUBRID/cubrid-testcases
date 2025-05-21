--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by short type parameters. 

create or replace procedure t( ) as
    var_min short := -32768;
    var_max short := 32767;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -32769;
    var_max := 32768;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();


create or replace procedure t(i_min short, i_max short ) as
    var_min smallint := i_min;
    var_max smallint := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t( -32768, 32767 );


call t(-32769, 0);

call t(0, 32768);

drop procedure t;

select cast( -32769 as short);

--+ server-message off

