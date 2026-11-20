/**
 *  This test case verifies CBRD-26470: the three forms of ALTER PROCEDURE / FUNCTION
 *  (COMMENT, OWNER TO, COMPILE) after jsp_alter_stored_procedure was reorganized.
 *
 *  The authorization check now comes before the owner change, the whole ALTER runs under a
 *  savepoint so that a failure in the middle rolls back the earlier steps, and the code row is
 *  updated for the new owner. A failed ALTER must leave the catalog as it was.
 *  compile_id changes at every run, so only the comparison is printed.
 *
 *  Coverage:
 *    Case 1: COMMENT by the owner is stored
 *    Case 2: COMMENT by a non-owner is denied and the comment is unchanged
 *    Case 3: COMPILE by the owner renews compile_id and the function still runs
 *    Case 4: COMPILE with the wrong routine type (ALTER PROCEDURE of a function) is denied
 *    Case 5: OWNER TO by a non-DBA is denied and the owner is unchanged
 *    Case 6: OWNER TO by DBA: unique_name, generated class name and the code row follow the new
 *            owner, and the new owner can run it
 *    Case 7: ALTER of a missing routine is denied
 */

--+ server-message on

drop table if exists t09_cid;
create table t09_cid (step int, cid varchar);

create user u09a;
create user u09b;

call login('u09a', '') on class db_user;
create or replace function f09_a(a int) return int as begin return a * 2; end;
create or replace procedure p09_a as begin null; end;


evaluate 'Case 1: COMMENT by the owner is stored, expect hello';
alter function f09_a comment 'hello';
call login('dba', '') on class db_user;
select comment from _db_stored_procedure where sp_name = 'f09_a';


evaluate 'Case 2: COMMENT by a non-owner is denied and the comment is unchanged, expect hello';
call login('u09b', '') on class db_user;
alter function u09a.f09_a comment 'evil';
call login('dba', '') on class db_user;
select comment from _db_stored_procedure where sp_name = 'f09_a';


evaluate 'Case 3: COMPILE by the owner renews compile_id (expect 1) and the function still runs (expect 6)';
insert into t09_cid select 1, code.compile_id from _db_stored_procedure where sp_name = 'f09_a';
call login('u09a', '') on class db_user;
alter function f09_a compile;
call login('dba', '') on class db_user;
insert into t09_cid select 2, code.compile_id from _db_stored_procedure where sp_name = 'f09_a';
select count(*) as renewed from t09_cid a, t09_cid b where a.step = 1 and b.step = 2 and b.cid is not null and a.cid <> b.cid;
call login('u09a', '') on class db_user;
select f09_a(3) as r from dual;


evaluate 'Case 4: COMPILE with the wrong routine type is denied';
alter procedure f09_a compile;


evaluate 'Case 5: OWNER TO by a non-DBA is denied and the owner is unchanged, expect U09A';
alter function f09_a owner to u09b;
call login('dba', '') on class db_user;
select owner.name as owner from _db_stored_procedure where sp_name = 'f09_a';


evaluate 'Case 6: OWNER TO by DBA moves the routine and its code to the new owner, expect u09b.f09_a, Func_4_U09B_F09_A, u09b.f09_a, 8';
alter function u09a.f09_a owner to u09b;
select unique_name from _db_stored_procedure where sp_name = 'f09_a';
select code.name as name from _db_stored_procedure where sp_name = 'f09_a';
select c.sp_of.unique_name as sp from _db_stored_procedure_code c, _db_stored_procedure s where s.sp_name = 'f09_a' and s.code = c;
call login('u09b', '') on class db_user;
select f09_a(4) as r from dual;


evaluate 'Case 7: ALTER of a missing routine is denied';
call login('u09a', '') on class db_user;
alter function f09_nosuch comment 'x';


call login('dba', '') on class db_user;
drop function u09b.f09_a;
drop procedure u09a.p09_a;
drop table t09_cid;
drop user u09b;
drop user u09a;

--+ server-message off
