set system parameters 'create_table_reuseoid=no';
create table t (a int default 222);
create table u (a int default 222, b int default 223);
create table x (a int default 222, b int default 223, c int);
create table y (dt datetime default now()); 


create view v_t as select * from t;
insert into v_t (a) values (default);
insert into t (a) values (default);
select * from v_t;
select * from t;

create view v_u as select * from u;
insert into v_u values (default, default);
insert into u values (default, default);
select * from v_u;
select * from u;

create view v_x (a int default 111, b int, c int) as select * from x;
insert into v_x values (default,default,default);
insert into x values (default, default, default);
select * from v_x;
select * from x;

create view v2_x (a int, c int default 113) as select a,c from x;
insert into v2_x values (default, default);
insert into x values (default, default, default);
select * from v2_x;
select * from x;

create view v_y as select * from y;
insert into v_y values (default);
select if (year(dt) = year(now()), 'ok', 'not ok') from v_y;
select if (month(dt) = month(now()), 'ok', 'not ok') from v_y;

drop v_t;
drop v_u;
drop v_x;
drop v2_x;
drop v_y;
drop t;
drop u;
drop x;
drop y;
set system parameters 'create_table_reuseoid=yes';
