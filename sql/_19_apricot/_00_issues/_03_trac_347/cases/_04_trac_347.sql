create table t (a int default 1, b int default 2);
create table s (s1 int default 10, s2 int default 11, s3 int default 12, s4 int default 13);

create view v (x int default 5, y int default 7) as
	select * from t;

create view v2 as subclass of v (z int default 8, w int default 9) as
	select * from s;
insert into v2 (x,z) values (default,default);
select * from v2;

drop v2;
drop v;
drop s;
drop t;