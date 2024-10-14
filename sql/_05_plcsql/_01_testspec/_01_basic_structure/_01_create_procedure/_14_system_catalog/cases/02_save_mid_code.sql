--+ server-message on
-- verified for CBRD-25222

select * from db_attribute where class_name = '_db_stored_procedure_code' order by def_order;

create or replace procedure test_mid_code()
as
begin
    dbms_output.put_line('test');
end;

-- icode is CLOB type. so the substr() with CLOB type prints the real file's contents
-- expect result: 0, import
select
    itype, substr(icode,0,6)
from
    _db_stored_procedure_code
where
    name like 'Proc_TEST_MID_CODE%'
;

drop procedure test_mid_code;

--+ server-message off
