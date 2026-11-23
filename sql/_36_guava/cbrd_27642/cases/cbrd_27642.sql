/**
 * This test case verifies CBRD-27642: CREATE OR REPLACE VIEW keeps the privileges granted on the view.
 *
 * CREATE OR REPLACE VIEW used to drop the existing view and create it again, so every privilege granted on it
 * was revoked. Now the existing view is defined again in place and keeps its OID, so the privileges are kept.
 *
 * Coverage:
 * 1  - the scenario of the issue: SELECT granted to a user is kept, and the user sees the new definition
 * 2  - several grantees, several privileges and WITH GRANT OPTION are kept
 * 3  - the column list changes (names and count), the privileges are kept
 * 4  - created_time is kept, updated_time is updated
 * 5  - the check option of the old definition is not kept, the one of the new definition is applied
 * 6  - the comment of the old definition is not kept, the one of the new definition is applied
 * 7  - a CREATE OR REPLACE that fails keeps the old definition and the privileges
 * 8  - a CREATE OR REPLACE that is rolled back keeps the old definition and the privileges
 * 9  - DBA replaces a view of another user: the owner and the privileges are kept
 * 10 - the privileges kept can be revoked as before
 * 11 - CREATE OR REPLACE of a view that does not exist creates it, and of a table fails
 */

drop view if exists v27642, v27642_u;
drop table if exists t27642, t27642_snap;

create user cbrd27642_u1;
create user cbrd27642_u2;
create user cbrd27642_u3;

-- dont_reuse_oid: the UPDATE of the view by cbrd27642_u2 in Case 2 and Case 5 fails with -494 on a table with reusable
-- OIDs, which create_table_reuseoid=yes makes by default
create table t27642 (a int, b varchar(10)) dont_reuse_oid;
insert into t27642 values (1, 'one'), (2, 'two'), (3, 'three');

evaluate 'Case 1: SELECT granted to a user is kept, and the user sees the new definition';
create view v27642 as select a from t27642;
grant select on v27642 to cbrd27642_u1;
select grantee_name, object_type, object_name, auth_type from db_auth where grantee_name = 'CBRD27642_U1';

call login('cbrd27642_u1','') on class db_user;
select * from dba.v27642 order by 1;
call login('dba','') on class db_user;

create or replace view v27642 as select a from t27642 where a > 1;
select grantee_name, object_type, object_name, auth_type from db_auth where grantee_name = 'CBRD27642_U1';

call login('cbrd27642_u1','') on class db_user;
select * from dba.v27642 order by 1;
call login('dba','') on class db_user;

evaluate 'Case 2: several grantees, several privileges and WITH GRANT OPTION are kept';
grant select on v27642 to cbrd27642_u2 with grant option;
grant update, delete on v27642 to cbrd27642_u2;
select grantee_name, auth_type, is_grantable from db_auth where object_name = 'v27642' order by 1, 2;
create or replace view v27642 as select a from t27642;
select grantee_name, auth_type, is_grantable from db_auth where object_name = 'v27642' order by 1, 2;

call login('cbrd27642_u2','') on class db_user;
update dba.v27642 set a = a where a = 1;
grant select on dba.v27642 to cbrd27642_u3;
call login('dba','') on class db_user;

call login('cbrd27642_u3','') on class db_user;
select * from dba.v27642 order by 1;
call login('dba','') on class db_user;

evaluate 'Case 3: the column list changes, the privileges are kept';
create or replace view v27642 (x, y, z) as select a, b, a * 10 from t27642;
select attr_name, def_order from db_attribute where class_name = 'v27642' order by def_order;
select grantee_name, auth_type, is_grantable from db_auth where object_name = 'v27642' order by 1, 2;

call login('cbrd27642_u1','') on class db_user;
select * from dba.v27642 order by 1;
call login('dba','') on class db_user;

evaluate 'Case 4: created_time is kept, updated_time is updated';
create table t27642_snap as select created_time, updated_time from _db_class where unique_name = 'dba.v27642';
-- make sure the time moves forward
select sleep (1);
create or replace view v27642 as select a from t27642;
select count(*) from _db_class c, t27642_snap s where c.unique_name = 'dba.v27642' and c.created_time = s.created_time;
select count(*) from _db_class c, t27642_snap s where c.unique_name = 'dba.v27642' and c.updated_time > s.updated_time;
drop table t27642_snap;

