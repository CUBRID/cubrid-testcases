--+ server-message on
-- Verification for CBRD-24832

create or replace procedure numeric_test(i numeric) as
	n1 numeric := i;
begin
	dbms_output.put_line('n1: ' || n1);
end;


select 'success, 38 digit' from dual;
call numeric_test(12345678901234567890123456789012345678);
select 'fail, 38 digit over' from dual;
call numeric_test(123456789012345678901234567890123456789);

select 'success, 0.38 digit' from dual;
call numeric_test(0.01234567890123456789012345678901234567);
select 'fail, 0.38 digit over' from dual;
call numeric_test(0.012345678901234567890123456789012345678);


select 'success, 19.19 digit' from dual;
call numeric_test(1234567890123456789.12345678901234567891);
select 'fail 19.20 digit' from dual;
call numeric_test(1234567890123456789.12345678901234567891);
select 'fail 20.19 digit' from dual;
call numeric_test(12345678901234567891.1234567890123456789);

drop procedure numeric_test;

--+ server-message off
