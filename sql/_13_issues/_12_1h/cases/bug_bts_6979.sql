autocommit on;
create table foo (a char(10), b varchar(10));

create index idx_foo_weekday_a on foo (weekday(a));
create index idx_foo_weekday_b on foo (weekday(b));

SHOW INDEXES from foo;

insert into foo values ('2010-01-01','2011-01-01');
insert into foo values ('2010-01-02','2011-01-02');
insert into foo values ('2010-01-03','2011-01-03');
insert into foo values ('2010-01-04','2011-01-04');
insert into foo values ('2010-01-05','2011-01-05');

select /*+ recompile */ * from foo where weekday(a) >= 4;
select /*+ recompile */ * from foo where weekday(b) >= 4;

alter table foo drop column b;

SHOW INDEXES from foo;

insert into foo values ('abc');

drop index idx_foo_weekday_a on foo;
truncate foo;

insert into foo values ('abc');
create index idx_foo_weekday_a on foo (weekday(a));

drop foo;
