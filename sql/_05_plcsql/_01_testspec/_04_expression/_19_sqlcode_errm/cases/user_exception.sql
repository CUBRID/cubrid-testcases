--+ server-message on
-- Verification for CBRD-24819

create or replace procedure sqlerr_test3 as
	my_exception EXCEPTION;
BEGIN
	RAISE my_exception;
	EXCEPTION WHEN my_exception THEN
		DBMS_OUTPUT.PUT_LINE('error code: ' || sqlcode);
		DBMS_OUTPUT.PUT_LINE('error msg: ' || sqlerrm);
END;

call sqlerr_test3();

drop procedure sqlerr_test3;

--+ server-message off
