create table t (a int default 1, dt datetime);

create view v (x int default 3, vdt datetime default now()) as
	select * from t;
insert into v (x) values (1);
select if (year(vdt) = year(now()), 'ok', 'not ok') from v;

drop v;
drop t;