--+ server-message on
-- verified for CBRD-25420

select 'test_out1' from dual;
CREATE OR REPLACE FUNCTION test_out1(
  val OUT INTEGER
) RETURN INTEGER
IS
BEGIN
  val := 9;
  RETURN 2;
END;

SELECT 1, 2 INTO :a, :b;
CALL test_out1 (:b);
SELECT :b;
-- error (OUT) FUNCTION
-- in, out, inout param is only work on call statement
SELECT test_out1 (:b) INTO :a;
SELECT :a, :b;


select 'test_out2' from dual;
CREATE OR REPLACE FUNCTION test_out2(
  val IN OUT INTEGER
) RETURN INTEGER
IS
BEGIN
  val := 1;
  RETURN 2;
END;

SELECT 3, 4 INTO :a, :b;
CALL test_out2 (:b);
SELECT :a, :b;
-- error (IN OUT) FUNCTION
-- in, out, inout param is only work on call statement
select test_out2 (:b) INTO :a;
SELECT :a, :b;


select 'test_out3' from dual;
CREATE OR REPLACE PROCEDURE test_out3(
  val IN OUT INTEGER
)
IS
BEGIN
  val := 9;
END;

SELECT 1 INTO :a;
CALL test_out3 (:a);
SELECT :a;
-- error (IN OUT) PROCEDURE
-- in, out, inout param is only work on call statement
SELECT 1 INTO :b;
SELECT test_out3 (:b);
SELECT :b;

create table t1(col1 int);
insert into t1 values(99);


select 'test_out4' from dual;
CREATE OR REPLACE FUNCTION test_out4() RETURN INTEGER
IS
BEGIN
  RETURN 5;
END;

SELECT 1, 2 INTO :a, :b;
CALL test_out4() INTO :a;
SELECT :a;

SELECT test_out4 () INTO :b;
SELECT :b;


select 'Used query result to param for function/procedure' from dual;
-- error
SELECT test_out1 (col1) FROM t1;
SELECT test_out2 (col1) FROM t1;
SELECT test_out3 (col1) FROM t1;

drop function test_out1;
drop function test_out2;
drop procedure test_out3;
drop function test_out4;


drop t1;


select 'inner call function/procedure' from dual;

CREATE OR REPLACE PROCEDURE test_proc(
  square_number INOUT INTEGER
)
IS
BEGIN
  square_number := square_number * square_number;
END;

CREATE OR REPLACE FUNCTION test_func1(
  target_num IN OUT INTEGER
) RETURN varchar
IS
  result_num integer;
BEGIN
  result_num := target_num;
  test_proc(result_num);

  RETURN 'result: ' || result_num;
END;

CREATE OR REPLACE FUNCTION test_func2(
  target_num IN OUT INTEGER
) RETURN varchar
IS
  result_num integer;
  val integer;
BEGIN
  result_num := target_num;
  select test_proc(result_num) into val from dual;

  RETURN 'result: ' || result_num;
END;

select 5 into :a;
-- result: 25
call test_func1(:a);
select :a;

-- Error:-889
call test_func2(:a);
select :a;

select 4 into :b;
-- Error:-494
select test_func1(:b);
select :b;

drop procedure test_proc;
drop function test_func1;
drop function test_func2;


--+ server-message off
