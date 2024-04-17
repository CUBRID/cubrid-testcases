--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by char type parameters.

-- bug
create or replace procedure t( ) as
    var_min CHAR(5) := 'a';
    var_max CHAR(5) := 'abc';
begin
    dbms_output.put_line('i_min=' || var_min || 'char');
    dbms_output.put_line('i_max=' || var_max || 'char');

    var_min := '123' || 'abcde';
    var_max := '321';
    dbms_output.put_line('i_min=' || var_min ||'xyz');
    dbms_output.put_line('i_max=' || var_max ||'xyz');
end;

call t();

select cast('a' as char(5) ) ||'char';


-- bug
create or replace procedure t(i_min CHAR(5), i_max CHAR(5) ) as
    var_min CHAR(5) := i_min;
    var_max CHAR(5) := i_max;
begin
    dbms_output.put_line('i_min=' || var_min || 'char');
    dbms_output.put_line('i_max=' || var_max ||'char');
end;

call t('a', 'abc');

call t('abcd1234', 'abcde12345');

select cast('a' as char(5) ) ||'abc';

drop procedure t;


--+ server-message off

