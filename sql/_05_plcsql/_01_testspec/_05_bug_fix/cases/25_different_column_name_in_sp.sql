--+ server-message on
-- verified the CBRD-25808

drop table if exists tbl;

CREATE TABLE tbl (a int, b string);
INSERT INTO tbl VALUES (1, 'aaa');
INSERT INTO tbl VALUES (2, 'bbb');
INSERT INTO tbl VALUES (3, 'ccc');

-- A core occurred when the column name in the table and the column name in the sp were different.
evaluate 'Stored procedure compile error';
CREATE OR REPLACE FUNCTION factorial(n INTEGER) RETURN INTEGER IS
k int;
t int;
BEGIN
	IF n = 0 OR n = 1 THEN
		UPDATE tbl SET s = 'ttt' WHERE id = 1;
		RETURN 1;
	ELSE
		SELECT factorial (n - 1) INTO k;
		DBMS_OUTPUT.put_line (n * k);
		RETURN n * k;
	END IF;
END;

drop function factorial;
drop table if exists tbl;

--+ server-message off
