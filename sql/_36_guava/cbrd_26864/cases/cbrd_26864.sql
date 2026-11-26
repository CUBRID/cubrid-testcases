/*
 * This test case verifies CBRD-26864 : ALTER TABLE <old> RENAME TO <new>
 * must not allow the owner of the table to change.
 *
 * Bug: when dba renames another user's table with an unqualified new name
 * (ALTER TABLE u1.t_old RENAME TO t_new, with no schema qualifier on
 * t_new), the rename silently succeeded and made dba the new owner of a
 * table originally created by u1. This produced a catalog inconsistency:
 * db_class.owner_name changed to DBA while the underlying unique_name
 * in the system catalog (_db_class.owner.name) still referenced the
 * original owner (u1), so the two catalog views disagreed about who
 * owns the table.
 *
 * Fix: RENAME now rejects any table rename that would change the owner,
 * raising ER_SM_RENAME_CANT_ALTER_OWNER ("RENAME does not allow change
 * of owner.").
 *
 * Session switching: this test uses CUBRID's built-in
 *   call login(user, password) on class db_user
 * method to switch the current session's authenticated user without
 * reconnecting, and --+ holdcas on / off to keep the same CAS process
 * for the whole file so the login switch is not lost to broker CAS
 * reassignment between statements.
 *
 * Coverage:
 *   Case 1:  u1 renames its own table (same owner, qualified) -- must
 *            succeed
 *   Case 2:  dba renames u1's table to an unqualified new name -- must
 *            be rejected with ER_SM_RENAME_CANT_ALTER_OWNER, t_new must
 *            not appear in db_class, and the original u1.t_old must
 *            still be shown as owned by U1
 *   Case 3:  same rejected rename, re-checked via the system catalog
 *            (_db_class.unique_name / owner.name) -- t_old must still
 *            be owned by U1 and t_new must not exist
 *   Case 4:  DML (SELECT/INSERT/DROP) against t_new from both dba and u1
 *            after the rejected rename -- all must fail with an
 *            unknown-class error, since the table was never actually
 *            renamed away from u1.t_old
 *   Case 5:  dba renames its own table, no qualifier on either side --
 *            must succeed (same-owner baseline with the DBA account)
 *   Case 6:  both the old and new names are qualified, but with two
 *            different owners -- must be rejected
 *   Case 7:  unqualified old name renamed into another owner's schema --
 *            must be rejected
 *   Case 8:  the new name repeats the same owner in a different letter
 *            case (U1 vs u1) -- must succeed, since owner names are
 *            case-insensitive
 *   Case 9:  the same owner-change rejection through the VIEW rename
 *            path (ALTER VIEW ... RENAME TO) -- must be rejected
 *   Case 10: the legacy RENAME TABLE ... TO ... statement -- confirms it
 *            funnels through the same fixed check and also rejects a
 *            cross-owner rename with ER_SM_RENAME_CANT_ALTER_OWNER
 *
 * Note: _db_class is only queryable while logged in as dba (a non-dba
 * SELECT on it fails with "SELECT is not authorized on _db_class"), so
 * every _db_class check below runs right after switching back to dba.
 */

--+ holdcas on;

call login('dba', '') on class db_user;
create user u1;


evaluate 'Case 1: u1 renames its own table, same owner -- must succeed';
call login('u1', '') on class db_user;
create table u1.t_old (col1 int, col2 varchar(100));
alter table u1.t_old rename to u1.t_new;

call login('dba', '') on class db_user;
select unique_name, class_name, owner.name from _db_class where class_name in ('t_old', 't_new');
drop table u1.t_new;
select class_name, owner_name from db_class where class_name in ('t_old', 't_new');


evaluate 'Case 2: dba renames u1 table to an unqualified name -- must be rejected, t_new must not appear in db_class, u1.t_old must survive';
call login('u1', '') on class db_user;
create table u1.t_old (col1 int);
select class_name, owner_name from db_class where class_name = 't_old';

call login('dba', '') on class db_user;
alter table u1.t_old rename to t_new;
select class_name, owner_name from db_class where class_name = 't_new';
select unique_name, class_name, owner.name from _db_class where class_name = 't_old';


evaluate 'Case 3: after the rejected rename, the system catalog still shows u1.t_old owned by U1 and no t_new';
select unique_name, class_name, owner.name from _db_class where class_name in ('t_old', 't_new');


evaluate 'Case 4: DML against t_new from both dba and u1 -- all must fail, t_old is still owned by u1 under its original name';
select * from t_new;
insert into t_new values (2);
drop table t_new;

call login('u1', '') on class db_user;
select * from u1.t_new;
insert into u1.t_new values (3);


evaluate 'Case 5: dba renames its own table, no qualifier on either side -- must succeed';
call login('dba', '') on class db_user;
create table t5_a (col1 int);
alter table t5_a rename to t5_b;
select unique_name, class_name, owner.name from _db_class where class_name in ('t5_a', 't5_b');
drop table t5_b;


evaluate 'Case 6: both sides qualified with different owners -- must be rejected';
create user u2;
call login('u1', '') on class db_user;
create table u1.t6_a (col1 int);
call login('dba', '') on class db_user;
alter table u1.t6_a rename to u2.t6_b;
select unique_name, class_name, owner.name from _db_class where class_name in ('t6_a', 't6_b');
drop table u1.t6_a;


evaluate 'Case 7: unqualified old name renamed into another owner -- must be rejected';
create table t7_a (col1 int);
alter table t7_a rename to u1.t7_b;
select unique_name, class_name, owner.name from _db_class where class_name in ('t7_a', 't7_b');
drop table t7_a;


evaluate 'Case 8: the same owner written in a different letter case -- must succeed';
call login('u1', '') on class db_user;
create table u1.t8_a (col1 int);
alter table u1.t8_a rename to U1.t8_b;

call login('dba', '') on class db_user;
select unique_name, class_name, owner.name from _db_class where class_name in ('t8_a', 't8_b');
drop table u1.t8_b;


evaluate 'Case 9: the same rejection through the VIEW rename path -- must be rejected';
create table u1.t9_a (col1 int);
create view u1.v9_a as select col1 from u1.t9_a;
call login('dba', '') on class db_user;
alter view u1.v9_a rename to v9_b;
select unique_name, class_name, owner.name from _db_class where class_name in ('v9_a', 'v9_b');
drop view u1.v9_a;
drop table u1.t9_a;


evaluate 'Case 10: legacy RENAME TABLE syntax also rejects the same cross-owner rename';
call login('u1', '') on class db_user;
create table u1.t10_a (col1 int);
call login('dba', '') on class db_user;
rename table u1.t10_a to t10_b;
select unique_name, class_name, owner.name from _db_class where class_name in ('t10_a', 't10_b');
drop table u1.t10_a;


call login('dba', '') on class db_user;
drop table if exists u1.t_old, u1.t_new, dba.t_new;
drop user u2;
drop user u1;

--+ holdcas off;
