--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by numeric type parameters.

select '"12345.6789" is assigned to the decimal variable, and "123456" is output, which is normal.';

create or replace procedure t( ) as
    var_min DECIMAL := -12345.6789;
    var_max DECIMAL := 12345.6789;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -12345.6789;
    var_max := 12345.6789;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(); 
select cast( 12345.6789 as DECIMAL) ;


select 'If the parameter value is passed as "0.123456789" in the call statement, the output should be "0.1235". It is processed normally.';
create or replace procedure t( ) as
    var_min DECIMAL(4,4) := -0.123456789;
    var_max DECIMAL(4,4) := 0.123456789;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -0.123456789;
    var_max := 0.123456789;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();
select cast( 0.123456789 as numeric(4,4)) ;



create or replace procedure t(i_min NUMERIC(4,4), i_max NUMERIC(4,4) ) as
    var_min NUMERIC := i_min;
    var_max NUMERIC := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-0.123456789, 0.123456789 );
select cast( cast( 0.123456789 as numeric(4,4)) as NUMERIC);



select 'This is a normal case because an error occurred in the parameter "NUMERIC(3,4)" when creating.';

create or replace procedure t(i_min NUMERIC(3,4), i_max NUMERIC(3,4) ) as
    var_min NUMERIC := i_min;
    var_max NUMERIC := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

create or replace procedure t(i_min NUMERIC, i_max NUMERIC ) as
    var_min NUMERIC(3,4) := i_min;
    var_max NUMERIC(3,4) := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;



--bug case
select 'An error should have occurred due to the variable's "decimal(3,4)" during creation, but it was created normally. This is a bug.';

create or replace procedure t( ) as
    var_min DECIMAL(3,4) := -12345.6789;
    var_max DECIMAL(3,4) := 12345.6789;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := -12345.6789;
    var_max := 12345.6789;
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;



--bug case
select 'If the parameter value is passed as "12345.6789" in the call statement, the output should be "12346". Currently "12345.6789" is being output.';

create or replace procedure t(i_min NUMERIC, i_max NUMERIC ) as
    var_min NUMERIC := i_min;
    var_max NUMERIC := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-12345.6789, 12345.6789); --bug
select cast( 12345.6789 as NUMERIC );


drop procedure t;


--+ server-message off

