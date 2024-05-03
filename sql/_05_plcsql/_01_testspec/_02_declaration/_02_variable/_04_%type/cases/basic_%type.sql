--+ server-message on
-- Verification for CBRD-24707
-- Support for % type

drop if exists t;
create table t(id int, name char(3));

insert into t values(1, 'aaa'),(2, 'bbb'),(3, 'ccc'), (3, 'ddd');


create or replace function test_types(s_id int) return string as
    v_name t.name%TYPE;

begin
    SELECT name INTO v_name FROM t WHERE id = s_id;
    return v_name;
end;

-- pass
select test_types(1) from dual;

-- fail, too many rows
select test_types(3) from dual;

drop t;
drop function test_types;

--+ server-message off
