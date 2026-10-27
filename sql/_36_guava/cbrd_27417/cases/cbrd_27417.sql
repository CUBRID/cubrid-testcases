/**
 *  This test case verifies CBRD-27417: the DBA group grants and revokes SELECT,
 *  ALTER and ALL PRIVILEGES ON SENSITIVITY LABEL, and db_auth and SHOW GRANTS
 *  show these grants beside object grants. What SELECT and ALTER allow on
 *  labels is checked by CBRD-27419, CBRD-27420 and CBRD-27421.
 */
drop table if exists t_group, t_duplicate, t_partial;

-- 1. DBA's GRANT SELECT gives u_select one SELECT row from DBA, with object_type SENSITIVITY LABEL, object_name NULL, owner_name DBA and is_grantable NO
create user u_select;
grant select on sensitivity label to u_select;
select grantor_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name = 'U_SELECT';

-- 2. GRANT ALL PRIVILEGES gives u_all an ALTER row and a SELECT row
create user u_all;
grant all privileges on sensitivity label to u_all;
select auth_type from db_auth where grantee_name = 'U_ALL' order by 1;

-- 3. GRANT of the privilege list SELECT, ALTER gives u_list an ALTER row and a SELECT row
create user u_list;
grant select, alter on sensitivity label to u_list;
select auth_type from db_auth where grantee_name = 'U_LIST' order by 1;

-- 4. GRANT to the user list u_to1, u_to2 gives each one SELECT row
create user u_to1;
create user u_to2;
grant select on sensitivity label to u_to1, u_to2;
select grantee_name, auth_type from db_auth where grantee_name in ('U_TO1', 'U_TO2') order by 1;

-- 5. REVOKE ALL PRIVILEGES leaves u_all no row
revoke all privileges on sensitivity label from u_all;
select auth_type from db_auth where grantee_name = 'U_ALL';

-- 6. REVOKE of the privilege list SELECT, ALTER leaves u_list no row
revoke select, alter on sensitivity label from u_list;
select auth_type from db_auth where grantee_name = 'U_LIST';

-- 7. REVOKE from the user list u_to1, u_to2 leaves neither user a row
revoke select on sensitivity label from u_to1, u_to2;
select grantee_name from db_auth where grantee_name in ('U_TO1', 'U_TO2');

-- 8. u_non, outside the DBA group and holding ALL PRIVILEGES, cannot GRANT SELECT to u_grant_target
create user u_non;
create user u_grant_target;
create user u_revoke_target;
grant all privileges on sensitivity label to u_non;
grant select on sensitivity label to u_revoke_target;
call login('u_non', '') on class db_user;
grant select on sensitivity label to u_grant_target;

-- 9. u_non cannot REVOKE SELECT from u_revoke_target
revoke select on sensitivity label from u_revoke_target;
call login('dba', '') on class db_user;

-- 10. m_revoke, a DBA group member, revokes DBA's grant and leaves u_revoke_by_member no row
create user m_revoke groups dba;
create user u_revoke_by_member;
grant select on sensitivity label to u_revoke_by_member;
call login('m_revoke', '') on class db_user;
revoke select on sensitivity label from u_revoke_by_member;
call login('dba', '') on class db_user;
select auth_type from db_auth where grantee_name = 'U_REVOKE_BY_MEMBER';

-- 11. GRANT SELECT WITH GRANT OPTION to u_option fails
create user u_option;
grant select on sensitivity label to u_option with grant option;

-- 12. SHOW GRANTS FOR u_member lists the label grant of its group g_label as it lists g_label's grant on t_group
create user g_label;
create user u_member groups g_label;
create table t_group (a int);
grant select on t_group to g_label;
grant select on sensitivity label to g_label;
show grants for u_member;

-- 13. a repeated GRANT on the label has the outcome of a repeated GRANT on t_duplicate, and leaves as many rows
create user u_duplicate_table;
create user u_duplicate_label;
create table t_duplicate (a int);
grant select on t_duplicate to u_duplicate_table;
grant select on t_duplicate to u_duplicate_table;
grant select on sensitivity label to u_duplicate_label;
grant select on sensitivity label to u_duplicate_label;
select grantee_name, count (*) from db_auth where grantee_name in ('U_DUPLICATE_TABLE', 'U_DUPLICATE_LABEL') group by grantee_name order by 1;

-- 14. REVOKE SELECT after ALL PRIVILEGES has the outcome it has on t_partial, and leaves u_partial_label only ALTER
create user u_partial_table;
create user u_partial_label;
create table t_partial (a int);
grant all privileges on t_partial to u_partial_table;
grant all privileges on sensitivity label to u_partial_label;
revoke select on t_partial from u_partial_table;
revoke select on sensitivity label from u_partial_label;
select grantee_name, auth_type from db_auth where grantee_name in ('U_PARTIAL_TABLE', 'U_PARTIAL_LABEL') order by 1, 2;

-- 15. SHOW GRANTS FOR u_select prints its label grant
show grants for u_select;

-- 16. a GRANT by m_grant, a DBA group member, records DBA as the grantor
create user m_grant groups dba;
create user u_grant_by_member;
call login('m_grant', '') on class db_user;
grant select on sensitivity label to u_grant_by_member;
call login('dba', '') on class db_user;
select grantor_name, auth_type from db_auth where grantee_name = 'U_GRANT_BY_MEMBER';

-- 17. DBA's GRANT on the label to itself succeeds, its REVOKE from itself fails, and neither adds a row
grant select on sensitivity label to dba;
revoke select on sensitivity label from dba;
select count (*) from db_auth where grantee_name = 'DBA' and object_type = 'SENSITIVITY LABEL';

-- 18. GRANT INSERT on the label fails
create user u_insert;
grant insert on sensitivity label to u_insert;

-- 19. db_auth shows the label row to its grantee u_seen and to u_catalog, a member of cub_select_catalog, but not to u_other
create user u_seen;
create user u_other;
create user u_catalog groups cub_select_catalog;
grant select on sensitivity label to u_seen;
call login('u_seen', '') on class db_user;
select grantee_name, auth_type from db_auth where object_type = 'SENSITIVITY LABEL' and grantee_name = 'U_SEEN';
call login('u_catalog', '') on class db_user;
select grantee_name, auth_type from db_auth where object_type = 'SENSITIVITY LABEL' and grantee_name = 'U_SEEN';
call login('u_other', '') on class db_user;
select grantee_name, auth_type from db_auth where object_type = 'SENSITIVITY LABEL' and grantee_name = 'U_SEEN';
call login('dba', '') on class db_user;

drop table t_group, t_duplicate, t_partial;
drop user u_select;
drop user u_all;
drop user u_list;
drop user u_to1;
drop user u_to2;
drop user u_non;
drop user u_grant_target;
drop user u_revoke_target;
drop user m_revoke;
drop user m_grant;
drop user u_revoke_by_member;
drop user u_option;
drop user u_member;
drop user g_label;
drop user u_duplicate_table;
drop user u_duplicate_label;
drop user u_partial_table;
drop user u_partial_label;
drop user u_grant_by_member;
drop user u_insert;
drop user u_seen;
drop user u_other;
drop user u_catalog;
