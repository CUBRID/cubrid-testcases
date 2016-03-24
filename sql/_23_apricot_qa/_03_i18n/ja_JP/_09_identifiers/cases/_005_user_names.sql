--+ holdcas on;
set names utf8;
create table t1 (i integer);

create user ユーザー1;

create user ユーザグループ members ユーザー1;

grant select on t1 to ユーザー1;

grant delete on t1 to ユーザグループ;

show grants for ユーザー1;

show grants for ユーザグループ;

drop user ユーザグループ;

drop user ユーザー1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;

