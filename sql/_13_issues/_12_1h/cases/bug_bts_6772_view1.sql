create table t (a int default 0);
create table u under t (b int default 1);

create view v
	as select * from u;
insert into v default;
select * from v;
drop v;

drop u;
drop t;