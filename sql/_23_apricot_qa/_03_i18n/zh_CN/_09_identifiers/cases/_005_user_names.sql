--+ holdcas on;
set names utf8;
create table t1 (i integer);

create user 用户1;

create user 用户组 members 用户1;

grant select on t1 to 用户1;

grant delete on t1 to 用户组;

show grants for 用户1;

show grants for 用户组;

drop user 用户组;

drop user 用户1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;

