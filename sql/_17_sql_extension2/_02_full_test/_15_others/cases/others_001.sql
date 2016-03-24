--insert values into a set column with incorrect format

create table foo(a set);

--error
insert into foo values((1,2,3));

drop table foo;
