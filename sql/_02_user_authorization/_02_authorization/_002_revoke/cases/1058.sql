--+ holdcas on;
--[er]test revoke privileges of select using domain type(user defined) and values of set 
set system parameters 'create_table_reuseoid=no';

call login('dba','') on class db_user;
create user db1;
create user db2;

call login('db1','') on class db_user;
create class b (bid int);

call login('db2','') on class db_user;
create class a(aid int, b b);
create class aa(aid int, s set(b));

call login('db1','') on class db_user;
insert into b values(1);
grant select on b to db2;

call login('db2','') on class db_user;
insert into a values(1, ( select b from b where bid=1));
insert into aa values(1, set(select b from b where bid=1));

call login('db1','') on class db_user;
revoke select on b from db2;

call login('db2','') on class db_user;
select aid, b.bid from a;
select aid, b.bid from aa, table(s) as t(b);

call login('dba','') on class db_user;

drop table a;
drop table b;
drop table aa;
drop user db1;
drop user db2;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
