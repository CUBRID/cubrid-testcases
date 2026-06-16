--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by numeric type parameters.

select '"12345.6789 is assigned to the decimal variable, and 12345.6789 is output';

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



create or replace procedure t(i_min NUMERIC, i_max NUMERIC) as
    var_min NUMERIC := i_min;
    var_max NUMERIC := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-0.123456789, 0.123456789 );
select cast( cast( 0.123456789 as numeric(4,4)) as NUMERIC);



select 'The procedure is created successfully because "NUMERIC(3,4)" is now valid and scale > precision is allowed.';

create or replace procedure t(i_min NUMERIC, i_max NUMERIC) as
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



select '"NUMERIC(3,4)" is now valid. scale > precision is allowed since the scale range was expanded to -84~127.';

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



select 'If the parameter value "12345.6789" is passed in the call statement, the same value is output because NUMERIC now supports floating precision.';

create or replace procedure t(i_min NUMERIC, i_max NUMERIC ) as
    var_min NUMERIC := i_min;
    var_max NUMERIC := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t(-12345.6789, 12345.6789);
select cast( 12345.6789 as NUMERIC );


drop procedure t;


--+ server-message off

