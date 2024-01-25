--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by time type parameters.

-- normal
create or replace procedure t( ) as
    var_min TIME := to_time('00:00:00', 'HH24:MI:SS');
    var_max TIME := to_time('12:59:59', 'HH24:MI:SS');
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := TIME'1:15';
    var_max := TIME'13:15:45';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();


-- normal
create or replace procedure t(i_min TIME, i_max TIME ) as
    var_min TIME := i_min;
    var_max TIME := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(TIME'00:00:00', TIME'23:59:59');

call t(TIME'1:15', TIME'13:15:45');

call t(TIME'1:15', TIME'13:15:45 am');

call t(TIME'25:15', TIME'13:15:45 am'); --error

call t(TIME'1:15', TIME'13:15:61 am'); --error

drop procedure t;


--+ server-message off

