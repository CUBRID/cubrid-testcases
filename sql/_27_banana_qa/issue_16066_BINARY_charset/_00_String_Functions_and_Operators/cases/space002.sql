set names binary;
create table foo(a char(500), b varchar(500));

insert into foo values(space(255), space(255));
insert into foo values(space(257), space(257));
--insert into foo values(space(6400), space(6400));

select length(a), length(b) from foo order by 2;

drop table foo;


