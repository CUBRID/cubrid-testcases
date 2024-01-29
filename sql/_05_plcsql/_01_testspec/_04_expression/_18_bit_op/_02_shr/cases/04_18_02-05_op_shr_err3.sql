--+ server-message on

-- wrong answer of operator '>>'

create or replace procedure t () as
begin
    dbms_output.put_line('-1' >> '1');
    dbms_output.put_line('9223372036854775807 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(-1 >> 1);
    dbms_output.put_line('9223372036854775807 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(-1 >> -1);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(1234567890 >> 128);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(1234567890 >> 123456789);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(9223372036854775807 >> -9223372036854775807);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(-9223372036854775807 >> 9223372036854775807);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(-9223372036854775807 >> -9223372036854775807);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(-9223372036854775807 >> -1);
    dbms_output.put_line('0 expected');
    dbms_output.put_line('---------');

    dbms_output.put_line(((9223372036854775807 >> -9223372036854775807) >> 2));
    dbms_output.put_line('0 expected');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
