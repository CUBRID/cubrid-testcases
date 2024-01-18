--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TRUNCATE(0.4)); -- TRUNCATE word parse error. might be confused with TRUNCATE TABLE
    dbms_output.put_line(TRUNC(0.4));
    dbms_output.put_line(TRUNC(0.5));
    dbms_output.put_line(TRUNC(0.40));
    dbms_output.put_line(TRUNC(0.500));
    dbms_output.put_line(TRUNC(TRUNC(34567.34567, 3)));
    dbms_output.put_line(TRUNC(TRUNC(-34567.34567, 3)));

    dbms_output.put_line('---------');
    dbms_output.put_line(TRUNC(date'2022-11-19', 'yyyy')); -- parse error on delimiter date'
    dbms_output.put_line(TRUNC(date'2022-11-19', 'mm')); -- parse error on delimiter date'
    dbms_output.put_line(TRUNC(date'2022-11-19', 'dd')); -- parse error on delimiter date'
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
