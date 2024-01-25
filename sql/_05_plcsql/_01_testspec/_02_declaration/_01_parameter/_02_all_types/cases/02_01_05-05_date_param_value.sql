--+ server-message on

--A test case that delivers values exceeding the minimum and maximum values supported by date type parameters.

-- normal
create or replace procedure t( ) as
    var_min DATE := to_date('0001-01-01','YYYY-MM-DD');
    var_max DATE := to_date('9999-12-31','YYYY-MM-DD');
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := DATE'2023-10-31' ;  //DATE'00-10-31' ;
    var_max := DATE'2000-10-31';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();


--bug
select 'An error should occur if "DATE'00-10-31'" is assigned to a date variable, but an error occurred. This is a bug.';
create or replace procedure t( ) as
    var_min DATE := to_date('0001-01-01','YYYY-MM-DD');
    var_max DATE := to_date('9999-12-31','YYYY-MM-DD');
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);

    var_min := DATE'00-10-31' ;
    var_max := DATE'2000-10-31';
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;

call t();

select DATE'00-10-31';


--normal
create or replace procedure t(i_min DATE, i_max DATE ) as
    var_min DATE := i_min;
    var_max DATE := i_max;
begin
    dbms_output.put_line('i_min=' || var_min);
    dbms_output.put_line('i_max=' || var_max);
end;
call t('0001-01-01','9999-12-31');

call t(to_date('0001-01-01','YYYY-MM-DD'), to_date('9999-12-31','YYYY-MM-DD') );

call t(to_date('01/01/0001','MM/DD/YYYY'), to_date('12/31/9999','MM/DD/YYYY') );

call t(DATE'00-10-31', DATE'70-10-31' );

call t('01/01/0001','12/31/9999');

call t('0001-01-00','9999-12-31'); --error


drop procedure t;


--+ server-message off

