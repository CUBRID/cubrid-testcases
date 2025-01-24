--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- In CUBRID, %type must be manually compiled when the column length or type changes.
-- Oracle handles it normally

-- create table & insert data
drop table if exists tbl1;
create table tbl_a ( col1 varchar(3) );
insert into tbl_a values('abc');
create or replace view tbl1 AS SELECT * FROM tbl_a;

EVALUATE 'normal';
CREATE OR REPLACE PROCEDURE test_prc IS
  v_col1   tbl1.col1%TYPE;
BEGIN
  SELECT col1 INTO  v_col1  FROM tbl1;
  dbms_output.put_line('col1     ' || v_col1    );
END;

CALL test_prc();


EVALUATE 'CASE 1. Normal ';
EVALUATE 'Change the column length from 3 to 5 and enter data.';
drop table tbl_a;
create table tbl_a ( col1 varchar(5) );
insert into tbl_a values('abcde');
CALL test_prc();


EVALUATE 'CASE 2. Normal ';
EVALUATE 'If you recompile, it will still be processed normally.';
create or replace view tbl1 AS SELECT * FROM tbl_a;
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
drop table tbl_a;
create table tbl_a ( col1 date );
insert into tbl_a values( to_date('2024-09-03','YYYY-MM-DD') );
create or replace view tbl1 AS SELECT * FROM tbl_a;
EVALUATE 'BUG, TODO';
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


drop procedure test_prc;

drop view  tbl1 ;

drop table tbl_a;

--+ server-message off

