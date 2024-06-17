--+ server-message on
-- verified the CBRD-24126

-- invalid type
create or replace procedure test_proc(a invalid_param) as
begin
	dbms_output.put_line('check invalid param');
end;

drop test_proc;

-- unsupported type
create or replace procedure test_proc1(a json) as
begin
    dbms_output.put_line('check unsupported param');
end;

drop procedure test_proc1;

-- unsupported type by javasp
create or replace procedure test_proc2(a blob) as language java name 'SpTest9.testblob()';

drop function test_proc2;

--_ server-message off
