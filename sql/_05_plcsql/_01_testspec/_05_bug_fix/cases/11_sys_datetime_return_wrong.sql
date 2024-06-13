--+ server-message on
-- verified the CBRD-25071

create or replace procedure test_sys_datetime as
begin
    dbms_output.put_line(case when sys_datetime is null then 'case1: null' else 'case1: not null' end);
	dbms_output.put_line(case when sys_datetime = null then 'case2: null' else 'case2: not null' end);
	dbms_output.put_line(NVL2(sys_datetime, 'nvl2: not null', 'nvl2: null'));
	dbms_output.put_line(decode(sys_datetime , null, 'decode: null', 'decode: not null'));
end;

call test_sys_datetime();

drop procedure test_sys_datetime;

--+ server-messgae off
