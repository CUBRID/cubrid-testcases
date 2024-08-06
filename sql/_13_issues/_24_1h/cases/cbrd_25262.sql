/* Description
This scenario verified CBRD-25262 issue.
Check whether the issue of displaying a view owned by a public user with the same name as the current user's view when executing the 'SHOW CREATE VIEW' statement has been resolved.
*/

drop view if exists v1;
create user u1;

-- dba
create view v1 as select 'dba' as c1;

-- u1
call login('u1') on class db_user;
create view v1 as select 'u1' as c1;

-- public
call login('public') on class db_user;
create view v1 as select 'public' as c1;
show create view v1;

-- dba
call login('dba') on class db_user;
show create view v1;
alter view v1 add query select 'dba_1' as c1;
show create view v1;

-- u1
call login('u1') on class db_user;
show create view v1;
alter view v1 add query select 'u1_1' as c1;
show create view v1;

-- dba
call login('dba') on class db_user;
show create view v1;
show create view u1.v1;
show create view public.v1;

drop view v1;
drop view u1.v1;
drop view public.v1;

drop user u1;
