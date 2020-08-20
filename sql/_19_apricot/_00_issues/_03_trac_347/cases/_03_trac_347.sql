set system parameters 'create_table_reuseoid=no';
create table t (a int default 1, b int default 2);
create table s under t (c int default 3, d int default 4);

create view v (x int default 5, y int default 7, z int default 8, w int default 9) as
	select * from s;
insert into v (x,z) values (default, default);
select * from v;

drop v;
drop s;
drop t;
set system parameters 'create_table_reuseoid=yes';
