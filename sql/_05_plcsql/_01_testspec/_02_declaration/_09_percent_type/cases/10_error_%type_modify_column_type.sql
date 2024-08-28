--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- In CUBRID, %type must be manually compiled when the column length or type changes.
-- Oracle handles it normally

-- create table & insert data
drop table if exists tbl1;
create table tbl1 ( col1 varchar(3) );
insert into tbl1 values('abc');

EVALUATE 'normal';
CREATE OR REPLACE PROCEDURE test_prc IS
  v_col1   tbl1.col1%TYPE;
BEGIN
  SELECT col1 INTO  v_col1  FROM tbl1;
  dbms_output.put_line('col1     ' || v_col1    );
END;

CALL test_prc();


EVALUATE 'CASE 1. Error ';
EVALUATE 'Change the column length from 3 to 5 and enter data.';
EVALUATE 'When I run the procedure, I get an error.';
EVALUATE 'ERROR : string does not fit in the target type length';
drop table tbl1;
create table tbl1 ( col1 varchar(5) );
insert into tbl1 values('abcde');
CALL test_prc();


EVALUATE 'CASE 2. Normal ';
EVALUATE 'If you recompile, it will be processed normally.';
CREATE OR REPLACE PROCEDURE test_prc IS
  v_col1   tbl1.col1%TYPE;
BEGIN
  SELECT col1 INTO  v_col1  FROM tbl1;
  dbms_output.put_line('col1     ' || v_col1    );
END;
CALL test_prc();


EVALUATE 'CASE 3. Error ';
EVALUATE 'Change the column type from varchar to date and enter data.';
EVALUATE 'Error when running the procedure.';
EVALUATE 'ERROR : internal server error';
drop table tbl1;
create table tbl1 ( col1 date );
insert into tbl1 values( sysdate );
CALL test_prc();
 


EVALUATE 'CASE 4. Normal ';
EVALUATE 'If you recompile, it will be processed normally.';
CREATE OR REPLACE PROCEDURE test_prc IS
  v_col1   tbl1.col1%TYPE;
BEGIN
  SELECT col1 INTO  v_col1  FROM tbl1;
  dbms_output.put_line('col1     ' || v_col1    );
END;
CALL test_prc();


drop procedure type_support;

drop table  type_support ;

--+ server-message off

