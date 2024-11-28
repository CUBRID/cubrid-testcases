--+ server-message on
-- verified the CBRD-25106

CREATE TABLE tbl (col1 int);
insert into tbl values(11);

CREATE OR REPLACE function test_tbl() return varchar
AS
    a int;
BEGIN
    SELECT * INTO a FROM tbl;
	
	return 'col1 :' || a;
END;

select test_tbl() from dual;

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';

evaluate 'auto commit off';
autocommit off;

evaluate 'alter table from tbl & check the "show create table" result';
ALTER TABLE tbl CHANGE col1 col2 char(2);
show create table tbl;

evaluate 'ERROR: Stored procedure execute error';
select test_tbl() from dual;

evaluate 're-compile procedure & add to comment';
ALTER function test_tbl compile;
ALTER function test_tbl OWNER TO dba COMMENT 'in auto commit off';
select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';
select test_tbl() from dual;

evaluate 'rollback & auto commit on';
rollback;
autocommit on;

select sp_name, lang, owner, comment from db_stored_procedure where sp_name='test_tbl';

select test_tbl() from dual;

drop table tbl;
drop function test_tbl;

--+ server-message off
