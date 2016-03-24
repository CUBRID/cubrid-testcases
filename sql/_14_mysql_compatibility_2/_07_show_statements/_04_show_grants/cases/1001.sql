-- SHOW GRANTS

create table t1 (i integer);
create table t2 (i integer);
create table t3 (i integer);
create table tg1 (i integer);
create table tp (i integer);
create table tc (i integer);

-- by default any user is member of group 'public'
create user user1;
create user user2;
create user group1 members user2;
create user user3 groups group1,public;

show grants;

show grants for current_user();

show grants for current_user;


show grants for user1;
show grants for user2;
show grants for user3;
show grants for group1;

--user1
grant select on t1 to user1;
grant execute on t1 to user1 with grant option;
grant select, insert on tc to user1;

--user2
grant select,insert,delete on t2 to user2;
grant select, delete on tc to user2 with grant option;

--user3
grant alter,execute on t3 to user3;
grant insert on t3 to user3 with grant option;
grant insert, delete on tc to user3 with grant option;

--group1
grant select, alter on tg1 to group1;

--public
grant select on tp to public with grant option;
grant insert, alter on tp to public;
grant select on tc to public;

show grants for user1;
show grants for user2;
show grants for user3;
show grants for group1;

revoke execute on t1 from user1;

revoke alter on tg1 from group1;

-- should fail
revoke select on tp from user1;


show grants for user1;
show grants for user2;
show grants for user3;
show grants for group1;



drop user user1;
drop user user2;
drop user user3;
drop user group1;


drop table t1;
drop table t2;
drop table t3;

drop table tg1;
drop table tp;
drop table tc;

