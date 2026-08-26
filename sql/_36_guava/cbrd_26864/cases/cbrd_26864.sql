/*
 * This test case verifies CBRD-26864 : ALTER TABLE <old> RENAME TO <new>
 * must not allow the owner of the table to change.
 *
 * Bug: when dba renames another users table with an unqualified new name
 * (ALTER TABLE u1.t_old RENAME TO t_new, with no schema qualifier on
 * t_new), the rename silently succeeded and made dba the new owner of a
 * table originally created by u1. This produced a catalog inconsistency:
 * db_class.owner_name changed to DBA while the underlying unique_name
 * in the system catalog (_db_class.owner.name) still referenced the
 * original owner (u1), so the two catalog views disagreed about who
 * owns the table.
 *
 * Fix: RENAME now rejects any table rename that would change the owner,
 * raising ER_SM_RENAME_CANT_ALTER_OWNER (RENAME does not allow change
 * of owner).
 *
 * Session switching: this test uses CUBRIDs built-in
 * call login(user, password) on class db_user
 * method to switch the current sessions authenticated user without
 * reconnecting, and --+ holdcas on / off to keep the same CAS process
 * for the whole file so the login switch is not lost to broker CAS
 * reassignment between statements.
 *
 * Coverage:
 *   Case 1: baseline, no owner change -- u1 renames a COLUMN on its own
 *           table -> must succeed normally, owner_name stays U1
 *   Case 2: dba renames u1s table to an unqualified new name -> must be
 *           rejected with ER_SM_RENAME_CANT_ALTER_OWNER, and db_class
 *           must show no trace of t_new (the rename never took effect)
 *   Case 3: same rejected rename, checked through the system catalog
 *           (_db_class.unique_name / owner.name) instead of db_class --
 *           both catalog views must agree that t_new does not exist
 *   Case 4: DML against t_new from both dba and u1 after the rejected
 *           rename -> both must fail with an unknown-class error, since
 *           the table was never actually renamed away from u1.t_old
 */

--+ holdcas on;

call login('dba', '') on class db_user;
drop user u1;
create user u1;


evaluate 'Case 1: u1 renames a column on its own table -- must succeed, owner stays U1';
call login('u1', '') on class db_user;
create table u1.t_old (col1 int, col2 varchar(100));
alter table u1.t_old rename column col1 as col1_new;
select class_name, owner_name from db_class where class_name = 't_old';
drop table u1.t_old;
select class_name, owner_name from db_class where class_name = 't_old';


evaluate 'Case 2: dba renames u1 table to an unqualified name -- must be rejected, t_new must not appear in db_class';
call login('u1', '') on class db_user;
create table u1.t_old (col1 int);
select class_name, owner_name from db_class where class_name = 't_old';

call login('dba', '') on class db_user;
alter table u1.t_old rename to t_new;
select class_name, owner_name from db_class where class_name = 't_new';


evaluate 'Case 3: same rejected rename, checked via the system catalog -- unique_name and owner.name must agree t_new does not exist';
select unique_name, class_name, owner.name from _db_class where class_name = 't_new';


evaluate 'Case 4: DML against t_new from both dba and u1 -- both must fail, t_old is still owned by u1 under its original name';
select * from t_new;
insert into t_new values (2);

call login('u1', '') on class db_user;
select * from u1.t_new;
insert into u1.t_new values (3);


call login('dba', '') on class db_user;
drop table if exists u1.t_old, u1.t_new, dba.t_new;
drop user u1;

--+ holdcas off;
