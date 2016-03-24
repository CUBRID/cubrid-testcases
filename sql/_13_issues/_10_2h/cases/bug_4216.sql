create table foo (a varchar(10), b varchar(10));

insert into foo values('a','aa');
insert into foo values('b','bb');

select a a1, a a2 from foo order by a;
select a a1, a a2 from foo order by a1;

drop table foo;
