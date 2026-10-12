/**
 *  This test case verifies CBRD-27416: a member of the system user
 *  cub_select_catalog still cannot read a table it has no privilege on or the
 *  catalog classes, and cub_select_catalog cannot be dropped, made loginable,
 *  or logged in as.
 */
create user u_mem groups cub_select_catalog;
create table t (a int);

call login('u_mem', '') on class db_user;
-- 1. u_mem cannot SELECT dba.t
select * from dba.t;
-- 2. u_mem cannot SELECT the catalog class _db_class
select count(*) from _db_class;

call login('dba', '') on class db_user;
-- 3. cub_select_catalog cannot be dropped
drop user cub_select_catalog;
-- 4. cub_select_catalog cannot be made loginable
alter user cub_select_catalog login;
-- 5. no one can log in as cub_select_catalog
call login('cub_select_catalog', '') on class db_user;

drop table t;
drop user u_mem;
