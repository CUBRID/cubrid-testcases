--+ server-message on
-- Verification for CBRD-24819

create or replace procedure sqlerr_test1 as
    v_param integer;
BEGIN
    v_param := 1 / 0;
	EXCEPTION WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('error code: ' || sqlcode);
        DBMS_OUTPUT.PUT_LINE('error msg: ' || sqlerrm);
END;

call sqlerr_test1();

drop procedure sqlerr_test1;

--+ server-message off
