--+ server-message on
-- verified the CBRD-25549
-- If an exception occurs while running SP, CSQL does not output the message put_line until then.

create or replace procedure poo as
begin
    dbms_output.put_line('hello');
    dbms_output.put_line(1/0);
end;

call poo();
select * from dual;

drop procedure poo;


--+ server-message off


