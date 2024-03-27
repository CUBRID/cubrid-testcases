--+ server-message on
/*
Verification for CBRD-24481

Test: unescape escape sequences in strings & check on escape string
*/

create or replace procedure proc_unesc_test() as
begin
	dbms_output.put_line('\t');
    dbms_output.put_line('\b');
    dbms_output.put_line('\n');
    dbms_output.put_line('\r');
    dbms_output.put_line('\f');
    dbms_output.put_line('\''');
    dbms_output.put_line('\"');
    dbms_output.put_line('\\');
	dbms_output.put_line(' ''escape test'' ');
end;

select proc_unesc_test() from dual;

drop procedure proc_unesc_test;

--+ server-message off