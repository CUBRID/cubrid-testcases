set system parameters 'create_table_reuseoid=no';
-- bts 6772
-- default value inheritance for views
create table t (a int default 222);
create view v as select * from t;
desc t;
desc v;
insert into v values (default);
select * from v;
select * from t;
drop v,t;


create table t (a int default 1, b int, c string default user, d int);

create view v (x int default 11, y int default 12, w string, z int) as select * from t;
desc v;
insert into v values default;
select * from v;
select * from t;
drop v;
truncate t;

create view v as select a as x, b as y, c as w from t alias_t;
desc v;
insert into v values default;
select * from v;
select * from t;
drop v;

drop t;


create table t (a int default 1, b int default 2);
create table u (c int default 3, d int default 4);

create view v as select * from t inner join u on t.a=u.c;
desc v;
-- not authorized
insert into v values default;
drop v;

create view v as select * from t,u;
desc v;
-- not authorized
insert into v values default;
drop v;

create view v as select * from (select /*+ NO_MERGE */ c from u where c > 0) as drv where drv.c < 10;
desc v;
-- not authorized
insert into v values default;
drop v;

drop t,u;
set system parameters 'create_table_reuseoid=yes';