evaluate 'Case 5: only the check option of the new definition applies';
-- cbrd27642_u2 updates the view with the UPDATE privilege granted in Case 2 and kept by every replace since
-- in _db_class.flags, 2 is WITH CHECK OPTION and 4 is WITH LOCAL CHECK OPTION
create or replace view v27642 as select a from t27642 where a > 1 with check option;
select class_name, flags from _db_class where unique_name = 'dba.v27642';
call login('cbrd27642_u2','') on class db_user;
-- check option exception
update dba.v27642 set a = 0 where a = 2;
call login('dba','') on class db_user;

create or replace view v27642 as select a from t27642 where a > 1;
select class_name, flags from _db_class where unique_name = 'dba.v27642';
call login('cbrd27642_u2','') on class db_user;
-- no check option
update dba.v27642 set a = 0 where a = 2;
call login('dba','') on class db_user;
update t27642 set a = 2 where a = 0;

create or replace view v27642 as select a from t27642 where a > 1 with local check option;
select class_name, flags from _db_class where unique_name = 'dba.v27642';
call login('cbrd27642_u2','') on class db_user;
-- check option exception
update dba.v27642 set a = 0 where a = 2;
call login('dba','') on class db_user;

evaluate 'Case 6: only the comment of the new definition applies';
create or replace view v27642 as select a from t27642 comment 'old comment';
select class_name, comment from db_class where class_name = 'v27642';
create or replace view v27642 as select a from t27642 comment 'new comment';
select class_name, comment from db_class where class_name = 'v27642';
create or replace view v27642 as select a from t27642;
select class_name, comment from db_class where class_name = 'v27642';
select grantee_name, auth_type, is_grantable from db_auth where object_name = 'v27642' order by 1, 2;

evaluate 'Case 7: a failed CREATE OR REPLACE keeps the old definition and the privileges';
-- error: no such column
create or replace view v27642 as select no_such_column from t27642;
-- error: more columns than the query
create or replace view v27642 (x, y) as select a from t27642;
select attr_name from db_attribute where class_name = 'v27642' order by def_order;
select grantee_name, auth_type, is_grantable from db_auth where object_name = 'v27642' order by 1, 2;

evaluate 'Case 8: a rolled back CREATE OR REPLACE keeps the old definition and the privileges';
autocommit off;
create or replace view v27642 (k) as select a * 100 from t27642;
select * from v27642 order by 1;
rollback;
autocommit on;
select attr_name from db_attribute where class_name = 'v27642' order by def_order;
select * from v27642 order by 1;
select grantee_name, auth_type, is_grantable from db_auth where object_name = 'v27642' order by 1, 2;

evaluate 'Case 9: DBA replaces a view of another user, the owner and the privileges are kept';
grant select on t27642 to cbrd27642_u1;
call login('cbrd27642_u1','') on class db_user;
create view v27642_u as select a from dba.t27642 where a = 1;
grant select on v27642_u to cbrd27642_u2;
call login('dba','') on class db_user;

create or replace view cbrd27642_u1.v27642_u as select a from dba.t27642 where a = 3;
select owner_name, class_name from db_class where class_name = 'v27642_u';
select grantor_name, grantee_name, owner_name, object_name, auth_type from db_auth where object_name = 'v27642_u';
call login('cbrd27642_u2','') on class db_user;
select * from cbrd27642_u1.v27642_u;
call login('dba','') on class db_user;

evaluate 'Case 10: the privileges kept can be revoked';
revoke select on v27642 from cbrd27642_u1;
select grantee_name, auth_type from db_auth where object_name = 'v27642' and grantee_name = 'CBRD27642_U1';
call login('cbrd27642_u1','') on class db_user;
-- error: no privilege
select * from dba.v27642;
call login('dba','') on class db_user;

evaluate 'Case 11: a view that does not exist is created, a table is refused';
drop view v27642;
create or replace view v27642 as select a from t27642;
select class_name, class_type from db_class where class_name = 'v27642';
select * from v27642 order by 1;
-- a new view has no privileges granted on it
select count(*) from db_auth where object_name = 'v27642';
-- error: t27642 is a table
create or replace view t27642 as select 1 as a;
select class_name, class_type from db_class where class_name = 't27642';

drop view if exists v27642;
drop view if exists cbrd27642_u1.v27642_u;
drop table if exists t27642;
drop user cbrd27642_u1;
drop user cbrd27642_u2;
drop user cbrd27642_u3;
