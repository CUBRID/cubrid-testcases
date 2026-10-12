/*
 * CBRD-27416: the system user CUB_SELECT_CATALOG. Its members see the db_* and information_schema views as DBA
 * does; this case checks what stays closed to a member and that the user itself is protected like the other
 * system users.
 *
 * 1. a member cannot read a table it has no privilege on
 * 2. a member cannot read the catalog classes under the views
 * 3. CUB_SELECT_CATALOG cannot be dropped
 * 4. CUB_SELECT_CATALOG cannot be made loginable
 * 5. CUB_SELECT_CATALOG cannot log in
 */
create user u_mem groups cub_select_catalog;
create table t (a int);

call login('u_mem', '') on class db_user;
-- 1.
select * from dba.t;
-- 2.
select count(*) from _db_class;

call login('dba', '') on class db_user;
-- 3.
drop user cub_select_catalog;
-- 4.
alter user cub_select_catalog login;
-- 5.
call login('cub_select_catalog', '') on class db_user;

drop table t;
drop user u_mem;
