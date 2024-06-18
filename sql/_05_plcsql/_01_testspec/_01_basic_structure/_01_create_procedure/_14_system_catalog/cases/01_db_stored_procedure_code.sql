--+ server-message on
-- Verified for CBRD-25227

create or replace procedure test_proc(p_char char(1)) as
    ch_1 character(1) := p_char;
begin
    dbms_output.put_line('test: ' || ch_1);
end;

select
    name, if (created_time is not null,'no problem','problem') as "created_time",
    owner, is_static, is_system_generated, stype, scode, otype, ocode
from _db_stored_procedure_code;

-- is not authorized
update _db_stored_procedure_code set is_system_generated='1';

delete from _db_stored_procedure_code;

drop table _db_stored_procedure_code;

-- procedure drop & check to delete on _db_stored_procedure_code
drop procedure test_proc;

select count(*) from _db_stored_procedure_code;

--+ server-message off