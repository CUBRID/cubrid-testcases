set system parameters 'create_table_reuseoid=no';
create table t (a int default 1, b int default 2);
create table s (a int);

insert into s values (10);

create view v (x int default 3, y int default 4) as
	select * from t;
insert into v (x) select * from s;
select * from v;

drop v;
drop s;
drop t;
set system parameters 'create_table_reuseoid=yes';
