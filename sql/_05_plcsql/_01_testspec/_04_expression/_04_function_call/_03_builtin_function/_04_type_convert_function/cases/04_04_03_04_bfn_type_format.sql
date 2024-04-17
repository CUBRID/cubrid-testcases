--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(FORMAT(NULL, 1));
    dbms_output.put_line(FORMAT(NULL, NULL));
    dbms_output.put_line(FORMAT(876543210987654321.09876543210987654321, NULL));
    /* value miss match */
    dbms_output.put_line(FORMAT(-876543210987654321.09876543210987654321, 4));
    dbms_output.put_line('-876,543,210,987,654,321.0988 is right');
    dbms_output.put_line(FORMAT(-876543210987654321.09876543210987654321, 8));
    dbms_output.put_line('-876,543,210,987,654,321.09876543 is right');
    dbms_output.put_line(FORMAT(-876543210987654321.09876543210987654321, 12));
    dbms_output.put_line('-876,543,210,987,654,321.098765432110 is right');
    dbms_output.put_line(FORMAT(-876543210987654321.09876543210987654321, 16));
    dbms_output.put_line('-876,543,210,987,654,321.0987654321098765 is right');
    dbms_output.put_line(FORMAT(-876543210987654321.09876543210987654321, 20));
    dbms_output.put_line('-876,543,210,987,654,321.09876543210987654321 is right');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
