--+ holdcas on;
-- CBRD-27043: the owner and SELECT-grantee branches of the db_histogram filter honor group membership
call login('dba') on class db_user;
create table t_hist_grp (k int);
insert into t_hist_grp values (1), (2);
update statistics on t_hist_grp with fullscan;
create user g_hist;
create user u_hist_member groups g_hist;

-- before the grant to the group: nothing
call login('u_hist_member') on class db_user;
select owner_name, class_name, attr_name, scan_type from db_histogram where class_name = 't_hist_grp' order by 1, 2, 3;

-- SELECT granted to the group only
call login('dba') on class db_user;
grant select on t_hist_grp to g_hist;
call login('u_hist_member') on class db_user;
select owner_name, class_name, attr_name, scan_type from db_histogram where class_name = 't_hist_grp' order by 1, 2, 3;

-- a table owned by the group is visible to its members
call login('g_hist') on class db_user;
create table t_hist_grp_owned (k int);
insert into t_hist_grp_owned values (1);
update statistics on t_hist_grp_owned with fullscan;
call login('u_hist_member') on class db_user;
select owner_name, class_name, attr_name, scan_type from db_histogram where class_name = 't_hist_grp_owned' order by 1, 2, 3;

call login('dba') on class db_user;
drop table t_hist_grp, g_hist.t_hist_grp_owned;
drop user u_hist_member;
drop user g_hist;
--+ holdcas off;
