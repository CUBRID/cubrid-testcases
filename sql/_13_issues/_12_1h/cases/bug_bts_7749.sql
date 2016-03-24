--+ holdcas on;
create table foo (a char(10));
create index idx_foo_weekday_a on foo (weekday(a));
insert into foo values ('abc');

drop table foo ;

commit;
--+ holdcas off;
