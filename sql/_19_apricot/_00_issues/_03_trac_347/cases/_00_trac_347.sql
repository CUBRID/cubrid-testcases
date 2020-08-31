set system parameters 'create_table_reuseoid=no';
create table t (a int default 1, b int default 2);

create view v (x int default 3, y int default 4) as
	select * from t;
insert into v (x) values (default);
insert into v (x) values (11), (12), (13);
select * from v order by x, y;

drop v;
drop t;
set system parameters 'create_table_reuseoid=yes';
