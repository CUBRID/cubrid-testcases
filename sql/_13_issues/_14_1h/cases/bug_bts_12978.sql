--+ holdcas on;

drop table if exists foo;
create table foo (r real);
insert into foo values ( 0 );
insert into foo values ( 5 );
insert into foo values ( null );
insert into foo values ( 987654321.987654321 );
insert into foo values ( -987654321.987654321 );
insert into foo values ( 987654321.987654321 );
insert into foo values ( -987654321.987654321 );
insert into foo values ( 0 );
insert into foo values ( null);

select sum(r) from foo order by 1;
select avg(r) from foo order by 1;
select sum(r), avg(all r) from foo order by 1;

DROP TABLE IF EXISTS foo;

--+ holdcas off;
commit;

