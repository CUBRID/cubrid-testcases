--+ server-message on
-- verified the CBRD-24126

create or replace procedure test_proc(a invalid_param) as
begin
	dbms_output.put_line('check invalid param');
end;

drop test_proc;

--_ server-message off
