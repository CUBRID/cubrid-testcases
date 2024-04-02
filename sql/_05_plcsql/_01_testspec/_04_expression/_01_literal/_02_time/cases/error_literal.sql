--+ server-message on
-- Verification for CBRD-24745

drop table if exists test_literal;
create table test_literal(t time);

-- wrong time literal
create or replace procedure proc_test_literal() as
begin
    insert into test_insert() values (time'12:13:14.123');
end;

call proc_test_literal();

select * from test_literal;

drop procedure proc_test_literal;

drop table test_literal;

--+ server-message off
