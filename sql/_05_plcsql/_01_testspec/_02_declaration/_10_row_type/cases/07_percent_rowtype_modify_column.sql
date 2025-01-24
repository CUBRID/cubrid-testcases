--+ server-message on
-- verified the CBRD-25056
-- Support RECORD types and %ROWTYPE feature

-- create table & insert data
drop table if exists tbl1;
create table tbl1 ( col1 varchar(10), col2 varchar(10) );
insert into tbl1 values('1', '1234567890');

EVALUATE 'CASE 1. Normal ';
CREATE OR REPLACE PROCEDURE test_prc IS
  r tbl1%ROWTYPE;
BEGIN
  execute immediate 'select decode(length(col2),10, ''sysdate'', to_char(col2)), col2 from tbl1 ' into r;
  dbms_output.put_line('col1 ===> ' || r.col1);
END;

CALL test_prc();


EVALUATE 'CASE 2. Error : Change the column length from 10 to 14 and enter data.';
drop table tbl1;
create table tbl1 ( col1 varchar(10), col2 varchar(14) );
insert into tbl1 values('2', '1234567890ab');

CALL test_prc();


--The type in the procedure is set to varchar. 
--It runs normally because of the compatibility between the date type and the varchar type.
EVALUATE 'CASE 3. Normal : Change the column type from varchar to date and enter data.';
drop table tbl1;
create table tbl1 (col1 varchar(10), col2 date );
insert into tbl1 values('3', sysdate );
CALL test_prc();




EVALUATE 'CASE 4. Normal';
drop table if exists tbl1;
create table tbl1 (col1 varchar(10), col2 date );
insert into tbl1 values('4', sysdate);

EVALUATE 'normal';
CREATE OR REPLACE PROCEDURE test_prc IS
  r tbl1%ROWTYPE;
BEGIN
  execute immediate 'select decode(length(col1),10, ''sysdate'', to_char(col1)), col2 from tbl1 ' into r;
  dbms_output.put_line('col1 ===> ' || r.col1);
END;

CALL test_prc();


--The type in the procedure is set to varchar. 
--An error occurs because the double type and the date type are not compatible.
EVALUATE 'CASE 5. Error : Change the column type from date to double and enter data.';
drop table tbl1;
create table tbl1 (col1 varchar(10), col2 double );
insert into tbl1 values('5', 12345 );
CALL test_prc();


--The type in the procedure is set to varchar.
--An error occurs because the varchar type and the date type are not compatible.
EVALUATE 'CASE 6. Error : Change the column type from date to double and enter data.';
drop table tbl1;
create table tbl1 (col1 varchar(10), col2 varchar(10) );
insert into tbl1 values('6', 'abcdefghi' );
CALL test_prc();



drop procedure test_prc;
drop table  tbl1 ;

--+ server-message off

