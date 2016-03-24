select cast(293842938.2039480289343094 as numeric(20, 10));

create table foo(a float, b double);
insert into foo values(123.678, 12384.239429034);

select cast(a as numeric(6, 3)) from foo;
select cast(b as numeric(20, 10)) from foo;

drop table foo;


create table foo(a numeric(10, 4));
insert into foo values(cast(123456.8373 as float));
insert into foo values(cast(12346.873 as double));

select * from foo order by 1;

show columns in foo;

drop table foo;
