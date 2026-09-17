--+ holdcas on;
-- CBRD-27043: the owner of a class sees its histogram rows in db_histogram without any grant
call login('dba') on class db_user;
call add_user('u_hist_own') on class _db_user;
call login('u_hist_own') on class db_user;
create table t_hist_mine (k int, v varchar(10));
insert into t_hist_mine values (1, 'x'), (2, 'y');
update statistics on t_hist_mine with fullscan;
select owner_name, class_name, attr_name, scan_type from db_histogram where class_name = 't_hist_mine' order by 1, 2, 3;

-- dba sees it as well, with the owner name
call login('dba') on class db_user;
select owner_name, class_name, attr_name, scan_type from db_histogram where class_name = 't_hist_mine' order by 1, 2, 3;

-- another plain user does not
call add_user('u_hist_other') on class _db_user;
call login('u_hist_other') on class db_user;
select owner_name, class_name, attr_name, scan_type from db_histogram where class_name = 't_hist_mine' order by 1, 2, 3;

call login('dba') on class db_user;
drop table u_hist_own.t_hist_mine;
call drop_user('u_hist_other') on class _db_user;
call drop_user('u_hist_own') on class _db_user;
--+ holdcas off;
