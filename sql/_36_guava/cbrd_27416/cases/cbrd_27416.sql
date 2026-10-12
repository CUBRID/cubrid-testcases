/**
 *  This test case verifies CBRD-27416: a member of the system user
 *  cub_select_catalog still cannot read a table it has no privilege on or the
 *  catalog classes, and cub_select_catalog cannot be dropped, made loginable,
 *  or logged in as.
 */
create user u_mem groups cub_select_catalog;
create table t (a int);

call login('u_mem', '') on class db_user;
-- 1. select on dba.t as u_mem: error -494
select * from dba.t;
-- 2. select on _db_class as u_mem: error -494
select count(*) from _db_class;

call login('dba', '') on class db_user;
-- 3. drop user cub_select_catalog: error -169
drop user cub_select_catalog;
-- 4. alter user cub_select_catalog login: error -1378
alter user cub_select_catalog login;
-- 5. login as cub_select_catalog: error -1369
call login('cub_select_catalog', '') on class db_user;

drop table t;
drop user u_mem;
