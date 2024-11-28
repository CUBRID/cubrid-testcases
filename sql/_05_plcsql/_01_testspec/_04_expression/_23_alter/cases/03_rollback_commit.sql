--+ server-message on
-- verified the CBRD-25106

CREATE TABLE tbl (col1 int);
insert into tbl values(11);

CREATE OR REPLACE PROCEDURE test_tbl()
AS
    a int;
BEGIN
    SELECT * INTO a
    FROM tbl;
	
	DBMS_OUTPUT.put_line('col1 :' || a);
END;

call test_tbl();

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';

evaluate 'auto commit off';
autocommit off;

evaluate 'alter table from tbl & check the "show create table" result';
ALTER TABLE tbl CHANGE col1 col2 char(2);
show create table tbl;

evaluate 'ERROR: Stored procedure execute error';
call test_tbl();

evaluate 're-compile procedure & add to comment';
ALTER procedure test_tbl compile;
ALTER procedure test_tbl OWNER TO dba COMMENT 'in auto commit off';
select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';
call test_tbl();

evaluate 'rollback & auto commit on';
rollback;
autocommit on;

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';

call test_tbl();

drop table tbl;
drop PROCEDURE test_tbl;

--+ server-message off
