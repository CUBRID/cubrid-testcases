--+ holdcas on;
-- CBRD-27043: db_histogram reports owner_name / class_name as strings (class_name used to be the class
-- object) and shows only the histogram rows of classes the current user may SELECT
-- (DBA group, owner, or SELECT grantee), like db_index / db_partition.
call login('dba') on class db_user;
create table t_hist_own (k int, v varchar(20));
create table t_hist_pub (k int);
insert into t_hist_own values (1, 'a'), (2, 'b'), (3, null), (4, 'd');
insert into t_hist_pub values (1), (2), (3);
update statistics on t_hist_own, t_hist_pub with fullscan;
call add_user('u_hist') on class _db_user;
grant select on t_hist_pub to u_hist;

-- dba sees every row
select owner_name, class_name, attr_name, scan_type, null_frequency from db_histogram where class_name like 't_hist_%' order by 1, 2, 3;

-- u_hist has SELECT on t_hist_pub only
call login('u_hist') on class db_user;
select owner_name, class_name, attr_name, scan_type, null_frequency from db_histogram where class_name like 't_hist_%' order by 1, 2, 3;
select count(*) from db_histogram where class_name = 't_hist_own';

-- once granted, the rows appear
call login('dba') on class db_user;
grant select on t_hist_own to u_hist;
call login('u_hist') on class db_user;
select owner_name, class_name, attr_name, scan_type, null_frequency from db_histogram where class_name like 't_hist_%' order by 1, 2, 3;

call login('dba') on class db_user;
drop table t_hist_own, t_hist_pub;
call drop_user('u_hist') on class _db_user;
--+ holdcas off;
