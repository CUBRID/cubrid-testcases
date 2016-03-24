--+ holdcas on;

drop table if exists foo;
create table foo (i int, dt datetime);
update foo set i = dt;
insert into foo values(1, now());
update foo set i = dt;
drop table if exists foo;

--+ holdcas off;
commit;
