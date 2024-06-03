--+ server-message on
-- Verification for CBRD-24745

create or replace procedure test_semantic_error_unknown_tbl() as
begin
    insert into unknown_tbl(t) values (time'12:13:14');
end;

drop procedure test_semantic_error_unknown_tbl;


--+ server-message off
