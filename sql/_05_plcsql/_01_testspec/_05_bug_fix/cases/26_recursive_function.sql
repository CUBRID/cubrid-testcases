--+ server-message on
-- verified the CBRD-25806

drop table if exists tbl;

CREATE TABLE tbl (id int, s string);
INSERT INTO tbl VALUES (1, 'aaa');
INSERT INTO tbl VALUES (2, 'bbb');
INSERT INTO tbl VALUES (3, 'ccc');

-- When creating a recursive function, an undefined function error should occur.
evaluate 'error: Function factorial is undefined';
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

-- When creating a recursive function, you must create a dummy function before creating the original function, and then create the corresponding function.
evaluate 'create a dumy function';
CREATE OR REPLACE FUNCTION factorial(n INTEGER) RETURN INTEGER IS
BEGIN
	return NULL;
END;

evaluate 'recursive function creation success';
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

select factorial(5);

evaluate 'Check table updates according to function execution results.';
select * from tbl;

drop function factorial;

drop table if exists tbl;

--+ server-message off
