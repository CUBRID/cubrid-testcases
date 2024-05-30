--+ server-message on
-- Verification for CBRD-24819

drop table if exists test;
create table test(col char(1));
insert into test values('a');

-- error code: 8
create or replace procedure sqlerr_test2 as
	s_col integer;
BEGIN
    select col into s_col from test;
	DBMS_OUTPUT.PUT_LINE('value: ' || s_col);
	EXCEPTION WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('error code: ' || sqlcode);
        DBMS_OUTPUT.PUT_LINE('error msg: ' || sqlerrm);
END;

call sqlerr_test2();

drop test;
drop procedure sqlerr_test2;

--+ server-message off
