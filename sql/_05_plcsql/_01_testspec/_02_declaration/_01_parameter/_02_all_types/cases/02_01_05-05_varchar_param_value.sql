--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by varchar type parameters.

-- normal
create or replace procedure t( ) as
    var_min VARCHAR(5) := 'abcdefg';
    var_max VARCHAR(5) := '12345xyz';
begin
    dbms_output.put_line('i_min=' || var_min || 'char');
    dbms_output.put_line('i_max=' || var_max || 'char');

    var_min := var_min ||'123' || 'abcde';
    var_max := var_max || '321';
    dbms_output.put_line('i_min=' || var_min ||'xyz');
    dbms_output.put_line('i_max=' || var_max ||'xyz');
end;

call t();


-- normal
create or replace procedure t(i_min VARCHAR(5), i_max VARCHAR(5) ) as
    var_min VARCHAR(5) := i_min;
    var_max VARCHAR(5) := i_max;
begin
    dbms_output.put_line('i_min=' || var_min || 'varchar');
    dbms_output.put_line('i_max=' || var_max || 'varchar');
end;

call t('a', 'abc');

call t('abcd1234', 'abcde12345');

drop procedure t;


--+ server-message off

